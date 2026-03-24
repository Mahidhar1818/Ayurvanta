import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../core/translations/tr_extension.dart';
import '../../core/widgets/voice_form_assistant.dart';
import '../../models/hospital_model.dart';
import '../../services/hospital_service.dart';
import '../../services/notification_service.dart';

class EmergencyHospitalBookingScreen extends StatefulWidget {
  final String patientId;
  final String patientName;
  final Map<String, dynamic>? emergencyData;

  const EmergencyHospitalBookingScreen({
    Key? key,
    required this.patientId,
    required this.patientName,
    this.emergencyData,
  }) : super(key: key);

  @override
  _EmergencyHospitalBookingScreenState createState() => 
      _EmergencyHospitalBookingScreenState();
}

class _EmergencyHospitalBookingScreenState 
    extends State<EmergencyHospitalBookingScreen> {
  
  final HospitalService _hospitalService = HospitalService();
  
  List<Hospital> _hospitals = [];
  List<Hospital> _filteredHospitals = [];
  bool _isLoading = true;
  String _selectedSpecialization = 'All';
  
  final TextEditingController _symptomsController = TextEditingController();
  final TextEditingController _patientConditionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _emergencyNotesController = TextEditingController();
  
  LatLng? _currentLocation;
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  
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
  
  @override
  void initState() {
    super.initState();
    _loadHospitals();
    _getCurrentLocation();
  }
  
  Future<void> _loadHospitals() async {
    setState(() { _isLoading = true; });
    
    try {
      final hospitals = await _hospitalService.getHospitalsBySpecialization(
        _selectedSpecialization == 'All' ? null : _selectedSpecialization,
      );
      setState(() {
        _hospitals = hospitals;
        _filteredHospitals = hospitals;
        _isLoading = false;
      });
      _addMarkers();
    } catch (e) {
      setState(() { _isLoading = false; });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading hospitals: $e')),
        );
      }
    }
  }
  
  Future<void> _getCurrentLocation() async {
    setState(() {
      _currentLocation = const LatLng(17.385044, 78.486671); 
    });
    
    if (_mapController != null && _currentLocation != null) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _currentLocation!, zoom: 12),
        ),
      );
    }
  }
  
  void _addMarkers() {
    _markers.clear();
    for (var hospital in _filteredHospitals) {
      final marker = Marker(
        markerId: MarkerId(hospital.id),
        position: LatLng(hospital.latitude, hospital.longitude),
        infoWindow: InfoWindow(
          title: hospital.name,
          snippet: hospital.specializations.join(', '),
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          _getMarkerColor(hospital),
        ),
      );
      _markers.add(marker);
    }
    setState(() {});
  }
  
  double _getMarkerColor(Hospital hospital) {
    if (hospital.hasEmergencyWard) return BitmapDescriptor.hueRed;
    if (hospital.hasICU) return BitmapDescriptor.hueOrange;
    return BitmapDescriptor.hueBlue;
  }
  
  void _filterHospitals(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredHospitals = _hospitals;
      } else {
        _filteredHospitals = _hospitals.where((hospital) {
          return hospital.name.toLowerCase().contains(query.toLowerCase()) ||
              hospital.address.toLowerCase().contains(query.toLowerCase()) ||
              hospital.specializations.any((s) => 
                  s.toLowerCase().contains(query.toLowerCase()));
        }).toList();
      }
      _addMarkers();
    });
  }
  
  void _selectSpecialization(String spec) {
    setState(() {
      _selectedSpecialization = spec;
    });
    _loadHospitals();
  }
  
  Future<void> _useVoiceInput() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => VoiceFormAssistant(
        fields: [
          VoiceField(
            label: context.tr('symptoms'),
            controller: _symptomsController,
            prompt: context.tr('voice_prompt_symptoms') ?? 'Please describe the symptoms you are experiencing',
          ),
          VoiceField(
            label: context.tr('patient_condition'),
            controller: _patientConditionController,
            prompt: context.tr('voice_prompt_condition') ?? 'Describe the current condition of the patient',
          ),
          VoiceField(
            label: context.tr('location'),
            controller: _locationController,
            prompt: context.tr('voice_prompt_location') ?? 'Please tell your current location',
          ),
          VoiceField(
            label: context.tr('additional_notes'),
            controller: _emergencyNotesController,
            prompt: context.tr('voice_prompt_notes') ?? 'Any additional information for the hospital',
          ),
        ],
        onComplete: () {
          Navigator.pop(context);
        },
      ),
    );
  }
  
  Future<void> _bookEmergencyOP(Hospital hospital) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.tr('confirm_emergency_booking') ?? 'Confirm Emergency Booking'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hospital: ${hospital.name}'),
            const SizedBox(height: 8),
            Text('Patient: ${widget.patientName}'),
            const SizedBox(height: 8),
            Text('Symptoms: ${_symptomsController.text}'),
            const SizedBox(height: 8),
            Text('Condition: ${_patientConditionController.text}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.tr('cancel')),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(context.tr('book_emergency_op') ?? 'Book Emergency OP'),
          ),
        ],
      ),
    );
    
    if (confirmed == true) {
      setState(() { _isLoading = true; });
      
      try {
        await _hospitalService.bookEmergencyAppointment(
          hospitalId: hospital.id,
          patientId: widget.patientId,
          symptoms: _symptomsController.text,
          condition: _patientConditionController.text,
          location: _locationController.text,
          notes: _emergencyNotesController.text,
        );
        
        await NotificationService.sendSMS(
          phoneNumber: hospital.emergencyPhone,
          message: 'EMERGENCY: Patient ${widget.patientName} is arriving. '
                   'Condition: ${_patientConditionController.text}. ',
        );
        
        await NotificationService.makeVoiceCall(hospital.emergencyPhone);
        
        await NotificationService.sendSMS(
          phoneNumber: await _getPatientPhone(),
          message: 'Emergency OP booked at ${hospital.name}. '
                   'Please reach immediately. '
                   'Emergency Contact: ${hospital.emergencyPhone}',
        );
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Emergency OP booked successfully! '
                           'Hospital has been notified.'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 5),
            ),
          );
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error booking emergency OP: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() { _isLoading = false; });
        }
      }
    }
  }
  
  Future<String> _getPatientPhone() async {
    return '1234567890';
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('emergency_hospital_booking')),
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            icon: const Icon(Icons.mic),
            onPressed: () => _useVoiceInput(),
            tooltip: context.tr('voice_input'),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildSearchBar(),
                _buildSpecializationChips(),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: _buildHospitalList(),
                      ),
                      Expanded(
                        flex: 3,
                        child: _buildMap(),
                      ),
                    ],
                  ),
                ),
                _buildEmergencyForm(),
              ],
            ),
    );
  }
  
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        decoration: InputDecoration(
          hintText: context.tr('search_hospital_hint') ?? 'Search hospitals...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          suffixIcon: IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _getCurrentLocation,
            tooltip: 'Current Location',
          ),
        ),
        onChanged: _filterHospitals,
      ),
    );
  }
  
  Widget _buildSpecializationChips() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _specializations.length,
        itemBuilder: (context, index) {
          final spec = _specializations[index];
          final isSelected = _selectedSpecialization == spec;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(spec),
              selected: isSelected,
              onSelected: (selected) {
                _selectSpecialization(spec);
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
    );
  }
  
  Widget _buildHospitalList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredHospitals.length,
      itemBuilder: (context, index) {
        final hospital = _filteredHospitals[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: () => _showHospitalDetails(hospital),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 40,
                        decoration: BoxDecoration(
                          color: hospital.hasEmergencyWard 
                              ? Colors.red 
                              : Colors.blue,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              hospital.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              hospital.address,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                              maxLines: 2,
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              children: hospital.specializations.take(3).map((spec) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    spec,
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (hospital.distance != null)
                            Text(
                              '${hospital.distance!.toStringAsFixed(1)} km',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () => _bookEmergencyOP(hospital),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text(
                              'Book',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildMap() {
    if (_currentLocation == null) {
      return const Center(child: CircularProgressIndicator());
    }
    
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: _currentLocation!,
        zoom: 12,
      ),
      markers: _markers,
      onMapCreated: (controller) {
        _mapController = controller;
      },
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      compassEnabled: true,
    );
  }
  
  Widget _buildEmergencyForm() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.info_outline, color: Colors.red),
                const SizedBox(width: 8),
                Text(
                  context.tr('emergency_details'),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () => _useVoiceInput(),
                  icon: const Icon(Icons.mic),
                  label: Text(context.tr('voice_input')),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _symptomsController,
              decoration: InputDecoration(
                hintText: context.tr('symptoms_hint') ?? 'Symptoms',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _patientConditionController,
              decoration: InputDecoration(
                hintText: context.tr('condition_hint') ?? 'Patient condition',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _showHospitalDetails(Hospital hospital) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                hospital.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                hospital.address,
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 16),
              const Text(
                'Specializations:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: hospital.specializations.map((spec) {
                  return Chip(
                    label: Text(spec),
                    backgroundColor: Colors.blue[50],
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              if (hospital.hasEmergencyWard)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.local_hospital, color: Colors.red),
                      SizedBox(width: 8),
                      Text(
                        '24/7 Emergency Services Available',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                         Navigator.pop(context);
                         _bookEmergencyOP(hospital);
                      },
                      icon: const Icon(Icons.emergency),
                      label: Text(context.tr('book_emergency_op') ?? 'Book Emergency'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        await NotificationService.makeVoiceCall(
                          hospital.emergencyPhone,
                        );
                      },
                      icon: const Icon(Icons.phone),
                      label: const Text('Call'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
