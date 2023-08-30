import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:delivery_app/models/address_info.dart';
import 'package:delivery_app/models/id_card.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../repository/delegate_repository.dart';

part 'create_delegate_event.dart';
part 'create_delegate_state.dart';

class CreateDelegateBloc extends Bloc<CreateDelegateEvent, DelegateState> {
  CreateDelegateBloc(this.delegateRepository) : super(DelegateState.initial) {
    on<_FetchDelegate>(_fetchDelegate);
    on<UpdateDelegate>(_updateDelegate);
    on<DeleteDelegate>(_deleteDelegate);
    on<CreateDelegate>(_createDelegate);
    _subscription = delegateRepository
        .fetchDelegate(FirebaseAuth.instance.currentUser!.uid)
        .listen((event) {
      add(_FetchDelegate(delegate: event));
      phoneNumberController = TextEditingController(text: event.phoneNum);
    });
  }

  final DelegateRepository delegateRepository;
  late final StreamSubscription<Delegate> _subscription;
  Delegate delegate = Delegate.empty();
  Delegate updatedDelegate = Delegate.empty();
  final TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController idNumController = TextEditingController();
  final TextEditingController dateTimeController = TextEditingController(
      text: DateFormat('yyyy-mm-dd').format(DateTime.now()));

  String selectVehicle = '';
  File profilePhoto = File('');
  File photoIdCard = File('');

  FutureOr<void> _createDelegate(CreateDelegate event, emit) async {
    emit(DelegateState.loading);
    _subscription.cancel();
    await delegateRepository.createDelegate(_initDelegate()).then((value) {
      nameController.clear();
      phoneNumberController.clear();
      idNumController.clear();
      profilePhoto = File('');
      photoIdCard = File('');
      emit(DelegateState.success);
    });
  }

  Delegate _initDelegate() {
    return Delegate(
        id: '',
        photoUrl: profilePhoto.path,
        name: nameController.text,
        idCard: _initIDCard(),
        phoneNum: phoneNumberController.text,
        email: FirebaseAuth.instance.currentUser!.email!,
        token: '',
        active: false,
        acceptable: false,
        isEmailVerified: false,
        location: AddressInfo.empty(),
        available: false,
        birthOfDate: dateTimeController.text,
        vehicle: selectVehicle);
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }

  IdCard _initIDCard() {
    return IdCard(
        firstName: nameController.text.split(' ').first,
        middleName: nameController.text.split(' ')[1],
        lastName: nameController.text.split(' ').last,
        nationalNum: idNumController.text,
        docUrl: photoIdCard.path);
  }

  FutureOr<void> _deleteDelegate(DeleteDelegate event, emit) async {
    emit(DelegateState.loading);
    await delegateRepository
        .deleteDelegate(event.id)
        .then((value) => emit(DelegateState.success));
  }

  FutureOr<void> _updateDelegate(UpdateDelegate event, emit) async {
    updatedDelegate = updatedDelegate.copyWith(
        phoneNum: phoneNumberController.text,
        photoUrl:
            profilePhoto.path.isEmpty ? delegate.photoUrl : profilePhoto.path,
        id: FirebaseAuth.instance.currentUser!.uid);

    if (delegate != updatedDelegate) {
      emit(DelegateState.loading);
      await delegateRepository
          .updateDelegate(updatedDelegate)
          .then((value) => emit(DelegateState.success));
    }
  }

  FutureOr<void> _fetchDelegate(_FetchDelegate event, emit) {
    emit(DelegateState.loadingData);

    delegate = event.delegate;
    updatedDelegate = event.delegate;
    if (delegate != Delegate.empty()) {
      emit(DelegateState.successData);
    }
  }
}
