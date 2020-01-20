import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_app/app/services/auth.dart';
import 'package:time_tracker_app/app/sign_in/email_sign_in_bloc.dart';
import 'package:time_tracker_app/app/sign_in/email_sign_in_model.dart';
import 'package:time_tracker_app/app/sign_in/validators.dart';
import 'package:time_tracker_app/app/widgets/form_submit_button.dart';
import 'package:time_tracker_app/app/widgets/platform_exception_alert_dialog.dart';

enum EmailSignInFormType {
  signIn, register
}

class EmailSignInFormBlocBased extends StatefulWidget with EmailAndPasswordValidators {

  final EmailSignInBloc bloc;

  static Widget create(BuildContext context) {
    final AuthBase auth = Provider.of<AuthBase>(context);
    return Provider<EmailSignInBloc>(
      create: (context) => EmailSignInBloc(auth: auth),
      child: Consumer<EmailSignInBloc>(
        builder: (context, bloc, _) => EmailSignInFormBlocBased(bloc: bloc,),
      ),
      dispose: (context, bloc) => bloc.dispose(),
    );
  }
  
  EmailSignInFormBlocBased({@required this.bloc});

  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();

}

class _EmailSignInFormState extends State<EmailSignInFormBlocBased> {

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _submit() async {
    try {
      await widget.bloc.submit();
      Navigator.of(context).pop();
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Sign in failed', 
        exception: e,
      ).show(context);
    } 
  }

  void _toggleFormType() {
    widget.bloc.toggleFormType();
    _emailController.clear();
    _passwordController.clear(); 
  }

  void _emailEditingComplete(EmailSignInModel model) {
    final newFocus = widget.emailValidator.isValid(model.email) ? _passwordFocus : _emailFocus;
    FocusScope.of(context).requestFocus(newFocus);
  }

  List<Widget> _buildChildren(EmailSignInModel model) {
    final String primaryText = model.formType == EmailSignInFormType.signIn ? 'Sign in' : 'Create an account';
    final String secondaryText = model.formType == EmailSignInFormType.signIn ? 'Need an account? Register' : 'Have an account? Sign in';
    bool submitEnabled = widget.emailValidator.isValid(model.email) && 
      widget.passwordValidator.isValid(model.password) && !model.isLoading;
    return [
      _buildEmailTextField(model),
      SizedBox(height: 8.0,),
      _buildPasswordTextField(model),
      SizedBox(height: 8.0,),
      FormSubmitButton(
        text: primaryText,
        onPressed: submitEnabled ? _submit : null,
      ),
      SizedBox(height: 8.0,),
      FlatButton(
        child: Text(secondaryText),
        onPressed: !model.isLoading ? _toggleFormType : null,
      ),
    ];
  }

  Widget _buildEmailTextField(EmailSignInModel model) {
    bool showErrorText = model.submitted && !widget.emailValidator.isValid(model.email);
    return TextField(
        controller: _emailController,
        autocorrect: false, // remove suggestions on keyboard
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        focusNode: _emailFocus,
        onEditingComplete: () => _emailEditingComplete(model),
        decoration: InputDecoration(
          labelText: 'Email',
          hintText: 'test@test.com',
          errorText: showErrorText ? widget.invalidEmailErrorText : null,
          enabled: !model.isLoading,
        ),
        onChanged: (email) {
          print('onChanged(email) = $email');
          widget.bloc.updateEmail(email);
        },
      );
  }

  Widget _buildPasswordTextField(EmailSignInModel model) {
    bool showErrorText = model.submitted && !widget.passwordValidator.isValid(model.password);
    return TextField(
        controller: _passwordController,
        textInputAction: TextInputAction.done,
        focusNode: _passwordFocus,
        onEditingComplete: _submit,
        decoration: InputDecoration(
          labelText: 'Password',
          errorText: showErrorText ? widget.invalidPasswordErrorText : null,
          enabled: !model.isLoading,
        ),
        obscureText: true,
        onChanged: widget.bloc.updatePassword,
      );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EmailSignInModel>(
      stream: widget.bloc.modelStream,
      initialData: EmailSignInModel(),
      builder: (context, snapshot){
        final EmailSignInModel model = snapshot.data;
        print('build EmailSignInBlocBased model = $model');
        return Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: _buildChildren(model),
          )
        );
      },
    );
  }
}