import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../models/journal_entry.dart';
import '../theme/colors.dart';

class JournalCard extends StatelessWidget {
  final JournalEntry entry;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const JournalCard({
    super.key,
    required this.entry,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title and actions
            Row(
              children: [
                Expanded(
                  child: Text(
                    entry.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (onEdit != null && onDelete != null) ...[
                  IconButton(
                    onPressed: onEdit,
                    icon: const Icon(Iconsax.edit,
                        size: 20, color: AppColors.textSecondary),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: onDelete,
                    icon: const Icon(Iconsax.trash,
                        size: 20, color: AppColors.error),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ],
            ),

            const SizedBox(height: 12),

            // Mood and date
            Row(
              children: [
                if (entry.mood != null) ...[
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getMoodColor(entry.mood!).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      entry.mood!,
                      style: TextStyle(
                        fontSize: 12,
                        color: _getMoodColor(entry.mood!),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                const Icon(Iconsax.calendar,
                    size: 14, color: AppColors.textDisabled),
                const SizedBox(width: 4),
                Text(
                  _formatDate(entry.dateTime),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textDisabled,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Content
            Text(
              entry.content,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Color _getMoodColor(String mood) {
    switch (mood) {
      case '😊 Happy':
        return AppColors.happy;
      case '😌 Calm':
        return AppColors.calm;
      case '😢 Sad':
        return AppColors.sad;
      case '😰 Anxious':
        return AppColors.anxious;
      case '😠 Angry':
        return AppColors.angry;
      case '😴 Tired':
        return AppColors.textSecondary;
      case '😃 Excited':
        return AppColors.primary;
      default:
        return AppColors.textSecondary;
    }
  }
}
