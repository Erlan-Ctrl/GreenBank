// lib/login_page.dart

import 'package:flutter/material.dart';
import 'user_repository.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String cpf = '';
  String senha = '';

  void _login() {
    if (_formKey.currentState!.validate()) {
      // Normaliza o CPF removendo tudo que não seja dígito
      final normalizedCpf = cpf.replaceAll(RegExp(r'\D'), '');

      // Tenta autenticar no repositório
      final canLogin = UserRepository.canLogin(normalizedCpf, senha);

      if (canLogin) {
        // Recupera o nome cadastrado
        final userName = UserRepository.getName(normalizedCpf) ?? 'Usuário';

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login bem-sucedido!")),
        );

        // Navega para /home, passando o nome como argumento
        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.pushReplacementNamed(
            context,
            '/home',
            arguments: userName,
          );
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("CPF ou senha inválidos.")),
        );
      }
    }
  }

  void _cadastreSe() {
    Navigator.pushNamed(context, '/cadastro');
  }

  void _esqueciSenha() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Navegar para recuperação de senha")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8E9),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logobank.jpg',
                width: 70,
                height: 70,
              ),
              const SizedBox(height: 32),
              Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Faça login na sua conta',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[900],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Campo CPF
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'CPF',
                            border: UnderlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'CPF obrigatório';
                            }
                            final onlyDigits = value.replaceAll(RegExp(r'\D'), '');
                            if (onlyDigits.length != 11) {
                              return 'CPF inválido (use 11 dígitos)';
                            }
                            return null;
                          },
                          onChanged: (v) => cpf = v,
                        ),
                        const SizedBox(height: 16),

                        // Campo Senha
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Senha',
                            border: UnderlineInputBorder(),
                          ),
                          obscureText: true,
                          validator: (value) =>
                          (value != null && value.length >= 6)
                              ? null
                              : 'Senha muito curta',
                          onChanged: (v) => senha = v,
                        ),
                        const SizedBox(height: 28),

                        // Botão Entrar
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2E7D32),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32),
                              ),
                            ),
                            child: const Text(
                              'Entrar',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),

                        // “Esqueci a senha”
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: _esqueciSenha,
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(0, 0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            'Esqueci a senha',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.green,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        // Link para cadastro
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Ainda não é cliente? ',
                              style: TextStyle(fontSize: 14),
                            ),
                            GestureDetector(
                              onTap: _cadastreSe,
                              child: Text(
                                'Cadastre-se',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.green[900],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
