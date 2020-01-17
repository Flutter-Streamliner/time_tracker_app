

import 'package:time_tracker_app/app/sign_in/email_sign_in_bloc_based.dart';

class EmailSignInModel {
  final String email;
  final String password;
  final EmailSignInFormType formType;
  final bool isLoading;
  final bool submitted;

  EmailSignInModel({
    this.email = '', 
    this.password = '', 
    this.formType = EmailSignInFormType.signIn, 
    this.isLoading = false, 
    this.submitted = false
    });

  EmailSignInModel copyWith({
    String email,
    String password,
    EmailSignInFormType formType,
    bool isLoading,
    bool submitted
  }) => EmailSignInModel(
    email: email ?? this.email,
    password: password ?? this.password,
    formType: formType ?? this.formType,
    isLoading: isLoading ?? this.isLoading,
    submitted: submitted ?? this.submitted
  );

  @override
  String toString() => 'email=$email password=$password formType=$formType isLoading=$isLoading submitted=$submitted';

}