import '../../domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.barcode,
    required super.name,
    required super.brand,
    required super.imageUrl,
    super.quantity,
    super.categories,
    super.ingredientsText,
    super.rawIngredients,
    super.ecoScore,
    super.novaGroup,
    super.nutriScore,
    super.ethicsScore,
    super.origins,
    super.packaging,
    super.labels,
    super.isBoycotted,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // Open Food Facts wraps product details in "product" or directly in top level
    final data = json.containsKey('product') && json['product'] is Map<String, dynamic>
        ? json['product'] as Map<String, dynamic>
        : json;

    final id = data['_id']?.toString() ?? data['id']?.toString() ?? data['code']?.toString() ?? 'unknown';
    final barcode = data['code']?.toString() ?? data['barcode']?.toString() ?? id;
    final name = (data['product_name'] ?? data['product_name_en'] ?? data['name'] ?? 'Ethical Scan Product').toString();
    final brand = (data['brands'] ?? data['brand'] ?? 'Unknown Brand').toString();
    final imageUrl = (data['image_url'] ?? data['image_front_url'] ?? data['imageUrl'] ?? '').toString();
    final quantity = (data['quantity'] ?? '').toString();

    List<String> categoriesList = [];
    if (data['categories'] is String) {
      categoriesList = (data['categories'] as String)
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
    } else if (data['categories_tags'] is List) {
      categoriesList = (data['categories_tags'] as List)
          .map((e) => e.toString().replaceAll('en:', '').replaceAll('-', ' ').trim())
          .toList();
    }

    final ingredientsText = (data['ingredients_text'] ?? data['ingredients_text_en'] ?? '').toString();

    List<String> rawIngredients = [];
    if (data['ingredients'] is List) {
      rawIngredients = (data['ingredients'] as List)
          .map((i) => (i is Map ? (i['text'] ?? i['id'] ?? '') : i).toString().trim())
          .where((e) => e.isNotEmpty)
          .toList();
    } else if (ingredientsText.isNotEmpty) {
      rawIngredients = ingredientsText
          .split(RegExp(r'[,;]'))
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
    }

    final ecoScore = (data['ecoscore_grade'] ?? data['ecoScore'] ?? 'B').toString().toUpperCase();
    final novaGroup = int.tryParse(data['nova_group']?.toString() ?? '') ?? 2;
    final nutriScore = (data['nutriscore_grade'] ?? data['nutriScore'] ?? 'B').toString().toUpperCase();
    final ethicsScore = double.tryParse(data['ethicsScore']?.toString() ?? '') ?? 6.8;
    final origins = (data['origins'] ?? data['origins_tags']?.toString() ?? 'EU / Sustainable Sourcing').toString();
    final packaging = (data['packaging'] ?? 'Recyclable Carton').toString();

    List<String> labelsList = [];
    if (data['labels_tags'] is List) {
      labelsList = (data['labels_tags'] as List)
          .map((l) => l.toString().replaceAll('en:', '').replaceAll('-', ' ').trim())
          .toList();
    }

    final normalizedBrand = brand.toLowerCase().replaceAll('é', 'e');
    final isBoycotted = data['isBoycotted'] == true ||
        normalizedBrand.contains('nestle') ||
        normalizedBrand.contains('unilever') ||
        normalizedBrand.contains('pepsi') ||
        normalizedBrand.contains('mondelez');

    return ProductModel(
      id: id,
      barcode: barcode,
      name: name,
      brand: brand,
      imageUrl: imageUrl,
      quantity: quantity,
      categories: categoriesList,
      ingredientsText: ingredientsText,
      rawIngredients: rawIngredients,
      ecoScore: ecoScore,
      novaGroup: novaGroup,
      nutriScore: nutriScore,
      ethicsScore: ethicsScore,
      origins: origins,
      packaging: packaging,
      labels: labelsList,
      isBoycotted: isBoycotted,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'barcode': barcode,
      'product_name': name,
      'brands': brand,
      'image_url': imageUrl,
      'quantity': quantity,
      'categories': categories.join(', '),
      'ingredients_text': ingredientsText,
      'rawIngredients': rawIngredients,
      'ecoscore_grade': ecoScore,
      'nova_group': novaGroup,
      'nutriscore_grade': nutriScore,
      'ethicsScore': ethicsScore,
      'origins': origins,
      'packaging': packaging,
      'labels': labels,
      'isBoycotted': isBoycotted,
    };
  }

  factory ProductModel.fromEntity(Product product) {
    return ProductModel(
      id: product.id,
      barcode: product.barcode,
      name: product.name,
      brand: product.brand,
      imageUrl: product.imageUrl,
      quantity: product.quantity,
      categories: product.categories,
      ingredientsText: product.ingredientsText,
      rawIngredients: product.rawIngredients,
      ecoScore: product.ecoScore,
      novaGroup: product.novaGroup,
      nutriScore: product.nutriScore,
      ethicsScore: product.ethicsScore,
      origins: product.origins,
      packaging: product.packaging,
      labels: product.labels,
      isBoycotted: product.isBoycotted,
    );
  }
}
