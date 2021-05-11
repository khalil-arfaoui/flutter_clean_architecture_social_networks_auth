import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../bloc/user_bloc.dart';
import '../../models_providers/auth_provider.dart';
import '../../pages/auth/register_page.dart';
import '../../pages/auth/reset_password_page.dart';

class LoginForm extends StatefulWidget {
  LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        return Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                top: 10.0,
                bottom: 10.0,
              ),
              child: Text(
                'S\'identifier',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                    top: 10.0,
                    right: 20,
                    bottom: 20,
                  ),
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => ResetPasswordPage(),
                      ),
                    ),
                    child: Text(
                      'Mot de passe oublié ?',
                      style: TextStyle(color: Theme.of(context).accentColor),
                    ),
                  ),
                ),
              ],
            ),
            BlocListener<UserBloc, UserState>(
              listener: (context, state) {
                if (state is UserLoaded) {
                  print('User loaded');
                  authProvider.loggedInOrOut = true;
                  authProvider.setUid = state.user.id;
                  authProvider.setUser = state.user;
                  Navigator.pop(context);
                } else if (state is UserError) {
                  String errorMessage = state.message;
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(child: Text(errorMessage)),
                            Icon(Icons.error_outline)
                          ],
                        ),
                      ),
                    );
                }
              },
              child: Container(),
            ),
            Divider(
              indent: 20.0,
              endIndent: 20.0,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 20.0,
              ),
              child: OutlinedButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.lightBlue,
                        ),
                        alignment: Alignment.bottomCenter,
                        height: 30.0,
                        width: 30.0,
                        child: Icon(
                          FontAwesomeIcons.facebookF,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Padding(
                        padding: EdgeInsets.only(right: 20.0),
                        child: Text(
                          'S\'identifier via Facebook',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
                onPressed: () => BlocProvider.of<UserBloc>(context).add(
                  LoginWithSocialNetwork(provider: 'facebook'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 20.0,
              ),
              child: OutlinedButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: Icon(
                        FontAwesomeIcons.google,
                        color: Colors.redAccent,
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Padding(
                        padding: EdgeInsets.only(right: 20.0),
                        child: Text(
                          'S\'identifier via Google',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
                onPressed: () => BlocProvider.of<UserBloc>(context).add(
                  LoginWithSocialNetwork(provider: 'google'),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 20.0,
              ),
              child: Text.rich(
                TextSpan(
                  style: TextStyle(
                    fontFamily:
                        Theme.of(context).textTheme.bodyText1?.fontFamily,
                  ),
                  children: [
                    TextSpan(text: 'Vous n’avez pas de compte ?'),
                    TextSpan(
                      recognizer: new TapGestureRecognizer()
                        ..onTap = () {
                          FocusScopeNode currentFocus = FocusScope.of(context);
                          if (!currentFocus.hasPrimaryFocus) {
                            currentFocus.unfocus();
                          }
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => RegisterPage(),
                            ),
                          );
                        },
                      text: ' S\'inscrire',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
