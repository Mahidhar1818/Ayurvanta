class HealthScheme {
  final String name;
  final String description;
  final String coverage;
  final String eligibility;
  final String officialUrl;
  final String type; // 'central' or 'state'
  final String category;

  const HealthScheme({
    required this.name,
    required this.description,
    required this.coverage,
    required this.eligibility,
    required this.officialUrl,
    required this.type,
    required this.category,
  });
}

class StateSchemeData {
  final String state;
  final String stateCode;
  final List<HealthScheme> schemes;

  const StateSchemeData({
    required this.state,
    required this.stateCode,
    required this.schemes,
  });
}
