import 'package:capstone_mobile/generated/l10n.dart';
import 'package:capstone_mobile/src/blocs/localization/localization_bloc.dart';
import 'package:capstone_mobile/src/blocs/violation_list/violation_list_bloc.dart';
import 'package:capstone_mobile/src/data/repositories/violation/violation_repository.dart';
import 'package:capstone_mobile/src/ui/screens/violation/violation_create_list_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViolationCreateScreen extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => ViolationCreateScreen());
  }

  @override
  _ViolationCreateScreenState createState() => _ViolationCreateScreenState();
}

class _ViolationCreateScreenState extends State<ViolationCreateScreen> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var size = MediaQuery.of(context).size;
    return BlocBuilder<LocalizationBloc, String>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: theme.scaffoldBackgroundColor,
            elevation: 0,
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
            title: Transform(
              transform: Matrix4.translationValues(-37.0, 1, 0.0),
              child: Text(
                S.of(context).BACK,
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
          ),
          body: BlocProvider(
            create: (context) => ViolationListBloc(
              violationRepository: ViolationRepository(),
            ),
            child: ViolationListForm(theme: theme, size: size),
          ),
        );
      },
    );
  }
}
