class UserModel {
  final int id;
  final String email;
  final String? fullName;
  final String? profilePicture;
  final int? birthYear;
  final int? birthMonth;
  
  UserModel({
    required this.id,
    required this.email,
    this.fullName,
    this.profilePicture,
    this.birthYear,
    this.birthMonth,
  });
  
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      fullName: json['full_name'],
      profilePicture: json['profile_picture'],
      birthYear: json['birth_year'],
      birthMonth: json['birth_month'],
    );
  }
  
  int? get currentAge {
    if (birthYear == null) return null;
    return DateTime.now().year - birthYear!;
  }
  
  int get livedMonths {
    if (birthYear == null || birthMonth == null) return 0;
    final now = DateTime.now();
    final birth = DateTime(birthYear!, birthMonth!);
    return ((now.difference(birth).inDays) / 30).round();
  }
}
