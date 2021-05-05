// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `hello`
  String get title {
    return Intl.message(
      'hello',
      name: 'title',
      desc: '',
      args: [],
    );
  }

  /// `of`
  String get OF {
    return Intl.message(
      'of',
      name: 'OF',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get EMAIL {
    return Intl.message(
      'Email',
      name: 'EMAIL',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get PASSWORD {
    return Intl.message(
      'Password',
      name: 'PASSWORD',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get HOME {
    return Intl.message(
      'Home',
      name: 'HOME',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get SETTINGS {
    return Intl.message(
      'Settings',
      name: 'SETTINGS',
      desc: '',
      args: [],
    );
  }

  /// `List`
  String get List {
    return Intl.message(
      'List',
      name: 'List',
      desc: '',
      args: [],
    );
  }

  /// `Report`
  String get REPORT {
    return Intl.message(
      'Report',
      name: 'REPORT',
      desc: '',
      args: [],
    );
  }

  /// `Reports`
  String get REPORTS {
    return Intl.message(
      'Reports',
      name: 'REPORTS',
      desc: '',
      args: [],
    );
  }

  /// `Branch`
  String get BRANCH {
    return Intl.message(
      'Branch',
      name: 'BRANCH',
      desc: '',
      args: [],
    );
  }

  /// `Assignee`
  String get ASSIGNEE {
    return Intl.message(
      'Assignee',
      name: 'ASSIGNEE',
      desc: '',
      args: [],
    );
  }

  /// `Violation`
  String get VIOLATION {
    return Intl.message(
      'Violation',
      name: 'VIOLATION',
      desc: '',
      args: [],
    );
  }

  /// `Violations`
  String get VIOLATIONS {
    return Intl.message(
      'Violations',
      name: 'VIOLATIONS',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get NOTIFICATION {
    return Intl.message(
      'Notifications',
      name: 'NOTIFICATION',
      desc: '',
      args: [],
    );
  }

  /// `belongs to`
  String get BELONGS_TO {
    return Intl.message(
      'belongs to',
      name: 'BELONGS_TO',
      desc: '',
      args: [],
    );
  }

  /// `Created on`
  String get CREATED_ON {
    return Intl.message(
      'Created on',
      name: 'CREATED_ON',
      desc: '',
      args: [],
    );
  }

  /// `Submitted by`
  String get SUBMITTED_BY {
    return Intl.message(
      'Submitted by',
      name: 'SUBMITTED_BY',
      desc: '',
      args: [],
    );
  }

  /// `Month`
  String get MONTH {
    return Intl.message(
      'Month',
      name: 'MONTH',
      desc: '',
      args: [],
    );
  }

  /// `Minus point(s)`
  String get MINUS_POINT {
    return Intl.message(
      'Minus point(s)',
      name: 'MINUS_POINT',
      desc: '',
      args: [],
    );
  }

  /// `Total`
  String get TOTAL {
    return Intl.message(
      'Total',
      name: 'TOTAL',
      desc: '',
      args: [],
    );
  }

  /// `Updated on`
  String get UPDATED_ON {
    return Intl.message(
      'Updated on',
      name: 'UPDATED_ON',
      desc: '',
      args: [],
    );
  }

  /// `Regulation`
  String get REGULATION {
    return Intl.message(
      'Regulation',
      name: 'REGULATION',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get DESCRIPTION {
    return Intl.message(
      'Description',
      name: 'DESCRIPTION',
      desc: '',
      args: [],
    );
  }

  /// `QC's note`
  String get COMMENTS {
    return Intl.message(
      'QC\'s note',
      name: 'COMMENTS',
      desc: '',
      args: [],
    );
  }

  /// `Admin's note`
  String get ADMIN_NOTE {
    return Intl.message(
      'Admin\'s note',
      name: 'ADMIN_NOTE',
      desc: '',
      args: [],
    );
  }

  /// `Evidence`
  String get EVIDENCE {
    return Intl.message(
      'Evidence',
      name: 'EVIDENCE',
      desc: '',
      args: [],
    );
  }

  /// `New violation`
  String get NEW_VIOLATION {
    return Intl.message(
      'New violation',
      name: 'NEW_VIOLATION',
      desc: '',
      args: [],
    );
  }

  /// `Edit violation`
  String get EDIT_VIOLATION {
    return Intl.message(
      'Edit violation',
      name: 'EDIT_VIOLATION',
      desc: '',
      args: [],
    );
  }

  /// `Add image`
  String get ADD_IMAGE {
    return Intl.message(
      'Add image',
      name: 'ADD_IMAGE',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get SUBMIT_BUTTON {
    return Intl.message(
      'Submit',
      name: 'SUBMIT_BUTTON',
      desc: '',
      args: [],
    );
  }

  /// `load fail!`
  String get LOAD_FAIL {
    return Intl.message(
      'load fail!',
      name: 'LOAD_FAIL',
      desc: '',
      args: [],
    );
  }

  /// `There is no`
  String get THERE_IS_NO {
    return Intl.message(
      'There is no',
      name: 'THERE_IS_NO',
      desc: '',
      args: [],
    );
  }

  /// `Sort by`
  String get SORT_BY {
    return Intl.message(
      'Sort by',
      name: 'SORT_BY',
      desc: '',
      args: [],
    );
  }

  /// `Filter`
  String get FILTER {
    return Intl.message(
      'Filter',
      name: 'FILTER',
      desc: '',
      args: [],
    );
  }

  /// `success`
  String get SUCCESS {
    return Intl.message(
      'success',
      name: 'SUCCESS',
      desc: '',
      args: [],
    );
  }

  /// `fail`
  String get FAIL {
    return Intl.message(
      'fail',
      name: 'FAIL',
      desc: '',
      args: [],
    );
  }

  /// `Back`
  String get BACK {
    return Intl.message(
      'Back',
      name: 'BACK',
      desc: '',
      args: [],
    );
  }

  /// `Latest notification`
  String get HOME_LATEST_NOTIFICATION {
    return Intl.message(
      'Latest notification',
      name: 'HOME_LATEST_NOTIFICATION',
      desc: '',
      args: [],
    );
  }

  /// `See all`
  String get HOME_SEE_ALL {
    return Intl.message(
      'See all',
      name: 'HOME_SEE_ALL',
      desc: '',
      args: [],
    );
  }

  /// `Latest reports`
  String get HOME_REPORT_LIST {
    return Intl.message(
      'Latest reports',
      name: 'HOME_REPORT_LIST',
      desc: '',
      args: [],
    );
  }

  /// `Violations in day`
  String get HOME_VIOLATION_LIST {
    return Intl.message(
      'Violations in day',
      name: 'HOME_VIOLATION_LIST',
      desc: '',
      args: [],
    );
  }

  /// `Create new`
  String get VIOLATION_SCREEN_CREATE_NEW_BUTTON {
    return Intl.message(
      'Create new',
      name: 'VIOLATION_SCREEN_CREATE_NEW_BUTTON',
      desc: '',
      args: [],
    );
  }

  /// `Fetch fail`
  String get VIOLATION_SCREEN_FETCH_FAIL {
    return Intl.message(
      'Fetch fail',
      name: 'VIOLATION_SCREEN_FETCH_FAIL',
      desc: '',
      args: [],
    );
  }

  /// `Reload`
  String get VIOLATION_SCREEN_RELOAD {
    return Intl.message(
      'Reload',
      name: 'VIOLATION_SCREEN_RELOAD',
      desc: '',
      args: [],
    );
  }

  /// `There is no violations`
  String get VIOLATION_SCREEN_NO_VIOLATIONS {
    return Intl.message(
      'There is no violations',
      name: 'VIOLATION_SCREEN_NO_VIOLATIONS',
      desc: '',
      args: [],
    );
  }

  /// `Branch`
  String get VIOLATION_CREATE_SCREEN_DROPDOWN_FIELD {
    return Intl.message(
      'Branch',
      name: 'VIOLATION_CREATE_SCREEN_DROPDOWN_FIELD',
      desc: '',
      args: [],
    );
  }

  /// `New violation`
  String get VIOLATION_CREATE_SCREEN_ADD_VIOLATION_CARD {
    return Intl.message(
      'New violation',
      name: 'VIOLATION_CREATE_SCREEN_ADD_VIOLATION_CARD',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get VIOLATION_CREATE_MODAL_ADD {
    return Intl.message(
      'Add',
      name: 'VIOLATION_CREATE_MODAL_ADD',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get VIOLATION_SUBMITTED {
    return Intl.message(
      'Submit',
      name: 'VIOLATION_SUBMITTED',
      desc: '',
      args: [],
    );
  }

  /// `Status`
  String get VIOLATION_STATUS {
    return Intl.message(
      'Status',
      name: 'VIOLATION_STATUS',
      desc: '',
      args: [],
    );
  }

  /// `Opening`
  String get VIOLATION_STATUS_OPENING {
    return Intl.message(
      'Opening',
      name: 'VIOLATION_STATUS_OPENING',
      desc: '',
      args: [],
    );
  }

  /// `Excused`
  String get VIOLATION_STATUS_EXCUSED {
    return Intl.message(
      'Excused',
      name: 'VIOLATION_STATUS_EXCUSED',
      desc: '',
      args: [],
    );
  }

  /// `Confirmed`
  String get VIOLATION_STATUS_CONFIRMED {
    return Intl.message(
      'Confirmed',
      name: 'VIOLATION_STATUS_CONFIRMED',
      desc: '',
      args: [],
    );
  }

  /// `Rejected`
  String get VIOLATION_STATUS_REJECTED {
    return Intl.message(
      'Rejected',
      name: 'VIOLATION_STATUS_REJECTED',
      desc: '',
      args: [],
    );
  }

  /// `There are no reports`
  String get REPORT_SCREEN_NO_REPORTS {
    return Intl.message(
      'There are no reports',
      name: 'REPORT_SCREEN_NO_REPORTS',
      desc: '',
      args: [],
    );
  }

  /// `Comment`
  String get REPORT_EDIT_SCREEN_QC_NOTE {
    return Intl.message(
      'Comment',
      name: 'REPORT_EDIT_SCREEN_QC_NOTE',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get LANGUAGE {
    return Intl.message(
      'Language',
      name: 'LANGUAGE',
      desc: '',
      args: [],
    );
  }

  /// `Vietnamese`
  String get LANGUAGE_VN {
    return Intl.message(
      'Vietnamese',
      name: 'LANGUAGE_VN',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get LANGUAGE_EN {
    return Intl.message(
      'English',
      name: 'LANGUAGE_EN',
      desc: '',
      args: [],
    );
  }

  /// `Change password`
  String get CHANGE_PASSWORD {
    return Intl.message(
      'Change password',
      name: 'CHANGE_PASSWORD',
      desc: '',
      args: [],
    );
  }

  /// `Log out`
  String get LOGOUT {
    return Intl.message(
      'Log out',
      name: 'LOGOUT',
      desc: '',
      args: [],
    );
  }

  /// `Log in`
  String get LOGIN {
    return Intl.message(
      'Log in',
      name: 'LOGIN',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get SAVE {
    return Intl.message(
      'Save',
      name: 'SAVE',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get EDIT {
    return Intl.message(
      'Edit',
      name: 'EDIT',
      desc: '',
      args: [],
    );
  }

  /// `Excuse`
  String get EXCUSE {
    return Intl.message(
      'Excuse',
      name: 'EXCUSE',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get CONFIRM {
    return Intl.message(
      'Confirm',
      name: 'CONFIRM',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get DELETE {
    return Intl.message(
      'Delete',
      name: 'DELETE',
      desc: '',
      args: [],
    );
  }

  /// `Remove`
  String get REMOVE {
    return Intl.message(
      'Remove',
      name: 'REMOVE',
      desc: '',
      args: [],
    );
  }

  /// `Change`
  String get CHANGE {
    return Intl.message(
      'Change',
      name: 'CHANGE',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get YES {
    return Intl.message(
      'Yes',
      name: 'YES',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get NO {
    return Intl.message(
      'No',
      name: 'NO',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get CANCEL {
    return Intl.message(
      'Cancel',
      name: 'CANCEL',
      desc: '',
      args: [],
    );
  }

  /// `Choose`
  String get CHOOSE {
    return Intl.message(
      'Choose',
      name: 'CHOOSE',
      desc: '',
      args: [],
    );
  }

  /// `Choose a branch`
  String get CHOOSE_BRANCH {
    return Intl.message(
      'Choose a branch',
      name: 'CHOOSE_BRANCH',
      desc: '',
      args: [],
    );
  }

  /// `Choose a regulation`
  String get CHOOSE_REGULATION {
    return Intl.message(
      'Choose a regulation',
      name: 'CHOOSE_REGULATION',
      desc: '',
      args: [],
    );
  }

  /// `create new successfully!`
  String get POPUP_CREATE_VIOLATION_SUCCESS {
    return Intl.message(
      'create new successfully!',
      name: 'POPUP_CREATE_VIOLATION_SUCCESS',
      desc: '',
      args: [],
    );
  }

  /// `create new fail!`
  String get POPUP_CREATE_VIOLATION_FAIL {
    return Intl.message(
      'create new fail!',
      name: 'POPUP_CREATE_VIOLATION_FAIL',
      desc: '',
      args: [],
    );
  }

  /// `Processing request.`
  String get POPUP_CREATE_VIOLATION_SUBMITTING {
    return Intl.message(
      'Processing request.',
      name: 'POPUP_CREATE_VIOLATION_SUBMITTING',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure to delete this violation?`
  String get POPUP_DELETE_VIOLATION {
    return Intl.message(
      'Are you sure to delete this violation?',
      name: 'POPUP_DELETE_VIOLATION',
      desc: '',
      args: [],
    );
  }

  /// `update successfully`
  String get POPUP_UPDATE_SUCCESS {
    return Intl.message(
      'update successfully',
      name: 'POPUP_UPDATE_SUCCESS',
      desc: '',
      args: [],
    );
  }

  /// `update fail!`
  String get POPUP_UPDATE_FAIL {
    return Intl.message(
      'update fail!',
      name: 'POPUP_UPDATE_FAIL',
      desc: '',
      args: [],
    );
  }

  /// `Current password`
  String get CHANGE_PASSWORD_SCREEN_CURRENT_PASSWORD {
    return Intl.message(
      'Current password',
      name: 'CHANGE_PASSWORD_SCREEN_CURRENT_PASSWORD',
      desc: '',
      args: [],
    );
  }

  /// `New password`
  String get CHANGE_PASSWORD_SCREEN_NEW_PASSWORD {
    return Intl.message(
      'New password',
      name: 'CHANGE_PASSWORD_SCREEN_NEW_PASSWORD',
      desc: '',
      args: [],
    );
  }

  /// `Confirm password`
  String get CHANGE_PASSWORD_SCREEN_CONFIRM_PASSWORD {
    return Intl.message(
      'Confirm password',
      name: 'CHANGE_PASSWORD_SCREEN_CONFIRM_PASSWORD',
      desc: '',
      args: [],
    );
  }

  /// `Change password success`
  String get CHANGE_PASSWORD_SCREEN_CHANGE_SUCCESS {
    return Intl.message(
      'Change password success',
      name: 'CHANGE_PASSWORD_SCREEN_CHANGE_SUCCESS',
      desc: '',
      args: [],
    );
  }

  /// `Current password is wrong`
  String get CHANGE_PASSWORD_SCREEN_PASSWORD_ERROR {
    return Intl.message(
      'Current password is wrong',
      name: 'CHANGE_PASSWORD_SCREEN_PASSWORD_ERROR',
      desc: '',
      args: [],
    );
  }

  /// `Confirm password must be the same as new password`
  String get CHANGE_PASSWORD_SCREEN_CONFIRM_ERROR {
    return Intl.message(
      'Confirm password must be the same as new password',
      name: 'CHANGE_PASSWORD_SCREEN_CONFIRM_ERROR',
      desc: '',
      args: [],
    );
  }

  /// `must not be empty`
  String get CHANGE_PASSWORD_SCREEN_EMPTY {
    return Intl.message(
      'must not be empty',
      name: 'CHANGE_PASSWORD_SCREEN_EMPTY',
      desc: '',
      args: [],
    );
  }

  /// `There are no images for this violation`
  String get THERE_ARE_NO_EVIDENCE {
    return Intl.message(
      'There are no images for this violation',
      name: 'THERE_ARE_NO_EVIDENCE',
      desc: '',
      args: [],
    );
  }

  /// `This field cannot be empty`
  String get THIS_FIELD_CANNOT_BE_EMPTY {
    return Intl.message(
      'This field cannot be empty',
      name: 'THIS_FIELD_CANNOT_BE_EMPTY',
      desc: '',
      args: [],
    );
  }

  /// `There is no QC's note yet.`
  String get THERE_NOT_QCNOTE_YET {
    return Intl.message(
      'There is no QC\'s note yet.',
      name: 'THERE_NOT_QCNOTE_YET',
      desc: '',
      args: [],
    );
  }

  /// `There is no excusion note yet.`
  String get THERE_NOT_EXCUSE_YET {
    return Intl.message(
      'There is no excusion note yet.',
      name: 'THERE_NOT_EXCUSE_YET',
      desc: '',
      args: [],
    );
  }

  /// `There are`
  String get THERE_ARE {
    return Intl.message(
      'There are',
      name: 'THERE_ARE',
      desc: '',
      args: [],
    );
  }

  /// `N/A`
  String get NA {
    return Intl.message(
      'N/A',
      name: 'NA',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'vi'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}