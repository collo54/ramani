class MarkerMetaData {
  final String infoWindow;
  final String markerId;
  final String description;
  final String assetString;
  // final List<String> preventativeMeasures;
  // final List<String> treatment;

  const MarkerMetaData({
    required this.infoWindow,
    required this.markerId,
    required this.description,
    required this.assetString,
    // required this.preventativeMeasures,
    // required this.treatment,
  });

  factory MarkerMetaData.fromJson(Map<String, dynamic> json) {
    return MarkerMetaData(
      infoWindow: json['infoWindow'] as String,
      markerId: json['markerId'] as String,
      description: json['description'] as String,
      assetString: json['assetString'] as String,
      // preventativeMeasures:
      //     List<String>.from(json['Preventative Measures'] as List),
      // treatment: List<String>.from(json['Treatment'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['infoWindow'] = infoWindow;
    data['markerId'] = markerId;
    data['description'] = description;
    data['assetString'] = assetString;
    return data;
  }
}

// {
//   "infoWindow": "Corn",
//   "markerId": "Aspergillus ear rot",
//   "Human and Livestock Danger": "Aspergillus molds produce mycotoxins that are harmful to both humans and livestock. Consumption of contaminated grain can lead to various health issues like liver damage, reduced immune function, and potentially even cancer.",
//   "Cause of markerId": "Infection occurs during pollination or soon after, particularly when silks remain moist for extended periods due to high humidity or rain.  Wounding of the ear by insects or birds makes infection more likely.",
//   "Preventative Measures": ["infoWindow resistant corn hybrids if available.", "Ensure proper irrigation to avoid stressing infoWindows, particularly during silking.", "Control insect pests and birds that can damage ears.", "Rotate crops regularly.", "Till under crop residue after harvest to reduce fungal inoculum."]
// }


// {
//   "infoWindow": "no infoWindow detected",
//   "markerId": "no markerId present",
//   "Human and Livestock Danger": "no dangers",
//   "Cause of markerId": "not applicable",
//   "Preventative Measures": []
// }

