class AlternativeProduct {
  final String id;
  final String name;
  final String brand;
  final String imageUrl;
  final double ethicsScore;
  final String description;
  final List<String> tagBadges;
  final String comparisonMetric;
  final String category;
  final String priceEstimate;
  final double carbonFootprintReduction;
  final String certifications;

  const AlternativeProduct({
    required this.id,
    required this.name,
    required this.brand,
    required this.imageUrl,
    required this.ethicsScore,
    required this.description,
    required this.tagBadges,
    required this.comparisonMetric,
    this.category = 'Beverages',
    this.priceEstimate = '€2.49',
    this.carbonFootprintReduction = -55.0,
    this.certifications = 'Fairtrade, B-Corp, EU Organic',
  });
}
