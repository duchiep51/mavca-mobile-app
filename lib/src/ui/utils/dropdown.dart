import 'package:capstone_mobile/src/blocs/authentication/authentication_bloc.dart';
import 'package:capstone_mobile/src/blocs/violation_list_create/violation_create_bloc.dart';
import 'package:capstone_mobile/src/data/models/branch/branch.dart';
import 'package:capstone_mobile/src/data/models/regulation/regulation.dart';
import 'package:capstone_mobile/src/data/repositories/branch/branch_repository.dart';
import 'package:capstone_mobile/src/data/repositories/regulation/regulation_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// class BranchDropdown extends StatefulWidget {
//   BranchDropdown({Key key, this.initValue}) : super(key: key);

//   final Branch initValue;

//   @override
//   BranchDropdownState createState() =>
//       BranchDropdownState(dropdownValue: initValue);
// }

// class BranchDropdownState extends State<BranchDropdown> {
//   BranchRepository _branchRepository = BranchRepository();
//   List<Branch> _branches = List();
//   Branch dropdownValue;

//   BranchDropdownState({this.dropdownValue});

//   Future<String> getBranches() async {
//     var branches = await _branchRepository.fetchBranches(
//         BlocProvider.of<AuthenticationBloc>(context).state.token);

//     if (this.mounted) {
//       setState(() => _branches = branches);
//     }

//     return 'success';
//   }

//   @override
//   void initState() {
//     super.initState();
//     if (this.dropdownValue != null) {
//       context.read<ViolationCreateBloc>().add(
//             ViolationBranchChanged(
//               branch: Branch(
//                 id: dropdownValue.id,
//                 name: dropdownValue.name,
//               ),
//             ),
//           );
//     }
//     this.getBranches();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 32,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10.0),
//         color: Colors.grey[200],
//         border: Border.all(),
//       ),
//       child: DropdownButtonHideUnderline(
//         child: ButtonTheme(
//           alignedDropdown: true,
//           child: DropdownButton<Branch>(
//             isExpanded: true,
//             value: dropdownValue,
//             icon: Icon(Icons.arrow_drop_down),
//             iconSize: 24,
//             elevation: 16,
//             style: TextStyle(color: Colors.black),
//             underline: Container(
//               height: 1,
//               color: Colors.black38,
//             ),
//             onChanged: (newValue) {
//               setState(() {
//                 dropdownValue = newValue;
//               });
//               context.read<ViolationCreateBloc>().add(
//                     ViolationBranchChanged(
//                         branch: Branch(
//                       id: newValue.id,
//                       name: newValue.name,
//                     )),
//                   );
//             },
//             items: _branches.map<DropdownMenuItem<Branch>>((branch) {
//               return DropdownMenuItem<Branch>(
//                 value: branch,
//                 child: Text(branch.name),
//               );
//             }).toList(),
//           ),
//         ),
//       ),
//     );
//     // });
//   }
// }

class RegulationDropdown extends StatefulWidget {
  RegulationDropdown({Key key, this.initValue}) : super(key: key);

  final Regulation initValue;

  @override
  RegulationDropdownState createState() =>
      RegulationDropdownState(dropdownValue: initValue);
}

class RegulationDropdownState extends State<RegulationDropdown> {
  RegulationRepository _regulationRepository = RegulationRepository();
  List<Regulation> _regulations = List();
  Regulation dropdownValue;

  RegulationDropdownState({this.dropdownValue});

  Future<String> getBranches() async {
    var regulations = await _regulationRepository.fetchRegulationes(
        BlocProvider.of<AuthenticationBloc>(context).state.token);

    if (this.mounted) {
      setState(() => _regulations = regulations);
    }

    return 'success';
  }

  @override
  void initState() {
    super.initState();
    if (this.dropdownValue != null) {
      context.read<ViolationCreateBloc>().add(
            ViolationRegulationChanged(
              regulation: Regulation(
                id: dropdownValue.id,
                name: dropdownValue.name,
              ),
            ),
          );
    }
    this.getBranches();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.grey[200],
        border: Border.all(),
      ),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton<Regulation>(
            itemHeight: 56,
            isExpanded: true,
            value: dropdownValue,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.black),
            underline: Container(
              height: 1,
              color: Colors.black38,
            ),
            onChanged: (newValue) {
              setState(() {
                dropdownValue = newValue;
              });

              context.read<ViolationCreateBloc>().add(
                    ViolationRegulationChanged(
                      regulation: Regulation(
                        id: newValue.id,
                        name: newValue.name,
                      ),
                    ),
                  );
            },
            items: _regulations.map<DropdownMenuItem<Regulation>>((regulation) {
              return DropdownMenuItem<Regulation>(
                value: regulation,
                child: Text(regulation.name),
              );
            }).toList(),
          ),
        ),
      ),
    );
    // });
  }
}

class StatusDropdown extends StatefulWidget {
  final List list;
  final Function onChanged;

  const StatusDropdown({Key key, this.list, this.onChanged}) : super(key: key);
  @override
  _StatusDropdownState createState() => _StatusDropdownState();
}

class _StatusDropdownState extends State<StatusDropdown> {
  String dropdownValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.grey[200],
        border: Border.all(),
      ),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton<String>(
            itemHeight: 56,
            // isExpanded: true,
            value: dropdownValue,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.black, fontFamily: 'Montserrat'),
            underline: Container(
              height: 1,
              color: Colors.black38,
            ),
            onChanged: (newValue) {
              setState(() {
                dropdownValue = newValue;
              });
              widget.onChanged(newValue);
            },
            items: widget.list.map<DropdownMenuItem<String>>((status) {
              return DropdownMenuItem<String>(
                value: status,
                child: Text(status),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
