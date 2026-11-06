import '../../domain/entities/boycott_record.dart';

class BoycottRecordModel extends BoycottRecord {
  const BoycottRecordModel({
    required super.brandName,
    required super.parentCompany,
    required super.isFlagged,
    required super.alertMessage,
    required super.boycottLists,
    required super.primaryIssue,
    required super.detailedReason,
    required super.evidenceSource,
    required super.actionRecommendation,
  });

  factory BoycottRecordModel.fromJson(Map<String, dynamic> json) {
    return BoycottRecordModel(
      brandName: json['brandName']?.toString() ?? '',
      parentCompany: json['parentCompany']?.toString() ?? '',
      isFlagged: json['isFlagged'] == true,
      alertMessage: json['alertMessage']?.toString() ?? '',
      boycottLists: (json['boycottLists'] as List?)?.map((e) => e.toString()).toList() ?? [],
      primaryIssue: json['primaryIssue']?.toString() ?? '',
      detailedReason: json['detailedReason']?.toString() ?? '',
      evidenceSource: json['evidenceSource']?.toString() ?? '',
      actionRecommendation: json['actionRecommendation']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'brandName': brandName,
      'parentCompany': parentCompany,
      'isFlagged': isFlagged,
      'alertMessage': alertMessage,
      'boycottLists': boycottLists,
      'primaryIssue': primaryIssue,
      'detailedReason': detailedReason,
      'evidenceSource': evidenceSource,
      'actionRecommendation': actionRecommendation,
    };
  }
}
