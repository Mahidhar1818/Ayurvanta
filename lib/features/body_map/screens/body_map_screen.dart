import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/translation_service.dart';
import '../models/body_part_model.dart';

class BodyMapScreen extends StatefulWidget {
  final String gender;
  const BodyMapScreen({super.key, required this.gender});
  @override
  State<BodyMapScreen> createState() => _BodyMapScreenState();
}

class _BodyMapScreenState extends State<BodyMapScreen>
    with SingleTickerProviderStateMixin {
  late TabController _viewCtrl;
  final Set<String> _selected = {};
  int _painLevel = -1;
  String _activeSystem = 'all';
  String _lang = 'en';

  String t(String key) => TranslationService.get(key, _lang);

  final _views = ['front_view', 'back_view', 'muscles',
      'nerves', 'skeleton'];

  final _systems = [
    {'key': 'all',         'color': Color(0xFFE8243A)},
    {'key': 'skeletal',    'color': Color(0xFF185FA5)},
    {'key': 'muscular',    'color': Color(0xFF1D9E75)},
    {'key': 'nervous',     'color': Color(0xFF534AB7)},
    {'key': 'digestive',   'color': Color(0xFFBA7517)},
    {'key': 'cardiac',     'color': Color(0xFFE8243A)},
    {'key': 'respiratory', 'color': Color(0xFF0F6E56)},
    {'key': 'skin',        'color': Color(0xFFA32D2D)},
    {'key': 'urinary',     'color': Color(0xFF993556)},
    {'key': 'endocrine',   'color': Color(0xFF633806)},
    {'key': 'reproductive','color': Color(0xFF993556)},
  ];

  List<BodyPart> get _parts => widget.gender == 'female'
      ? BodyPartsData.femaleParts
      : BodyPartsData.maleParts;

  List<BodyPart> get _filteredParts =>
      _activeSystem == 'all'
          ? _parts
          : _parts
              .where((p) => p.system == _activeSystem)
              .toList();

  @override
  void initState() {
    super.initState();
    _viewCtrl = TabController(length: 5, vsync: this);
    _loadLang();
  }

  Future<void> _loadLang() async {
    final l = await TranslationService.getSaved();
    setState(() => _lang = l);
  }

  @override
  void dispose() {
    _viewCtrl.dispose();
    super.dispose();
  }

  void _togglePart(String key) {
    setState(() {
      if (_selected.contains(key)) {
        _selected.remove(key);
      } else {
        _selected.add(key);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isFemale = widget.gender == 'female';
    final skinColor =
        isFemale ? const Color(0xFFFADADD) : const Color(0xFFFFD5B8);

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      body: Column(
        children: [
          _buildTopBar(isFemale),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // System sidebar
                _buildSidebar(),
                // Body + details
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: _buildBodyMap(
                            isFemale, skinColor),
                      ),
                      _buildSelectedParts(),
                      _buildPainScale(),
                      _buildSubmitButton(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(bool isFemale) {
    return Container(
      color: AppColors.navyDark,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 12, right: 12, bottom: 0,
      ),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 34, height: 34,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white, size: 15),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(t('where_pain'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  )),
              ),
              // Gender toggle
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(3),
                child: Row(
                  children: [
                    _GenderPill(
                      label: '👨 \${t("male")}',
                      active: !isFemale,
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) =>
                          const BodyMapScreen(gender: 'male')),
                      ),
                    ),
                    _GenderPill(
                      label: '👩 \${t("female")}',
                      active: isFemale,
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) =>
                          const BodyMapScreen(gender: 'female')),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // View tabs
          TabBar(
            controller: _viewCtrl,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            indicator: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            labelColor: AppColors.blue,
            unselectedLabelColor: Colors.white54,
            labelStyle: const TextStyle(
                fontSize: 10, fontWeight: FontWeight.w700),
            padding: const EdgeInsets.only(bottom: 8),
            overlayColor:
                WidgetStateProperty.all(Colors.transparent),
            tabs: _views.map((v) => Tab(text: t(v))).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 72,
      color: Colors.white,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(
            vertical: 8, horizontal: 5),
        itemCount: _systems.length,
        itemBuilder: (_, i) {
          final sys = _systems[i];
          final key = sys['key'] as String;
          final color = sys['color'] as Color;
          final isActive = _activeSystem == key;
          return GestureDetector(
            onTap: () =>
                setState(() => _activeSystem = key),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: const EdgeInsets.only(bottom: 5),
              padding: const EdgeInsets.symmetric(
                  horizontal: 5, vertical: 6),
              decoration: BoxDecoration(
                color: isActive
                    ? color.withOpacity(0.12)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isActive
                      ? color
                      : Colors.transparent,
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 10, height: 10,
                    decoration: BoxDecoration(
                      color: color, shape: BoxShape.circle),
                  ),
                  const SizedBox(height: 3),
                  Text(t(key),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                      color: isActive
                          ? color
                          : AppColors.textSecondary,
                    )),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBodyMap(bool isFemale, Color skinColor) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: const Color(0xFFE3EAF2), width: 0.5),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
                vertical: 5),
            decoration: const BoxDecoration(
              color: Color(0xFFE6F1FB),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
            ),
            child: Center(
              child: Text(
                '\${t("tap_body")} \${isFemale ? "👩" : "👨"}',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.blue,
                ),
              ),
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (ctx, constraints) {
                final w = constraints.maxWidth;
                final h = constraints.maxHeight;
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    // Background Silhouette
                    Icon(
                      isFemale ? Icons.woman_rounded : Icons.man_rounded,
                      size: h * 0.95,
                      color: skinColor.withOpacity(0.3),
                    ),
                    GestureDetector(
                      onTapDown: (details) {
                        final dx = details.localPosition.dx / w;
                        final dy = details.localPosition.dy / h;
                        _handleBodyTap(dx, dy);
                      },
                      child: CustomPaint(
                        size: Size(w, h),
                        painter: _BodyPainter(
                          parts: _filteredParts,
                          selected: _selected,
                          skinColor: skinColor,
                          isFemale: isFemale,
                          lang: _lang,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _handleBodyTap(double dx, double dy) {
    // Find closest body part to tap
    BodyPart? closest;
    double minDist = double.infinity;

    for (final part in _filteredParts) {
      final px = part.frontOffset.dx;
      final py = part.frontOffset.dy;
      final dist = ((dx - px) * (dx - px) +
              (dy - py) * (dy - py))
          .abs();
      if (dist < minDist) {
        minDist = dist;
        closest = part;
      }
    }

    if (closest != null && minDist < 0.01) {
      _togglePart(closest.key);
    } else if (closest != null && minDist < 0.03) {
      _togglePart(closest.key);
    }
  }

  Widget _buildSelectedParts() {
    if (_selected.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 6, 10, 4),
      decoration: const BoxDecoration(
        border: Border(
            top: BorderSide(
                color: Color(0xFFE3EAF2), width: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t('selected_parts'),
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
              letterSpacing: 0.5,
            )),
          const SizedBox(height: 5),
          Wrap(
            spacing: 5, runSpacing: 4,
            children: _selected.map((key) =>
              GestureDetector(
                onTap: () => _togglePart(key),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFCEBEB),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(t(key),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFA32D2D),
                        )),
                      const SizedBox(width: 4),
                      const Icon(Icons.close_rounded,
                          size: 10,
                          color: Color(0xFFA32D2D)),
                    ],
                  ),
                ),
              ),
            ).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPainScale() {
    final faces = [
      ('😊', 'no_pain'),
      ('🙂', 'mild'),
      ('😐', 'moderate'),
      ('😣', 'severe'),
      ('😭', 'worst'),
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(10, 6, 10, 6),
      decoration: const BoxDecoration(
        border: Border(
            top: BorderSide(
                color: Color(0xFFE3EAF2), width: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t('pain_level'),
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
              letterSpacing: 0.5,
            )),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceEvenly,
            children: faces.asMap().entries.map((e) {
              final idx = e.key;
              final emoji = e.value.$1;
              final label = e.value.$2;
              final isSelected = _painLevel == idx;
              return GestureDetector(
                onTap: () =>
                    setState(() => _painLevel = idx),
                child: AnimatedContainer(
                  duration:
                      const Duration(milliseconds: 180),
                  width: 44, height: 52,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFFFCEBEB)
                        : const Color(0xFFF4F7FB),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.emergency
                          : const Color(0xFFE3EAF2),
                      width: isSelected ? 1.5 : 0.5,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      Text(emoji,
                          style: const TextStyle(
                              fontSize: 20)),
                      const SizedBox(height: 2),
                      Text(t(label),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? AppColors.emergency
                              : AppColors.textSecondary,
                        )),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 6, 10, 10),
      child: SizedBox(
        width: double.infinity,
        height: 44,
        child: ElevatedButton(
          onPressed: _selected.isEmpty ? null : _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.blue,
            foregroundColor: Colors.white,
            disabledBackgroundColor:
                AppColors.bgMuted,
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
          child: Text(t('send_doctor'),
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800)),
        ),
      ),
    );
  }

  void _submit() {
    final parts =
        _selected.map((k) => t(k)).join(', ');
    final painLabels = [
        'no_pain', 'mild', 'moderate',
        'severe', 'worst'];
    final pain = _painLevel >= 0
        ? t(painLabels[_painLevel])
        : '';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18)),
        title: Text(t('send_doctor'),
          style: const TextStyle(
              fontWeight: FontWeight.w800)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('\${t("selected_parts")}: \$parts'),
            if (pain.isNotEmpty)
              Text('\${t("pain_level")}: \$pain'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // popup
              Navigator.pop(context, _selected.toList()); // screen
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.blue,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(t('submit'))),
        ],
      ),
    );
  }
}

// ── Gender Pill ──────────────────────────────────────────
class _GenderPill extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _GenderPill({required this.label,
      required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(
            horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: active
              ? Colors.white
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: active
                ? AppColors.blue
                : Colors.white54,
          )),
      ),
    );
  }
}

