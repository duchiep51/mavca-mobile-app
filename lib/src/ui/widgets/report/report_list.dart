import 'package:capstone_mobile/generated/l10n.dart';
import 'package:capstone_mobile/src/blocs/report_by_demand/report_by_demand_bloc.dart';
import 'package:capstone_mobile/src/data/models/report/report.dart';
import 'package:capstone_mobile/src/ui/utils/skeleton_loading.dart';
import 'package:capstone_mobile/src/ui/widgets/report/report_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LatestReportList extends StatelessWidget {
  final int reportId;

  const LatestReportList({Key key, this.reportId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportByDemandBloc, ReportByDemandState>(
        builder: (context, state) {
      if (state is ReportByDemandLoadInProgress) {
        return Center(
          child: SkeletonLoading(
            item: 2,
          ),
        );
      }
      if (state is ReportByDemandLoadFailure) {
        return Center(
            child: Column(
          children: [
            Container(
              child:
                  Text(S.of(context).THERE_IS_NO + ' ' + S.of(context).REPORT),
            ),
            ElevatedButton(
              onPressed: () {
                BlocProvider.of<ReportByDemandBloc>(context)
                    .add(ReportByDemandRequested());
              },
              child: Text(S.of(context).VIOLATION_SCREEN_RELOAD),
              style: ElevatedButton.styleFrom(
                primary: Colors.grey[200],
                onPrimary: Colors.black,
              ),
            ),
          ],
        ));
      }
      if (state is ReportByDemandLoadSuccess) {
        var reports = state.reports;

        if (reports.isEmpty) {
          return Center(
            child: Text(S.of(context).THERE_IS_NO + ' ' + S.of(context).REPORT),
          );
        }

        return buildReportList(
          reports,
          bloc: BlocProvider.of<ReportByDemandBloc>(context),
        );
      }
      return Container();
    });
  }
}

Widget buildReportList(List<Report> reports, {bloc, screen}) {
  List<ReportCard> reportCards = List<ReportCard>();
  for (var report in reports) {
    ReportCard card = ReportCard(
      report: report,
      reportByDemandBloc: bloc,
    );
    reportCards.add(card);
  }
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: Column(
      children: [...reportCards],
    ),
  );
}
