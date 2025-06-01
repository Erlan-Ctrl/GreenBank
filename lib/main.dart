import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'login_page.dart';
import 'cadastro_page.dart'; // ✅ Importe a nova página de cadastro

void main() => runApp(GreenBankApp());

class GreenBankApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GreenBank Login',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: Color(0xFFB2F2BB),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,

      // ✅ Use rotas nomeadas (opcional, mas facilita a navegação)
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginPage(),
        '/cadastro': (context) => CadastroPage(),
      },
    );
  }
}
