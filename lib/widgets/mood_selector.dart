import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/mood_service.dart';
import '../theme/colors.dart';

class MoodSelector extends StatefulWidget {
  @override
  _MoodSelectorState createState() => _MoodSelectorState();
}

class _MoodSelectorState extends State<MoodSelector> {
  String? _selectedMood;
  int _intensity = 3;
  final _noteController = TextEditingController();

  final List<Map<String, dynamic>> _moods = [
    {'emoji': '😊', 'label': 'Happy', 'color': AppColors.happy},
    {'emoji': '😌', 'label': 'Calm', 'color': AppColors.calm},
    {'emoji': '😢', 'label': 'Sad', 'color': AppColors.sad},
    {'emoji': '😰', 'label': 'Anxious', 'color': AppColors.anxious},
    {'emoji': '😠', 'label': 'Angry', 'color': AppColors.angry},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Select how you\'re feeling',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _moods.map((mood) {
            final String label = mood['label'] as String;
            final Color color = mood['color'] as Color;
            final String emoji = mood['emoji'] as String;

            return _buildMoodChip(label, emoji, color);
          }).toList(),
        ),
        const SizedBox(height: 24),
        if (_selectedMood != null) ...[
          _buildIntensitySelector(),
          const SizedBox(height: 24),
          _buildNoteInput(),
          const SizedBox(height: 24),
          _buildSaveButton(context),
        ],
      ],
    );
  }

  Widget _buildMoodChip(String label, String emoji, Color color) {
    final isSelected = _selectedMood == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMood = isSelected ? null : label;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIntensitySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Intensity: $_intensity/5',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(12),
          ),
          child: SliderTheme(
            data: SliderThemeData(
              trackHeight: 6,
              thumbShape: const RoundSliderThumbShape(
                enabledThumbRadius: 12,
                disabledThumbRadius: 8,
              ),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
              activeTrackColor: _getSelectedMoodColor(),
              inactiveTrackColor: AppColors.textDisabled.withValues(alpha: 0.3),
              thumbColor: _getSelectedMoodColor(),
            ),
            child: Slider(
              value: _intensity.toDouble(),
              min: 1,
              max: 5,
              divisions: 4,
              onChanged: (value) {
                setState(() {
                  _intensity = value.round();
                });
              },
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(5, (index) {
            return Text(
              '${index + 1}',
              style: TextStyle(
                color: _intensity >= index + 1
                    ? _getSelectedMoodColor()
                    : AppColors.textDisabled,
                fontWeight: FontWeight.w600,
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildNoteInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Add a note (optional)',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _noteController,
          decoration: const InputDecoration(
            hintText: 'What\'s making you feel this way?',
            filled: true,
            fillColor: AppColors.surface,
          ),
          maxLines: 3,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return ElevatedButton(
      onPressed: _saveMood,
      style: ElevatedButton.styleFrom(
        backgroundColor: _getSelectedMoodColor(),
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
      ),
      child: const Text(
        'Save Mood Entry',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _getSelectedMoodColor() {
    final mood = _moods.firstWhere(
      (m) => m['label'] == _selectedMood,
      orElse: () => {'color': AppColors.primary},
    );
    return mood['color'] as Color;
  }

  void _saveMood() {
    if (_selectedMood != null) {
      final moodService = Provider.of<MoodService>(context, listen: false);
      moodService.addMood(
        mood: _selectedMood!,
        intensity: _intensity,
        note: _noteController.text.isNotEmpty ? _noteController.text : null,
      );

      setState(() {
        _selectedMood = null;
        _intensity = 3;
        _noteController.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Mood saved successfully!'),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }
}
