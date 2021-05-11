import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../bloc/user_bloc.dart';
import '../../models_providers/auth_provider.dart';
import '../../pages/auth/login_page.dart';
import '../../pages/auth/register-with-social-page.dart';

class RegisterForm extends StatefulWidget {
  RegisterForm({Key? key}) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        return Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: Text(
                'Créer un compte',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            BlocListener<UserBloc, UserState>(
              listener: (context, state) {
                if (state is UserLoaded) {
                  authProvider.loggedInOrOut = true;
                  authProvider.setUid = state.user.id;
                  authProvider.setUser = state.user;
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                }
                if (state is SocialUserLoaded) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => RegisterWithSocialPage(
                        socialNetworks: state.socialNetworks,
                      ),
                    ),
                  );
                }
                if (state is UserError) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(child: Text(state.message)),
                            Icon(Icons.error_outline),
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
                          'S\'inscrire via Facebook',
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
                  GetSocialNetwork(provider: 'facebook'),
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
                          'S\'inscrire via Google',
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
                  GetSocialNetwork(provider: 'google'),
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
                  children: [
                    TextSpan(text: 'Vous avez déjà un compte ? '),
                    TextSpan(
                      recognizer: new TapGestureRecognizer()
                        ..onTap = () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => LoginPage(),
                              ),
                            ),
                      text: 'S\'identifier',
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
