import 'package:capstone_mobile/src/blocs/localization/localization_bloc.dart';
import 'package:capstone_mobile/src/blocs/report_by_demand/report_by_demand_bloc.dart';
import 'package:flutter/material.dart';

import 'package:capstone_mobile/src/data/models/report/report.dart';
import 'package:capstone_mobile/src/ui/screens/report/report_detail_screen.dart';
import 'package:capstone_mobile/src/ui/constants/constant.dart';
import 'package:capstone_mobile/generated/l10n.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ReportCard extends StatelessWidget {
  const ReportCard({
    Key key,
    @required this.report,
    this.reportByDemandBloc,
  }) : super(key: key);

  final Report report;
  final ReportByDemandBloc reportByDemandBloc;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Card(
      elevation: 5,
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          reportByDemandBloc == null
              ? Navigator.push(
                  context,
                  ReportDetailScreen.route(
                    id: report.id,
                  ),
                )
              : Navigator.push(
                  context,
                  ReportDetailByDemandScreen.route(
                    id: report.id,
                    reportByDemandBloc: reportByDemandBloc,
                  ),
                );
        },
        child: ClipPath(
          clipper: ShapeBorderClipper(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          child: Container(
            height: size.height * 0.17,
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: Constant.reportStatusColors[report.status] ??
                      Colors.black,
                  width: 5,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${report.assigneeName ?? 'N/A'}',
                              style: TextStyle(
                                color: Color(0xffBDBDBD),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "${report.status ?? "N/A"}",
                              style: TextStyle(
                                color:
                                    Constant.reportStatusColors[report.status],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          "${report?.name ?? "N/A"}",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.visible,
                        ),
                      ]),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        report.totalMinusPoint > 0
                            ? '${report.totalMinusPoint}' +
                                ' ' +
                                S.of(context).MINUS_POINT.toLowerCase()
                            : '',
                        style: TextStyle(
                          color: Color(0xffEB5757),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        report?.createdAt != null
                            ? S.of(context).CREATED_ON +
                                ': '
                                    "${DateFormat.yMd(BlocProvider.of<LocalizationBloc>(context).state).format(report?.createdAt)}"
                            : 'N/A',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[400],
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
