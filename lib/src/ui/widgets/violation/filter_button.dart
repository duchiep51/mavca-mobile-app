import 'package:capstone_mobile/src/blocs/authentication/authentication_bloc.dart';
import 'package:capstone_mobile/src/blocs/violation/violation_bloc.dart';
import 'package:capstone_mobile/src/blocs/violation_filter/filter.dart';
import 'package:capstone_mobile/src/blocs/violation_filter/violation_filter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FilterButton extends StatelessWidget {
  final bool visible;

  FilterButton({this.visible, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final defaultStyle = Theme.of(context).textTheme.bodyText2;
    final activeStyle = Theme.of(context)
        .textTheme
        .bodyText2
        .copyWith(color: Theme.of(context).accentColor);
    return BlocBuilder<ViolationFilterBloc, ViolationFilterState>(
        builder: (context, state) {
      final button = _Button(
        onSelected: (filter) {
          // BlocProvider.of<ViolationFilterBloc>(context)
          //     .add(FilterUpdated(ViolationFilter(branch: filter)));
          BlocProvider.of<ViolationBloc>(context).add(
            FilterChanged(
              filter: Filter(branchId: filter),
            ),
          );
        },
        // activeFilter: state is ViolationFilterSucess
        //     ? state.activeFilter.branch.name
        //     : '',
        activeStyle: activeStyle,
        defaultStyle: defaultStyle,
      );
      return AnimatedOpacity(
        opacity: visible ? 1.0 : 0.0,
        duration: Duration(milliseconds: 150),
        child: visible ? button : IgnorePointer(child: button),
      );
    });
  }
}

class _Button extends StatelessWidget {
  _Button({
    Key key,
    @required this.onSelected,
    // @required this.activeFilter,
    @required this.activeStyle,
    @required this.defaultStyle,
  }) : super(key: key);

  final PopupMenuItemSelected<int> onSelected;
  // final String activeFilter;
  final TextStyle activeStyle;
  final TextStyle defaultStyle;

  final branches = [
    'All branches',
    'Quan 9',
    'Quan 666',
    'Farrell Shoal',
    'string',
    'Q5',
    'Quan 66',
    'Hoeger Branch',
    'Corporations',
    'Quigley Meadow',
    'Chi Nhanh 1',
  ];

  final ids = [0, 1, 2, 3, 4, 6, 10, 13, 18, 27, 28];

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      tooltip: 'Filter',
      onSelected: onSelected,
      itemBuilder: (BuildContext context) =>
          branches.map<PopupMenuItem<int>>((branch) {
        return PopupMenuItem<int>(
          value:
              branch == 'All branches' ? null : ids[branches.indexOf(branch)],
          child: Text(branch),
        );
      }).toList(),
      icon: Icon(Icons.filter_alt_outlined),
    );
  }
}
