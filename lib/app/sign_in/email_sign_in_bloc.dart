import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:time_tracker_app/app/services/auth.dart';
import 'package:time_tracker_app/app/sign_in/email_sign_in_bloc_based.dart';
import 'package:time_tracker_app/app/sign_in/email_sign_in_model.dart';

class EmailSignInBloc {

  final AuthBase auth;
  final _modelSubject = BehaviorSubject<EmailSignInModel>.seeded(EmailSignInModel());
  ValueStream<EmailSignInModel> get modelStream => _modelSubject.stream;
  EmailSignInModel get model => _modelSubject.value;

  EmailSignInBloc({@required this.auth});

  void dispose() {
    _modelSubject.close();
  }

  void toggleFormType() {
    final formType = model.formType == EmailSignInFormType.signIn ? EmailSignInFormType.register : EmailSignInFormType.signIn;
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
    // update model
    _modelSubject.value = model.copyWith(
      email: email,
      password: password,
      formType: formType,
      isLoading: isLoading,
      submitted: submitted
    );
  }

  Future<void> submit() async {
    updateWith(submitted: true, isLoading: true);
    print('submit');
    try {
      if (model.formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(email: model.email, password: model.password);
      } else {
        await auth.createUserWithEmailAndPassword(email: model.email, password: model.password);
      }
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    } 
  }

}