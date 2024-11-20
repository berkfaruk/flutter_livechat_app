import 'package:flutter/material.dart';
import 'package:flutter_livechat_app/common_widget/social_log_in_button.dart';
import 'package:flutter_livechat_app/model/user_model.dart';
import 'package:flutter_livechat_app/viewmodel/user_viewmodel.dart';
import 'package:provider/provider.dart';

enum FormType { Register, LogIn }

class EmailPasswordLoginPage extends StatefulWidget {
  const EmailPasswordLoginPage({super.key});

  @override
  State<EmailPasswordLoginPage> createState() => _EmailPasswordLoginPageState();
}

class _EmailPasswordLoginPageState extends State<EmailPasswordLoginPage> {
  String? _email, _password;
  String? _buttonText, _linkText;
  var _formType = FormType.LogIn;
  final _formKey = GlobalKey<FormState>();

  _formSubmit(BuildContext context) async {
    _formKey.currentState!.save();
    debugPrint("Email : $_email Password : $_password");
    final _userModel = Provider.of<UserViewModel>(context, listen: false);

    if (_formType == FormType.LogIn) {
      UserModel? _loginUser =
          await _userModel.signInWithEmailAndPassword(_email!, _password!);
      if (_loginUser != null)
        print("Oturum açan User ID : " + _loginUser.userID.toString());
    } else {
      UserModel? _registerUser =
          await _userModel.createUserWithEmailAndPassword(_email!, _password!);
      if (_registerUser != null)
        print("Oturum açan User ID : " + _registerUser.userID.toString());
    }
  }

  void _change() {
    setState(() {
      _formType =
          _formType == FormType.LogIn ? FormType.Register : FormType.LogIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    _buttonText = _formType == FormType.LogIn ? 'Sign In' : 'Sign Up';
    _linkText = _formType == FormType.LogIn
        ? 'Do not have an account? Sign Up'
        : 'Already a user? Sign In';
    final _userViewModel = Provider.of<UserViewModel>(context);

    if (_userViewModel.user != null) {
      Future.delayed(Duration(milliseconds: 10), () {
        Navigator.of(context).pop();
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Giriş / Kayıt'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).secondaryHeaderColor,
      ),
      body: _userViewModel.state == ViewState.Idle
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          errorText: _userViewModel.emailErrorMessage != null ?_userViewModel.emailErrorMessage : null,
                          prefixIcon: Icon(Icons.mail),
                          hintText: "Email",
                          labelText: "Email",
                          border: OutlineInputBorder(),
                        ),
                        onSaved: (userEmail) {
                          _email = userEmail;
                        },
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                          errorText: _userViewModel.passwordErrorMessage != null ? _userViewModel.passwordErrorMessage : null,
                          prefixIcon: Icon(Icons.key),
                          hintText: "Password",
                          labelText: "Password",
                          border: OutlineInputBorder(),
                        ),
                        onSaved: (userPassword) {
                          _password = userPassword;
                        },
                      ),
                      SizedBox(height: 8),
                      SocialLogInButton(
                        buttonText: _buttonText!,
                        onPressed: () => _formSubmit(context),
                        buttonColor: Theme.of(context).primaryColor,
                        textColor: Theme.of(context).secondaryHeaderColor,
                      ),
                      SizedBox(height: 10),
                      OutlinedButton(
                        onPressed: () => _change(),
                        child: Text(_linkText!),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
