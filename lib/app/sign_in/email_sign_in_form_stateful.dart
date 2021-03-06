import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_app/app/services/auth.dart';
import 'package:time_tracker_app/app/sign_in/validators.dart';
import 'package:time_tracker_app/app/widgets/form_submit_button.dart';
import 'package:time_tracker_app/app/widgets/platform_exception_alert_dialog.dart';

enum EmailSignInFormType {
  signIn, register
}

class EmailSignInFormStateful extends StatefulWidget with EmailAndPasswordValidators {

  final VoidCallback onSignIn;

  EmailSignInFormStateful({this.onSignIn});
  
  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();

}

class _EmailSignInFormState extends State<EmailSignInFormStateful> {

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String get _email => _emailController.text;
  String get _password => _passwordController.text;

  EmailSignInFormType _formType = EmailSignInFormType.signIn;
  bool _submitted = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _submit() async {
    setState(() {
      _submitted = true;
      _isLoading = true;
    });
    
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      if (_formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(email: _email, password: _password);
      } else {
        await auth.createUserWithEmailAndPassword(email: _email, password: _password);
      }
      if (widget.onSignIn != null) widget.onSignIn();
      //Navigator.of(context).pop();
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Sign in failed', 
        exception: e,
      ).show(context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _toggleFormType() {
    setState(() {
      _submitted = false;
      _formType = _formType == EmailSignInFormType.signIn ? EmailSignInFormType.register : EmailSignInFormType.signIn;
      _emailController.clear();
      _passwordController.clear();
    });
  }

  void _emailEditingComplete() {
    final newFocus = widget.emailValidator.isValid(_email) ? _passwordFocus : _emailFocus;
    FocusScope.of(context).requestFocus(newFocus);
  }

  List<Widget> _buildChildren() {
    final String primaryText = _formType == EmailSignInFormType.signIn ? 'Sign in' : 'Create an account';
    final String secondaryText = _formType == EmailSignInFormType.signIn ? 'Need an account? Register' : 'Have an account? Sign in';
    bool submitEnabled = widget.emailValidator.isValid(_email) && 
      widget.passwordValidator.isValid(_password) && !_isLoading;

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
        onPressed: !_isLoading ? _toggleFormType : null,
      ),
    ];
  }

  Widget _buildEmailTextField() {
    bool showErrorText = _submitted && widget.emailValidator.isValid(_email);
    return TextField(
        key: Key('email'),
        controller: _emailController,
        autocorrect: false, // remove suggestions on keyboard
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        focusNode: _emailFocus,
        onEditingComplete: _emailEditingComplete,
        decoration: InputDecoration(
          labelText: 'Email',
          hintText: 'test@test.com',
          errorText: showErrorText ? widget.invalidEmailErrorText : null,
          enabled: !_isLoading,
        ),
        onChanged: (email) => _updateState(),
      );
  }

  void _updateState() {
    setState(() {
    });
  }

  Widget _buildPasswordTextField() {
    bool showErrorText = _submitted && widget.passwordValidator.isValid(_password);
    return TextField(
        key: Key('password'),
        controller: _passwordController,
        textInputAction: TextInputAction.done,
        focusNode: _passwordFocus,
        onEditingComplete: _submit,
        decoration: InputDecoration(
          labelText: 'Password',
          errorText: showErrorText ? widget.invalidPasswordErrorText : null,
          enabled: !_isLoading,
        ),
        obscureText: true,
        onChanged: (password) => _updateState(),
      );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: _buildChildren(),
        ),
      ),
    );
  }
}