import 'package:capstone_mobile/generated/l10n.dart';
import 'package:capstone_mobile/src/blocs/authentication/authentication_bloc.dart';
import 'package:capstone_mobile/src/blocs/report_by_demand/report_by_demand_bloc.dart';
import 'package:capstone_mobile/src/blocs/tab/tab_bloc.dart';
import 'package:capstone_mobile/src/blocs/violation_by_demand/violation_by_demand_bloc.dart';
import 'package:capstone_mobile/src/data/models/notification/notification.dart'
    as model;
import 'package:capstone_mobile/src/data/models/report/report.dart';
import 'package:capstone_mobile/src/data/models/tab.dart';
import 'package:capstone_mobile/src/data/models/violation/violation.dart';
import 'package:capstone_mobile/src/data/repositories/authentication/authentication_repository.dart';
import 'package:capstone_mobile/src/data/repositories/notification/notification_repository.dart';
import 'package:capstone_mobile/src/data/repositories/report/report_repository.dart';
import 'package:capstone_mobile/src/data/repositories/violation/violation_repository.dart';
import 'package:capstone_mobile/src/ui/screens/notification/notification_screen.dart';
import 'package:capstone_mobile/src/ui/widgets/notification/notification_list.dart';
import 'package:capstone_mobile/src/ui/widgets/report/report_list.dart';
import 'package:capstone_mobile/src/ui/widgets/violation/violation_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeTab extends StatelessWidget {
  Future<List<Report>> countReport(context) async {
    ReportRepository reportRepository = ReportRepository();

    return await reportRepository.fetchReports(
      token: BlocProvider.of<AuthenticationBloc>(context).state.token,
      status: "Opening",
    );
  }

  Future<List<Violation>> countViolation(context) async {
    ViolationRepository violationRepository = ViolationRepository();

    return await violationRepository.fetchViolations(
      token: BlocProvider.of<AuthenticationBloc>(context).state.token,
    );
  }

  Future<List<model.Notification>> countNotification(context) async {
    NotificationRepository notificationRepository = NotificationRepository();

    return await notificationRepository.fetchNotifications(
      token: BlocProvider.of<AuthenticationBloc>(context).state.token,
      isRead: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return ListView(
      children: [
        Stack(children: [
          Container(
            width: double.infinity,
            height: size.height * 0.2,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/cover.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              width: size.width * 0.6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Color(0xffC8C8C9),
                            width: 3,
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          'You have:',
                          style: TextStyle(
                            color: Color(0xff2329D6),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  FutureBuilder(
                    future: countReport(context),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasData) {
                          return RichText(
                            overflow: TextOverflow.clip,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                    text: snapshot.data?.length.toString(),
                                    style: TextStyle(
                                      color: Color(0xff2329D6),
                                      fontWeight: FontWeight.bold,
                                    )),
                                TextSpan(
                                  text: ' assigned report this month.',
                                  style: TextStyle(
                                    color: Color(0xff2329D6),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      }
                      return Text(
                        ' assigned report this month.',
                        style: TextStyle(
                          color: Color(0xff2329D6),
                        ),
                      );
                    },
                  ),
                  FutureBuilder(
                    future: countNotification(context),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasData) {
                          return RichText(
                            overflow: TextOverflow.clip,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                    text: snapshot.data?.length.toString(),
                                    style: TextStyle(
                                      color: Color(0xff2329D6),
                                      fontWeight: FontWeight.bold,
                                    )),
                                TextSpan(
                                  text: ' unread announcements.',
                                  style: TextStyle(
                                    color: Color(0xff2329D6),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      }
                      return Text(
                        ' unread announcements.',
                        style: TextStyle(
                          color: Color(0xff2329D6),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ]),
        SizedBox(
          height: 16,
        ),
        Container(
          width: size.width * 0.2,
          // height: size.height * 0.1,
          color: Colors.grey[100],
          child: Padding(
            padding: const EdgeInsets.only(
              top: 8.0,
              right: 16.0,
              left: 16.0,
              bottom: 8.0,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      S.of(context).HOME_LATEST_NOTIFICATION,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    GestureDetector(
                      child: Container(
                        child: Text(
                          S.of(context).HOME_SEE_ALL,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(context, NotificationScreen.route());
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        LatestNotificationList(),
        SizedBox(
          height: 16,
        ),
        GestureDetector(
          onTap: () {
            BlocProvider.of<TabBloc>(context).add(
              TabUpdated(AppTab.reports),
            );
          },
          child: Container(
            color: Colors.orange[400],
            height: 36,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    S.of(context).HOME_REPORT_LIST,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: Colors.white,
                  )
                ],
              ),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => ReportByDemandBloc(
              reportRepository: ReportRepository(),
              authenticationRepository:
                  RepositoryProvider.of<AuthenticationRepository>(context))
            ..add(ReportByDemandRequested(
                roleName: BlocProvider.of<AuthenticationBloc>(context)
                    .state
                    .user
                    .roleName)),
          child: LatestReportList(),
        ),
        SizedBox(
          height: 16,
        ),
        GestureDetector(
          onTap: () {
            BlocProvider.of<TabBloc>(context).add(
              TabUpdated(AppTab.violations),
            );
          },
          child: Container(
            color: Colors.orange[400],
            height: 36,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    S.of(context).HOME_VIOLATION_LIST,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: Colors.white,
                  )
                ],
              ),
            ),
          ),
        ),
        // LatesViolationList(),
        BlocProvider(
          create: (context) => ViolationByDemandBloc(
            violationRepository: ViolationRepository(),
            authenticationRepository:
                RepositoryProvider.of<AuthenticationRepository>(context),
          )..add(ViolationRequestedByDate(date: DateTime.now())),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: LatestViolationList(),
          ),
        ),
      ],
    );
  }
}
