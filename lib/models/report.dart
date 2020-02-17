class Report {
  final String recipeId;
  final String reportedBy;
  final String content;
  final String action;

  Report({
    this.recipeId,
    this.reportedBy,
    this.content,
    this.action = '',
  });

  Report.fromData(Map<String, dynamic> data)
      : recipeId = data['recipeId'],
        reportedBy = data['reportedBy'],
        content = data['content'],
        action = data['action'];

  Map<String, dynamic> toJson() {
    return {
      'recipeId': recipeId,
      'reportedBy': reportedBy,
      'content': content,
      'action': action,
    };
  }
}
