import '../entities/boycott_record.dart';

abstract class BoycottCheckRepository {
  Future<BoycottRecord> checkBrand(String brandName);
}
