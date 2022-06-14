import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../appbar.dart';
import '../input.dart';
import '../scrollable_column.dart';

class LoginPage extends StatefulWidget {
  const LoginPage() : super();
  @override
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMeChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Entra en tu cuenta de CFE"),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Form(
          key: _formKey,
          child: ScrollableColumn(
            children: [
              CustomInputField(
                keyboardType: TextInputType.emailAddress,
                hintText: "Email",
                controller: _emailController,
                validator: (String? email) {
                  if (email == null) {
                    return null;
                  }
                  bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
                  return emailValid ? null : "Correo no valido";
                },
              ),
              SizedBox(height: 24),
              CustomInputField(
                keyboardType: TextInputType.visiblePassword,
                hintText: "Contraseña",
                obscureText: true,
                controller: _passwordController,
                validator: (String? password) {
                  if (password == null) {
                    return null;
                  }
                  if (password.length < 6) {
                    return "Contraseña muy corta";
                  }
                },
              ),
              SizedBox(height: 24),
              CustomCheckbox(
                labelText: "Recordarme",
                value: _rememberMeChecked,
                onChanged: (checked) => setState(() => _rememberMeChecked = checked ?? false),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                child: Text("Login"),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF008F5A),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                      email: _emailController.value.text,
                      password: _passwordController.value.text,
                    )
                        .then((result) {
                      Navigator.of(context).pushNamedAndRemoveUntil('/main', (_) => false);
                    }).catchError((Object exception) {
                      if (exception is FirebaseAuthException) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to auth: ${exception.message}')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Unhandled auth error ${exception}')),
                        );
                      }
                    });
                  }
                },
              ),
              Expanded(
                child: Container(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    "No tienes cuenta?",
                    style: TextStyle(
                      color: Color(0xFFb8b8b8),
                    ),
                  ),
                  TextButton(
                    child: Text("Registrar"),
                    onPressed: () => {
                      Navigator.of(context).pushNamed("/register")
                    },
                  ),
                ],
              ),
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
