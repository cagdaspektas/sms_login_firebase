// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_screen_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AuthScreenViewModel on _AuthScreenViewModelBase, Store {
  final _$statusAtom = Atom(name: '_AuthScreenViewModelBase.status');

  @override
  String get status {
    _$statusAtom.reportRead();
    return super.status;
  }

  @override
  set status(String value) {
    _$statusAtom.reportWrite(value, super.status, () {
      super.status = value;
    });
  }

  final _$isSubmitAtom = Atom(name: '_AuthScreenViewModelBase.isSubmit');

  @override
  bool get isSubmit {
    _$isSubmitAtom.reportRead();
    return super.isSubmit;
  }

  @override
  set isSubmit(bool value) {
    _$isSubmitAtom.reportWrite(value, super.isSubmit, () {
      super.isSubmit = value;
    });
  }

  final _$logoutAsyncAction = AsyncAction('_AuthScreenViewModelBase.logout');

  @override
  Future<void> logout() {
    return _$logoutAsyncAction.run(() => super.logout());
  }

  final _$submitPhoneNumberAsyncAction =
      AsyncAction('_AuthScreenViewModelBase.submitPhoneNumber');

  @override
  Future<void> submitPhoneNumber() {
    return _$submitPhoneNumberAsyncAction.run(() => super.submitPhoneNumber());
  }

  final _$submitOTPAsyncAction =
      AsyncAction('_AuthScreenViewModelBase.submitOTP');

  @override
  Future<void> submitOTP() {
    return _$submitOTPAsyncAction.run(() => super.submitOTP());
  }

  final _$loginAsyncAction = AsyncAction('_AuthScreenViewModelBase.login');

  @override
  Future<void> login() {
    return _$loginAsyncAction.run(() => super.login());
  }

  final _$_AuthScreenViewModelBaseActionController =
      ActionController(name: '_AuthScreenViewModelBase');

  @override
  void countDown() {
    final _$actionInfo = _$_AuthScreenViewModelBaseActionController.startAction(
        name: '_AuthScreenViewModelBase.countDown');
    try {
      return super.countDown();
    } finally {
      _$_AuthScreenViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void handleError(dynamic e) {
    final _$actionInfo = _$_AuthScreenViewModelBaseActionController.startAction(
        name: '_AuthScreenViewModelBase.handleError');
    try {
      return super.handleError(e);
    } finally {
      _$_AuthScreenViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void reset() {
    final _$actionInfo = _$_AuthScreenViewModelBaseActionController.startAction(
        name: '_AuthScreenViewModelBase.reset');
    try {
      return super.reset();
    } finally {
      _$_AuthScreenViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
status: ${status},
isSubmit: ${isSubmit}
    ''';
  }
}
