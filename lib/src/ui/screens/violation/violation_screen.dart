import 'package:capstone_mobile/src/ui/screens/filter/violation_filter_screen.dart';
import 'package:capstone_mobile/src/ui/widgets/violation/violation_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:capstone_mobile/src/blocs/violation/violation_bloc.dart';
import 'package:capstone_mobile/src/data/models/violation/violation.dart';
import 'package:capstone_mobile/src/ui/utils/skeleton_loading.dart';
import 'package:capstone_mobile/generated/l10n.dart';
import 'package:capstone_mobile/src/ui/utils/bottom_loader.dart';

class ViolationTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, ViolationFilterScreen.route());
                  },
                  child: Container(
                    height: 40,
                    child: Row(
                      children: [
                        Icon(
                          Icons.filter_alt_outlined,
                          color: Colors.grey,
                        ),
                        Container(
                          child: Text(
                            S.of(context).FILTER,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Color(0xff828282),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            _ViolationList(),
          ],
        ),
      ),
    );
  }
}

class _ViolationList extends StatefulWidget {
  const _ViolationList({
    Key key,
  }) : super(key: key);

  @override
  __ViolationListState createState() => __ViolationListState();
}

class __ViolationListState extends State<_ViolationList> {
  final _scrollController = ScrollController();
  ViolationBloc _violationBloc;

  @override
  void initState() {
    super.initState();
    _violationBloc = BlocProvider.of<ViolationBloc>(context);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ViolationBloc, ViolationState>(
        builder: (context, state) {
      if (state is ViolationLoadInProgress) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
      if (state is ViolationLoadFailure) {
        return Center(
          child: Column(
            children: [
              Text(S.of(context).VIOLATION_SCREEN_FETCH_FAIL),
              ElevatedButton(
                onPressed: () {
                  _violationBloc.add(ViolationRequested());
                },
                child: Text(S.of(context).VIOLATION_SCREEN_RELOAD),
                style: ElevatedButton.styleFrom(
                  primary: Colors.grey[200],
                  onPrimary: Colors.black,
                ),
              ),
            ],
          ),
        );
      }

      if (state is ViolationLoadSuccess) {
        if (state.violations.isEmpty) {
          return Column(
            children: [
              Center(
                child: Text(S.of(context).VIOLATION_SCREEN_NO_VIOLATIONS),
              ),
              ElevatedButton(
                onPressed: () {
                  _violationBloc.add(ViolationRequested(isRefresh: true));
                },
                child: Text(S.of(context).VIOLATION_SCREEN_RELOAD),
                style: ElevatedButton.styleFrom(
                  primary: Colors.grey[200],
                  onPrimary: Colors.black,
                ),
              ),
            ],
          );
        }

        List<Violation> violations = state.violations;
        print(violations.length.toString());
        return Expanded(
            child: NotificationListener<ScrollEndNotification>(
          onNotification: (scrollEnd) {
            var metrics = scrollEnd.metrics;
            if (metrics.atEdge) {
              if (metrics.pixels == 0) {
                _violationBloc.add(ViolationRequested(
                  isRefresh: true,
                ));
              } else {
                _violationBloc.add(
                  ViolationRequested(),
                );
              }
            }
            return true;
          },
          child: ListView.builder(
              itemCount:
                  (_violationBloc.state as ViolationLoadSuccess).hasReachedMax
                      ? state.violations.length
                      : state.violations.length + 1,
              controller: _scrollController,
              itemBuilder: (context, index) {
                return index >= state.violations.length
                    ? BottomLoader()
                    : ViolationCard(violation: violations[index]);
              }),
        ));
      }
      return Container(
        child: Center(
          child: SkeletonLoading(
            item: 4,
          ),
        ),
      );
    });
  }
}
