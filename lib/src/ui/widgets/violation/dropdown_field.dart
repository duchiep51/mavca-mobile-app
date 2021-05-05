import 'package:capstone_mobile/generated/l10n.dart';
import 'package:capstone_mobile/src/blocs/authentication/authentication_bloc.dart';
import 'package:capstone_mobile/src/blocs/violation_list_create/violation_create_bloc.dart';
import 'package:capstone_mobile/src/data/models/branch/branch.dart';
import 'package:capstone_mobile/src/data/models/regulation/regulation.dart';
import 'package:capstone_mobile/src/data/models/report/report.dart';
import 'package:capstone_mobile/src/data/models/violation/violation_report.dart';
import 'package:capstone_mobile/src/data/repositories/branch/branch_repository.dart';
import 'package:capstone_mobile/src/blocs/violation_list/violation_list_bloc.dart';
import 'package:capstone_mobile/src/data/repositories/regulation/regulation_repository.dart';
import 'package:capstone_mobile/src/data/repositories/report/report_repository.dart';
import 'package:capstone_mobile/src/ui/utils/my_dropdown_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DropdownFieldBranch extends StatefulWidget {
  @override
  _DropdownFieldBranchState createState() => _DropdownFieldBranchState();
}

class _DropdownFieldBranchState extends State<DropdownFieldBranch> {
  String id;

  BranchRepository _branchRepository = BranchRepository();
  List<Branch> _branches = List();
  List<String> _brancheNames = List();
  String _initValue;
  final myController = TextEditingController();

  Future<String> getBranches() async {
    var branches = await _branchRepository.fetchBranchesForQC(
      BlocProvider.of<AuthenticationBloc>(context).state.token,
    );

    if (this.mounted) {
      setState(() {
        _branches = branches;
        _brancheNames = _branches.map((e) => e.name).toList();
      });
    }

    return 'success';
  }

  _printLatestValue() {
    if (myController.text.isEmpty) {
      context.read<ViolationListBloc>().add(ViolationBranchChanged(
            branch: null,
          ));
    }
  }

  @override
  void initState() {
    super.initState();
    this.getBranches();
    myController.addListener(_printLatestValue);
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: DropDownField(
        controller: myController,
        onValueChanged: (value) {
          id = value;
          context.read<ViolationListBloc>().add(ViolationBranchChanged(
                branch: Branch(
                  id: _branches
                      .firstWhere((element) => element.name == value)
                      .id,
                  name: value,
                ),
              ));
        },
        value: _initValue,
        hintText: S.of(context).CHOOSE_BRANCH,
        items: _brancheNames,
        strict: false,
        required: true,
        errorText: S.of(context).THIS_FIELD_CANNOT_BE_EMPTY,
      ),
    );
  }
}

class DropdownFieldReport extends StatefulWidget {
  @override
  _DropdownFieldReportState createState() => _DropdownFieldReportState();
}

class _DropdownFieldReportState extends State<DropdownFieldReport> {
  String id;

  ReportRepository _branchRepository = ReportRepository();
  List<Report> _reports = List();
  List<String> _reportNames = List();
  String _initValue;
  final myController = TextEditingController();

  Future<String> getReports() async {
    try {
      var reports = await _branchRepository.fetchReports(
        token: BlocProvider.of<AuthenticationBloc>(context).state.token,
        status: 'Opening',
      );

      if (this.mounted) {
        setState(() {
          _reports = reports;
          _reportNames = _reports.map((report) => report.name).toList();
        });
      }
    } catch (e) {}

    return 'success';
  }

  _printLatestValue() {
    if (myController.text.isEmpty) {
      context.read<ViolationListBloc>().add(ViolationReportChanged(
            reportId: 0,
          ));
      context.read<ViolationListBloc>().add(ViolationBranchChanged(
            branch: null,
          ));
    }
  }

  @override
  void initState() {
    super.initState();
    this.getReports();
    myController.addListener(_printLatestValue);
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: DropDownField(
        controller: myController,
        onValueChanged: (value) {
          context.read<ViolationListBloc>().add(ViolationBranchChanged(
                branch: Branch(
                    id: _reports
                        .firstWhere((element) => element.name == value)
                        .branchId,
                    name: _reports
                        .firstWhere((element) => element.name == value)
                        .branchName),
              ));
          context.read<ViolationListBloc>().add(ViolationReportChanged(
              reportId:
                  _reports.firstWhere((element) => element.name == value).id));
        },
        value: _initValue,
        hintText:
            S.of(context).CHOOSE + ' ' + S.of(context).REPORT.toLowerCase(),
        items: _reportNames,
        strict: false,
        required: true,
        errorText: S.of(context).THIS_FIELD_CANNOT_BE_EMPTY,
      ),
    );
  }
}

class DropdownFieldRegulation extends StatefulWidget {
  final Regulation initValue;

  const DropdownFieldRegulation({Key key, this.initValue}) : super(key: key);
  @override
  _DropdownFieldRegulationState createState() =>
      _DropdownFieldRegulationState(initValue: initValue);
}

class _DropdownFieldRegulationState extends State<DropdownFieldRegulation> {
  String id;

  RegulationRepository _regulationRepository = RegulationRepository();
  List<Regulation> _regulations = List();
  List<String> _regulationNames = List();
  Regulation initValue;
  final myController = TextEditingController();

  _DropdownFieldRegulationState({this.initValue});

  Future<String> getBranches() async {
    var regulations = await _regulationRepository.fetchRegulationes(
      BlocProvider.of<AuthenticationBloc>(context).state.token,
    );

    if (this.mounted) {
      setState(() {
        _regulations = regulations;
        _regulationNames = _regulations.map((e) => e.name).toList();
      });
    }

    return 'success';
  }

  _printLatestValue() {
    if (myController.text.isEmpty) {
      context.read<ViolationCreateBloc>().add(ViolationRegulationChanged(
            regulation: null,
          ));
    }
    print("Second text field: ${myController.text}");
  }

  @override
  void initState() {
    super.initState();
    this.getBranches();
    myController.addListener(_printLatestValue);
    if (widget.initValue != null) {
      myController.text = initValue.name;

      context.read<ViolationCreateBloc>().add(
            ViolationRegulationChanged(
              regulation: Regulation(
                id: widget.initValue.id,
                name: widget.initValue.name,
              ),
            ),
          );
    }
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: DropDownField(
        controller: myController,
        onValueChanged: (value) {
          id = value;
          context.read<ViolationCreateBloc>().add(
                ViolationRegulationChanged(
                  regulation: Regulation(
                    id: _regulations
                        .firstWhere((element) => element.name == value)
                        .id,
                    name: value,
                  ),
                ),
              );
        },
        hintText: S.of(context).CHOOSE_REGULATION,
        // labelText: 'Branch',
        items: _regulationNames,
        strict: false,
        required: true,
        errorText: S.of(context).THIS_FIELD_CANNOT_BE_EMPTY,
      ),
    );
  }
}
