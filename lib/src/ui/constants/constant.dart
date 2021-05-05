import 'package:flutter/material.dart';

class Constant {
  static const ROLE_QC = 'QC Manager';
  static const ROLE_BM = 'Branch Manager';

  static final violationStatusColors = {
    'Opening': Colors.blue,
    'Confirmed': Colors.green,
    'Excused': Colors.orange[300],
    'Rejected': Colors.orange[900],
  };

  static final reportStatusColors = {
    'Opening': Colors.blue,
    'Done': Color(0xff2329D6),
    'Submitted': Colors.grey,
    'Time To Submit': Colors.yellow,
  };
}

class ViolationStatusConstant {
  static const CONFIRMED = 'Confirmed';
  static const EXCUSED = 'Excused';
}

class ReportStatusConstant {
  static const OPENING = 'Opening';
  static const TIMETOSUBMIT = 'Time To Submit';
  static const DONE = 'Done';
  static const SUBMITED = 'Submitted';
}
