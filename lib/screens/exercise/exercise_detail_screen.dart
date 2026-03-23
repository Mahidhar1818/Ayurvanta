// lib/screens/exercise/exercise_detail_screen.dart
import 'package:flutter/material.dart';
import '../../models/exercise_model.dart';
import 'package:url_launcher/url_launcher.dart';

class ExerciseDetailScreen extends StatelessWidget {
  final Exercise exercise;

  const ExerciseDetailScreen({Key? key, required this.exercise}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(exercise.name, style: TextStyle(shadows: [Shadow(color: Colors.black, blurRadius: 4)])),
              background: exercise.imageUrl.isNotEmpty
                  ? Image.network(
                      exercise.imageUrl,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      color: Colors.blue[300],
                      child: Icon(Icons.fitness_center, size: 100, color: Colors.white),
                    ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTags(),
                  SizedBox(height: 24),
                  
                  Text('Description', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text(exercise.description, style: TextStyle(fontSize: 16)),
                  SizedBox(height: 24),

                  if (exercise.videoUrl.isNotEmpty) ...[
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () => _launchURL(exercise.videoUrl),
                        icon: Icon(Icons.play_circle_fill),
                        label: Text('Watch Tutorial Video'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[600],
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                  ],

                  Text('Instructions', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text(exercise.instructions, style: TextStyle(fontSize: 16)),
                  SizedBox(height: 24),
                  
                  if (exercise.benefits.isNotEmpty) ...[
                    Text('Benefits', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    ...exercise.benefits.map((b) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.check_circle, color: Colors.green, size: 20),
                              SizedBox(width: 8),
                              Expanded(child: Text(b, style: TextStyle(fontSize: 16))),
                            ],
                          ),
                        )),
                    SizedBox(height: 24),
                  ],

                  if (exercise.precautions.isNotEmpty) ...[
                    Text('Precautions', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    ...exercise.precautions.map((p) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.warning, color: Colors.orange, size: 20),
                              SizedBox(width: 8),
                              Expanded(child: Text(p, style: TextStyle(fontSize: 16))),
                            ],
                          ),
                        )),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTags() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        Chip(
          label: Text(exercise.category),
          backgroundColor: Colors.blue[100],
          labelStyle: TextStyle(color: Colors.blue[900]),
        ),
        Chip(
          label: Text(exercise.difficultyLevel),
          backgroundColor: Colors.orange[100],
          labelStyle: TextStyle(color: Colors.orange[900]),
        ),
        Chip(
          label: Text(exercise.bodyPart),
          backgroundColor: Colors.green[100],
          labelStyle: TextStyle(color: Colors.green[900]),
        ),
        Chip(
          avatar: Icon(Icons.timer, size: 16, color: Colors.purple[900]),
          label: Text('\${exercise.durationMinutes} min'),
          backgroundColor: Colors.purple[100],
          labelStyle: TextStyle(color: Colors.purple[900]),
        ),
      ],
    );
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
