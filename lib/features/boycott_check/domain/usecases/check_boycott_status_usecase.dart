import '../entities/boycott_record.dart';
import '../repositories/boycott_check_repository.dart';

class CheckBoycottStatusUseCase {
  final BoycottCheckRepository _repository;

  CheckBoycottStatusUseCase(this._repository);

  Future<BoycottRecord> call(String brandName) async {
    return await _repository.checkBrand(brandName);
  }
}
