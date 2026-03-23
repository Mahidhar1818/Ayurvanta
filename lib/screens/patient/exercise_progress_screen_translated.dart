import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/exercise/exercise_bloc.dart';
import '../../bloc/locale/locale_cubit.dart';
import '../../models/exercise_model.dart';
import '../../core/localization/app_localizations.dart';

class ExerciseProgressScreenTranslated extends StatefulWidget {
  final AssignedExercise assignedExercise;

  const ExerciseProgressScreenTranslated({
    Key? key,
    required this.assignedExercise,
  }) : super(key: key);

  @override
  _ExerciseProgressScreenTranslatedState createState() => 
      _ExerciseProgressScreenTranslatedState();
}

class _ExerciseProgressScreenTranslatedState 
    extends State<ExerciseProgressScreenTranslated> {
  
  final _formKey = GlobalKey<FormState>();
  bool _completed = false;
  int _setsDone = 0;
  int _repsDone = 0;
  String _painLevel = 'Mild';
  final TextEditingController _notesController = TextEditingController();

  final List<String> _painLevels = ['None', 'Mild', 'Moderate', 'Severe'];
  
  Map<String, String> _translatedPainLevels = {};

  @override
  void initState() {
    super.initState();
    _translatePainLevels();
  }

  void _translatePainLevels() {
    // This will initially be called, but wait till build when context is ready.
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    _translatedPainLevels = {
      'None': t.translate('pain_none'),
      'Mild': t.translate('pain_mild'),
      'Moderate': t.translate('pain_moderate'),
      'Severe': t.translate('pain_severe'),
    };
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.assignedExercise.exercise.name),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildExerciseInfo(t),
            SizedBox(height: 24),
            _buildProgressForm(t),
            SizedBox(height: 24),
            _buildSubmitButton(t),
            SizedBox(height: 24),
            _buildProgressHistory(t),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseInfo(AppLocalizations t) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t.translate('exercise_details'),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            _buildInfoRow(t.translate('instructions'), 
                widget.assignedExercise.exercise.instructions),
            _buildInfoRow(t.translate('frequency'), 
                '${widget.assignedExercise.frequencyPerDay} ${t.translate('times_per_day')}'),
            _buildInfoRow(t.translate('duration'), 
                '${widget.assignedExercise.durationDays} ${t.translate('days')}'),
            if (widget.assignedExercise.notes.isNotEmpty)
              _buildInfoRow(t.translate('doctors_notes'), 
                  widget.assignedExercise.notes),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressForm(AppLocalizations t) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t.translate('log_your_progress'),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            SwitchListTile(
              title: Text(t.translate('completed_today_exercise')),
              value: _completed,
              onChanged: (value) {
                setState(() {
                  _completed = value;
                });
              },
              activeColor: Colors.green,
            ),
            if (_completed) ...[
              SizedBox(height: 16),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: t.translate('sets_completed'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (value) {
                  _setsDone = int.tryParse(value) ?? 0;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: t.translate('repetitions_done'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (value) {
                  _repsDone = int.tryParse(value) ?? 0;
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _painLevel,
                decoration: InputDecoration(
                  labelText: t.translate('pain_level'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: _painLevels.map((level) {
                  return DropdownMenuItem(
                    value: level,
                    child: Text(_translatedPainLevels[level] ?? level),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _painLevel = value!;
                  });
                },
              ),
            ],
            SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: t.translate('notes'),
                hintText: t.translate('notes_hint'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton(AppLocalizations t) {
    return ElevatedButton(
      onPressed: () => _submitProgress(t),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        minimumSize: Size(double.infinity, 50),
      ),
      child: Text(
        t.translate('submit_progress'),
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildProgressHistory(AppLocalizations t) {
    if (widget.assignedExercise.progress.isEmpty) {
      return Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(
            child: Text(t.translate('no_progress_logged')),
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t.translate('progress_history'),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            ...widget.assignedExercise.progress.map((progress) {
              return ListTile(
                title: Text(_formatDate(progress.date)),
                subtitle: Text(
                  '${t.translate('sets')}: ${progress.setsDone}, '
                  '${t.translate('reps')}: ${progress.repsDone}',
                ),
                trailing: Text(
                  _translatedPainLevels[progress.painLevel] ?? progress.painLevel,
                  style: TextStyle(
                    color: _getPainColor(progress.painLevel),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Future<void> _submitProgress(AppLocalizations t) async {
    if (_completed && (_setsDone == 0 || _repsDone == 0)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.translate('fill_all_details'))),
      );
      return;
    }

    context.read<ExerciseBloc>().add(
      LogExerciseProgress(
        assignedExerciseId: widget.assignedExercise.id,
        completed: _completed,
        setsDone: _setsDone,
        repsDone: _repsDone,
        notes: _notesController.text,
        painLevel: _painLevel,
      ),
    );
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(t.translate('progress_submitted')),
        backgroundColor: Colors.green,
      ),
    );
    
    Navigator.pop(context);
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Color _getPainColor(String painLevel) {
    switch (painLevel) {
      case 'None':
        return Colors.green;
      case 'Mild':
        return Colors.blue;
      case 'Moderate':
        return Colors.orange;
      case 'Severe':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
