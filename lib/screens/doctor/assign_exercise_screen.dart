// lib/screens/doctor/assign_exercise_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/exercise/exercise_bloc.dart';
import '../../models/exercise_model.dart';
import '../../services/exercise_diet_service.dart';
import '../../core/services/api_service.dart';
import '../../core/widgets/loading_widget.dart';

class AssignExerciseScreen extends StatefulWidget {
  final String patientId;
  final String patientName;

  const AssignExerciseScreen({
    Key? key,
    required this.patientId,
    required this.patientName,
  }) : super(key: key);

  @override
  _AssignExerciseScreenState createState() => _AssignExerciseScreenState();
}

class _AssignExerciseScreenState extends State<AssignExerciseScreen> {
  final TextEditingController _exerciseIdController = TextEditingController();
  final TextEditingController _frequencyController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  
  Exercise? _selectedExercise;
  bool _isLoading = false;
  String _searchError = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assign Exercise to \${widget.patientName}'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildExerciseSearchCard(),
            if (_selectedExercise != null) ...[
              SizedBox(height: 24),
              _buildExerciseDetails(),
              SizedBox(height: 24),
              _buildAssignmentForm(),
              SizedBox(height: 24),
              _buildAssignButton(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseSearchCard() {
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
              'Search Exercise by ID',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _exerciseIdController,
              decoration: InputDecoration(
                hintText: 'Enter Exercise ID (e.g., EX-001)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _searchExercise,
                ),
                errorText: _searchError.isNotEmpty ? _searchError : null,
              ),
            ),
            if (_isLoading)
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseDetails() {
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
            Row(
              children: [
                Icon(Icons.fitness_center, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  'Exercise Details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            _buildDetailRow('Name:', _selectedExercise!.name),
            _buildDetailRow('Category:', _selectedExercise!.category),
            _buildDetailRow('Difficulty:', _selectedExercise!.difficultyLevel),
            _buildDetailRow('Body Part:', _selectedExercise!.bodyPart),
            SizedBox(height: 12),
            Text(
              'Description:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(_selectedExercise!.description),
            SizedBox(height: 12),
            Text(
              'Instructions:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(_selectedExercise!.instructions),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
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

  Widget _buildAssignmentForm() {
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
              'Assignment Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _frequencyController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Frequency per Day',
                hintText: 'e.g., 2',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _durationController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Duration (Days)',
                hintText: 'e.g., 7',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _notesController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Additional Notes',
                hintText: 'Any specific instructions for the patient...',
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

  Widget _buildAssignButton() {
    return ElevatedButton(
      onPressed: _assignExercise,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        minimumSize: Size(double.infinity, 50),
      ),
      child: Text(
        'Assign Exercise',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Future<void> _searchExercise() async {
    final exerciseId = _exerciseIdController.text.trim();
    if (exerciseId.isEmpty) {
      setState(() {
        _searchError = 'Please enter an Exercise ID';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _searchError = '';
    });

    try {
      final service = ExerciseDietService(
        context.read<ApiService>(),
      );
      final exercise = await service.getExerciseById(exerciseId);
      setState(() {
        _selectedExercise = exercise;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _searchError = 'Exercise not found. Please check the ID.';
        _isLoading = false;
        _selectedExercise = null;
      });
    }
  }

  Future<void> _assignExercise() async {
    if (_selectedExercise == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please search and select an exercise first')),
      );
      return;
    }

    final frequency = int.tryParse(_frequencyController.text.trim());
    final duration = int.tryParse(_durationController.text.trim());

    if (frequency == null || duration == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter valid frequency and duration')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      context.read<ExerciseBloc>().add(
        AssignExercise(
          patientId: widget.patientId,
          exerciseId: _selectedExercise!.id,
          frequencyPerDay: frequency,
          durationDays: duration,
          notes: _notesController.text.trim(),
        ),
      );
      
      Navigator.pop(context, true);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Exercise assigned successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: \$e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
