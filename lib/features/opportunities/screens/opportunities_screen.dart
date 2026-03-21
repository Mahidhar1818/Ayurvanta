import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/translations/tr_extension.dart';

class OpportunitiesScreen extends StatefulWidget {
  const OpportunitiesScreen({super.key});
  @override
  State<OpportunitiesScreen> createState() =>
      _OpportunitiesScreenState();
}

class _OpportunitiesScreenState
    extends State<OpportunitiesScreen> {
  final _searchCtrl = TextEditingController();
  String _filter = 'All'; // All, Full-time, Part-time

  final _jobs = [
    {
      'id': '1',
      'title': 'Community Health Worker',
      'org': 'Rural Health Mission',
      'location': 'Warangal, TS',
      'type': 'Full-time',
      'salary': '₹15,000 - ₹20,000/mo',
      'desc': 'Looking for dedicated individuals to '
          'conduct health camps and basic checkups '
          'in rural areas.',
      'reqs': [
        '12th Pass / ANM / GNM',
        'Knows Telugu & Basic English',
        'Two-wheeler required'
      ],
      'posted': '2d ago',
      'urgency': 'High',
    },
    {
      'id': '2',
      'title': 'Pharmacy Assistant',
      'org': 'Apollo Pharmacy',
      'location': 'Hyderabad, TS',
      'type': 'Full-time',
      'salary': '₹18,000/mo',
      'desc': 'Assist pharmacist in dispensing '
          'medicines and managing inventory.',
      'reqs': ['D.Pharm or B.Pharm', '0-2 yrs experience'],
      'posted': '1w ago',
      'urgency': 'Normal',
    },
    {
      'id': '3',
      'title': 'Elder Care Giver',
      'org': 'Caretaker Services',
      'location': 'Khammam, TS',
      'type': 'Part-time',
      'salary': '₹400/shift',
      'desc': 'Provide daily living assistance '
          'to seniors in their homes.',
      'reqs': ['Compassionate', 'Flexible timings'],
      'posted': '3d ago',
      'urgency': 'Normal',
    },
    {
      'id': '4',
      'title': 'Data Entry Operator (Health)',
      'org': 'TS Medical Dept',
      'location': 'Karimnagar, TS',
      'type': 'Contract',
      'salary': '₹12,000/mo',
      'desc': 'Digitize patient records from '
          'PHCs to central database.',
      'reqs': ['Computer skills', 'Typing 30wpm'],
      'posted': '5d ago',
      'urgency': 'Normal',
    },
    {
      'id': '5',
      'title': 'Ambulance Driver',
      'org': '108 Services',
      'location': 'Nizamabad, TS',
      'type': 'Full-time',
      'salary': '₹22,000/mo',
      'desc': 'Drive emergency vehicles and '
          'assist paramedics on site.',
      'reqs': ['Heavy Driving License', 'First-aid knowledge'],
      'posted': '1d ago',
      'urgency': 'High',
    },
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _jobs.where((j) {
      final matchType = _filter == 'All' || j['type'] == _filter;
      final matchSearch = (j['title'] as String)
              .toLowerCase()
              .contains(_searchCtrl.text.toLowerCase()) ||
          (j['org'] as String)
              .toLowerCase()
              .contains(_searchCtrl.text.toLowerCase());
      return matchType && matchSearch;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: AppBar(
        backgroundColor: AppColors.navyDark,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Opportunities',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17)),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.navyDark,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Banner text
                const Text(
                  'Find healthcare & support jobs\nnear you.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 16),
                // Search bar
                Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search,
                          color: AppColors.textHint, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _searchCtrl,
                          style: const TextStyle(
                              color: AppColors.textPrimary, fontSize: 13),
                          onChanged: (_) => setState(() {}),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search jobs or orgs...',
                            hintStyle: TextStyle(
                                color: AppColors.textHint, fontSize: 13),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Filter chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      'All',
                      'Full-time',
                      'Part-time',
                      'Contract'
                    ].map((f) {
                      final active = _filter == f;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () => setState(() => _filter = f),
                          child: AnimatedContainer(
                            duration:
                                const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: active
                                  ? AppColors.teal
                                  : Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(f,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: active
                                      ? Colors.white
                                      : Colors.white,
                                )),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (ctx, i) {
                final job = filtered[i];
                return FadeInUp(
                  delay: Duration(milliseconds: i * 50),
                  child: _JobCard(
                    job: job as Map<String, dynamic>,
                    onApply: () => _applyForJob(job['title'] as String),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _applyForJob(String title) {
    // Show a bottom sheet or directly apply
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => _ApplicationSheet(jobTitle: title),
    );
  }
}

class _JobCard extends StatefulWidget {
  final Map<String, dynamic> job;
  final VoidCallback onApply;
  const _JobCard({required this.job, required this.onApply});

  @override
  State<_JobCard> createState() => _JobCardState();
}

class _JobCardState extends State<_JobCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final j = widget.job;
    final isUrgent = j['urgency'] == 'High';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE3EAF2), width: 0.5),
        boxShadow: const [
          BoxShadow(
              color: Color(0x05000000), blurRadius: 10, offset: Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 44, height: 44,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.blueLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(j['title'][0],
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.blue)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(j['title'],
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                )),
                            const SizedBox(height: 2),
                            Text('${j['org']} • ${j['location']}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                )),
                          ],
                        ),
                      ),
                      if (isUrgent)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF4E5),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text('URGENT',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFFFF9800),
                                letterSpacing: 0.5,
                              )),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _Tag(Icons.work_outline, j['type']),
                      const SizedBox(width: 8),
                      _Tag(Icons.account_balance_wallet_outlined,
                          j['salary']),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (_expanded) ...[
            const Divider(height: 1, color: Color(0xFFF0F4F8)),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Description',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      )),
                  const SizedBox(height: 6),
                  Text(j['desc'],
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      )),
                  const SizedBox(height: 16),
                  const Text('Requirements',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      )),
                  const SizedBox(height: 6),
                  ...(j['reqs'] as List<String>).map((r) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 4),
                              child: Icon(Icons.circle,
                                  size: 6, color: AppColors.teal),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                                child: Text(r,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textSecondary))),
                          ],
                        ),
                      )),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: widget.onApply,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.teal,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Apply Now',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w800)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.center,
                    child: Text('Posted ${j['posted']}',
                        style: const TextStyle(
                            fontSize: 10, color: AppColors.textHint)),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Tag(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F7FB),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.textSecondary),
          const SizedBox(width: 4),
          Text(text,
              style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

class _ApplicationSheet extends StatefulWidget {
  final String jobTitle;
  const _ApplicationSheet({required this.jobTitle});

  @override
  State<_ApplicationSheet> createState() => _ApplicationSheetState();
}

class _ApplicationSheetState extends State<_ApplicationSheet> {
  bool _submitting = false;

  void _submit() async {
    setState(() => _submitting = true);
    await Future.delayed(const Duration(seconds: 1)); // Simulate API
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Successfully applied for ${widget.jobTitle}!'),
          backgroundColor: AppColors.teal));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Apply for job',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 4),
          Text(widget.jobTitle,
              style: const TextStyle(
                  fontSize: 14, color: AppColors.textSecondary)),
          const SizedBox(height: 24),
          const Text('Your Ayurvanta Profile details will be shared '
              'with the employer.',
              style: TextStyle(fontSize: 13, height: 1.4, color: AppColors.textPrimary)),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _submitting ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.teal,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: _submitting
                  ? const SizedBox(
                      width: 20, height: 20,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2))
                  : const Text('Confirm Application',
                      style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold)),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}
