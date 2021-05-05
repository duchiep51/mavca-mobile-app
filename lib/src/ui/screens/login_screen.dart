import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import 'package:capstone_mobile/src/blocs/login/login_bloc.dart';
import 'package:capstone_mobile/src/data/repositories/authentication/authentication_repository.dart';
import 'package:capstone_mobile/src/ui/widgets/login/login_form.dart';

class LoginScreen extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => LoginScreen());
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification overscroll) {
            overscroll.disallowGlow();
          },
          child: ListView(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: size.height * 0.15,
              ),
              Column(
                children: [
                  Container(
                    width: size.width * 0.6,
                    height: size.width * 0.3,
                    child: Image(
                      image: AssetImage('assets/Group1108.png'),
                    ),
                  ),
                  BlocProvider(
                    create: (context) {
                      return LoginBloc(
                        authenticationRepository:
                            RepositoryProvider.of<AuthenticationRepository>(
                                context),
                      );
                    },
                    child: LoginForm(),
                  ),
                ],
              ),
              // Container(
              //   height: size.height * 0.1,
              //   width: double.infinity,
              // ),
              Container(
                height: size.height * 0.45,
                width: double.infinity,
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage('assets/login.png'),
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
