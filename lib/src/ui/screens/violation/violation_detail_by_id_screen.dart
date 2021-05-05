import 'package:capstone_mobile/src/blocs/authentication/authentication_bloc.dart';
import 'package:capstone_mobile/src/blocs/violation_by_demand/violation_by_demand_bloc.dart';
import 'package:capstone_mobile/src/data/models/violation/violation.dart';
import 'package:capstone_mobile/src/data/repositories/violation/violation_repository.dart';
import 'package:capstone_mobile/src/ui/constants/constant.dart';
import 'package:capstone_mobile/src/ui/utils/skeleton_loading.dart';
import 'package:capstone_mobile/src/ui/widgets/violation/action_popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:capstone_mobile/generated/l10n.dart';
import 'package:capstone_mobile/src/blocs/localization/localization_bloc.dart';
import 'package:intl/intl.dart';

enum ExtraAction { remove, edit }

class ViolationDetailByIdScreen extends StatefulWidget {
  final int id;
  final ViolationByDemandBloc bloc;
  final String fromScreen;

  const ViolationDetailByIdScreen({
    Key key,
    @required this.id,
    this.bloc,
    this.fromScreen,
  }) : super(key: key);

  static Route route({
    @required int id,
    ViolationByDemandBloc bloc,
    String fromScreen,
  }) {
    return MaterialPageRoute<void>(
        settings:
            RouteSettings(name: "/ViolationDetailByIdScreen", arguments: int),
        builder: (_) => ViolationDetailByIdScreen(
              id: id,
              bloc: bloc,
              fromScreen: fromScreen,
            ));
  }

  @override
  _ViolationDetailByIdScreenState createState() =>
      _ViolationDetailByIdScreenState();
}

class _ViolationDetailByIdScreenState extends State<ViolationDetailByIdScreen> {
  final ViolationRepository _violationRepository = ViolationRepository();
  Violation violation;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return BlocBuilder<LocalizationBloc, String>(builder: (context, state) {
      return FutureBuilder(
          future: _violationRepository.fetchViolations(
            token: BlocProvider.of<AuthenticationBloc>(context).state.token,
            id: widget.id,
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              if (snapshot.data.length != 0) {
                violation = snapshot.data[0];
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
                    actions: violation?.status?.toLowerCase() == 'opening'
                        ? BlocProvider.of<AuthenticationBloc>(context)
                                    .state
                                    .user
                                    .roleName ==
                                Constant.ROLE_QC
                            ? BlocProvider.of<AuthenticationBloc>(context)
                                        .state
                                        .user
                                        .id ==
                                    violation.createdBy
                                ? [
                                    ActionPopupMenu(
                                      theme: theme,
                                      violation: violation,
                                      widget: widget,
                                      bloc: widget.bloc,
                                      successCallBack: (context) {
                                        Navigator.pushAndRemoveUntil<void>(
                                            context,
                                            ViolationDetailByIdScreen.route(
                                                id: violation.id),
                                            ModalRoute.withName(
                                              '/${widget.fromScreen}',
                                            ));
                                      },
                                      deleteCallBack: (context) {
                                        Navigator.popUntil(
                                            context,
                                            ModalRoute.withName(
                                                '/${widget.fromScreen}'));
                                      },
                                    ),
                                  ]
                                : null
                            : [
                                ActionPopupMenuForBM(
                                  theme: theme,
                                  violation: violation,
                                  widget: widget,
                                  bloc: widget.bloc,
                                  successCallBack: (context) {
                                    Navigator.pushAndRemoveUntil<void>(
                                        context,
                                        ViolationDetailByIdScreen.route(
                                            id: violation.id),
                                        ModalRoute.withName(
                                            '/${widget.fromScreen}'));
                                  },
                                  confirmCallBack: (context) {
                                    Navigator.pushAndRemoveUntil<void>(
                                        context,
                                        ViolationDetailByIdScreen.route(
                                            id: violation.id),
                                        ModalRoute.withName(
                                            '/${widget.fromScreen}'));
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
                              fontSize: 24,
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: Text(
                                    'Created by: ' + violation.creatorName ??
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
                                            color:
                                                Constant.violationStatusColors[
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
                                .violationStatusColors[violation?.status]),
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
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Text(violation?.branchName ?? 'N/A'),
                              SizedBox(
                                height: 16,
                              ),
                              Container(
                                child: Text(
                                  S.of(context).CREATED_ON + ':',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Text(
                                DateFormat.yMMMd(
                                            BlocProvider.of<LocalizationBloc>(
                                                    context)
                                                .state)
                                        .format(violation?.createdAt) ??
                                    'N/A',
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              Container(
                                child: Text(S.of(context).DESCRIPTION + ':',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  minWidth: double.infinity,
                                ),
                                child: Container(
                                    child: Text(violation?.description ?? '')),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              Container(
                                child: Text(S.of(context).EXCUSE + ':',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              violation.imagePaths == null ||
                                      violation.imagePaths.length <= 0
                                  ? Container(
                                      child: Text(
                                          S.of(context).THERE_ARE_NO_EVIDENCE),
                                    )
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: violation.imagePaths.length,
                                      itemBuilder: (context, index) {
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              child:
                                                  Text('#' + ' ${index + 1} '),
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Center(
                                              child: Image(
                                                image: NetworkImage(
                                                  violation.imagePaths[index],
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
                );
              }
            } else if (snapshot.hasError) {
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
                  child: Text(S.of(context).LOAD_FAIL),
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
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
                child: Text(
                  'This violation is no longer existed!',
                ),
              ),
            );
          });
    });
  }
}

class ImageZoomScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Hero(
        tag: 'dash',
        child: Image(
          image: AssetImage('assets/avt.jpg'),
        ),
      ),
    );
  }
}
