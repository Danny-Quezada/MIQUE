import 'package:flutter/material.dart';
import 'package:mi_que/domain/entities/user_model.dart';
import 'package:mi_que/providers/user_provider.dart';
import 'package:mi_que/ui/pages/bottom_navigation_page.dart';
import 'package:mi_que/ui/widgets/logo_widget.dart';
import 'package:mi_que/ui/widgets/safe_scaffold.dart';
import 'package:mi_que/ui/widgets/snack_bar.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
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
                  "Registrarse",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "Por favor llena los campos para registrarte",
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 40),
                Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: "Nombre o apodo",
                        prefixIcon: Icon(Icons.person),
                      ),
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingresa tu nombre o apodo';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 40),
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
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          UserModel userModel = UserModel(
                              id: '',
                              name: _nameController.text,
                              books: [],
                              email: _passwordController.text);
                          signUpUser(userModel);
                        }
                      },
                      child: const Text("Registrarse"),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("¿Ya tienes una cuenta?"),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          "/login",
                          (route) => false,
                        );
                      },
                      child: const Text("Iniciar sesión"),
                    ),
                  ],
                ),
                const Text("O registrarse con:"),
                Container(
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
                              if (isSucces) {
                                await userProvider.loadCurrentUser();
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

  void signUpUser(UserModel user) async {
    try {
      if (_emailController.text.trim().isNotEmpty &&
          _passwordController.text.trim().isNotEmpty &&
          _nameController.text.trim().isNotEmpty) {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        await userProvider.createUser(user);
        await userProvider.loadCurrentUser();

        if (!mounted) return;
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const BottomNavigationPage()));
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
