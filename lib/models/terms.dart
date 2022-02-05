class Terms {
  final String termId;
  final String name;

  const Terms({
    required this.termId,
    required this.name,
  });

  factory Terms.fromJson(Map<String, dynamic> json) {
    return Terms(
      termId: json['id'],
      name: json['name']['pl'],
    );
  }
}
