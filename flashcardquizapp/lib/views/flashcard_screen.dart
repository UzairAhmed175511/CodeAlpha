import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../viewmodels/flashcard_viewmodel.dart';

class FlashcardScreen extends StatefulWidget {
  const FlashcardScreen({super.key});

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  @override
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<FlashcardViewModel>(context);
    final theme = Theme.of(context);

    return AnimatedTheme(
      duration: const Duration(milliseconds: 400),
      data: theme,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor, // 🌙 dynamic color
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(
                viewModel.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                color: Colors.white,
              ),
              onPressed: viewModel.toggleTheme,
            ),
            IconButton(
              icon: const Icon(Icons.add, color: Colors.white),
              onPressed: () => _showAddEditDialog(context, viewModel),
            ),
          ],
          title: const Text(
            'Flashcard Quiz',
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
          ),
          centerTitle: true,
          elevation: 2,
          backgroundColor:
              theme.appBarTheme.backgroundColor ?? Colors.blueAccent,
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: theme.colorScheme.primary,
          onPressed: () => _showAddEditDialog(context, viewModel),
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text("Add", style: TextStyle(color: Colors.white)),
        ),
        body: viewModel.flashcards.isEmpty
            ? Center(
                child: Text(
                  "No flashcards yet.\nTap '+' to add one!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: theme.colorScheme.onBackground.withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Card ${viewModel.currentIndex + 1} of ${viewModel.flashcards.length}",
                      style: TextStyle(
                        fontSize: 18,
                        color: theme.colorScheme.onBackground.withOpacity(0.6),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildAnimatedCard(viewModel, theme),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _circleButton(
                          icon: Icons.arrow_back_ios_new,
                          onTap: viewModel.previousCard,
                          color: theme.colorScheme.primary,
                        ),
                        _circleButton(
                          icon: Icons.edit,
                          onTap: () => _showAddEditDialog(
                            context,
                            viewModel,
                            editIndex: viewModel.currentIndex,
                          ),
                          color: theme.colorScheme.primary,
                        ),
                        _circleButton(
                          icon: Icons.delete_outline,
                          color: Colors.redAccent,
                          onTap: () =>
                              viewModel.deleteCard(viewModel.currentIndex),
                        ),
                        _circleButton(
                          icon: Icons.arrow_forward_ios,
                          onTap: viewModel.nextCard,
                          color: theme.colorScheme.primary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildAnimatedCard(FlashcardViewModel viewModel, ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: viewModel.toggleAnswer,
      child: Animate(
        effects: [FlipEffect(duration: 400.ms, curve: Curves.easeInOut)],
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          height: 250,
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: viewModel.showAnswer
                  ? [Colors.greenAccent.shade100, Colors.teal.shade100]
                  : isDark
                  ? [Colors.grey.shade900, Colors.grey.shade800]
                  : [Colors.blueAccent.shade100, Colors.lightBlue.shade50],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                blurRadius: 8,
                offset: const Offset(0, 4),
                color: isDark ? Colors.black54 : Colors.black12,
              ),
            ],
          ),
          child: Center(
            child: Text(
              viewModel.showAnswer
                  ? viewModel.currentCard.answer
                  : viewModel.currentCard.question,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: viewModel.showAnswer
                    ? (isDark
                          ? const Color.fromARGB(255, 11, 35, 30)
                          : Colors.teal.shade900)
                    : (isDark ? Colors.blueAccent : Colors.blue.shade900),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  Widget _circleButton({
    required IconData icon,
    required VoidCallback onTap,
    Color color = Colors.blueAccent,
  }) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child:
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 26),
          ).animate().scaleXY(
            begin: 0.9,
            end: 1.0,
            curve: Curves.easeOutBack,
            duration: 150.ms,
          ),
    );
  }

  void _showAddEditDialog(
    BuildContext context,
    FlashcardViewModel viewModel, {
    int? editIndex,
  }) {
    final TextEditingController questionController = TextEditingController(
      text: editIndex != null ? viewModel.flashcards[editIndex].question : '',
    );
    final TextEditingController answerController = TextEditingController(
      text: editIndex != null ? viewModel.flashcards[editIndex].answer : '',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // transparent to allow animation
      builder: (_) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Animate(
            effects: [
              FadeEffect(duration: 300.ms),
              SlideEffect(
                begin: const Offset(0, 0.3), // slide from bottom
                end: Offset.zero,
                curve: Curves.easeOutCubic,
                duration: 300.ms,
              ),
            ],
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(25),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    editIndex != null ? "Edit Flashcard" : "Add New Flashcard",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 20),

                  TextField(
                    controller: questionController,
                    style: TextStyle(color: theme.colorScheme.onSurface),
                    decoration: InputDecoration(
                      labelText: "Question",
                      labelStyle: TextStyle(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                      filled: true,
                      fillColor: isDark ? Colors.grey[800] : Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: answerController,
                    style: TextStyle(color: theme.colorScheme.onSurface),
                    decoration: InputDecoration(
                      labelText: "Answer",
                      labelStyle: TextStyle(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                      filled: true,
                      fillColor: isDark ? Colors.grey[800] : Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: theme.colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    icon: const Icon(Icons.save, color: Colors.white),
                    label:
                        const Text(
                          "Save",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ).animate().scaleXY(
                          begin: 0.95,
                          end: 1.0,
                          curve: Curves.easeOut,
                          duration: 200.ms,
                        ), // 🔥 pop animation
                    onPressed: () {
                      if (editIndex != null) {
                        viewModel.editCard(
                          editIndex,
                          questionController.text,
                          answerController.text,
                        );
                      } else {
                        viewModel.addCard(
                          questionController.text,
                          answerController.text,
                        );
                      }
                      Navigator.pop(context);
                    },
                  ).animate().scaleXY(
                    begin: 0.95,
                    end: 1.0,
                    curve: Curves.easeOut,
                    duration: 200.ms,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
