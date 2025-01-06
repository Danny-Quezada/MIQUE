import 'package:flutter/material.dart';
import 'package:mi_que/ui/widgets/logo_widget.dart';
import 'package:mi_que/ui/widgets/safe_scaffold.dart';

class InitialPage extends StatelessWidget {
  const InitialPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeScaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            LogoWidget(width: 100, height: 100),
            Image(
              image: const AssetImage(
                "assets/images/Welcome.png",
              ),
              width: size.width,
              height: 200,
            ),
            _buildWelcomeText(),
            _buildNextButtons(context)
          ],
        ),
      ),
    );
  }

  Column _buildNextButtons(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                "/signup",
                (route) => false,
              );
            },
            child: const Text("Empezar")),
        const SizedBox(
          height: 9,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("¿Ya tienes una cuenta?"),
            TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/login");
                },
                child: const Text("Iniciar sesión")),
          ],
        ),
      ],
    );
  }

  Column _buildWelcomeText() {
    return const Column(
      children: [
        Text(
          "Bienvenido a MiQue",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "Crea una cuenta o inicia sesión para continuar",
          style: TextStyle(fontSize: 15, color: Colors.grey),
        ),
      ],
    );
  }
}
