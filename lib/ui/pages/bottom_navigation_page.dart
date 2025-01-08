import 'package:flutter/material.dart';
import 'package:mi_que/ui/pages/dashboard_page.dart';
import 'package:mi_que/ui/pages/principal_page.dart';
import 'package:mi_que/ui/pages/setting_page.dart';
import 'package:mi_que/ui/widgets/safe_scaffold.dart';

class BottomNavigationPage extends StatefulWidget {
  const BottomNavigationPage({super.key});

  @override
  State<BottomNavigationPage> createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return SafeScaffold(
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        fixedColor: Colors.blue,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Libros',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Ajustes',
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_currentIndex == 0) {
      return PrincipalPage();
    } else if (_currentIndex == 1) {
      return DashboardPage();
    } else {
      return SettingPage();
    }
  }
}
