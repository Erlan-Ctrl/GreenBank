import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'login_page.dart';
import 'cadastro_page.dart';
import 'home_screen.dart';
import 'em_desenvolvimento.dart';//
import 'cotacao_page.dart';

void main() => runApp(GreenBankApp());

class GreenBankApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GreenBank',
      theme: ThemeData(
        primaryColor: const Color(0xFF325F2A),
        scaffoldBackgroundColor: const Color(0xFFF1F8E9),
        fontFamily: 'Montserrat Arabic',  // Corrigido o nome da fonte
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginPage(),
        '/cadastro': (context) => CadastroPage(),
        '/home': (context) => const HomeScreen(),
        '/em_desenvolvimento': (context)=> const EmDesenvolvimentoScreen(),
        '/cotacao': (context) => const CotacaoPage(),  // Corrigida a rota e completada
      },
    );
  }
}
