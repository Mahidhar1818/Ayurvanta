// lib/screens/exercise/exercise_library_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/exercise/exercise_bloc.dart';
import '../../models/exercise_model.dart';
import 'exercise_detail_screen.dart';

class ExerciseLibraryScreen extends StatefulWidget {
  @override
  _ExerciseLibraryScreenState createState() => _ExerciseLibraryScreenState();
}

class _ExerciseLibraryScreenState extends State<ExerciseLibraryScreen> {
  String _selectedCategory = 'All';
  final List<String> _categories = [
    'All',
    'Strength Training',
    'Stretching',
    'Balance Exercises',
    'Aerobic',
    'Range of Motion',
    'Postural Exercises',
  ];

  @override
  void initState() {
    super.initState();
    context.read<ExerciseBloc>().add(LoadExercises());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercise Library'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Implementation for search route/dialog
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildCategoryFilter(),
          Expanded(
            child: _buildExerciseList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategory == category;
          
          return Padding(
            padding: EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedCategory = category;
                  });
                  if (category == 'All') {
                    context.read<ExerciseBloc>().add(LoadExercises());
                  } else {
                    context.read<ExerciseBloc>().add(LoadExercisesByCategory(category));
                  }
                }
              },
              selectedColor: Colors.blue,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildExerciseList() {
    return BlocBuilder<ExerciseBloc, ExerciseState>(
      builder: (context, state) {
        if (state is ExerciseLoading) {
          return Center(child: CircularProgressIndicator());
        }
        
        if (state is ExerciseError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48, color: Colors.red),
                SizedBox(height: 16),
                Text(state.message, style: TextStyle(color: Colors.red)),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<ExerciseBloc>().add(LoadExercises());
                  },
                  child: Text('Retry'),
                ),
              ],
            ),
          );
        }
        
        if (state is ExerciseLoaded) {
          final exercises = state.exercises;
          
          if (exercises.isEmpty) {
            return Center(child: Text('No exercises found in this category.'));
          }
          
          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: exercises.length,
            itemBuilder: (context, index) {
              final exercise = exercises[index];
              return _buildExerciseCard(exercise);
            },
          );
        }
        
        return Center(child: Text('No data available'));
      },
    );
  }

  Widget _buildExerciseCard(Exercise exercise) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ExerciseDetailScreen(exercise: exercise),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image placeholder
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                  image: exercise.imageUrl.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(exercise.imageUrl),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: exercise.imageUrl.isEmpty
                    ? Icon(Icons.fitness_center, color: Colors.grey[400])
                    : null,
              ),
              SizedBox(width: 16),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      '\${exercise.difficultyLevel} • \${exercise.durationMinutes} mins',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        exercise.category,
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Action arrow
              Center(
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
