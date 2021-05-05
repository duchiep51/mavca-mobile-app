import 'package:capstone_mobile/generated/l10n.dart';
import 'package:capstone_mobile/src/blocs/branch/branch_bloc.dart';
import 'package:capstone_mobile/src/blocs/notification/notification_bloc.dart';
import 'package:capstone_mobile/src/blocs/regulation/regulation_bloc.dart';
import 'package:capstone_mobile/src/blocs/report/report_bloc.dart';
import 'package:capstone_mobile/src/blocs/violation/violation_bloc.dart';
import 'package:capstone_mobile/src/data/repositories/branch/branch_repository.dart';
import 'package:capstone_mobile/src/data/repositories/notification/notification_repository.dart';
import 'package:capstone_mobile/src/data/repositories/regulation/regulation_repository.dart';
import 'package:capstone_mobile/src/data/repositories/report/report_repository.dart';
import 'package:capstone_mobile/src/data/repositories/violation/violation_repository.dart';
import 'package:capstone_mobile/src/ui/screens/home_screen.dart';
import 'package:capstone_mobile/src/ui/screens/onboard_welcome/onboard_welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:capstone_mobile/src/blocs/authentication/authentication_bloc.dart';
import 'package:capstone_mobile/src/blocs/localization/localization_bloc.dart';
import 'package:capstone_mobile/src/data/repositories/authentication/authentication_repository.dart';
import 'package:capstone_mobile/src/data/repositories/user/user_repository.dart';
import 'package:capstone_mobile/src/ui/screens/login_screen.dart';

class App extends StatelessWidget {
  const App({
    Key key,
    @required this.authenticationRepository,
    @required this.userRepository,
  })  : assert(authenticationRepository != null),
        assert(userRepository != null),
        super(key: key);

  final AuthenticationRepository authenticationRepository;
  final UserRepository userRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
        value: authenticationRepository,
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => AuthenticationBloc(
                authenticationRepository: authenticationRepository,
                userRepository: userRepository,
              ),
            ),
            BlocProvider(
              create: (context) => LocalizationBloc(),
            )
          ],
          child: AppView(),
        ));
  }
}

class AppView extends StatefulWidget {
  @override
  _AppViewState createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  NavigatorState get _navigator => _navigatorKey.currentState;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var blue = Color(0xff322ED9);
    var themeData = ThemeData(
      primaryColor: blue,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
      ),
      fontFamily: 'Montserrat',
      textTheme: TextTheme(
        headline1: TextStyle(
          fontSize: 40.0,
          fontWeight: FontWeight.bold,
        ),
        button: TextStyle(fontSize: 16, color: Colors.white),
      ),
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );

    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(
                  child: Text('Some thing went wrong!'),
                ),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                    lazy: false,
                    create: (context) => ViolationBloc(
                          authenticationRepository:
                              RepositoryProvider.of<AuthenticationRepository>(
                                  context),
                          violationRepository: ViolationRepository(),
                        )),
                BlocProvider(
                    lazy: false,
                    create: (context) => ReportBloc(
                          reportRepository: ReportRepository(),
                          authenticationRepository:
                              RepositoryProvider.of<AuthenticationRepository>(
                                  context),
                        )),
                BlocProvider(
                  lazy: false,
                  create: (context) => NotificationBloc(
                      authenticationRepository:
                          RepositoryProvider.of<AuthenticationRepository>(
                              context),
                      notificationRepository: NotificationRepository()),
                ),
                BlocProvider(
                    lazy: false,
                    create: (context) => BranchBloc(
                        authenticationRepository:
                            RepositoryProvider.of<AuthenticationRepository>(
                                context),
                        branchRepository: BranchRepository())),
                BlocProvider(
                  create: (context) => RegulationBloc(
                      regulationRepository: RegulationRepository())
                    ..add(RegulationRequested(
                      token: BlocProvider.of<AuthenticationBloc>(context)
                          .state
                          .token,
                    )),
                )
              ],
              child: MaterialApp(
                localizationsDelegates: [
                  S.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: S.delegate.supportedLocales,
                theme: themeData,
                debugShowCheckedModeBanner: false,
                navigatorKey: _navigatorKey,
                builder: (context, child) {
                  BlocProvider.of<LocalizationBloc>(context).add(
                    LocalizationUpdated(
                      Localizations.localeOf(context).toString(),
                    ),
                  );

                  print(Localizations.localeOf(context).toString());

                  return BlocListener<AuthenticationBloc, AuthenticationState>(
                    listener: (context, state) {
                      switch (state.status) {
                        case AuthenticationStatus.authenticated:
                          _navigator.pushAndRemoveUntil<void>(
                            HomeScreen.route(),
                            (route) => false,
                          );
                          break;
                        case AuthenticationStatus.unauthenticated:
                          _navigator.pushAndRemoveUntil<void>(
                            LoginScreen.route(),
                            (route) => false,
                          );
                          break;
                          // case AuthenticationStatus.unknown:
                          //   _navigator.pushAndRemoveUntil<void>(
                          //     OnboardWelcomeScreen.route(),
                          //     (route) => false,
                          //   );
                          break;
                        default:
                          break;
                      }
                    },
                    child: child,
                  );
                },
                // onGenerateRoute: (_) => SplashScreen.route(),
                onGenerateRoute: (_) => OnboardWelcomeScreen.route(),
              ),
            );
          }
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(child: Text('')),
            ),
          );
        });
  }
}
