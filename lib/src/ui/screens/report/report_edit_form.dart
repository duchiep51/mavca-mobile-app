import 'package:capstone_mobile/src/blocs/authentication/authentication_bloc.dart';
import 'package:capstone_mobile/src/blocs/localization/localization_bloc.dart';
import 'package:capstone_mobile/src/blocs/report/report_bloc.dart';
import 'package:capstone_mobile/src/blocs/report_by_demand/report_by_demand_bloc.dart';
import 'package:capstone_mobile/src/blocs/violation_by_demand/violation_by_demand_bloc.dart';
import 'package:capstone_mobile/src/data/repositories/authentication/authentication_repository.dart';
import 'package:capstone_mobile/src/data/repositories/violation/violation_repository.dart';
import 'package:capstone_mobile/src/ui/widgets/violation/violation_list.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import 'package:capstone_mobile/src/blocs/report_create/report_create_bloc.dart';
import 'package:capstone_mobile/src/data/models/report/report.dart';
import 'package:capstone_mobile/src/ui/constants/constant.dart';
import 'package:capstone_mobile/generated/l10n.dart';
import 'package:intl/intl.dart';

class ReportEditForm extends StatelessWidget {
  const ReportEditForm({
    Key key,
    @required this.report,
    @required this.isEditing,
    this.reportByDemandBloc,
  }) : super(key: key);

