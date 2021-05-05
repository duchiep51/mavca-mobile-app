import 'dart:io';

import 'package:capstone_mobile/generated/l10n.dart';
import 'package:capstone_mobile/src/data/models/violation/violation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// class ViolationModalFit extends StatelessWidget {
//   const ViolationModalFit({Key key, @required this.violation})
//       : super(key: key);

//   final Violation violation;

//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;
//     var theme = Theme.of(context);
//     return Material(
//       clipBehavior: Clip.antiAlias,
//       borderRadius: BorderRadius.circular(16.0),
//       child: SafeArea(
//         top: false,
//         child: Padding(
//           padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16, 0),
//           child: Container(
//             height: size.height * 0.8,
//             child: ListView(
//               children: <Widget>[
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Expanded(
//                       child: Container(
//                         child: Text(
//                           S.of(context).VIOLATION +
//                               ' ' +
//                               '${violation.regulationName ?? 'regulation'}',
//                           style: TextStyle(
//                             fontSize: 24,
//                             color: theme.primaryColor,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ),
//                     Container(
//                       child: IconButton(
//                         icon: Icon(Icons.clear),
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//                 Divider(
//                   color: Colors.red,
//                 ),
//                 SizedBox(
//                   height: 16,
//                 ),
//                 Container(
//                   child: Text(
//                     S.of(context).DESCRIPTION + ': ',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 8,
//                 ),
//                 TextFormField(
//                   initialValue: violation.description,
//                   decoration: InputDecoration(
//                     labelStyle: TextStyle(color: Colors.black),
//                     fillColor: Colors.grey[200],
//                     filled: true,
//                     border: InputBorder.none,
//                     focusedBorder: InputBorder.none,
//                     enabledBorder: InputBorder.none,
//                     errorBorder: InputBorder.none,
//                     disabledBorder: InputBorder.none,
//                   ),
//                   enabled: false,
//                   maxLines: null,
//                 ),
//                 SizedBox(
//                   height: 16,
//                 ),
//                 Container(
//                   child: Text(S.of(context).EVIDENCE + ':',
//                       style: TextStyle(fontWeight: FontWeight.bold)),
//                 ),
//                 SizedBox(
//                   height: 8,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(2),
//                         image: DecorationImage(
//                           fit: BoxFit.cover,
//                           image: violation.imagePath == null
//                               ? AssetImage('assets/avt.jpg')
//                               : FileImage(File(violation.imagePath)),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 Image(
//                   image: violation?.imagePath == null
//                       ? AssetImage('assets/avt.jpg')
//                       : FileImage(File(violation.imagePath)),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

class ModalFit extends StatelessWidget {
  ModalFit({Key key, this.list, this.title, this.value}) : super(key: key);

  final list;
  final String title;
  final value;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Material(
        child: SafeArea(
      top: false,
      child: Container(
        height: size.height * 0.5,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: 16,
            ),
            Center(
              child: Text(title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            Expanded(
              child: ListView(
                children: ListTile.divideTiles(
                  context: context,
                  tiles: List<Widget>.generate(
                    list.length,
                    (index) => CheckboxListTile(
                      value: value == list[index].id,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text(list[index].name),
                      onChanged: (value) {
                        Navigator.pop(context, list[index].id);
                      },
                    ),
                  ),
                ).toList(),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
