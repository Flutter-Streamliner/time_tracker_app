import 'dart:async';

import 'package:flutter/material.dart';
import 'package:time_tracker_app/app/services/auth.dart';
import 'package:time_tracker_app/app/sign_in/email_sign_in_bloc_based.dart';
import 'package:time_tracker_app/app/sign_in/email_sign_in_model.dart';

class EmailSignInBloc {

  final AuthBase auth;
  final StreamController<EmailSignInModel> _modelController = StreamController<EmailSignInModel>();
  Stream<EmailSignInModel> get modelStream => _modelController.stream;
  EmailSignInModel _model = EmailSignInModel();

  EmailSignInBloc({@required this.auth});

  void dispose() {
    _modelController.close();
  }

  void toggleFormType() {
    final formType = _model.formType == EmailSignInFormType.signIn ? EmailSignInFormType.register : EmailSignInFormType.signIn;
    updateWith(
      email: '',
      password: '',
      formType: formType,
      isLoading: false,
      submitted: false
    );
  }

  void updateEmail(String email) => updateWith(email: email);

  void updatePassword(String password) => updateWith(password: password);

  void updateWith({
    String email,
    String password,
    EmailSignInFormType formType,
    bool isLoading,
    bool submitted,
  }) {
    print('EmailSignInBloc updateWith email $email, password $password');
    // update model
    _model = _model.copyWith(
      email: email,
      password: password,
      formType: formType,
      isLoading: isLoading,
      submitted: submitted
    );
    print('EmailSignInBloc updateWith adding model $_model');
    _modelController.add(_model);
    // add updated model to _modelController
  }

  Future<void> submit() async {
    updateWith(submitted: true, isLoading: true);
    print('submit');
    try {
      if (_model.formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(email: _model.email, password: _model.password);
      } else {
        await auth.createUserWithEmailAndPassword(email: _model.email, password: _model.password);
      }
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    } 
  }

}