import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../models/quote.dart';
import '../utils/constants.dart';

class ShareQuoteCard {
  static Future<void> shareQuote(BuildContext context, Quote quote) async {
    final text = '''
"${quote.text}"

— ${quote.author}

Shared from Quotes App - Daily wisdom for modern life
''';

    try {
      await Share.share(
        text,
        subject: 'Quote from ${quote.author}',
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to share quote'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  static void showShareDialog(BuildContext context, Quote quote) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Share Quote'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary.withOpacity(0.1),
                    AppColors.secondary.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Icon(Icons.format_quote, size: 32, color: AppColors.primary),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    quote.text,
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    '— ${quote.author}',
                    style: AppTextStyles.caption.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              shareQuote(context, quote);
            },
            icon: const Icon(Icons.share),
            label: const Text('Share'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
