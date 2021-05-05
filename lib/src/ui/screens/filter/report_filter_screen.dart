import 'package:capstone_mobile/generated/l10n.dart';
import 'package:capstone_mobile/src/blocs/authentication/authentication_bloc.dart';
import 'package:capstone_mobile/src/blocs/branch/branch_bloc.dart';
import 'package:capstone_mobile/src/blocs/localization/localization_bloc.dart';
import 'package:capstone_mobile/src/blocs/report/report_bloc.dart';
import 'package:capstone_mobile/src/blocs/report_filter/report_filter_bloc.dart';
import 'package:capstone_mobile/src/ui/constants/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class ReportFilterScreen extends StatelessWidget {
  const ReportFilterScreen({Key key}) : super(key: key);

  static Route route({
    ReportFilterBloc reportFilterBloc,
    String status,
  }) {
    return MaterialPageRoute<void>(
      settings: RouteSettings(name: "/Report_Filter_Screen"),
      builder: (_) => ReportFilterScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var size = MediaQuery.of(context).size;
    return BlocProvider(
        create: (context) =>
            ReportFilterBloc(reportBloc: BlocProvider.of<ReportBloc>(context)),
        child: Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: theme.scaffoldBackgroundColor,
            title: Transform(
              transform: Matrix4.translationValues(-37.0, 1, 0.0),
              child: Text(
                S.of(context).BACK,
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
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
          ),
          body: Padding(
            padding: const EdgeInsets.all(0.0),
            child: ListView(
              children: [
                Container(
                  color: Colors.orange[400],
                  height: 40,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          S.of(context).FILTER,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TimePicker(),
                ),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    child: Text(
                      S.of(context).VIOLATION_STATUS,
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: StatusGrid(),
                ),
                BlocProvider.of<AuthenticationBloc>(context)
                            .state
                            .user
                            .roleName ==
                        Constant.ROLE_QC
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Text(
                                S.of(context).BRANCH,
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                            BranchGrid()
                          ],
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ));
  }
}

class TimePicker extends StatelessWidget {
  const TimePicker({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 64,
          child: Text(
            S.of(context).MONTH + ':',
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        BlocBuilder<ReportFilterBloc, ReportFilterState>(
            builder: (context, state) {
          return GestureDetector(
            onTap: () => showMonthPicker(
              context: context,
              firstDate: DateTime(DateTime.now().year - 1, 5),
              lastDate: DateTime(DateTime.now().year + 1, 9),
              initialDate: DateTime.now(),
              locale: Locale(BlocProvider.of<LocalizationBloc>(context).state),
            ).then((value) {
              BlocProvider.of<ReportFilterBloc>(context)
                  .add(ReportFilterMonthUpdated(
                date: value,
              ));
            }),
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: 80),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.grey[200],
                  border: Border.all(),
                ),
                height: 32,
                child: Center(
                  child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              state.filter.date != null
                                  ? DateFormat.MMM(
                                          BlocProvider.of<LocalizationBloc>(
                                                  context)
                                              .state)
                                      .format(state.filter.date)
                                  : DateFormat.MMM(
                                          BlocProvider.of<LocalizationBloc>(
                                                  context)
                                              .state)
                                      .format(DateTime.now()),
                            ),
                          ),
                        ),
                        Icon(Icons.arrow_drop_down),
                      ]),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}

class StatusGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var list = Constant.reportStatusColors.entries.map((e) => e.key).toList();
    return BlocBuilder<ReportFilterBloc, ReportFilterState>(
      builder: (context, state) {
        return GridView.count(
          childAspectRatio: 4,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          shrinkWrap: true,
          children: List.generate(list.length, (index) {
            return Row(
              children: [
                Checkbox(
                  value: BlocProvider.of<ReportFilterBloc>(context)
                          .state
                          .filter
                          .status ==
                      list[index],
                  onChanged: (value) {
                    BlocProvider.of<ReportFilterBloc>(context)
                        .add(ReportFilterStatusUpdated(
                      status: value ? list[index] : null,
                    ));
                  },
                ),
                Container(
                  height: 20,
                  child: Text(list[index]),
                ),
              ],
            );
          }),
        );
      },
    );
  }
}

class BranchGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var list;
    if (BlocProvider.of<BranchBloc>(context).state is BranchLoadSuccess) {
      list = (BlocProvider.of<BranchBloc>(context).state as BranchLoadSuccess)
          .branches;
      var size = MediaQuery.of(context).size;

      return BlocBuilder<BranchBloc, BranchState>(builder: (context, state) {
        if (state is BranchLoadInProgress) {
          return Container();
        } else if (state is BranchLoadSuccess) {
          return BlocBuilder<ReportFilterBloc, ReportFilterState>(
            builder: (context, state) {
              return GridView.count(
                childAspectRatio: 3.5,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                shrinkWrap: true,
                children: List.generate(list?.length, (index) {
                  return Row(
                    children: [
                      Checkbox(
                        value: BlocProvider.of<ReportFilterBloc>(context)
                                .state
                                .filter
                                .branchId ==
                            list[index].id,
                        onChanged: (value) {
                          print(value);
                          BlocProvider.of<ReportFilterBloc>(context)
                              .add(ReportFilterBranchIdUpdated(
                            branchId: value ? list[index].id : null,
                          ));
                        },
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            list[index].name,
                            overflow: TextOverflow.visible,
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              );
            },
          );
        }
        return Container();
      });
    }
    return Container();
  }
}
