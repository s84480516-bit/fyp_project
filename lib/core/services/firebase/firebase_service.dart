import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../logger/logger_service.dart';

class FirebaseService {
  final LoggerService _logger = LoggerService(className: 'FirebaseService');
  bool _isInitialized = false;
  FirebaseFirestore? _firestore;

  bool get isInitialized => _isInitialized;
  FirebaseFirestore? get firestore => _firestore;

  Future<void> initialize() async {
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp();
      }
      _firestore = FirebaseFirestore.instance;
      _isInitialized = true;
      _logger.info('Firebase & Firestore initialized successfully');
    } catch (e) {
      _logger.error(
        'Firebase initialization skipped or running in fallback mode: $e',
      );
      _isInitialized = false;
    }
  }

  /// Helper to fetch custom ingredient safety records from Firestore or fallback
  Future<Map<String, dynamic>?> getIngredientRule(String ingredientName) async {
    if (!_isInitialized || _firestore == null) return null;
    try {
      final doc = await _firestore!
          .collection('ingredient_rules')
          .doc(ingredientName.toLowerCase().trim())
          .get();
      if (doc.exists) {
        return doc.data();
      }
    } catch (e) {
      _logger.error('Error fetching ingredient rule from Firestore: $e');
    }
    return null;
  }
}
