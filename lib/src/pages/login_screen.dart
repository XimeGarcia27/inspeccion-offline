import 'package:app_inspections/providers/login_form_provider.dart';
import 'package:app_inspections/services/services.dart';
import 'package:app_inspections/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                  height: 400), // Espacio para mover el contenido hacia abajo
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
                    const SizedBox(height: 20),
                    ChangeNotifierProvider(
                      create: (_) => LoginFormProvider(),
                      child: _LoginForm(),
                    ),
                    const SizedBox(
                        height: 30), // Espacio entre el formulario y el botón
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
                    const Color.fromARGB(255, 169, 181, 63).withOpacity(0.1),
                  ),
                  shape: MaterialStateProperty.all(const StadiumBorder()),
                ),
                child: Text(
                  'Crear una nueva cuenta',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.02,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromRGBO(169, 27, 96, 1),
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

    return Form(
      key: loginForm.formkey,
      child: Column(
        children: [
          const SizedBox(height: 30), // Separar renglones

          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 20), // Agregar espacio a los lados
            child: TextFormField(
              // Configuraciones del cuadro de texto
              autocorrect: false,
              keyboardType: TextInputType.name,
              onChanged: (value) => loginForm.usuario = value,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Escribe tu usuario';
                }
                return null;
              },
              // Decoración del cuadro de texto
              decoration: InputDecoration(
                hintText: 'Nombre de Usuario',
                labelText: 'Usuario',
                prefixIcon: const Icon(Icons.alternate_email_rounded),
                // Cambiar el color del borde del cuadro de texto
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color.fromRGBO(169, 27, 96, 1),
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color.fromRGBO(169, 27, 96, 1),
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),

          const SizedBox(height: 40), // Separar renglones

          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 20), // Agregar espacio a los lados
            child: TextFormField(
              // Configuraciones del cuadro de texto
              autocorrect: false,
              keyboardType: TextInputType.visiblePassword,
              obscureText: true, // Para ocultar la contraseña
              onChanged: (value) => loginForm.password = value,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                return (value != null && value.length >= 6)
                    ? null
                    : 'La contraseña debe de ser de 6 caracteres';
              },
              // Decoración del cuadro de texto
              decoration: InputDecoration(
                hintText: '***********',
                labelText: 'Contraseña',
                prefixIcon: const Icon(Icons.lock_outlined),
                // Cambiar el color del borde del cuadro de texto
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color.fromRGBO(169, 27, 96, 1),
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color.fromRGBO(169, 27, 96, 1),
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),

          MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            disabledColor: Colors.grey,
            elevation: 0,
            color: const Color.fromRGBO(6, 6, 68, 1),
            onPressed: loginForm.isLoading
                ? null
                : () async {
                    FocusScope.of(context).unfocus();
                    final authService =
                        Provider.of<AuthService>(context, listen: false);

                    if (!loginForm.isValidForm()) return;

                    loginForm.isLoading = true;

                    final String? errorMessage = await authService.login(
                        loginForm.usuario, loginForm.password);
                    if (errorMessage == null) {
                      // ignore: use_build_context_synchronously
                      Navigator.pushReplacementNamed(
                          context, 'inicioInsp'); // Navegar a otra pantalla
                    } else {
                      // Muestra un snackbar para notificar al usuario que las credenciales no son correctas
                      const snackBar = SnackBar(
                        content: Text('La contraseña o correo no coinciden'),
                        backgroundColor: Color.fromARGB(255, 1, 25, 66),
                      );
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);

                      // Restaura el estado de isLoading a falso para que el botón de inicio de sesión vuelva a estar habilitado
                      loginForm.isLoading = false;
                    }
                  },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
              child: Text(
                loginForm.isLoading ? 'Espere' : 'Ingresar',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
