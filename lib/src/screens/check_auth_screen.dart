import 'package:app_inspections/services/auth_service.dart';
import 'package:app_inspections/src/pages/inicio_inspeccion.dart';
import 'package:app_inspections/src/pages/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckAuthScreen extends StatelessWidget {
  const CheckAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      body: Center(),
    );
  }
}
