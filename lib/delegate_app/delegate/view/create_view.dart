import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_app/core/core.dart';
import 'package:delivery_app/core/services/image_picker/image_picker_mixin.dart';
import 'package:delivery_app/delegate_app/delegate/bloc/create_delegate_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';

import '../../../models/model.dart';

class CreateDelegateView extends StatefulWidget {
  const CreateDelegateView({super.key});

  @override
  State<CreateDelegateView> createState() => _CreateDelegateViewState();
}

class _CreateDelegateViewState extends State<CreateDelegateView>
    with PickMediaMixin {
  late final CreateDelegateBloc bloc;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  @override
  void initState() {
    bloc = BlocProvider.of<CreateDelegateBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(trans(context).createAccount),
        actions: [
          dropDownButtonLang(context),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            vSpace(4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _pickdocImage(context),
                _profilePhotoAvatar(context),
              ],
            ),
            vSpace(3),
            LandkTextField(
              controller: bloc.nameController,
              label: trans(context).fullName,
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              prefix: const Icon(Icons.person),
            ),
            vSpace(3),
            LandkTextField(
              controller: bloc.phoneNumberController,
              label: trans(context).phoneNum,
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              prefix: const Icon(Icons.phone),
            ),
            vSpace(3),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: TextField(
                decoration: InputDecoration(
                  labelText: trans(context).date,
                  prefixIcon: const Icon(Icons.date_range),
                ),
                onTap: () {
                  _showBottomSheet();
                },
                controller: bloc.dateTimeController,
                readOnly: true,
              ),
            ),
            vSpace(3),
            _dropdownVehicles(),
            vSpace(3),
            LandkTextField(
              controller: bloc.idNumController,
              label: trans(context).idNumber,
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              prefix: const Icon(Icons.contact_emergency),
            ),
            vSpace(3),
            BlocBuilder<CreateDelegateBloc, DelegateState>(
              builder: (context, state) {
                return LandkBtn(
                  onTap: () {
                    bloc.add(CreateDelegate());
                    if (state == DelegateState.success) {
                      Navigator.pop(context);
                    }
                  },
                  title: state == DelegateState.loading
                      ? loadingWidget()
                      : Text(
                          trans(context).createAccount,
                          style: btnFont.copyWith(fontWeight: FontWeight.bold),
                        ),
                  width: 90,
                  height: 7,
                );
              },
            ),
            vSpace(4),
          ],
        ),
      ),
    );
  }

  PickImageWidget _pickdocImage(BuildContext context) {
    return PickImageWidget(
      width: 35,
      height: 10,
      source: bloc.photoIdCard,
      onTap: () {
        showBottomPicker(() async {
          await pickSingleImage(ImageSource.camera).then((value) {
            bloc.photoIdCard = File(value ?? '');

            setState(() {});
            Navigator.pop(context);
          });
        }, () async {
          await pickSingleImage(ImageSource.gallery).then((value) {
            bloc.photoIdCard = File(value ?? '');

            Navigator.pop(context);
            setState(() {});
          });
        }, scaffoldKey);
      },
      label: trans(context).photoIdCard,
    );
  }

  InkWell _profilePhotoAvatar(BuildContext context) {
    return InkWell(
      onTap: () {
        showBottomPicker(() async {
          await pickSingleImage(ImageSource.camera).then((value) {
            bloc.profilePhoto = File(value ?? '');

            setState(() {});
            Navigator.pop(context);
          });
        }, () async {
          await pickSingleImage(ImageSource.gallery).then((value) {
            bloc.profilePhoto = File(value ?? '');

            Navigator.pop(context);
            setState(() {});
          });
        }, scaffoldKey);
      },
      child: bloc.profilePhoto.path.isEmpty
          ? CircleAvatar(
              radius: 40.sp,
              foregroundImage: AssetImage(iPersonPng),
            )
          : CircleAvatar(
              radius: 40.sp,
              foregroundImage: FileImage(bloc.profilePhoto),
            ),
    );
  }

  void _showBottomSheet() {
    scaffoldKey.currentState!.showBottomSheet((context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(trans(context).done)),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(trans(context).cancel)),
            ],
          ),
          SizedBox(
            height: 30.h,
            child: CupertinoDatePicker(
              minimumYear: 2000,
              initialDateTime: DateTime.now(),
              maximumYear: DateTime.now().year,
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: (value) {
                bloc.dateTimeController.text =
                    DateFormat('yyyy-mm-dd').format(value);
                setState(() {});
              },
            ),
          ),
        ],
      );
    });
  }

  _dropdownVehicles() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('vehicles').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return loadingWidget();
        } else if (snapshot.hasData) {
          final List<Vehicle> vehicles = List<Vehicle>.from(
              snapshot.data!.docs.map((e) => Vehicle.fromMap(e.data())));
          bloc.selectVehicle = vehicles.first.id;
          final name = (vehicles
              .firstWhere((element) => element.id == bloc.selectVehicle));
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(width: 0.5),
              ),
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.3.h),
              child: Center(
                child: DropdownButton(
                    icon: SvgPicture.asset(iVehicle),
                    isDense: true,
                    isExpanded: true,
                    underline: empty(),
                    hint: Text(locale(context)
                        ? name.vehicleNameAR
                        : name.vehicleNameEN),
                    items: snapshot.data!.docs.map((e) {
                      final vehicle = Vehicle.fromMap(e.data());
                      return DropdownMenuItem(
                        value: vehicle.id,
                        child: Text(
                          locale(context)
                              ? vehicle.vehicleNameAR
                              : vehicle.vehicleNameEN,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      bloc.selectVehicle = value!;
                      setState(() {});
                    }),
              ),
            ),
          );
        }
        return empty();
      },
    );
  }
}
