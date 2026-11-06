import 'package:flutter/foundation.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/get_product_by_barcode_usecase.dart';
import '../../domain/usecases/get_recent_scans_usecase.dart';
import '../../domain/usecases/search_products_usecase.dart';

enum ScannerStatus { initial, scanning, loading, success, error }

class ScannerProvider extends ChangeNotifier {
  final GetProductByBarcodeUseCase _getProductByBarcodeUseCase;
  final SearchProductsUseCase _searchProductsUseCase;
  final GetRecentScansUseCase _getRecentScansUseCase;

  ScannerProvider({
    required GetProductByBarcodeUseCase getProductByBarcodeUseCase,
    required SearchProductsUseCase searchProductsUseCase,
    required GetRecentScansUseCase getRecentScansUseCase,
  })  : _getProductByBarcodeUseCase = getProductByBarcodeUseCase,
        _searchProductsUseCase = searchProductsUseCase,
        _getRecentScansUseCase = getRecentScansUseCase;

  MobileScannerController? _scannerController;
  MobileScannerController get scannerController {
    _scannerController ??= MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back,
      torchEnabled: false,
    );
    return _scannerController!;
  }

  ScannerStatus _status = ScannerStatus.initial;
  ScannerStatus get status => _status;

  bool _isTorchOn = false;
  bool get isTorchOn => _isTorchOn;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Product? _scannedProduct;
  Product? get scannedProduct => _scannedProduct;

  List<Product> _recentScans = [];
  List<Product> get recentScans => _recentScans;

  List<Product> _searchResults = [];
  List<Product> get searchResults => _searchResults;

  bool _isSearching = false;
  bool get isSearching => _isSearching;

  int _selectedNavIndex = 0;
  int get selectedNavIndex => _selectedNavIndex;

  void setNavIndex(int index) {
    _selectedNavIndex = index;
    notifyListeners();
  }

  Future<void> initScanner() async {
    _status = ScannerStatus.scanning;
    await loadRecentScans();
  }

  Future<void> loadRecentScans() async {
    try {
      _recentScans = await _getRecentScansUseCase();
      notifyListeners();
    } catch (_) {}
  }

  Future<void> toggleTorch() async {
    _isTorchOn = !_isTorchOn;
    try {
      await scannerController.toggleTorch();
    } catch (_) {}
    notifyListeners();
  }

  Future<Product?> onBarcodeDetected(String barcode) async {
    if (_status == ScannerStatus.loading) return null;
    final cleanBarcode = barcode.trim();
    if (cleanBarcode.isEmpty) return null;

    _status = ScannerStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final product = await _getProductByBarcodeUseCase(cleanBarcode);
      _scannedProduct = product;
      _status = ScannerStatus.success;
      await loadRecentScans();
      notifyListeners();
      return product;
    } catch (e) {
      _errorMessage = 'Could not retrieve product information: ${e.toString()}';
      _status = ScannerStatus.error;
      notifyListeners();
      return null;
    }
  }

  Future<void> searchProducts(String query) async {
    if (query.trim().isEmpty) {
      _searchResults = [];
      _isSearching = false;
      notifyListeners();
      return;
    }

    _isSearching = true;
    notifyListeners();

    try {
      _searchResults = await _searchProductsUseCase(query);
    } catch (e) {
      _searchResults = [];
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }

  void clearSearch() {
    _searchResults = [];
    _isSearching = false;
    notifyListeners();
  }

  void resetScanner() {
    _status = ScannerStatus.scanning;
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _scannerController?.dispose();
    super.dispose();
  }
}
