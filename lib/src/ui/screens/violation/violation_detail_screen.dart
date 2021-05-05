import 'package:capstone_mobile/src/blocs/authentication/authentication_bloc.dart';
import 'package:capstone_mobile/src/blocs/violation/violation_bloc.dart';
import 'package:capstone_mobile/src/data/models/violation/violation.dart';
import 'package:capstone_mobile/src/ui/constants/constant.dart';
import 'package:capstone_mobile/src/ui/widgets/violation/action_popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:capstone_mobile/generated/l10n.dart';
import 'package:capstone_mobile/src/blocs/localization/localization_bloc.dart';
import 'package:intl/intl.dart';

class ViolationDetailScreen extends StatefulWidget {
  final Violation violation;
  final int id;

  const ViolationDetailScreen({
    Key key,
    @required this.violation,
    @required this.id,
  }) : super(key: key);

  static Route route({
    @required Violation violation,
    @required int id,
  }) {
    return MaterialPageRoute<void>(
        settings: RouteSettings(name: "/ViolationDetailScreen"),
        builder: (_) => ViolationDetailScreen(
              violation: violation,
              id: id,
            ));
  }

  @override
  _ViolationDetailScreenState createState() => _ViolationDetailScreenState();
}

class _ViolationDetailScreenState extends State<ViolationDetailScreen> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return BlocListener<ViolationBloc, ViolationState>(
        listener: (context, state) {},
        child: BlocBuilder<LocalizationBloc, String>(builder: (context, state) {
          return BlocBuilder<ViolationBloc, ViolationState>(
              builder: (context, state) {
            if (state is ViolationLoadSuccess) {
              Violation violation = state.violations.firstWhere(
                  (violation) => violation.id == widget.id,
                  orElse: () => null);
              return violation != null
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
                        actions: violation?.status?.toLowerCase() == 'opening'
                            ? BlocProvider.of<AuthenticationBloc>(context)
                                        .state
                                        .user
                                        .roleName ==
                                    Constant.ROLE_QC
                                ? [
                                    ActionPopupMenu(
                                      theme: theme,
                                      violation: violation,
                                      widget: widget,
                                      successCallBack: (context) {
                                        Navigator.of(context).popUntil(
                                            ModalRoute.withName(
                                                '/ViolationDetailScreen'));
                                      },
                                      deleteCallBack: (context) {
                                        Navigator.of(context).popUntil(
                                            ModalRoute.withName('/Home'));
                                      },
                                    ),
                                  ]
                                : [
                                    ActionPopupMenuForBM(
                                      theme: theme,
                                      violation: violation,
                                      widget: widget,
                                      successCallBack: (context) {
                                        Navigator.of(context).popUntil(
                                            ModalRoute.withName(
                                                '/ViolationDetailScreen'));
                                      },
                                      confirmCallBack: (context) {
                                        Navigator.of(context).popUntil(
                                            ModalRoute.withName(
                                                '/ViolationDetailScreen'));
                                      },
                                    ),
                                  ]
                            : null,
                      ),
                      body: Padding(
                        padding: EdgeInsets.only(left: 16, right: 16),
                        child: ListView(
                          children: [
                            Container(
                              child: Text(
                                '${violation?.name ?? 'N/A'}',
                                style: TextStyle(
                                  color: theme.primaryColor,
                                  fontSize: theme.textTheme.headline5.fontSize,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      child: Text(
                                        'Created by: ' +
                                                violation.creatorName ??
                                            'Mavca',
                                        overflow: TextOverflow.clip,
                                      ),
                                    ),
                                    Container(
                                      child: Text(''),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: Container(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          child: Text(
                                              S.of(context).VIOLATION_STATUS +
                                                  ': '),
                                        ),
                                        Container(
                                          child: Text(
                                            "${violation?.status ?? 'N/A'}",
                                            style: TextStyle(
                                                color: Constant
                                                        .violationStatusColors[
                                                    violation?.status]),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              color: Constant
                                  .violationStatusColors[violation?.status],
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
                                      S.of(context).BRANCH + ":",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Text(violation?.branchName ?? 'N/A'),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Container(
                                    child: Text(
                                      S.of(context).CREATED_ON + ':',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Text(
                                    DateFormat.yMMMd(BlocProvider.of<
                                                    LocalizationBloc>(context)
                                                .state)
                                            .format(violation?.createdAt) ??
                                        '',
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Container(
                                    child: Text(S.of(context).DESCRIPTION + ':',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ),
                                  ConstrainedBox(
                                    constraints: BoxConstraints(
                                      minWidth: double.infinity,
                                    ),
                                    child: Container(
                                        child: Text(
                                            violation?.description ?? 'N/A')),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Container(
                                    child: Text(S.of(context).EXCUSE + ':',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  ConstrainedBox(
                                    constraints: BoxConstraints(
                                      minWidth: double.infinity,
                                    ),
                                    child: Container(
                                      child: Text(violation?.excuse ??
                                          S.of(context).THERE_NOT_EXCUSE_YET),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Container(
                                    child: Text(S.of(context).EVIDENCE + ':',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  violation.imagePaths == null ||
                                          violation.imagePaths.length <= 0
                                      ? Container(
                                          child: Text(S
                                              .of(context)
                                              .THERE_ARE_NO_EVIDENCE),
                                        )
                                      : ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount:
                                              violation.imagePaths.length,
                                          itemBuilder: (context, index) {
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                    child: Text('#' +
                                                        ' ${index + 1} ')),
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                Center(
                                                  child: Image(
                                                    image: NetworkImage(
                                                      violation
                                                          .imagePaths[index],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 8,
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Scaffold();
            }
            return Container(child: Text('Violation list'));
          });
        }));
  }
}
