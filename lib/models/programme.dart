class Programme {
  final String id;
  final String name;

  const Programme({
    required this.id,
    required this.name,
  });

  factory Programme.fromJson(Map<String, dynamic> json) {
    return Programme(
      id: json['programme']['id'],
      name: json['programme']['description']['pl'],
    );
  }
}
