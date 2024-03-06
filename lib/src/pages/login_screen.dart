import 'package:app_inspections/providers/login_form_provider.dart';
import 'package:app_inspections/services/services.dart';
import 'package:app_inspections/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 250), // Espacio para mover el contenido hacia abajo
              CardContainer(
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    Text(
                      'Inicio de Sesión',
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                        fontSize: MediaQuery.of(context).size.width * 0.05,
                      ),
                    ),
                    const SizedBox(height:20),
                    ChangeNotifierProvider(
                      create: (_) => LoginFormProvider(),
                      child: _LoginForm(),
                    ),
                    const SizedBox(height: 30), // Espacio entre el formulario y el botón
                  ],
                ),
              ),
              // Botón "Crear una nueva cuenta"
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, 'registro');
                },
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(
                    Color.fromARGB(255, 169, 181, 63).withOpacity(0.1),
                  ),
                  shape: MaterialStateProperty.all(const StadiumBorder()),
                ),
                child: Text(
                  'Crear una nueva cuenta',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.03, 
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(169, 27, 96, 1),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class _LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);

    return Container(
      child: Form(
        key: loginForm.formkey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            SizedBox(height: 30), // Separar renglones

            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 20), // Agregar espacio a los lados
              child: TextFormField(
                // Configuraciones del cuadro de texto
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) => loginForm.email = value,
                validator: (value) {
                  String pattern = r'^[a-zA-Z0-9_.+-]+@gmail\.com$';
                  RegExp regExp = RegExp(pattern);

                  return regExp.hasMatch(value ?? '')
                      ? null
                      : 'Por favor, introduce un correo electrónico válido de Gmail';
                },
                // Decoración del cuadro de texto
                decoration: InputDecoration(
                  hintText: 'example@gmail.com',
                  labelText: 'Correo electrónico',
                  prefixIcon: Icon(Icons.alternate_email_rounded),
                  // Cambiar el color del borde del cuadro de texto
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromRGBO(169, 27, 96, 1),
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromRGBO(169, 27, 96, 1),
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),

            SizedBox(height: 40), // Separar renglones

            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 20), // Agregar espacio a los lados
              child: TextFormField(
                // Configuraciones del cuadro de texto
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                obscureText: true, // Para ocultar la contraseña
                onChanged: (value) => loginForm.password = value,
                validator: (value) {
                  return (value != null && value.length >= 6)
                      ? null
                      : 'La contraseña debe de ser de 6 caracteres';
                },
                // Decoración del cuadro de texto
                decoration: InputDecoration(
                  hintText: '***********',
                  labelText: 'Contraseña',
                  prefixIcon: Icon(Icons.lock_outlined),
                  // Cambiar el color del borde del cuadro de texto
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromRGBO(169, 27, 96, 1),
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromRGBO(169, 27, 96, 1),
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),

            SizedBox(height: 30),

            MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              disabledColor: Colors.grey,
              elevation: 0,
              color: const Color.fromRGBO(6, 6, 68, 1),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                child: Text(
                  loginForm.isLoading ? 'Espere' : 'Ingresar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              onPressed: loginForm.isLoading
                  ? null
                  : () async {
                      FocusScope.of(context).unfocus();
                      final authService =
                          Provider.of<AuthService>(context, listen: false);

                      if (!loginForm.isValidForm()) return;

                      loginForm.isLoading = true;

                      final String? errorMessage = await authService.login(
                          loginForm.email, loginForm.password);
                      if (errorMessage == null) {
                        // ignore: use_build_context_synchronously
                        Navigator.pushReplacementNamed(
                            context, 'inicioInsp'); //navegar a otra pantalla
                      } else {
                        //print(errorMessage);
                        NotificationsServices.showSnackbar(
                            "La contraseña o correo no coinciden");
                        loginForm.isLoading = false;
                      }
                    },
            ),
          ],
        ),
      ),
    );
  }
}