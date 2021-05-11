import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/user_bloc.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String getName(String name) {
    return name
        .split(' ')
        .map((element) => element.substring(0, 1).toUpperCase())
        .join();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoaded) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 40.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: Container(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        radius: 40.0,
                        child: state.user.socialNetworks.avatar != null
                            ? ClipOval(
                                child: Image.network(
                                  state.user.socialNetworks.avatar!,
                                ),
                              )
                            : FittedBox(
                                child: Text(
                                  getName(state.user.fullName),
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 30.0,
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        'Bonjour ${state.user.fullName} !',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(
                  //     horizontal: 20.0,
                  //   ),
                  //   child: Container(
                  //     child: TextButton(
                  //       onPressed: () {
                  //         setState(() {
                  //           _isEdit = true;
                  //         });
                  //       },
                  //       child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: [
                  //           Padding(
                  //             padding:
                  //                 const EdgeInsets.symmetric(horizontal: 6.0),
                  //             child: Icon(Icons.edit),
                  //           ),
                  //           Padding(
                  //             padding:
                  //                 const EdgeInsets.symmetric(horizontal: 6.0),
                  //             child: Text('Editer le profil'),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                    ),
                    child: Container(
                      child: TextButton(
                        onPressed: () {
                          BlocProvider.of<UserBloc>(context).add(
                            Logout(context: context),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6.0),
                          child: Text(
                            'Se déconnecter',
                            style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 10.0,
                    ),
                    child: Container(
                      child: buildFullNameTextField(state.user.fullName),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 10.0,
                    ),
                    child: Container(
                      child: buildEmailTextField(state.user.email),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 10.0,
                    ),
                    child: Container(
                      child: buildAddressTextField(state.user.address),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 10.0,
                    ),
                    child: Container(
                      child: buildPhoneTextField(state.user.phone),
                    ),
                  ),
                  /*Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 10.0,
                    ),
                    child: Container(
                      child: buildPasswordTextField(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 10.0,
                    ),
                    child: Container(
                      child: buildConfirmPasswordTextField(),
                    ),
                  ),*/
                  /*Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 20.0,
                    ),
                    child: Container(
                      child: ElevatedButton(

                        child: Text(
                          'Sauvegarder',
                        ),
                        onPressed: _isEdit ? _submitForm : null,
                      ),
                    ),
                  ),*/
                ],
              ),
            ),
          );
        }
        return Container();
      },
    );
  }

  TextFormField buildAddressTextField(String initialValue) {
    return TextFormField(
      initialValue: initialValue,
      readOnly: true,
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
    );
  }

  TextFormField buildPhoneTextField(String initialValue) {
    return TextFormField(
      initialValue: initialValue,
      readOnly: true,
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
    );
  }

  TextFormField buildEmailTextField(String initialValue) {
    return TextFormField(
      initialValue: initialValue,
      readOnly: true,
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
        // hintText: 'Email',
        labelText: 'Email',
        labelStyle: TextStyle(height: 5.0),
        alignLabelWithHint: true,
      ),
    );
  }

  TextFormField buildFullNameTextField(String initialValue) {
    return TextFormField(
      initialValue: initialValue,
      readOnly: true,
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
    );
  }
}
