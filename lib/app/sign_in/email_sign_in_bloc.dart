import 'dart:async';

import 'package:flutter/material.dart';
import 'package:time_tracker_app/app/services/auth.dart';
import 'package:time_tracker_app/app/sign_in/email_sign_in_form_stateful.dart';
import 'package:time_tracker_app/app/sign_in/email_sign_in_model.dart';

class EmailSignInBloc {

  final AuthBase auth;
  final StreamController<EmailSignInModel> _modelController = StreamController<EmailSignInModel>();
  Stream<EmailSignInModel> get modelController => _modelController.stream;
  EmailSignInModel _model = EmailSignInModel();

  EmailSignInBloc({@required this.auth});

  void dispose() {
    _modelController.close();
  }

  void updateWith({
    String email,
    String password,
    EmailSignInFormType formType,
    bool isLoading,
    bool submitted,
  }) {
    // update model
    _model.copyWith(
      email: email,
      password: password,
      formType: formType,
      isLoading: isLoading,
      submitted: submitted
    );
    _modelController.add(_model);
    // add updated model to _modelController
  }

  Future<void> submit() async {
    updateWith(submitted: true, isLoading: true);
    
    try {
      if (_model.formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(email: _model.email, password: _model.password);
      } else {
        await auth.createUserWithEmailAndPassword(email: _model.email, password: _model.password);
      }
    } catch (e) {
      rethrow;
    } finally {
      updateWith(isLoading: false);
    }
  }

}