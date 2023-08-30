import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Vehicle extends Equatable {
  final String id;
  final String vehicleNameDef;
  final String vehicleNameAR;
  final String vehicleNameEN;
  final double extraCharges;
  final double maximumCoverage;
  final double minimumCoverage;
  final bool status;
  const Vehicle({
    required this.id,
    required this.vehicleNameDef,
    required this.vehicleNameAR,
    required this.vehicleNameEN,
    required this.extraCharges,
    required this.maximumCoverage,
    required this.minimumCoverage,
    required this.status,
  });

  static Vehicle empty() => const Vehicle(
        id: '',
        vehicleNameDef: '',
        vehicleNameAR: '',
        vehicleNameEN: '',
        extraCharges: 0,
        maximumCoverage: 0,
        minimumCoverage: 0,
        status: false,
      );

  @override
  List<Object?> get props => [
        id,
        vehicleNameDef,
        vehicleNameAR,
        vehicleNameEN,
        extraCharges,
        maximumCoverage,
        minimumCoverage,
        status,
      ];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'vehicleNameDef': vehicleNameDef,
      'vehicleNameAR': vehicleNameAR,
      'vehicleNameEN': vehicleNameEN,
      'extraCharges': extraCharges,
      'maximumCoverage': maximumCoverage,
      'minimumCoverage': minimumCoverage,
      'status': status,
    };
  }

  factory Vehicle.fromMap(Map<String, dynamic> map) {
    return Vehicle(
      id: map['id'] as String,
      vehicleNameDef: map['vehicleNameDef'] as String,
      vehicleNameAR: map['vehicleNameAR'] as String,
      vehicleNameEN: map['vehicleNameEN'] as String,
      extraCharges: double.parse(map['extraCharges'].toString()),
      maximumCoverage: double.parse(map['maximumCoverage'].toString()),
      minimumCoverage: double.parse(map['minimumCoverage'].toString()),
      status: map['status'] as bool,
    );
  }

  Vehicle copyWith(
      {String? id,
      String? vehicleNameDef,
      String? vehicleNameAR,
      String? vehicleNameEN,
      double? extraCharges,
      double? maximumCoverage,
      double? minimumCoverage,
      bool? status,
      FieldValue? createdDate,
      FieldValue? updatedDate}) {
    return Vehicle(
      id: id ?? this.id,
      vehicleNameDef: vehicleNameDef ?? this.vehicleNameDef,
      vehicleNameAR: vehicleNameAR ?? this.vehicleNameAR,
      vehicleNameEN: vehicleNameEN ?? this.vehicleNameEN,
      extraCharges: extraCharges ?? this.extraCharges,
      maximumCoverage: maximumCoverage ?? this.maximumCoverage,
      minimumCoverage: minimumCoverage ?? this.minimumCoverage,
      status: status ?? this.status,
    );
  }
}
