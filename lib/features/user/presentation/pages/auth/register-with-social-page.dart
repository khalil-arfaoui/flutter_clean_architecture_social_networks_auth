import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../../../core/utils/validators.dart';
import '../../../domain/entities/social_networks.dart';
import '../../../domain/entities/user.dart';
import '../../bloc/user_bloc.dart';
import '../../models_providers/auth_provider.dart';

class RegisterWithSocialPage extends StatefulWidget {
  const RegisterWithSocialPage({
    Key? key,
    required this.socialNetworks,
  }) : super(key: key);

  final SocialNetworks socialNetworks;

  @override
  _RegisterWithSocialPageState createState() => _RegisterWithSocialPageState();
}

class _RegisterWithSocialPageState extends State<RegisterWithSocialPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email = '';
  String _fullName = '';
  String _address = '';
  String _phone = '';
  late SocialNetworks socialUser;

  @override
  void initState() {
    super.initState();
    socialUser = widget.socialNetworks;
  }

  void _sendEmail() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState?.save();
    final String email = _email.trim();
    final String phone = _phone.trim();
    final User _user = User(
      fullName: _fullName,
      email: email,
      address: _address,
      phone: phone,
      socialNetworks: socialUser,
    );
    BlocProvider.of<UserBloc>(context).add(
      RegisterWithSocialNetwork(user: _user),
    );
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () async {
                bool isTrue = await _onWillPop();
                if (isTrue) {
                  Navigator.pop(context);
                }
              },
            ),
            elevation: 0.0,
            backgroundColor: Colors.transparent,
          ),
          extendBodyBehindAppBar: true,
          body: Form(
            key: _formKey,
            child: Padding(
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
                        color:
                            Theme.of(context).primaryTextTheme.bodyText1?.color,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Text(
                        'Créer un compte',
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
                        'Veuillez saisir ou modifier vos informations restantes pour créer un nouveau compte',
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
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 10.0,
                      ),
                      child: Container(
                        child: buildFullNameTextField(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 10.0,
                      ),
                      child: Container(
                        child: buildAddressTextField(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 10.0,
                      ),
                      child: Container(
                        child: buildPhoneTextField(),
                      ),
                    ),
                    BlocConsumer<UserBloc, UserState>(
                      listener: (context, state) {
                        if (state is UserLoaded) {
                          authProvider.loggedInOrOut = true;
                          authProvider.setUid = state.user.id;
                          authProvider.setUser = state.user;
                          Navigator.popUntil(context, ModalRoute.withName('/'));
                        }
                        if (state is UserError) {
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(
                              SnackBar(
                                content: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(child: Text(state.message)),
                                    Icon(Icons.error_outline),
                                  ],
                                ),
                              ),
                            );
                        }
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
        ),
      ),
    );
  }

  TextFormField buildFullNameTextField() {
    return TextFormField(
      initialValue: socialUser.fullName,
      validator: (value) {
        if (value != null) {
          if (value.isEmpty) {
            return 'Veuillez saisir votre nom et prénom';
          }
          return null;
        }
      },
      textAlignVertical: TextAlignVertical.bottom,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        filled: true,
        contentPadding: EdgeInsets.only(
          left: 30.0,
          top: 32.0,
          bottom: 20.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          borderSide: BorderSide.none,
        ),
        // hintText: 'Nom et prénom',
        labelText: 'Nom et prénom',
        labelStyle: TextStyle(height: 5.0),
        alignLabelWithHint: true,
      ),
      onSaved: (String? value) {
        if (value != null) {
          _fullName = value;
        }
      },
    );
  }

  TextFormField buildEmailTextField() {
    return TextFormField(
      initialValue: socialUser.email,
      validator: (value) {
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
      readOnly: true,
      enabled: false,
      enableInteractiveSelection: false,
      textAlignVertical: TextAlignVertical.bottom,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        filled: true,
        contentPadding: EdgeInsets.only(
          left: 30.0,
          top: 32.0,
          bottom: 20.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          borderSide: BorderSide.none,
        ),
        labelText: 'Email',
        labelStyle: TextStyle(height: 5.0),
        alignLabelWithHint: true,
      ),
      onSaved: (String? value) {
        if (value != null) {
          _email = value;
        }
      },
    );
  }

  TextFormField buildPhoneTextField() {
    return TextFormField(
      initialValue: socialUser.phoneNumber,
      validator: (value) {
        if (value != null) {
          if (value.isEmpty) {
            return 'Veuillez saisir votre numéro de téléphone';
          }
          if (!Validators.isValidPhoneNumber(value)) {
            return 'Veuillez saisir un numéro de téléphone valide';
          }
          return null;
        }
      },
      textAlignVertical: TextAlignVertical.bottom,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        filled: true,
        contentPadding: EdgeInsets.only(
          left: 30.0,
          top: 32.0,
          bottom: 20.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          borderSide: BorderSide.none,
        ),
        // hintText: 'Numéro de téléphone',
        labelText: 'Numéro de téléphone',
        labelStyle: TextStyle(height: 5.0),
        alignLabelWithHint: true,
      ),
      onSaved: (String? value) {
        if (value != null) {
          _phone = value;
        }
      },
    );
  }

  TextFormField buildAddressTextField() {
    return TextFormField(
      initialValue: socialUser.location,
      validator: (value) {
        if (value != null) {
          if (value.isEmpty) {
            return 'Veuillez saisir votre adresse';
          }
          return null;
        }
      },
      textAlignVertical: TextAlignVertical.bottom,
      keyboardType: TextInputType.streetAddress,
      decoration: InputDecoration(
        filled: true,
        contentPadding: EdgeInsets.only(
          left: 30.0,
          top: 32.0,
          bottom: 20.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          borderSide: BorderSide.none,
        ),
        labelText: 'Adresse',
        labelStyle: TextStyle(height: 5.0),
        alignLabelWithHint: true,
      ),
      onSaved: (String? value) {
        if (value != null) {
          _address = value;
        }
      },
    );
  }

  Future<bool> _onWillPop() async {
    final result = await showDialog<bool?>(
      context: context,
      builder: (_) {
        return AlertDialog(
          content: Text(
            "Voulez-vous vraiment quitter l'inscription ? Toutes vos données seront perdues.",
          ),
          title: Text("Alerte!"),
          actions: <Widget>[
            TextButton(
              child: Text("Oui"),
              onPressed: () {
                Navigator.pop(context, true);
                BlocProvider.of<UserBloc>(context).add(
                  UndoRegistration(),
                );
              },
            ),
            TextButton(
              child: Text("Non"),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
          ],
        );
      },
    );

    return result != null ? result : false;
  }
}
