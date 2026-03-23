import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/locale/locale_cubit.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/widgets/voice_form_assistant_translated.dart';
import '../language/language_selector.dart';

class EmergencyHospitalBookingTranslated extends StatefulWidget {
  final String patientId;
  final String patientName;
  final Map<String, dynamic>? emergencyData;

  const EmergencyHospitalBookingTranslated({
    Key? key,
    required this.patientId,
    required this.patientName,
    this.emergencyData,
  }) : super(key: key);

  @override
  _EmergencyHospitalBookingTranslatedState createState() => 
      _EmergencyHospitalBookingTranslatedState();
}

class _EmergencyHospitalBookingTranslatedState 
    extends State<EmergencyHospitalBookingTranslated> {
  
  final TextEditingController _symptomsController = TextEditingController();
  final TextEditingController _patientConditionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _emergencyNotesController = TextEditingController();
  
  String _selectedSpecialization = 'All';
  
  final List<String> _specializations = [
    'All',
    'Orthopedics',
    'Emergency Medicine',
    'Cardiology',
    'Neurology',
    'General Surgery',
    'Trauma Care',
    'ICU/Critical Care',
  ];
  
  Map<String, String> _translatedSpecializations = {};
  
  @override
  void initState() {
    super.initState();
  }
  
  void _loadTranslations(AppLocalizations t) {
    _translatedSpecializations = {
      'All': t.translate('all'),
      'Orthopedics': t.translate('orthopedics'),
      'Emergency Medicine': t.translate('emergency_medicine'),
      'Cardiology': t.translate('cardiology'),
      'Neurology': t.translate('neurology'),
      'General Surgery': t.translate('general_surgery'),
      'Trauma Care': t.translate('trauma_care'),
      'ICU/Critical Care': t.translate('icu_critical_care'),
    };
  }
  
  Future<void> _useVoiceInput(AppLocalizations t) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => VoiceFormAssistantTranslated(
        fields: [
          VoiceFieldTranslated(
            label: t.translate('symptoms'),
            controller: _symptomsController,
            prompt: t.translate('voice_prompt_symptoms'),
          ),
          VoiceFieldTranslated(
            label: t.translate('patient_condition'),
            controller: _patientConditionController,
            prompt: t.translate('voice_prompt_condition'),
          ),
          VoiceFieldTranslated(
            label: t.translate('location'),
            controller: _locationController,
            prompt: t.translate('voice_prompt_location'),
          ),
          VoiceFieldTranslated(
            label: t.translate('additional_notes'),
            controller: _emergencyNotesController,
            prompt: t.translate('voice_prompt_notes'),
          ),
        ],
        onComplete: () {
          Navigator.pop(context);
        },
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    _loadTranslations(t);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(t.translate('emergency_hospital_booking')),
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            icon: Icon(Icons.language),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => const LanguageSelector(),
              );
            },
            tooltip: t.translate('change_language'),
          ),
          IconButton(
            icon: Icon(Icons.mic),
            onPressed: () => _useVoiceInput(t),
            tooltip: t.translate('voice_input'),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildEmergencyForm(t),
          Expanded(
            child: _buildSpecializationChips(t),
          ),
        ],
      ),
    );
  }
  
  Widget _buildEmergencyForm(AppLocalizations t) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.red),
              SizedBox(width: 8),
              Text(
                t.translate('emergency_details'),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              TextButton.icon(
                onPressed: () => _useVoiceInput(t),
                icon: Icon(Icons.mic),
                label: Text(t.translate('voice_input')),
              ),
            ],
          ),
          SizedBox(height: 8),
          TextField(
            controller: _symptomsController,
            decoration: InputDecoration(
              hintText: t.translate('symptoms_hint'),
              labelText: t.translate('symptoms'),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
          SizedBox(height: 8),
          TextField(
            controller: _patientConditionController,
            decoration: InputDecoration(
              hintText: t.translate('condition_hint'),
              labelText: t.translate('patient_condition'),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
          SizedBox(height: 8),
          TextField(
            controller: _locationController,
            decoration: InputDecoration(
              hintText: t.translate('location_hint'),
              labelText: t.translate('location'),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSpecializationChips(AppLocalizations t) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            t.translate('select_specialization'),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
        ),
        Container(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: _specializations.length,
            itemBuilder: (context, index) {
              final spec = _specializations[index];
              final isSelected = _selectedSpecialization == spec;
              return Padding(
                padding: EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(_translatedSpecializations[spec] ?? spec),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedSpecialization = spec;
                    });
                  },
                  backgroundColor: Colors.grey[200],
                  selectedColor: Colors.red[100],
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.red : Colors.black,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              );
            },
          ),
        ),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.local_hospital,
                  size: 80,
                  color: Colors.red.withOpacity(0.5),
                ),
                SizedBox(height: 16),
                Text(
                  t.translate('select_hospital_from_map'),
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    // Navigate to map view
                  },
                  icon: Icon(Icons.map),
                  label: Text(t.translate('view_nearby_hospitals')),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
