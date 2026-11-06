import '../../domain/entities/alternative_product.dart';

class AlternativeProductModel extends AlternativeProduct {
  const AlternativeProductModel({
    required super.id,
    required super.name,
    required super.brand,
    required super.imageUrl,
    required super.ethicsScore,
    required super.description,
    required super.tagBadges,
    required super.comparisonMetric,
    super.category,
    super.priceEstimate,
    super.carbonFootprintReduction,
    super.certifications,
  });

  factory AlternativeProductModel.fromJson(Map<String, dynamic> json) {
    return AlternativeProductModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      brand: json['brand']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString() ?? '',
      ethicsScore: double.tryParse(json['ethicsScore']?.toString() ?? '') ?? 9.0,
      description: json['description']?.toString() ?? '',
      tagBadges: (json['tagBadges'] as List?)?.map((e) => e.toString()).toList() ?? [],
      comparisonMetric: json['comparisonMetric']?.toString() ?? '',
      category: json['category']?.toString() ?? 'Food & Beverage',
      priceEstimate: json['priceEstimate']?.toString() ?? '€2.49',
      carbonFootprintReduction:
          double.tryParse(json['carbonFootprintReduction']?.toString() ?? '') ?? -50.0,
      certifications: json['certifications']?.toString() ?? 'Fairtrade, B-Corp',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'imageUrl': imageUrl,
      'ethicsScore': ethicsScore,
      'description': description,
      'tagBadges': tagBadges,
      'comparisonMetric': comparisonMetric,
      'category': category,
      'priceEstimate': priceEstimate,
      'carbonFootprintReduction': carbonFootprintReduction,
      'certifications': certifications,
    };
  }
}
