class MilestoneModel {
  final int id;
  final String title;
  final String? reason;
  final int targetYear;
  final int targetMonth;
  final String color;
  final bool isCompleted;
  
  MilestoneModel({
    required this.id,
    required this.title,
    this.reason,
    required this.targetYear,
    required this.targetMonth,
    this.color = '#FF6B35',
    this.isCompleted = false,
  });
  
  factory MilestoneModel.fromJson(Map<String, dynamic> json) {
    return MilestoneModel(
      id: json['id'],
      title: json['title'],
      reason: json['reason'],
      targetYear: json['target_year'],
      targetMonth: json['target_month'],
      color: json['color'] ?? '#FF6B35',
      isCompleted: json['is_completed'] == 1,
    );
  }
  
  int get monthIndex {
    return ((targetYear - 1900) * 12) + targetMonth - 1;
  }
}