// ── Body Painter ─────────────────────────────────────────
class _BodyPainter extends CustomPainter {
  final List<BodyPart> parts;
  final Set<String> selected;
  final Color skinColor;
  final bool isFemale;
  final String lang;

  const _BodyPainter({
    required this.parts,
    required this.selected,
    required this.skinColor,
    required this.isFemale,
    required this.lang,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final part in parts) {
      final isSelected = selected.contains(part.key);
      final cx = part.frontOffset.dx * size.width;
      final cy = part.frontOffset.dy * size.height;
      final w = part.width * size.width / 300;
      final h = part.height * size.height / 600;

      final paint = Paint()
        ..color = isSelected
            ? part.systemColor.withOpacity(0.85)
            : skinColor.withOpacity(0.9)
        ..style = PaintingStyle.fill;

      final strokePaint = Paint()
        ..color = isSelected
            ? part.systemColor
            : part.systemColor.withOpacity(0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = isSelected ? 2.0 : 1.0;

      final rect = RRect.fromRectAndRadius(
        Rect.fromCenter(
            center: Offset(cx, cy), width: w, height: h),
        Radius.circular(w * 0.2), // Rounded like a 3D pill
      );

      // 3D Shadow
      canvas.drawRRect(
        rect.shift(const Offset(2, 4)),
        Paint()
          ..color = Colors.black.withOpacity(0.2)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
      );

      // Base color
      canvas.drawRRect(rect, paint);

      // 3D Specular Highlight Gradient
      final gradient = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.6),
          Colors.white.withOpacity(0.0),
          Colors.black.withOpacity(0.1),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(rect.outerRect);
      
      canvas.drawRRect(rect, Paint()..shader = gradient);

      // Stroke
      canvas.drawRRect(rect, strokePaint);

      // Label
      final label =
          TranslationService.get(part.key, lang);
      final tp = TextPainter(
        text: TextSpan(
          text: label,
          style: TextStyle(
            fontSize: (w * 0.22).clamp(6.0, 9.0),
            fontWeight: isSelected
                ? FontWeight.w900
                : FontWeight.w700,
            color: isSelected
                ? Colors.white
                : part.systemColor.withOpacity(0.9),
            shadows: isSelected ? [
              Shadow(color: Colors.black.withOpacity(0.3), blurRadius: 2, offset: const Offset(1,1))
            ] : null,
          ),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      )..layout(maxWidth: w);

      tp.paint(
        canvas,
        Offset(cx - tp.width / 2, cy - tp.height / 2),
      );
    }
  }

  @override
  bool shouldRepaint(_BodyPainter old) =>
      old.selected != selected ||
      old.parts != parts ||
      old.lang != lang;
}
