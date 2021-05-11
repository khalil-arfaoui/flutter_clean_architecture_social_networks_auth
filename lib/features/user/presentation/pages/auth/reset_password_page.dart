import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/validators.dart';
import '../../bloc/user_bloc.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  String _email = '';

  void _sendEmail() {
    if (_email.isEmpty) {
      return;
    }
    final String email = _email.trim();
    print(email);
    // TODO: Reset password implementation
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        } // To close keyboard when tapping somewhere else
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context),
          ),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
        ),
        extendBodyBehindAppBar: true,
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 30.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/logo.png',
                    fit: BoxFit.fill,
                    height: 160.0,
                    color: Theme.of(context).primaryTextTheme.bodyText1?.color,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: Text(
                    'Réinitialiser le mot de passe',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 30.0,
                    vertical: 10.0,
                  ),
                  child: Text(
                    'Veuillez saisir votre e-mail pour recevoir un lien pour créer un nouveau mot de passe par e-mail',
                    style: TextStyle(),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 10.0,
                  ),
                  child: Container(
                    child: buildEmailTextField(),
                  ),
                ),
                BlocConsumer<UserBloc, UserState>(
                  listener: (context, state) {
                    // if (state is UserLoaded) {
                    //   Navigator.pop(context);
                    // }
                    // if (state is UserError) {
                    //   ScaffoldMessenger.of(context)
                    //     ..hideCurrentSnackBar()
                    //     ..showSnackBar(
                    //       SnackBar(
                    //         content: Row(
                    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //           children: [
                    //             Flexible(child: Text(state.message)),
                    //             Icon(Icons.error_outline),
                    //           ],
                    //         ),
                    //       ),
                    //     );
                    // }
                  },
                  builder: (context, state) {
                    if (state is UserLoading) {
                      return CircularProgressIndicator(
                        strokeWidth: 2,
                      );
                    }
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 20.0,
                      ),
                      child: Container(
                        child: ElevatedButton(
                          child: Text(
                            'Envoyer',
                          ),
                          onPressed: _sendEmail,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextFormField buildEmailTextField() {
    return TextFormField(
      validator: (String? value) {
        if (value != null) {
          if (value.isEmpty) {
            return 'Veuillez saisir votre email';
          }
          if (!Validators.isValidEmail(value)) {
            return 'Veuillez saisir un email valide';
          }
          return null;
        }
      },
      onChanged: (String value) {
        setState(() {
          _email = value;
        });
      },
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        filled: true,
        contentPadding: EdgeInsets.all(21.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(40.0)),
          borderSide: BorderSide.none,
        ),
        hintText: 'Email',
      ),
      onSaved: (String? value) {
        if (value != null) {
          _email = value;
        }
      },
    );
  }
}
