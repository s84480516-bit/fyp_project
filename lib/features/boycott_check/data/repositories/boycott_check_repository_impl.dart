import '../../domain/entities/boycott_record.dart';
import '../../domain/repositories/boycott_check_repository.dart';
import '../datasources/boycott_data_source.dart';

class BoycottCheckRepositoryImpl implements BoycottCheckRepository {
  final BoycottDataSource _dataSource;

  BoycottCheckRepositoryImpl(this._dataSource);

  @override
  Future<BoycottRecord> checkBrand(String brandName) async {
    return await _dataSource.checkBrand(brandName);
  }
}
