import 'package:flutter/material.dart';
import 'package:mi_que/providers/user_provider.dart';
import 'package:mi_que/ui/pages/bottom_navigation_page.dart';
import 'package:mi_que/ui/widgets/logo_widget.dart';
import 'package:mi_que/ui/widgets/safe_scaffold.dart';
import 'package:mi_que/ui/widgets/snack_bar.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeScaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                LogoWidget(width: 120, height: 120),
                const Text(
                  "Inicia sesión",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "Por favor iniciar sesión para continuar",
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 40),
                Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: "Correo electrónico",
                        prefixIcon: Icon(Icons.email),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingresa tu correo';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Correo inválido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 40),
                    PasswordField(controller: _passwordController),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          loginUser();
                        }
                      },
                      child: const Text("Ingresar"),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("¿No tienes una cuenta?"),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          "/signup",
                          (route) => false,
                        );
                      },
                      child: const Text("Regístrate"),
                    ),
                  ],
                ),
                const Text("O iniciar sesión con:"),
                SizedBox(
                  width: 250,
                  height: 70,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                          onPressed: () async {
                          try {
                            final userProvider = Provider.of<UserProvider>(
                                context,
                                listen: false);
                            bool isSucces =
                                await userProvider.signInWithGoogle();
                            await userProvider.loadCurrentUser();
                            if (isSucces) {
                              if (!mounted) return;
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const BottomNavigationPage()));
                            }
                          } catch (e) {
                            rethrow;
                          }
                          },
                          icon: Image.network(
                              'http://pngimg.com/uploads/google/google_PNG19635.png',
                              fit: BoxFit.cover)),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
    void loginUser() async {
    try {
      if (_emailController.text.trim().isNotEmpty &&
          _passwordController.text.trim().isNotEmpty) {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        await userProvider.verifyUser(
            _emailController.text, _passwordController.text);
        await userProvider.loadCurrentUser();
        
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const BottomNavigationPage()));
      } else {
        throw ("Error: Debe de completar todos los campos");
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}

class PasswordField extends StatefulWidget {
  final TextEditingController controller;

  const PasswordField({Key? key, required this.controller}) : super(key: key);

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: "Contraseña",
        prefixIcon: IconButton(
          icon: Icon(
            _isObscure ? Icons.lock : Icons.lock_open,
          ),
          onPressed: () {
            setState(() {
              _isObscure = !_isObscure;
            });
          },
        ),
      ),
      obscureText: _isObscure,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, ingresa tu contraseña';
        }
        if (value.length < 6) {
          return 'La contraseña debe tener al menos 6 caracteres';
        }
        return null;
      },
    );
  }
}
