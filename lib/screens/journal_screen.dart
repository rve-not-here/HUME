import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import '../services/mood_service.dart';
import '../models/journal_entry.dart';
import '../widgets/journal_card.dart';
import '../theme/colors.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  String? _selectedMood;
  JournalEntry? _editingEntry;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _startEditing(JournalEntry entry) {
    setState(() {
      _editingEntry = entry;
      _titleController.text = entry.title;
      _contentController.text = entry.content;
      _selectedMood = entry.mood;
    });
    _showJournalDialog(context);
  }

  void _clearEditing() {
    setState(() {
      _editingEntry = null;
      _titleController.clear();
      _contentController.clear();
      _selectedMood = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Journal',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: Consumer<MoodService>(
        builder: (context, moodService, child) {
          if (moodService.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            );
          }

          final journalEntries = moodService.journalEntries;
          return Column(
            children: [
              // Header
              const Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Thoughts',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.8,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Capture your thoughts and reflect on your journey',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              // Journal List
              Expanded(
                child: journalEntries.isEmpty
                    ? const _EmptyJournalState()
                    : _buildJournalList(journalEntries, moodService),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _clearEditing();
          _showJournalDialog(context);
        },
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Iconsax.add),
      ),
    );
  }

  Widget _buildJournalList(
      List<JournalEntry> entries, MoodService moodService) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: JournalCard(
            entry: entry,
            onEdit: () => _startEditing(entry),
            onDelete: () => _confirmDelete(context, entry, moodService),
          ),
        );
      },
    );
  }

  void _confirmDelete(
      BuildContext context, JournalEntry entry, MoodService moodService) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Entry'),
        content:
            const Text('Are you sure you want to delete this journal entry?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              moodService.deleteJournalEntry(entry.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Journal entry deleted'),
                  backgroundColor: AppColors.primary,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showJournalDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
            _editingEntry == null ? 'New Journal Entry' : 'Edit Journal Entry'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: AppColors.surfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: 'What\'s on your mind?',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: AppColors.surfaceVariant,
                ),
                maxLines: 5,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _selectedMood,
                items: const [
                  DropdownMenuItem(value: '😊 Happy', child: Text('😊 Happy')),
                  DropdownMenuItem(value: '😌 Calm', child: Text('😌 Calm')),
                  DropdownMenuItem(value: '😢 Sad', child: Text('😢 Sad')),
                  DropdownMenuItem(
                      value: '😰 Anxious', child: Text('😰 Anxious')),
                  DropdownMenuItem(value: '😠 Angry', child: Text('😠 Angry')),
                  DropdownMenuItem(value: '😴 Tired', child: Text('😴 Tired')),
                  DropdownMenuItem(
                      value: '😃 Excited', child: Text('😃 Excited')),
                ],
                onChanged: (String? value) {
                  setState(() => _selectedMood = value);
                },
                decoration: const InputDecoration(
                  labelText: 'Current Mood',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: AppColors.surfaceVariant,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _clearEditing();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _saveJournalEntry(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _saveJournalEntry(BuildContext context) {
    if (_titleController.text.trim().isEmpty ||
        _contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in both title and content'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    final moodService = Provider.of<MoodService>(context, listen: false);

    if (_editingEntry != null) {
      // Update existing entry
      moodService.deleteJournalEntry(_editingEntry!.id);
    }

    moodService.addJournalEntry(
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      mood: _selectedMood,
    );

    _clearEditing();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_editingEntry == null
            ? 'Journal entry saved!'
            : 'Journal entry updated!'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

class _EmptyJournalState extends StatelessWidget {
  const _EmptyJournalState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.note_1, size: 80, color: AppColors.textDisabled),
          SizedBox(height: 24),
          Text(
            'No journal entries yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 12),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              'Start writing to reflect on your thoughts and emotions',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textDisabled,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
