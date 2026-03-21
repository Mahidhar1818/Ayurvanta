import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/theme/app_colors.dart';
import '../models/doctor_rating_model.dart';

class FeedbackScreen extends StatefulWidget {
  final Doctor doctor;
  final String patientName;
  final String patientId;

  const FeedbackScreen({
    super.key,
    required this.doctor,
    required this.patientName,
    required this.patientId,
  });

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  double _rating = 0;
  String _feedback = '';
  bool _anonymous = false;
  final List<String> _selectedTags = [];

  final List<String> _availableTags = [
    'Excellent Care',
    'Good Listener',
    'On Time',
    'Friendly',
    'Explained Well',
    'Clean Clinic',
    'Good Staff',
    'Affordable',
    'Experienced',
    'Recommended',
    'Follow-up Care',
  ];

  final _feedbackController = TextEditingController();

  void _submitFeedback() {
    if (_rating == 0) {
      _showSnackBar('Please select a rating');
      return;
    }

    if (_feedback.trim().isEmpty) {
      _showSnackBar('Please write your feedback');
      return;
    }

    final review = Review(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      doctorId: widget.doctor.id,
      patientName: widget.patientName,
      patientId: widget.patientId,
      rating: _rating,
      feedback: _feedback,
      tags: _selectedTags,
      date: DateTime.now(),
      anonymous: _anonymous,
    );

    // Add review to doctor
    widget.doctor.reviews = [...widget.doctor.reviews, review];
    widget.doctor.updateRating();

    // Show success dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: const BoxDecoration(
                color: Color(0xFFEAF3DE),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_rounded,
                  color: Color(0xFF1D9E75), size: 40),
            ),
            const SizedBox(height: 16),
            const Text('Thank You!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text('Your feedback helps ${widget.doctor.name} improve care',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 13, color: AppColors.textSecondary)),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context); // Close feedback screen
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.teal,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Done',
                    style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.navyMid,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      body: Column(
        children: [
          _buildTopBar(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  FadeInDown(child: _buildDoctorCard()),
                  const SizedBox(height: 20),
                  FadeInUp(
                      delay: const Duration(milliseconds: 100),
                      child: _buildRatingSection()),
                  const SizedBox(height: 20),
                  FadeInUp(
                      delay: const Duration(milliseconds: 200),
                      child: _buildFeedbackSection()),
                  const SizedBox(height: 20),
                  FadeInUp(
                      delay: const Duration(milliseconds: 300),
                      child: _buildTagsSection()),
                  const SizedBox(height: 20),
                  FadeInUp(
                      delay: const Duration(milliseconds: 400),
                      child: _buildAnonymousToggle()),
                  const SizedBox(height: 30),
                  FadeInUp(
                    delay: const Duration(milliseconds: 500),
                    child: SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _submitFeedback,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.teal,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                        child: const Text('Submit Feedback',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      color: AppColors.navyDark,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10,
        left: 16,
        right: 16,
        bottom: 14,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white, size: 16),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Rate Your Experience',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700)),
                Text('Your feedback helps us improve',
                    style: TextStyle(color: AppColors.textHint, fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE3EAF2), width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: widget.doctor.color,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(widget.doctor.imageInitials,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.doctor.name,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary)),
                Text(widget.doctor.specialty,
                    style: const TextStyle(
                        fontSize: 13, color: AppColors.textSecondary)),
                Text(widget.doctor.hospital,
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textHint)),
              ],
            ),
          ),
          if (widget.doctor.totalReviews > 0)
            Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.star, size: 16, color: Color(0xFFBA7517)),
                    const SizedBox(width: 4),
                    Text(widget.doctor.averageRating.toStringAsFixed(1),
                        style: const TextStyle(fontWeight: FontWeight.w800)),
                  ],
                ),
                Text('${widget.doctor.totalReviews} reviews',
                    style: const TextStyle(
                        fontSize: 10, color: AppColors.textHint)),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildRatingSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE3EAF2), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('How would you rate your experience?',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(5, (index) {
              final starValue = (index + 1).toDouble();
              return GestureDetector(
                onTap: () => setState(() => _rating = starValue),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Icon(
                        starValue <= _rating
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        size: 40,
                        color: starValue <= _rating
                            ? const Color(0xFFBA7517)
                            : Colors.grey[300],
                      ),
                      const SizedBox(height: 4),
                      Text(_getRatingLabel(starValue),
                          style: TextStyle(
                              fontSize: 11,
                              color: starValue <= _rating
                                  ? const Color(0xFFBA7517)
                                  : Colors.grey[400])),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  String _getRatingLabel(double rating) {
    if (rating == 5) return 'Excellent';
    if (rating == 4) return 'Good';
    if (rating == 3) return 'Average';
    if (rating == 2) return 'Poor';
    return 'Very Poor';
  }

  Widget _buildFeedbackSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE3EAF2), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Write your feedback',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          TextFormField(
            controller: _feedbackController,
            onChanged: (v) => _feedback = v,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'What did you like? What could be improved?',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.all(12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTagsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE3EAF2), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('What best describes your experience?',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _availableTags.map((tag) {
              final isSelected = _selectedTags.contains(tag);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedTags.remove(tag);
                    } else {
                      _selectedTags.add(tag);
                    }
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color:
                        isSelected ? AppColors.teal : const Color(0xFFF4F7FB),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color:
                          isSelected ? AppColors.teal : const Color(0xFFE3EAF2),
                      width: 0.5,
                    ),
                  ),
                  child: Text(tag,
                      style: TextStyle(
                        fontSize: 12,
                        color:
                            isSelected ? Colors.white : AppColors.textPrimary,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      )),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAnonymousToggle() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE3EAF2), width: 0.5),
      ),
      child: Row(
        children: [
          const Icon(Icons.visibility_off_outlined,
              color: AppColors.textSecondary),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Post anonymously',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary)),
                Text('Your name won\'t be visible publicly',
                    style: TextStyle(
                        fontSize: 11, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Switch(
            value: _anonymous,
            onChanged: (v) => setState(() => _anonymous = v),
            activeThumbColor: AppColors.teal,
          ),
        ],
      ),
    );
  }
}
