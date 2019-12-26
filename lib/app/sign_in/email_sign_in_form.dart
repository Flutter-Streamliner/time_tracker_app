import 'package:flutter/material.dart';
import 'package:time_tracker_app/app/services/auth.dart';
import 'package:time_tracker_app/app/sign_in/validators.dart';
import 'package:time_tracker_app/app/widgets/form_submit_button.dart';

enum EmailSignInFormType {
  signIn, register
}

class EmailSignInForm extends StatefulWidget with EmailAndPasswordValidators {

  final AuthBase auth;

  EmailSignInForm({@required this.auth});
  
  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();

}

class _EmailSignInFormState extends State<EmailSignInForm> {

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String get _email => _emailController.text;
  String get _password => _passwordController.text;

  EmailSignInFormType _formType = EmailSignInFormType.signIn;

  void _submit() async {
    try {
      if (_formType == EmailSignInFormType.signIn) {
        await widget.auth.signInWithEmailAndPassword(email: _email, password: _password);
      } else {
        await widget.auth.createUserWithEmailAndPassword(email: _email, password: _password);
      }
      Navigator.of(context).pop();
    } catch (e) {
      print(e.toString());
    }
  }

  void _toggleFormType() {
    setState(() {
      _formType = _formType == EmailSignInFormType.signIn ? EmailSignInFormType.register : EmailSignInFormType.signIn;
      _emailController.clear();
      _passwordController.clear();
    });
  }

  void _emailEditingComplete() {
    FocusScope.of(context).requestFocus(_passwordFocus);
  }

  List<Widget> _buildChildren() {
    final String primaryText = _formType == EmailSignInFormType.signIn ? 'Sign in' : 'Create an account';
    final String secondaryText = _formType == EmailSignInFormType.signIn ? 'Need an account? Register' : 'Have an account? Sign in';
    bool submitEnabled = widget.emailValidator.isValid(_email) && widget.passwordValidator.isValid(_password);

    return [
      _buildEmailTextField(),
      SizedBox(height: 8.0,),
      _buildPasswordTextField(),
      SizedBox(height: 8.0,),
      FormSubmitButton(
        text: primaryText,
        onPressed: submitEnabled ? _submit : null,
      ),
      SizedBox(height: 8.0,),
      FlatButton(
        child: Text(secondaryText),
        onPressed: _toggleFormType,
      ),
    ];
  }

  Widget _buildEmailTextField() {
    bool emailValid = widget.emailValidator.isValid(_email);
    return TextField(
        controller: _emailController,
        autocorrect: false, // remove suggestions on keyboard
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        focusNode: _emailFocus,
        onEditingComplete: _emailEditingComplete,
        decoration: InputDecoration(
          labelText: 'Email',
          hintText: 'test@test.com',
          errorText: emailValid ? null : widget.invalidEmailErrorText,
        ),
        onChanged: (email) => _updateState(),
      );
  }

  void _updateState() {
    setState(() {
    });
  }

  Widget _buildPasswordTextField() {
    bool passwordValid = widget.passwordValidator.isValid(_password);
    return TextField(
        controller: _passwordController,
        textInputAction: TextInputAction.done,
        focusNode: _passwordFocus,
        onEditingComplete: _submit,
        decoration: InputDecoration(
          labelText: 'Password',
          errorText: passwordValid ? null : widget.invalidPasswordErrorText,
        ),
        obscureText: true,
        onChanged: (password) => _updateState(),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: _buildChildren(),
      ),
    );
  }
}