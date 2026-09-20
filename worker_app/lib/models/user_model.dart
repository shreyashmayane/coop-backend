import 'dart:convert';

class UserModel {
  final String id;
  final String name;
  final String phone;
  final String? email;
  final String? address;
  final String? avatarUrl;
  final String locale;
  final String status;

  const UserModel({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    this.address,
    this.avatarUrl,
    this.locale = 'en',
    this.status = 'active',
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: (json['_id'] ?? json['id'] ?? '').toString(),
        name: json['name'] ?? '',
        phone: json['phone'] ?? '',
        email: json['email'],
        address: json['address'],
        avatarUrl: json['avatarUrl'],
        locale: json['locale'] ?? 'en',
        status: json['status'] ?? 'active',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
        'email': email,
        'address': address,
        'avatarUrl': avatarUrl,
        'locale': locale,
        'status': status,
      };

  String toJsonString() => jsonEncode(toJson());

  factory UserModel.fromJsonString(String s) =>
      UserModel.fromJson(jsonDecode(s) as Map<String, dynamic>);

  UserModel copyWith({
    String? name,
    String? email,
    String? address,
    String? avatarUrl,
    String? locale,
    String? status,
  }) =>
      UserModel(
        id: id,
        phone: phone,
        name: name ?? this.name,
        email: email ?? this.email,
        address: address ?? this.address,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        locale: locale ?? this.locale,
        status: status ?? this.status,
      );
}
