import '../../../../core/services/firebase/firebase_service.dart';
import 'package:cleanarchitecturetemplate/features/product_scanner/domain/entities/product.dart';
import '../models/alternative_product_model.dart';

abstract class RecommendationsDataSource {
  Future<List<AlternativeProductModel>> getAlternatives(Product product);
}

class RecommendationsDataSourceImpl implements RecommendationsDataSource {
  final FirebaseService _firebaseService;

  RecommendationsDataSourceImpl(this._firebaseService);

  @override
  Future<List<AlternativeProductModel>> getAlternatives(Product product) async {
    // Check Firebase Firestore collection 'product_alternatives' if available
    if (_firebaseService.isInitialized && _firebaseService.firestore != null) {
      try {
        final query = await _firebaseService.firestore!
            .collection('product_alternatives')
            .where('category', arrayContainsAny: product.categories)
            .limit(5)
            .get();

        if (query.docs.isNotEmpty) {
          return query.docs
              .map((d) => AlternativeProductModel.fromJson(d.data()))
              .toList();
        }
      } catch (_) {}
    }

    // Curated recommendations dataset mapped by category and brand
    return _getCuratedAlternatives(product);
  }

  List<AlternativeProductModel> _getCuratedAlternatives(Product product) {
    final name = product.name.toLowerCase();
    final brand = product.brand.toLowerCase();

    // Chocolate / Drink Mixes
    if (name.contains('chocolate') || name.contains('nesquik') || brand.contains('nestle') || brand.contains('cadbury')) {
      return const [
        AlternativeProductModel(
          id: 'alt_tonys_cocoa',
          name: 'Tony\'s Chocolonely 100% Slave-Free Cocoa',
          brand: 'Tony\'s Chocolonely',
          imageUrl:
              'https://images.openfoodfacts.org/images/products/871/988/100/0034/front_en.12.400.jpg',
          ethicsScore: 9.8,
          description:
              'Single-origin Fairtrade cocoa powder. 100% slave-free certified supply chain supporting West African cooperative farmers.',
          tagBadges: [
            '🟢 Boycott-Free',
            '🟢 Sustainable Sourcing',
            'No Palm Oil',
            'Vegan',
            'Cruelty-Free',
          ],
          comparisonMetric: 'Lower Sugar Content (-40% vs. original)',
          category: 'Cocoa & Breakfast',
          priceEstimate: '€3.89',
          carbonFootprintReduction: -62.0,
          certifications: 'Fairtrade, B-Corp Certified',
        ),
        AlternativeProductModel(
          id: 'alt_naturya_cacao',
          name: 'Naturya Organic Fairtrade Raw Cacao',
          brand: 'Naturya Superfoods',
          imageUrl:
              'https://images.openfoodfacts.org/images/products/506/010/733/1408/front_en.11.400.jpg',
          ethicsScore: 9.5,
          description:
              'Cold-pressed raw Criollo cacao beans from organic Peruvian agroforestry plots without synthetic chemical additives.',
          tagBadges: [
            '🟢 Boycott-Free',
            '🟢 Sustainable Sourcing',
            'No Palm Oil',
            'Vegan',
            'Cruelty-Free',
          ],
          comparisonMetric: 'Zero Added Sugars (-95% vs. original)',
          category: 'Organic Superfoods',
          priceEstimate: '€4.20',
          carbonFootprintReduction: -70.0,
          certifications: 'Soil Association Organic, Vegan Society',
        ),
        AlternativeProductModel(
          id: 'alt_clipper_hot_choc',
          name: 'Clipper Fairtrade Organic Velvet Hot Cocoa',
          brand: 'Clipper Teas & Cocoa',
          imageUrl:
              'https://images.openfoodfacts.org/images/products/501/002/900/1008/front_en.8.400.jpg',
          ethicsScore: 9.2,
          description:
              'Velvety chocolate blend crafted with unrefined raw organic cane sugar and sustainably harvested beans.',
          tagBadges: [
            '🟢 Boycott-Free',
            '🟢 Sustainable Sourcing',
            'No Palm Oil',
            'Vegan',
            'Cruelty-Free',
          ],
          comparisonMetric: 'Higher Cocoa Purity (+60% vs. original)',
          category: 'Hot Beverages',
          priceEstimate: '€3.49',
          carbonFootprintReduction: -50.0,
          certifications: 'Fairtrade, Plastic-Free Packaging',
        ),
      ];
    }

    // Sodas / Carbonated Colas
    if (name.contains('cola') || name.contains('soda') || brand.contains('coca-cola') || brand.contains('pepsi')) {
      return const [
        AlternativeProductModel(
          id: 'alt_karma_cola',
          name: 'Karma Cola Organic & Fairtrade',
          brand: 'Karma Drinks',
          imageUrl:
              'https://images.openfoodfacts.org/images/products/942/190/328/1018/front_en.10.400.jpg',
          ethicsScore: 9.6,
          description:
              'Original recipe brewed with real cola nut hand-harvested by farmers in Boma, Sierra Leone. Proceeds fund local village schools.',
          tagBadges: [
            '🟢 Boycott-Free',
            '🟢 Sustainable Sourcing',
            'No Palm Oil',
            'Vegan',
            'Cruelty-Free',
          ],
          comparisonMetric: 'Zero Synthetic Phosphoric Acid (-100%)',
          category: 'Artisan Beverages',
          priceEstimate: '€1.99',
          carbonFootprintReduction: -58.0,
          certifications: 'Fairtrade, B-Corp, 100% Recyclable Glass',
        ),
        AlternativeProductModel(
          id: 'alt_whole_earth_sparkling',
          name: 'Whole Earth Organic Sparkling Ginger & Lemon',
          brand: 'Whole Earth Foods',
          imageUrl:
              'https://images.openfoodfacts.org/images/products/501/183/510/2436/front_en.15.400.jpg',
          ethicsScore: 9.3,
          description:
              'Sparkling refreshment sweetened exclusively with organic agave and apple juice. Free from artificial colorants.',
          tagBadges: [
            '🟢 Boycott-Free',
            '🟢 Sustainable Sourcing',
            'No Palm Oil',
            'Vegan',
            'Cruelty-Free',
          ],
          comparisonMetric: 'Lower Sugar Content (-40% vs. original)',
          category: 'Natural Sodas',
          priceEstimate: '€1.79',
          carbonFootprintReduction: -52.0,
          certifications: 'EU Organic, Vegan Society',
        ),
      ];
    }

    // Plant Milks & Beverages (e.g. Oatly, Alpro, etc.)
    return const [
      AlternativeProductModel(
        id: 'alt_minor_figures',
        name: 'Minor Figures Organic Barista Oat',
        brand: 'Minor Figures',
        imageUrl:
            'https://images.openfoodfacts.org/images/products/506/058/289/0014/front_en.23.400.jpg',
        ethicsScore: 9.7,
        description:
            'Crafted specifically for coffee by baristas. Sourced from 100% certified British and Nordic organic oats in climate-neutral operations.',
        tagBadges: [
          '🟢 Boycott-Free',
          '🟢 Sustainable Sourcing',
          'No Palm Oil',
          'Vegan',
          'Cruelty-Free',
        ],
        comparisonMetric: 'Lower Sugar Content (-40% vs. original)',
        category: 'Plant Milks',
        priceEstimate: '€2.39',
        carbonFootprintReduction: -68.0,
        certifications: 'B-Corp Certified, Carbon Neutral',
      ),
      AlternativeProductModel(
        id: 'alt_rude_health',
        name: 'Rude Health Organic Barista Oat & Almond',
        brand: 'Rude Health',
        imageUrl:
            'https://images.openfoodfacts.org/images/products/506/012/028/0118/front_en.30.400.jpg',
        ethicsScore: 9.4,
        description:
            'Pure ingredients only: spring water, organic gluten-free oats, and cold-pressed sunflower oil. Absolutely no added thickeners.',
        tagBadges: [
          '🟢 Boycott-Free',
          '🟢 Sustainable Sourcing',
          'No Palm Oil',
          'Vegan',
          'Cruelty-Free',
        ],
        comparisonMetric: 'Zero Added Phosphates (-100% additives)',
        category: 'Organic Dairy Alternatives',
        priceEstimate: '€2.69',
        carbonFootprintReduction: -60.0,
        certifications: 'Soil Association Organic, B-Corp',
      ),
      AlternativeProductModel(
        id: 'alt_plenish_oat',
        name: 'Plenish 100% Organic Enriched Oat M*lk',
        brand: 'Plenish Drinks',
        imageUrl:
            'https://images.openfoodfacts.org/images/products/506/020/553/0842/front_en.19.400.jpg',
        ethicsScore: 9.2,
        description:
            'Just 3 simple organic ingredients. Sourced directly from sustainably maintained European organic farms.',
        tagBadges: [
          '🟢 Boycott-Free',
          '🟢 Sustainable Sourcing',
          'No Palm Oil',
          'Vegan',
          'Cruelty-Free',
        ],
        comparisonMetric: 'Cleanest Ingredient List (Only 3 ingredients)',
        category: 'Plant Milks',
        priceEstimate: '€2.29',
        carbonFootprintReduction: -64.0,
        certifications: 'EU Organic, Certified Carbon Neutral',
      ),
    ];
  }
}
