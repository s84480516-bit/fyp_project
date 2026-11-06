class BoycottRecord {
  final String brandName;
  final String parentCompany;
  final bool isFlagged;
  final String alertMessage;
  final List<String> boycottLists;
  final String primaryIssue;
  final String detailedReason;
  final String evidenceSource;
  final String actionRecommendation;

  const BoycottRecord({
    required this.brandName,
    required this.parentCompany,
    required this.isFlagged,
    required this.alertMessage,
    required this.boycottLists,
    required this.primaryIssue,
    required this.detailedReason,
    required this.evidenceSource,
    required this.actionRecommendation,
  });
}
