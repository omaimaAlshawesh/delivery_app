import 'dart:io';

import 'package:delivery_app/core/services/image_picker/image_picker_mixin.dart';
import 'package:delivery_app/delegate_app/delegate/bloc/create_delegate_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../../core/core.dart';
import '../repository/delegate_repository.dart';
import 'create_page.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> with PickMediaMixin {
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
      body: SafeArea(
        child: BlocConsumer<CreateDelegateBloc, DelegateState>(
          listener: (context, state) {
            if (state == DelegateState.failure) {}
          },
          builder: (context, state) {
            if (bloc.delegate != Delegate.empty()) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  vSpace(3),
                  _profilePhotoAvatar(context),
                  vSpace(3),
                  LandkTextField(
                    controller: bloc.phoneNumberController,
                    label: trans(context).phoneNum,
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    prefix: const Icon(Icons.phone),
                  ),
                  vSpace(4),
                  BlocBuilder<CreateDelegateBloc, DelegateState>(
                    builder: (context, state) {
                      return LandkBtn(
                          onTap: () {
                            bloc.add(UpdateDelegate());
                          },
                          title: state == DelegateState.loading
                              ? loadingWidget()
                              : Text(trans(context).done),
                          width: 80,
                          height: 7);
                    },
                  ),
                ],
              );
            }
            return const _UnDocumentedWidget();
          },
        ),
      ),
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
      child: CircleAvatar(
        radius: 40.sp,
        foregroundImage: NetworkImage(bloc.delegate.photoUrl),
      ),
    );
  }
}

class _UnDocumentedWidget extends StatelessWidget {
  const _UnDocumentedWidget();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        EmptyData(
          assetIcon: iServerDown,
          title: trans(context).unDocumented,
        ),
        vSpace(3),
        LandkBtn(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateDelegatePage(
                  delegateRepository: DelegateRepository(),
                ),
              ),
            );
          },
          title: Text(trans(context).verifyAccount),
          width: 80,
          height: 7,
        )
      ],
    );
  }
}
