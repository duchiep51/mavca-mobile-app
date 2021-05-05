import 'package:capstone_mobile/generated/l10n.dart';
import 'package:capstone_mobile/src/blocs/blocs.dart';
import 'package:capstone_mobile/src/blocs/report/report_bloc.dart';
import 'package:capstone_mobile/src/blocs/report_by_demand/report_by_demand_bloc.dart';
import 'package:capstone_mobile/src/blocs/report_create/report_create_bloc.dart';
import 'package:capstone_mobile/src/blocs/localization/localization_bloc.dart';
import 'package:capstone_mobile/src/data/models/report/report.dart';
import 'package:capstone_mobile/src/data/repositories/authentication/authentication_repository.dart';
import 'package:capstone_mobile/src/data/repositories/branch/branch_repository.dart';
import 'package:capstone_mobile/src/data/repositories/report/report_repository.dart';
import 'package:capstone_mobile/src/ui/constants/constant.dart';
import 'package:capstone_mobile/src/ui/screens/report/report_edit_form.dart';
import 'package:capstone_mobile/src/ui/utils/skeleton_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReportDetailScreen extends StatelessWidget {
  final int id;
  final ReportByDemandBloc reportByDemandBloc;

  const ReportDetailScreen({Key key, this.id, this.reportByDemandBloc})
      : super(key: key);

  static Route route({
    @required int id,
    ReportByDemandBloc reportByDemandBloc,
  }) {
    return MaterialPageRoute<void>(
        settings: RouteSettings(
          name: "/ReportDetailScreen",
        ),
        builder: (_) => ReportDetailScreen(
              id: id,
              reportByDemandBloc: reportByDemandBloc,
            ));
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return BlocProvider(
      create: (context) => ReportCreateBloc(
        authenticationRepository:
            RepositoryProvider.of<AuthenticationRepository>(context),
        branchRepository: BranchRepository(),
        reportRepository: ReportRepository(),
        reportBloc: BlocProvider.of<ReportBloc>(context),
      ),
      child: BlocBuilder<LocalizationBloc, String>(builder: (context, state) {
        return BlocBuilder<ReportBloc, ReportState>(
          builder: (context, state) {
            if (state is ReportLoadSuccess) {
              Report report = state.reports
                  .firstWhere((report) => report.id == id, orElse: () => null);
              return report != null
                  ? Scaffold(
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
                        actions: (report.status.toLowerCase() ==
                                        ReportStatusConstant.OPENING
                                            .toLowerCase() ||
                                    report.status.toLowerCase() ==
                                        ReportStatusConstant.TIMETOSUBMIT
                                            .toLowerCase()) &&
                                BlocProvider.of<AuthenticationBloc>(context)
                                        .state
                                        .user
                                        .roleName ==
                                    Constant.ROLE_QC
                            ? [
                                Builder(builder: (context) {
                                  return IconButton(
                                    icon: Icon(
                                      Icons.edit_outlined,
                                      color: theme.primaryColor,
                                    ),
                                    onPressed: () {},
                                  );
                                }),
                              ]
                            : [],
                      ),
                      body: ReportEditForm(
                        report: report,
                        reportByDemandBloc: reportByDemandBloc,
                        isEditing: report.status.toLowerCase() ==
                                ReportStatusConstant.OPENING.toLowerCase() ||
                            report.status.toLowerCase() ==
                                ReportStatusConstant.TIMETOSUBMIT.toLowerCase(),
                      ),
                    )
                  : Container();
            }
            return Container();
          },
        );
      }),
    );
  }
}

class ReportDetailByDemandScreen extends StatelessWidget {
  final int id;
  final ReportByDemandBloc reportByDemandBloc;

  const ReportDetailByDemandScreen({Key key, this.id, this.reportByDemandBloc})
      : super(key: key);

  static Route route({
    @required int id,
    ReportByDemandBloc reportByDemandBloc,
  }) {
    return MaterialPageRoute<void>(
      settings: RouteSettings(
        name: "/ReportDetailByDemandScreen",
      ),
      builder: (_) => BlocProvider.value(
        value: reportByDemandBloc,
        child: ReportDetailByDemandScreen(
          id: id,
          reportByDemandBloc: reportByDemandBloc,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return BlocProvider(
      create: (context) => ReportCreateBloc(
        authenticationRepository:
            RepositoryProvider.of<AuthenticationRepository>(context),
        branchRepository: BranchRepository(),
        reportRepository: ReportRepository(),
        reportBloc: BlocProvider.of<ReportBloc>(context),
      ),
      child: BlocBuilder<LocalizationBloc, String>(builder: (context, state) {
        return BlocBuilder<ReportByDemandBloc, ReportByDemandState>(
          builder: (context, state) {
            if (state is ReportByDemandLoadSuccess) {
              Report report = state.reports
                  .firstWhere((report) => report.id == id, orElse: () => null);
              return report != null
                  ? Scaffold(
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
                        actions: (report.status.toLowerCase() ==
                                        ReportStatusConstant.OPENING
                                            .toLowerCase() ||
                                    report.status.toLowerCase() ==
                                        ReportStatusConstant.TIMETOSUBMIT
                                            .toLowerCase()) &&
                                BlocProvider.of<AuthenticationBloc>(context)
                                        .state
                                        .user
                                        .roleName ==
                                    Constant.ROLE_QC
                            ? [
                                Builder(builder: (context) {
                                  return IconButton(
                                    icon: Icon(
                                      Icons.edit_outlined,
                                      color: theme.primaryColor,
                                    ),
                                    onPressed: () {},
                                  );
                                }),
                              ]
                            : [],
                      ),
                      body: ReportEditForm(
                        report: report,
                        reportByDemandBloc: reportByDemandBloc,
                        isEditing: report.status.toLowerCase() ==
                                ReportStatusConstant.OPENING.toLowerCase() ||
                            report.status.toLowerCase() ==
                                ReportStatusConstant.TIMETOSUBMIT.toLowerCase(),
                      ),
                    )
                  : Container();
            }
            if (state is ReportByDemandLoadInProgress) {
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
                body: Center(
                    child: SkeletonLoading(
                  item: 2,
                )),
              );
            }
            return Container();
          },
        );
      }),
    );
  }
}
