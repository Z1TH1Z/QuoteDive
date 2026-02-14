import 'package:flutter/material.dart';
import '../models/quiz.dart';
import '../utils/constants.dart';

class QuizWidget extends StatefulWidget {
  final List<QuizQuestion> questions;
  final Function(int score) onComplete;

  const QuizWidget({
    super.key,
    required this.questions,
    required this.onComplete,
  });

  @override
  State<QuizWidget> createState() => _QuizWidgetState();
}

class _QuizWidgetState extends State<QuizWidget> {
  int _currentQuestionIndex = 0;
  int? _selectedAnswerIndex;
  bool _hasAnswered = false;
  int _score = 0;

  void _selectAnswer(int index) {
    if (_hasAnswered) return;

    setState(() {
      _selectedAnswerIndex = index;
      _hasAnswered = true;

      if (index == widget.questions[_currentQuestionIndex].correctAnswerIndex) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < widget.questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswerIndex = null;
        _hasAnswered = false;
      });
    } else {
      widget.onComplete(_score);
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.questions[_currentQuestionIndex];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Question ${_currentQuestionIndex + 1}/${widget.questions.length}',
                  style: AppTextStyles.caption,
                ),
                Text(
                  'Score: $_score',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // Question
            Text(
              question.question,
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Options
            ...List.generate(question.options.length, (index) {
              final isSelected = _selectedAnswerIndex == index;
              final isCorrect = index == question.correctAnswerIndex;
              final showResult = _hasAnswered;

              Color? backgroundColor;
              Color? borderColor;

              if (showResult) {
                if (isCorrect) {
                  backgroundColor = AppColors.success.withOpacity(0.1);
                  borderColor = AppColors.success;
                } else if (isSelected && !isCorrect) {
                  backgroundColor = AppColors.error.withOpacity(0.1);
                  borderColor = AppColors.error;
                }
              } else if (isSelected) {
                backgroundColor = AppColors.primary.withOpacity(0.1);
                borderColor = AppColors.primary;
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: InkWell(
                  onTap: () => _selectAnswer(index),
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      border: Border.all(
                        color: borderColor ?? Colors.grey.shade300,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: borderColor?.withOpacity(0.2),
                            border: Border.all(
                              color: borderColor ?? Colors.grey.shade400,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              String.fromCharCode(65 + index), // A, B, C, D
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: borderColor ?? Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Text(
                            question.options[index],
                            style: AppTextStyles.body,
                          ),
                        ),
                        if (showResult && isCorrect)
                          const Icon(Icons.check_circle, color: AppColors.success),
                        if (showResult && isSelected && !isCorrect)
                          const Icon(Icons.cancel, color: AppColors.error),
                      ],
                    ),
                  ),
                ),
              );
            }),

            // Explanation
            if (_hasAnswered && question.explanation.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.md),
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.lightbulb, color: AppColors.primary, size: 20),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        question.explanation,
                        style: AppTextStyles.caption,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Next button
            if (_hasAnswered) ...[
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _nextQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(AppSpacing.md),
                  ),
                  child: Text(
                    _currentQuestionIndex < widget.questions.length - 1
                        ? 'Next Question'
                        : 'Complete Quiz',
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
