import 'package:capstone_mobile/generated/l10n.dart';
import 'package:capstone_mobile/src/blocs/localization/localization_bloc.dart';
import 'package:capstone_mobile/src/ui/utils/custom_text_field.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:capstone_mobile/src/blocs/change_password/change_password_cubit.dart';
import 'package:capstone_mobile/src/data/repositories/user/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:capstone_mobile/src/blocs/authentication/authentication_bloc.dart';
import 'package:capstone_mobile/src/data/repositories/authentication/authentication_repository.dart';
import 'package:capstone_mobile/src/data/repositories/user/user_api.dart';
import 'package:http/http.dart' as http;

class ChangePasswordScreen extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => ChangePasswordScreen());
  }

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var size = MediaQuery.of(context).size;
    return BlocBuilder<LocalizationBloc, String>(
      builder: (context, state) {
        return BlocProvider(
          create: (context) => ChangePasswordCubit(
              userRepository:
                  UserRepository(userApi: UserApi(httpClient: http.Client()))),
          child: Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: theme.scaffoldBackgroundColor,
              title: Transform(
                transform: Matrix4.translationValues(-37.0, 1, 0.0),
                child: Text(
                  S.of(context).BACK,
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
              leading: IconButton(
                iconSize: 16.0,
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: theme.primaryColor,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            body: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: _ChangePasswordForm(),
            ),
          ),
        );
      },
    );
  }
}

class _ChangePasswordForm extends StatefulWidget {
  const _ChangePasswordForm({
    Key key,
  }) : super(key: key);

  @override
  __ChangePasswordFormState createState() => __ChangePasswordFormState();
}

class __ChangePasswordFormState extends State<_ChangePasswordForm> {
  bool isConfirmed = false;
  String confirmPassword = '';

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChangePasswordCubit, ChangePasswordRequested>(
        listener: (context, state) {
          if (state.status.isSubmissionSuccess) {
            CoolAlert.show(
              context: context,
              type: CoolAlertType.success,
              text: S.of(context).CHANGE_PASSWORD_SCREEN_CHANGE_SUCCESS,
            ).then((value) {
              context
                  .read<AuthenticationBloc>()
                  .add(AuthenticationLogoutRequested());
            });
          }
          if (state.status.isSubmissionFailure) {
            Navigator.pop(context);
            CoolAlert.show(
              context: context,
              type: CoolAlertType.error,
              title: "Oops...",
              text: S.of(context).CHANGE_PASSWORD_SCREEN_PASSWORD_ERROR,
            ).then((value) {});
          }
        },
        child: Container(
          padding: EdgeInsets.only(left: 16, top: 25, right: 16),
          child: Center(
            child: ListView(
              children: [
                BlocBuilder<ChangePasswordCubit, ChangePasswordRequested>(
                  builder: (context, state) {
                    return CustomTextField(
                      label:
                          S.of(context).CHANGE_PASSWORD_SCREEN_CURRENT_PASSWORD,
                      placeholder: '',
                      isHidden: true,
                      errorText: state.oldPassword.invalid
                          ? S
                                  .of(context)
                                  .CHANGE_PASSWORD_SCREEN_CURRENT_PASSWORD +
                              ' ' +
                              S.of(context).CHANGE_PASSWORD_SCREEN_EMPTY
                          : null,
                      onChange: (value) {
                        context
                            .read<ChangePasswordCubit>()
                            .oldPasswordChanged(value);
                      },
                    );
                  },
                ),
                BlocBuilder<ChangePasswordCubit, ChangePasswordRequested>(
                  builder: (context, state) {
                    return CustomTextField(
                      label: S.of(context).CHANGE_PASSWORD_SCREEN_NEW_PASSWORD,
                      placeholder: '',
                      isHidden: true,
                      errorText: state.newPassword.invalid
                          ? S.of(context).CHANGE_PASSWORD_SCREEN_NEW_PASSWORD +
                              ' ' +
                              S.of(context).CHANGE_PASSWORD_SCREEN_EMPTY
                          : null,
                      onChange: (value) {
                        context
                            .read<ChangePasswordCubit>()
                            .newPasswordChanged(value);
                        if (value == confirmPassword) {
                          setState(() {
                            isConfirmed = true;
                          });
                        }
                        if (value != confirmPassword) {
                          setState(() {
                            isConfirmed = false;
                          });
                        }
                      },
                    );
                  },
                ),
                CustomTextField(
                    label:
                        S.of(context).CHANGE_PASSWORD_SCREEN_CONFIRM_PASSWORD,
                    placeholder: '',
                    isHidden: true,
                    errorText: isConfirmed
                        ? null
                        : S.of(context).CHANGE_PASSWORD_SCREEN_CONFIRM_ERROR,
                    onChange: (value) {
                      confirmPassword = value;
                      if (confirmPassword ==
                          context
                              .read<ChangePasswordCubit>()
                              .state
                              .newPassword
                              .value) {
                        setState(() {
                          isConfirmed = true;
                        });
                      }
                      if (confirmPassword !=
                          context
                              .read<ChangePasswordCubit>()
                              .state
                              .newPassword
                              .value) {
                        setState(() {
                          isConfirmed = false;
                        });
                      }
                    }),
                SizedBox(
                  height: 32,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    BlocBuilder<ChangePasswordCubit, ChangePasswordRequested>(
                      builder: (context, state) {
                        return RaisedButton(
                          color: Theme.of(context).primaryColor,
                          padding: EdgeInsets.symmetric(horizontal: 40),
                          onPressed: isConfirmed && state.status.isValidated
                              ? () {
                                  CoolAlert.show(
                                      context: context,
                                      type: CoolAlertType.confirm,
                                      confirmBtnText: S.of(context).YES,
                                      cancelBtnText: S.of(context).NO,
                                      confirmBtnColor:
                                          Theme.of(context).primaryColor,
                                      onConfirmBtnTap: () {
                                        context
                                            .read<ChangePasswordCubit>()
                                            .changePassword(
                                                context
                                                    .read<AuthenticationBloc>()
                                                    .state
                                                    .token,
                                                RepositoryProvider.of<
                                                            AuthenticationRepository>(
                                                        context)
                                                    .username);
                                        Navigator.pop(context);
                                      }).then((value) {
                                    showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (context) {
                                          return SimpleDialog(
                                            title: Text(
                                              S
                                                  .of(context)
                                                  .POPUP_CREATE_VIOLATION_SUBMITTING,
                                            ),
                                            children: [
                                              Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                            ],
                                          );
                                        });
                                  });
                                }
                              : null,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          child: Text(
                            S.of(context).CHANGE,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