  final Report report;
  final bool isEditing;
  final ReportByDemandBloc reportByDemandBloc;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return BlocListener<ReportCreateBloc, ReportCreateState>(
        listener: (context, state) {
          if (state.status.isSubmissionSuccess) {
            Navigator.pop(context);
            CoolAlert.show(
              context: context,
              type: CoolAlertType.success,
              text: S.of(context).SUCCESS,
            ).then((value) {
              BlocProvider.of<ReportBloc>(context).add(
                ReportRequested(
                  isRefresh: true,
                ),
              );
              // if (reportByDemandBloc != null) {
              //   reportByDemandBloc.add(ReportByDemandUpdated(
              //     report:
              //   ));
              // }
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
            Navigator.pop(context);
            CoolAlert.show(
              context: context,
              type: CoolAlertType.error,
              title: "Oops...",
              text: S.of(context).FAIL,
            );
          }
        },
        child: Padding(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: ListView(
            children: [
              Container(
                child: Text(
                  '${report.name}',
                  style: TextStyle(
                    color: theme.primaryColor,
                    fontSize: theme.textTheme.headline5.fontSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Text(
                      S.of(context).ASSIGNEE + ": " + report.assigneeName,
                      overflow: TextOverflow.clip,
                    ),
                  ),
                  Expanded(
                    child: Container(
                        alignment: Alignment.topRight,
                        child: RichText(
                          overflow: TextOverflow.clip,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text: S.of(context).VIOLATION_STATUS + ': ',
                                  style: TextStyle(
                                    color: Colors.black,
                                  )),
                              TextSpan(
                                text: report.status,
                                style: TextStyle(
                                  color: Constant
                                      .reportStatusColors[report.status],
                                ),
                              ),
                            ],
                          ),
                        )),
                  ),
                ],
              ),
              Divider(
                color: Colors.black,
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        S.of(context).TOTAL +
                            ' ' +
                            S.of(context).MINUS_POINT.toLowerCase() +
                            ':',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(report.totalMinusPoint != 0
                        ? report.totalMinusPoint?.toString()
                        : 'N/A'),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      child: Text(
                        S.of(context).BRANCH + ':',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(report.branchName ?? 'N/A'),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      child: Text(S.of(context).CREATED_ON + ": ",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Text(report?.createdAt != null
                        ? DateFormat.yMMMd(
                                BlocProvider.of<LocalizationBloc>(context)
                                    .state)
                            .format(report.createdAt)
                        : 'N/A'),
                    SizedBox(
                      height: 16,
                    ),
                    report?.updatedAt != null
                        ? Container(
                            child: Text(S.of(context).UPDATED_ON + ": ",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          )
                        : Container(),
                    report?.updatedAt != null
                        ? Text(DateFormat.yMMMd(
                                BlocProvider.of<LocalizationBloc>(context)
                                    .state)
                            .format(report?.updatedAt))
                        : Container(),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      child: Text(
                        S.of(context).DESCRIPTION + ": ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: double.infinity,
                        minHeight: 24,
                      ),
                      child: Container(
                        child: Text(report?.description ?? 'N/A'),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      child: Text(
                        S.of(context).COMMENTS + ": ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    BlocProvider.of<AuthenticationBloc>(context)
                                    .state
                                    .user
                                    .roleName ==
                                Constant.ROLE_QC &&
                            report.status == ReportStatusConstant.OPENING
                        ? _ReportQCNote(
                            qcNote: report.qcNote,
                            isEditing: isEditing,
                          )
                        : ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: double.infinity,
                              minHeight: 24,
                            ),
                            child: Container(
                              child: Text(report?.qcNote ?? S.of(context).NA),
                            ),
                          ),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      child: Text(
                        S.of(context).ADMIN_NOTE + ": ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: double.infinity,
                        minHeight: 24,
                      ),
                      child: Container(
                        child: Text(
                          report?.adminNote ?? S.of(context).NA,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
              // Container(
              //   child: Text(
              //       S.of(context).List +
              //           " " +
              //           S.of(context).VIOLATIONS.toLowerCase() +
              //           ': ',
              //       style: TextStyle(fontWeight: FontWeight.bold)),
              // ),

              BlocProvider(
                create: (context) => ViolationByDemandBloc(
                  authenticationRepository:
                      RepositoryProvider.of<AuthenticationRepository>(context),
                  violationRepository: ViolationRepository(),
                )..add(ViolationRequestedByReportId(reportId: report.id)),
                child: ViolationByReportList(
                  reportId: report.id,
                  screen: reportByDemandBloc != null
                      ? 'ReportDetailByDemandScreen'
                      : 'ReportDetailScreen',
                ),
              ),
              SizedBox(
                height: 32,
              ),
              BlocProvider.of<AuthenticationBloc>(context)
                          .state
                          .user
                          .roleName ==
                      Constant.ROLE_BM
                  ? Container()
                  : report.status.toLowerCase() ==
                              ReportStatusConstant.OPENING.toLowerCase() ||
                          report.status.toLowerCase() ==
                              ReportStatusConstant.TIMETOSUBMIT.toLowerCase()
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _SaveButton(
                              report: report,
                              reportByDemandBloc: reportByDemandBloc,
                            ),
                            _SubmitButton(
                              report: report,
                              reportByDemandBloc: reportByDemandBloc,
                            ),
                          ],
                        )
                      : Container(),
              SizedBox(
                height: 32,
              ),
            ],
          ),
        ));
  }
}

class _ReportQCNote extends StatelessWidget {
  const _ReportQCNote({
    Key key,
    @required this.qcNote,
    @required this.isEditing,
  }) : super(key: key);

  final String qcNote;
  final bool isEditing;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportCreateBloc, ReportCreateState>(
      buildWhen: (previous, current) =>
          previous.reportDescription != current.reportDescription,
      builder: (context, state) {
        return TextFormField(
          style: TextStyle(fontSize: 14),
          initialValue: qcNote,
          key: const Key('editForm_reportQCNote_textField'),
          decoration: InputDecoration(
            filled: true,
            fillColor: BlocProvider.of<AuthenticationBloc>(context)
                        .state
                        .user
                        .roleName ==
                    Constant.ROLE_QC
                ? Colors.grey[200]
                : Theme.of(context).scaffoldBackgroundColor,
            hintText: qcNote,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: (newValue) {
            print(newValue);
            context.read<ReportCreateBloc>().add(
                  ReportDescriptionChanged(
                    reportDescription: newValue,
                    isEditing: true,
                  ),
                );
          },
          enabled: BlocProvider.of<AuthenticationBloc>(context)
                  .state
                  .user
                  .roleName !=
              Constant.ROLE_BM,
          maxLines: BlocProvider.of<AuthenticationBloc>(context)
                      .state
                      .user
                      .roleName ==
                  Constant.ROLE_QC
              ? 5
              : null,
        );
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({
    Key key,
    @required this.report,
    this.reportByDemandBloc,
  }) : super(key: key);

  final Report report;
  final ReportByDemandBloc reportByDemandBloc;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return BlocBuilder<ReportCreateBloc, ReportCreateState>(
      // buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return Container(
          width: size.width * 0.4,
          child: ElevatedButton(
            key: const Key('reportForm_submitEdit_raisedButton'),
            child: const Text(
              'Submit',
              style: TextStyle(
                color: Colors.white,
                letterSpacing: 1.5,
              ),
            ),
            onPressed: report.status == ReportStatusConstant.TIMETOSUBMIT
                ? () {
                    context.read<ReportCreateBloc>().add(
                          ReportEdited(
                            report: report.copyWith(
                              status: ReportStatusConstant.SUBMITED,
                            ),
                          ),
                        );
                    if (reportByDemandBloc != null) {
                      reportByDemandBloc.add(ReportByDemandUpdated(
                        report: report.copyWith(
                          status: ReportStatusConstant.SUBMITED,
                        ),
                      ));
                    }
                  }
                : null,
            style: ElevatedButton.styleFrom(
              onPrimary: Colors.red,
              primary: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({
    Key key,
    this.report,
    this.reportByDemandBloc,
  }) : super(key: key);

  final Report report;
  final ReportByDemandBloc reportByDemandBloc;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return BlocBuilder<ReportCreateBloc, ReportCreateState>(
      buildWhen: (previous, current) => previous.isEditing != current.isEditing,
      builder: (context, state) {
        return Container(
          width: size.width * 0.4,
          child: ElevatedButton(
            key: const Key('reportForm_save_elevatedButton'),
            child: const Text(
              'Save',
              style: TextStyle(
                color: Colors.white,
                letterSpacing: 1.5,
              ),
            ),
            onPressed: state.isEditing == true
                ? () {
                    context.read<ReportCreateBloc>().add(
                          ReportEdited(
                            report: report,
                          ),
                        );
                    if (reportByDemandBloc != null) {
                      reportByDemandBloc.add(ReportByDemandUpdated(
                        report: report.copyWith(
                          qcNote: BlocProvider.of<ReportCreateBloc>(context)
                              .state
                              .reportDescription
                              .value,
                        ),
                      ));
                    }
                  }
                : null,
            style: ElevatedButton.styleFrom(
              onPrimary: Colors.red,
              primary: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        );
      },
    );
  }
}
