// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class IdCard extends Equatable {
  String firstName;
  String middleName;
  String lastName;
  String nationalNum;
  String docUrl;
  IdCard({
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.nationalNum,
    required this.docUrl,
  });

  @override
  List<Object?> get props => [firstName, middleName, lastName, nationalNum];

  static IdCard empty() => IdCard(
      firstName: '', middleName: '', lastName: '', nationalNum: '', docUrl: '');

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'nationalNum': nationalNum,
      'docUrl': docUrl,
    };
  }

  factory IdCard.fromMap(Map<String, dynamic> map) {
    return IdCard(
      firstName: map['firstName'] as String,
      middleName: map['middleName'] as String,
      lastName: map['lastName'] as String,
      nationalNum: map['nationalNum'] as String,
      docUrl: map['docUrl'] as String,
    );
  }

  IdCard copyWith({
    String? firstName,
    String? middleName,
    String? lastName,
    String? nationalNum,
    String? docUrl,
  }) {
    return IdCard(
      firstName: firstName ?? this.firstName,
      middleName: middleName ?? this.middleName,
      lastName: lastName ?? this.lastName,
      nationalNum: nationalNum ?? this.nationalNum,
      docUrl: docUrl ?? this.docUrl,
    );
  }
}
