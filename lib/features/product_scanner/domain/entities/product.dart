class Product {
  final String id;
  final String barcode;
  final String name;
  final String brand;
  final String imageUrl;
  final String quantity;
  final List<String> categories;
  final String ingredientsText;
  final List<String> rawIngredients;
  final String ecoScore;
  final int? novaGroup;
  final String nutriScore;
  final double ethicsScore;
  final String origins;
  final String packaging;
  final List<String> labels;
  final bool isBoycotted;

  const Product({
    required this.id,
    required this.barcode,
    required this.name,
    required this.brand,
    required this.imageUrl,
    this.quantity = '',
    this.categories = const [],
    this.ingredientsText = '',
    this.rawIngredients = const [],
    this.ecoScore = 'B',
    this.novaGroup = 2,
    this.nutriScore = 'B',
    this.ethicsScore = 7.0,
    this.origins = 'Local / Certified',
    this.packaging = 'Recyclable Paper / Glass',
    this.labels = const [],
    this.isBoycotted = false,
  });

  Product copyWith({
    String? id,
    String? barcode,
    String? name,
    String? brand,
    String? imageUrl,
    String? quantity,
    List<String>? categories,
    String? ingredientsText,
    List<String>? rawIngredients,
    String? ecoScore,
    int? novaGroup,
    String? nutriScore,
    double? ethicsScore,
    String? origins,
    String? packaging,
    List<String>? labels,
    bool? isBoycotted,
  }) {
    return Product(
      id: id ?? this.id,
      barcode: barcode ?? this.barcode,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      imageUrl: imageUrl ?? this.imageUrl,
      quantity: quantity ?? this.quantity,
      categories: categories ?? this.categories,
      ingredientsText: ingredientsText ?? this.ingredientsText,
      rawIngredients: rawIngredients ?? this.rawIngredients,
      ecoScore: ecoScore ?? this.ecoScore,
      novaGroup: novaGroup ?? this.novaGroup,
      nutriScore: nutriScore ?? this.nutriScore,
      ethicsScore: ethicsScore ?? this.ethicsScore,
      origins: origins ?? this.origins,
      packaging: packaging ?? this.packaging,
      labels: labels ?? this.labels,
      isBoycotted: isBoycotted ?? this.isBoycotted,
    );
  }
}
