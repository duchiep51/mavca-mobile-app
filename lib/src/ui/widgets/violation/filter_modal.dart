import 'package:capstone_mobile/src/blocs/violation_filter/violation_filter_bloc.dart';
import 'package:capstone_mobile/src/ui/constants/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FilterModal extends StatelessWidget {
  FilterModal({Key key, this.list, this.title, this.value, this.violationbloc})
      : super(key: key);

  final list;
  final String title;
  final value;
  final violationbloc;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Material(
        child: SafeArea(
      top: false,
      child: BlocProvider(
        create: (context) => ViolationFilterBloc(
          violationbloc: violationbloc,
        ),
        child: Container(
          height: size.height * 0.9,
          child: ListView(
            children: <Widget>[
              Center(
                child: Text('Filter',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              StatusGrid(),
            ],
          ),
        ),
      ),
    ));
  }
}

class StatusGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var list =
        Constant.violationStatusColors.entries.map((e) => e.key).toList();
    return BlocBuilder<ViolationFilterBloc, ViolationFilterState>(
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
                  value: true,
                  onChanged: (value) {
                    // widget.violationFilterBloc.add(ViolationFilterStatusUpdated(
                    //   token:
                    //       BlocProvider.of<AuthenticationBloc>(context).state.token,
                    //   status: list[index],
                    // ));
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
