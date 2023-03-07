import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import './decoration_functions.dart';
import './sign_in_up_bar.dart';
import './title.dart';
import '../../providers/auth_provider.dart';

class SignUp extends StatefulWidget {
  const SignUp({
    Key? key,
    required this.onSignInPressed,
  }) : super(key: key);

  final VoidCallback onSignInPressed;

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _hidePassword = true;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String email = '';
    String password = '';
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Expanded(
            flex: 3,
            child: Align(
              alignment: Alignment.centerLeft,
              child: LoginTitle(
                title: 'Welcome\nto\nEventFlow',
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Form(
              key: _formKey,
              child: ListView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: TextFormField(
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                      decoration: registerInputDecoration(
                          hintText: 'Email', icon: Icons.email),
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      cursorColor: Colors.white,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          return 'Please enter an email.';
                        } else if (!value.trim().contains('@')) {
                          return 'Invalid Email';
                        } else if (!value
                            .trim()
                            .endsWith("christuniversity.in")) {
                          return 'Please use your college email';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (newValue) {
                        email = newValue!.trim();
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: <Widget>[
                        TextFormField(
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                          decoration: registerInputDecoration(
                            hintText: 'Password',
                            icon: Icons.vpn_key,
                          ),
                          autocorrect: false,
                          cursorColor: Colors.white,
                          obscureText: _hidePassword,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return 'Please enter a password.';
                            } else if (value.trim().length < 6) {
                              return 'Password should be of at least 6 characters.';
                            } else {
                              return null;
                            }
                          },
                          onSaved: (newValue) {
                            password = newValue!.trim();
                          },
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _hidePassword = !_hidePassword;
                            });
                          },
                          icon: _hidePassword
                              ? const Icon(Icons.visibility_off)
                              : const Icon(Icons.visibility),
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  SignInBar(
                    label: 'Sign up',
                    color: Colors.white,
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        await Provider.of<AuthProvider>(context, listen: false)
                            .register(email, password)
                            .then(
                          (value) {
                            String? errorMessage = value;
                            if (errorMessage != null) {
                              SnackBar snackBar = SnackBar(
                                content: ListTile(
                                  title: Text(errorMessage),
                                  leading: const Icon(Icons.error),
                                ),
                                backgroundColor: Colors.amberAccent,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                duration: const Duration(seconds: 2),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          },
                        );
                      }
                    },
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Consumer<AuthProvider>(
                      builder: (_, authProvider, __) => InkWell(
                        splashColor: Colors.white,
                        onTap: () {
                          if (!authProvider.isLoading) {
                            widget.onSignInPressed.call();
                          }
                        },
                        child: const Text(
                          'Sign in',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
