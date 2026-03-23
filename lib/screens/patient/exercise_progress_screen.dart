// lib/screens/patient/exercise_progress_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/exercise/exercise_bloc.dart';
import '../../models/exercise_model.dart';
import 'package:intl/intl.dart';

class ExerciseProgressScreen extends StatefulWidget {
  final AssignedExercise assignedExercise;

  const ExerciseProgressScreen({
    Key? key,
    required this.assignedExercise,
  }) : super(key: key);

  @override
  _ExerciseProgressScreenState createState() => _ExerciseProgressScreenState();
}

class _ExerciseProgressScreenState extends State<ExerciseProgressScreen> {
  final _formKey = GlobalKey<FormState>();
  int _setsDone = 0;
  int _repsDone = 0;
  bool _completed = true;
  String _painLevel = 'None';
  final TextEditingController _notesController = TextEditingController();

  final List<String> _painLevels = ['None', 'Mild', 'Moderate', 'Severe'];

  @override
  void initState() {
    super.initState();
    _setsDone = widget.assignedExercise.exercise.sets;
    _repsDone = widget.assignedExercise.exercise.repetitions;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Log Progress'),
        backgroundColor: Colors.blue,
      ),
      body: BlocListener<ExerciseBloc, ExerciseState>(
        listener: (context, state) {
          if (state is ProgressLogged) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Progress logged successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context, true);
          } else if (state is ExerciseError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: \${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildExerciseInfoCard(),
              SizedBox(height: 24),
              _buildProgressForm(),
              SizedBox(height: 24),
              _buildProgressHistory(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExerciseInfoCard() {
    final exercise = widget.assignedExercise.exercise;
    
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
              exercise.name,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Target: \${exercise.sets} sets x \${exercise.repetitions} reps',
              style: TextStyle(
                fontSize: 16,
                color: Colors.blue[700],
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 12),
            Divider(),
            SizedBox(height: 8),
            Text(
              'Doctor's Notes:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              widget.assignedExercise.notes.isNotEmpty 
                  ? widget.assignedExercise.notes 
                  : 'No specific notes from doctor.',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressForm() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Today's Session',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              
              // Completed Checkbox
              CheckboxListTile(
                title: Text('I completed the full assigned session'),
                value: _completed,
                onChanged: (val) {
                  setState(() {
                    _completed = val ?? false;
                  });
                },
                activeColor: Colors.blue,
                contentPadding: EdgeInsets.zero,
              ),
              
              // Sets and Reps done (if not fully completed)
              if (!_completed) ...[
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildNumberInput(
                        'Sets Done',
                        _setsDone,
                        (val) => setState(() => _setsDone = val),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: _buildNumberInput(
                        'Reps Done',
                        _repsDone,
                        (val) => setState(() => _repsDone = val),
                      ),
                    ),
                  ],
                ),
              ],
              
              SizedBox(height: 20),
              
              // Pain Level
              Text(
                'Did you experience any pain?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _painLevels.map((level) {
                  return ChoiceChip(
                    label: Text(level),
                    selected: _painLevel == level,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _painLevel = level);
                      }
                    },
                    selectedColor: level == 'None' 
                        ? Colors.green[100] 
                        : (level == 'Severe' ? Colors.red[100] : Colors.orange[100]),
                  );
                }).toList(),
              ),
              
              SizedBox(height: 20),
              
              // Personal Notes
              TextField(
                controller: _notesController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'How did it feel? (Optional)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              
              SizedBox(height: 24),
              
              // Submit Button
              BlocBuilder<ExerciseBloc, ExerciseState>(
                builder: (context, state) {
                  final isLoading = state is ExerciseLoading;
                  
                  return ElevatedButton(
                    onPressed: isLoading ? null : _submitProgress,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: isLoading
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Log Progress',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumberInput(String label, int value, Function(int) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.w500)),
        SizedBox(height: 8),
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.remove_circle_outline),
              onPressed: value > 0 ? () => onChanged(value - 1) : null,
              color: Colors.blue,
            ),
            Text(
              value.toString(),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: Icon(Icons.add_circle_outline),
              onPressed: () => onChanged(value + 1),
              color: Colors.blue,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressHistory() {
    if (widget.assignedExercise.progress.isEmpty) {
      return Center(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('No progress logged yet.', style: TextStyle(color: Colors.grey))),
      );
    }
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
              'Progress History',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: widget.assignedExercise.progress.length,
              separatorBuilder: (context, index) => Divider(),
              itemBuilder: (context, index) {
                final progress = widget.assignedExercise.progress[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(DateFormat('MMM dd, yyyy - hh:mm a').format(progress.date)),
                  subtitle: Text(
                    'Pain level: \${progress.painLevel}\n\${progress.notes.isNotEmpty ? progress.notes : "No notes"}',
                  ),
                  trailing: Icon(
                    progress.completed ? Icons.check_circle : Icons.check_circle_outline,
                    color: progress.completed ? Colors.green : Colors.grey,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _submitProgress() {
    context.read<ExerciseBloc>().add(
      LogExerciseProgress(
        assignedExerciseId: widget.assignedExercise.id,
        completed: _completed,
        setsDone: _setsDone,
        repsDone: _repsDone,
        notes: _notesController.text.trim(),
        painLevel: _painLevel,
      ),
    );
  }
}
