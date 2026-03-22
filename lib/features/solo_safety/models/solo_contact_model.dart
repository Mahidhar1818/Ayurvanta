class SoloContact {
  final String id;
  final String name;
  final String phone;
  final String voicePassphrase;   // words user says to trigger
  final String voiceMessage;      // message spoken TO contact
  bool isActive;

  SoloContact({
    required this.id,
    required this.name,
    required this.phone,
    required this.voicePassphrase,
    required this.voiceMessage,
    this.isActive = true,
  });

  Map<String, dynamic> toJson() => {
    'id': id, 'name': name, 'phone': phone,
    'voicePassphrase': voicePassphrase,
    'voiceMessage': voiceMessage,
    'isActive': isActive,
  };

  factory SoloContact.fromJson(Map<String, dynamic> j) =>
    SoloContact(
      id: j['id'], name: j['name'], phone: j['phone'],
      voicePassphrase: j['voicePassphrase'] ?? 'help me',
      voiceMessage: j['voiceMessage'] ??
          'Emergency! I need help. Please call me immediately.',
      isActive: j['isActive'] ?? true,
    );
}
