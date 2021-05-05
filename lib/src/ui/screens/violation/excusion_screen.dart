import 'package:capstone_mobile/generated/l10n.dart';
import 'package:capstone_mobile/src/blocs/violation/violation_bloc.dart';
import 'package:capstone_mobile/src/blocs/violation_by_demand/violation_by_demand_bloc.dart';
import 'package:capstone_mobile/src/blocs/violation_list_create/violation_create_bloc.dart';
import 'package:capstone_mobile/src/data/models/violation/violation.dart';
import 'package:capstone_mobile/src/data/repositories/authentication/authentication_repository.dart';
import 'package:capstone_mobile/src/data/repositories/violation/violation_repository.dart';
import 'package:capstone_mobile/src/ui/constants/constant.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class ExcuseScreen extends StatelessWidget {
  final Violation violation;
  final Function successCallBack;
  final ViolationByDemandBloc bloc;

  const ExcuseScreen({
    Key key,
    @required this.violation,
    @required this.successCallBack,
    this.bloc,
  }) : super(key: key);

  static Route route({
    @required Violation violation,
    @required Function successCallBack,
    ViolationByDemandBloc bloc,
  }) =>
      MaterialPageRoute(
          builder: (_) => ExcuseScreen(
                successCallBack: successCallBack,
                violation: violation,
                bloc: bloc,
              ));
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: theme.scaffoldBackgroundColor,
          leading: IconButton(
            iconSize: 16,
            icon: Icon(
              Icons.arrow_back_ios,
              color: theme.primaryColor,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Transform(
            transform: Matrix4.translationValues(-37.0, 1, 0.0),
            child: Text(
              S.of(context).BACK,
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
          ),
        ),
        body: BlocProvider(
          create: (context) => ViolationCreateBloc(
            violationBloc: BlocProvider.of<ViolationBloc>(context),
            authenticationRepository:
                RepositoryProvider.of<AuthenticationRepository>(context),
            violationRepository: ViolationRepository(),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ExcuseForm(
              violation: violation,
              successCallBack: successCallBack,
              violationByDemandBloc: bloc,
            ),
          ),
        ));
  }
}

class ExcuseForm extends StatefulWidget {
  final Violation violation;
  final Function successCallBack;
  final ViolationByDemandBloc violationByDemandBloc;

  const ExcuseForm({
    Key key,
    @required this.violation,
    @required this.successCallBack,
    this.violationByDemandBloc,
  }) : super(key: key);

  @override
  _ExcuseFormState createState() => _ExcuseFormState();
}

class _ExcuseFormState extends State<ExcuseForm> {
  String excusion = '';

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return BlocListener<ViolationCreateBloc, ViolationCreateState>(
      listener: (context, state) {
        if (state.status.isSubmissionSuccess) {
          CoolAlert.show(
            context: context,
            type: CoolAlertType.success,
            text: S.of(context).POPUP_CREATE_VIOLATION_SUCCESS,
          ).then((value) {
            if (widget.violationByDemandBloc != null) {
              print('asfadf');
              widget.violationByDemandBloc.add(ViolationByDemandUpdated(
                  violation: widget.violation.copyWith(
                status: ViolationStatusConstant.EXCUSED,
                excuse: excusion.trim(),
              )));
            }
            widget.successCallBack(context);
          });
        }
        if (state.status.isSubmissionInProgress) {
          CoolAlert.show(
            barrierDismissible: false,
            context: context,
            type: CoolAlertType.loading,
            text: S.of(context).POPUP_CREATE_VIOLATION_SUBMITTING,
          );
        }
        if (state.status.isSubmissionFailure) {
          CoolAlert.show(
            context: context,
            type: CoolAlertType.error,
            title: "Oops...",
            text: S.of(context).POPUP_CREATE_VIOLATION_FAIL,
          ).then((value) => Navigator.pop(context));
        }
      },
      child: Column(
        children: [
          Row(
            children: [
              Container(
                child: Text('Your excusion: '),
              ),
              Container(),
            ],
          ),
          SizedBox(
            height: 8.0,
          ),
          TextField(
            key: const Key('ExcuseForm_ExcuseInput_TextField'),
            onChanged: (text) {
              setState(() {
                excusion = text;
              });
            },
            style: TextStyle(fontSize: 14),
            decoration: InputDecoration(
              fillColor: Colors.grey[200],
              filled: true,
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              errorText:
                  excusion.trim().isEmpty ? 'Excusion must not be empty' : null,
            ),
            maxLines: 5,
          ),
          ElevatedButton(
            onPressed: excusion.trim().isNotEmpty
                ? () {
                    var bloc = BlocProvider.of<ViolationCreateBloc>(context);
                    showDialog<void>(
                      context: context,
                      barrierDismissible: false, // user must tap button!
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(S.of(context).CONFIRM),
                          actions: <Widget>[
                            TextButton(
                              child: Text(
                                S.of(context).CONFIRM,
                                style: TextStyle(),
                              ),
                              onPressed: () {
                                bloc.add(ViolationExcuseChanged(
                                  violation: widget.violation.copyWith(
                                    status: ViolationStatusConstant.EXCUSED,
                                    excuse: excusion.trim(),
                                  ),
                                ));
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text(S.of(context).CANCEL),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                    // Navigator.of(context).pop();
                  }
                : null,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.075),
              child: Text(
                S.of(context).SUBMIT_BUTTON,
              ),
            ),
            style: ElevatedButton.styleFrom(
              primary: theme.primaryColor,
              elevation: 5,
            ),
          ),
        ],
      ),
    );
  }
}
