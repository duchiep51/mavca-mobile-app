import 'package:capstone_mobile/src/blocs/blocs.dart';
import 'package:capstone_mobile/src/blocs/report/report_bloc.dart';
import 'package:capstone_mobile/src/blocs/report_filter/report_filter_bloc.dart';
import 'package:capstone_mobile/src/services/firebase/notification.dart';
import 'package:capstone_mobile/src/ui/constants/constant.dart';
import 'package:capstone_mobile/src/ui/widgets/home/home_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:capstone_mobile/src/blocs/tab/tab_bloc.dart';
import 'package:capstone_mobile/src/blocs/localization/localization_bloc.dart';
import 'package:capstone_mobile/src/blocs/violation/violation_bloc.dart';
import 'package:capstone_mobile/src/blocs/violation_filter/violation_filter_bloc.dart';
import 'package:capstone_mobile/src/data/models/tab.dart';
import 'package:capstone_mobile/src/ui/screens/report/reports_screen.dart';
import 'package:capstone_mobile/src/ui/screens/settings_screen.dart';
import 'package:capstone_mobile/src/ui/screens/violation/violation_create_screen.dart';
import 'package:capstone_mobile/src/ui/screens/violation/violation_screen.dart';
import 'package:capstone_mobile/src/ui/widgets/tab_selector.dart';
import 'package:capstone_mobile/src/utils/utils.dart';
import 'package:capstone_mobile/generated/l10n.dart';

class HomeScreen extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(
      settings: RouteSettings(name: "/Home"),
      builder: (_) => HomeScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ViolationFilterBloc(
              violationbloc: BlocProvider.of<ViolationBloc>(context),
            ),
          ),
          BlocProvider(
            create: (context) => ReportFilterBloc(
              reportBloc: BlocProvider.of<ReportBloc>(context),
            ),
          ),
          BlocProvider(
            create: (context) => TabBloc(),
          ),
        ],
        child: BlocBuilder<LocalizationBloc, String>(
          builder: (context, state) {
            return HomeView();
          },
        ));
  }
}

class HomeView extends StatelessWidget {
  final FirebaseNotification firebaseNotification = FirebaseNotification();
  final _navigatorKey = GlobalKey<NavigatorState>();
  NavigatorState get _navigator => _navigatorKey.currentState;

  HomeView({
    Key key,
  }) : super(key: key);

  final List<Widget> _tabs = <Widget>[
    HomeTab(),
    ReportsTab(),
    ViolationTab(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    var user = BlocProvider.of<AuthenticationBloc>(context).state.user;
    FirebaseNotification.topics.add(user.accountId.toString());

    if (user.roleName == Constant.ROLE_BM) {
      FirebaseNotification.topics.add(
          user.roleName.replaceAll(new RegExp(r"\s+"), "") +
              user.branchId.toString());
    } else {
      FirebaseNotification.topics
          .add(user.roleName.replaceAll(new RegExp(r"\s+"), ""));
    }
    FirebaseNotification.configFirebaseMessaging(
      _navigator,
    );

    var theme = Theme.of(context);
    var size = MediaQuery.of(context).size;
    return BlocBuilder<TabBloc, AppTab>(
      builder: (context, activeTab) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: theme.scaffoldBackgroundColor,
            title: activeTab == AppTab.home
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image(
                        width: size.width * 0.07,
                        image: AssetImage('assets/logo.png'),
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      Column(
                        children: [
                          Image(
                            width: size.width * 0.2,
                            image: AssetImage('assets/brand_name.png'),
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                        ],
                      ),
                    ],
                  )
                : Transform(
                    transform: Matrix4.translationValues(0.0, 0, 0.0),
                    child: Text(
                      activeTab == AppTab.reports
                          ? S.of(context).List.toUpperCase() +
                              ' ' +
                              S.of(context).REPORTS.toUpperCase()
                          : activeTab == AppTab.violations
                              ? S.of(context).List.toUpperCase() +
                                  ' ' +
                                  S.of(context).VIOLATIONS.toUpperCase()
                              : activeTab == AppTab.settings
                                  ? S.of(context).SETTINGS.toUpperCase()
                                  : '',
                      style: TextStyle(
                        color: theme.primaryColor,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
            actions: [
              Container(
                width: 64,
                child: Center(
                  child: Container(
                    width: 80,
                    height: 32,
                    child: ElevatedButton(
                      onPressed: () {
                        Utils.getImage();
                      },
                      child: Icon(Icons.camera_alt_outlined),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xff916BFF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 16,
              ),
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: activeTab == AppTab.violations &&
                  BlocProvider.of<AuthenticationBloc>(context)
                          .state
                          .user
                          .roleName ==
                      Constant.ROLE_QC
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          ViolationCreateScreen.route(),
                        );
                      },
                      child: Container(
                        width: 156,
                        height: 32,
                        decoration: BoxDecoration(
                          color: theme.primaryColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: Text(
                            S
                                    .of(context)
                                    .VIOLATION_SCREEN_CREATE_NEW_BUTTON
                                    .toUpperCase() +
                                " +",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : null,
          body: _tabs[AppTab.values.indexOf(activeTab)],
          bottomNavigationBar: TabSelector(
            activeTab: activeTab,
            onTabSelected: (tab) => BlocProvider.of<TabBloc>(context).add(
              TabUpdated(tab),
            ),
          ),
        );
      },
    );
  }
}
