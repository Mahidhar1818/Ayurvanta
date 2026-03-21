import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/translations/tr_extension.dart';

class SchemesScreen extends StatefulWidget {
  const SchemesScreen({super.key});
  @override
  State<SchemesScreen> createState() =>
      _SchemesScreenState();
}

class _SchemesScreenState extends State<SchemesScreen> {
  final _searchCtrl = TextEditingController();
  String _filter = 'All'; // All, Central, State

  final _schemes = [
    {
      'title': 'Ayushman Bharat (PM-JAY)',
      'desc': 'Free health cover up to ₹5 Lakhs per '
          'family per year for secondary & tertiary care.',
      'type': 'Central',
      'url': 'https://pmjay.gov.in/',
      'eligibility': 'BPL families, SECC 2011 database',
      'icon': '🛡️',
    },
    {
      'title': 'Aarogyasri (Telangana)',
      'desc': 'Financial protection to BPL families up '
          'to ₹5 Lakhs for critical surgeries.',
      'type': 'State',
      'url': 'https://www.aarogyasri.telangana.gov.in/',
      'eligibility': 'White Ration Card holders (TS)',
      'icon': '🏥',
    },
    {
      'title': 'PM Matru Vandana Yojana',
      'desc': 'Maternity benefit of ₹5,000 for first '
          'child birth to pregnant women.',
      'type': 'Central',
      'url': 'https://pmmvy.wcd.gov.in/',
      'eligibility': 'Pregnant women & lactating mothers',
      'icon': '🤱',
    },
    {
      'title': 'KCR Kit',
      'desc': 'Maternal & child health scheme providing '
          'a 16-item kit and financial assistance.',
      'type': 'State',
      'url': 'https://kcrkit.telangana.gov.in/',
      'eligibility': 'Pregnant women in TS Govt Hospitals',
      'icon': '🎁',
    },
    {
      'title': 'Mukhyamantri Amrutum (MA)',
      'desc': 'Cashless medical and surgical treatment '
          'for BPL families in Gujarat.',
      'type': 'State',
      'url': 'https://magujarat.com/',
      'eligibility': 'BPL families in Gujarat',
      'icon': '🚑',
    },
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _schemes.where((s) {
      final matchType = _filter == 'All' || s['type'] == _filter;
      final matchSearch = s['title']!
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
        title: const Text('Govt Health Schemes',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17)),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.navyDark,
            child: Column(
              children: [
                // Search bar
                Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search,
                          color: Colors.white54, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _searchCtrl,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 13),
                          onChanged: (_) => setState(() {}),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search schemes...',
                            hintStyle: TextStyle(
                                color: Colors.white54, fontSize: 13),
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
                    children: ['All', 'Central', 'State'].map((f) {
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
                                  : Colors.white10,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(f,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: active
                                      ? Colors.white
                                      : Colors.white70,
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
                final s = filtered[i];
                return FadeInUp(
                  delay: Duration(milliseconds: i * 50),
                  child: _SchemeCard(
                    title: s['title']!,
                    desc: s['desc']!,
                    type: s['type']!,
                    url: s['url']!,
                    eligibility: s['eligibility']!,
                    icon: s['icon']!,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SchemeCard extends StatefulWidget {
  final String title, desc, type, url, eligibility, icon;
  const _SchemeCard({
    required this.title,
    required this.desc,
    required this.type,
    required this.url,
    required this.eligibility,
    required this.icon,
  });

  @override
  State<_SchemeCard> createState() => _SchemeCardState();
}

class _SchemeCardState extends State<_SchemeCard> {
  bool _expanded = false;

  Future<void> _launchURL() async {
    final uri = Uri.parse(widget.url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri,
          mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not open page')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE3EAF2), width: 0.5),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44, height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: widget.type == 'Central'
                          ? const Color(0xFFFFF4E5)
                          : const Color(0xFFE8F4FD),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(widget.icon,
                        style: const TextStyle(fontSize: 22)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: widget.type == 'Central'
                                    ? const Color(0xFFFF9800)
                                    : AppColors.blue,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(widget.type.toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    letterSpacing: 0.5,
                                  )),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(widget.title,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            )),
                        const SizedBox(height: 4),
                        Text(widget.desc,
                            maxLines: _expanded ? null : 2,
                            overflow: _expanded
                                ? TextOverflow.visible
                                : TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                              height: 1.4,
                            )),
                      ],
                    ),
                  ),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppColors.textHint,
                  ),
                ],
              ),
            ),
          ),
          if (_expanded) ...[
            const Divider(height: 1, color: Color(0xFFF0F4F8)),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Eligibility',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textHint,
                        letterSpacing: 0.5,
                      )),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.check_circle,
                          size: 14, color: AppColors.teal),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(widget.eligibility,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            )),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: OutlinedButton.icon(
                      onPressed: _launchURL,
                      icon: const Icon(Icons.open_in_new, size: 16),
                      label: const Text('Apply / Read More',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w700)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.blue,
                        side: BorderSide(
                            color: AppColors.blue.withOpacity(0.3)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
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
