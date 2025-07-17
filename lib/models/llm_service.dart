class LLMService {
  final String name;
  final String description;
  final String url;
  final String icon;

  const LLMService({
    required this.name,
    required this.description,
    required this.url,
    required this.icon,
  });

  factory LLMService.fromJson(Map<String, dynamic> json) {
    return LLMService(
      name: json['name'] as String,
      description: json['description'] as String,
      url: json['url'] as String,
      icon: json['icon'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'description': description, 'url': url, 'icon': icon};
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LLMService &&
        other.name == name &&
        other.description == description &&
        other.url == url &&
        other.icon == icon;
  }

  @override
  int get hashCode {
    return name.hashCode ^ description.hashCode ^ url.hashCode ^ icon.hashCode;
  }
}
