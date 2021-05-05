import 'package:capstone_mobile/generated/l10n.dart';
import 'package:capstone_mobile/src/blocs/violation_by_demand/violation_by_demand_bloc.dart';
import 'package:capstone_mobile/src/data/models/violation/violation.dart';
import 'package:capstone_mobile/src/ui/utils/skeleton_loading.dart';
import 'package:capstone_mobile/src/ui/widgets/violation/violation_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LatestViolationList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ViolationByDemandBloc, ViolationByDemandState>(
        builder: (context, state) {
      if (state is ViolationByDemandLoadInProgress) {
        return Center(
          child: SkeletonLoading(
            item: 2,
          ),
        );
      }
      if (state is ViolationByDemandLoadFailure) {
        return Center(
            child: Column(
          children: [
            Container(
              child: Text(S.of(context).THERE_IS_NO +
                  ' ' +
                  S.of(context).VIOLATION.toLowerCase()),
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     BlocProvider.of<ViolationByDemandBloc>(context)
            //         .add(ViolationRequestedByDate(date: DateTime.now()));
            //   },
            //   child: Text(S.of(context).VIOLATION_SCREEN_RELOAD),
            //   style: ElevatedButton.styleFrom(
            //     primary: Colors.grey[200],
            //     onPrimary: Colors.black,
            //   ),
            // ),
          ],
        ));
      }
      if (state is ViolationByDemandLoadSuccess) {
        var violations = state.violations;

        if (violations.isEmpty) {
          return Center(
            child: Text(
              S.of(context).THERE_IS_NO +
                  ' ' +
                  S.of(context).VIOLATION.toLowerCase() +
                  ' yet today.',
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...buildViolationList(
              violations,
              bloc: BlocProvider.of<ViolationByDemandBloc>(context),
              screen: 'Home',
            ),
          ],
        );
      }
      return Container();
    });
  }
}

class ViolationByReportList extends StatelessWidget {
  final int reportId;
  final String screen;

  const ViolationByReportList({Key key, this.reportId, this.screen})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ViolationByDemandBloc, ViolationByDemandState>(
        builder: (context, state) {
      if (state is ViolationByDemandLoadInProgress) {
        return Center(
          child: SkeletonLoading(
            item: 2,
          ),
        );
      }
      if (state is ViolationByDemandLoadFailure) {
        return Center(
            child: Column(
          children: [
            Container(
              child: Text(
                  S.of(context).THERE_IS_NO + ' ' + S.of(context).VIOLATION),
            ),
            ElevatedButton(
              onPressed: () {
                BlocProvider.of<ViolationByDemandBloc>(context)
                    .add(ViolationRequestedByReportId(reportId: reportId));
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
      if (state is ViolationByDemandLoadSuccess) {
        var violations = state.violations;

        if (violations.isEmpty) {
          return Center(
            child:
                Text(S.of(context).THERE_IS_NO + ' ' + S.of(context).VIOLATION),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Text(
                  S.of(context).THERE_ARE +
                      " " +
                      violations.length.toString() +
                      ' ' +
                      S.of(context).VIOLATIONS.toLowerCase() +
                      ': ',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            ...buildViolationList(
              violations,
              bloc: BlocProvider.of<ViolationByDemandBloc>(context),
              screen: screen,
            ),
          ],
        );
      }
      return Container();
    });
  }
}

List<Widget> buildViolationList(
  List<Violation> violations, {
  bloc,
  screen,
}) {
  List<ViolationCard> violationCards = List<ViolationCard>();
  for (var vio in violations) {
    ViolationCard card = ViolationCard(
      violation: vio,
      isFetchedById: true,
      bloc: bloc,
      fromScreen: screen,
    );
    violationCards.add(card);
  }
  return violationCards;
}
