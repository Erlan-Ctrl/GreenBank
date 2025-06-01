// lib/cadastro_page.dart

import 'package:flutter/material.dart';
import 'user_repository.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _formKey = GlobalKey<FormState>();
  String nome = '';
  String cpf = '';
  String senha = '';

  void _cadastrar() {
    if (_formKey.currentState!.validate()) {
      final normalizedCpf = cpf.replaceAll(RegExp(r'\D'), '');
      // Ordem correta: CPF, nome, senha
      final success = UserRepository.register(normalizedCpf, nome, senha);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Cadastro realizado com sucesso!")),
        );
        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.pop(context);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Este CPF já está cadastrado.")),
        );
      }
    }
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
                          'Crie sua conta',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[900],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Nome completo
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Nome completo',
                            border: UnderlineInputBorder(),
                          ),
                          validator: (value) =>
                          (value != null && value.isNotEmpty)
                              ? null
                              : 'Nome obrigatório',
                          onChanged: (v) => nome = v,
                        ),
                        const SizedBox(height: 16),

                        // CPF
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
                            final onlyDigits =
                            value.replaceAll(RegExp(r'\D'), '');
                            if (onlyDigits.length != 11) {
                              return 'CPF inválido';
                            }
                            return null;
                          },
                          onChanged: (v) => cpf = v,
                        ),
                        const SizedBox(height: 16),

                        // Senha
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

                        // Botão Cadastrar
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _cadastrar,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2E7D32),
                              foregroundColor: Colors.white,
                              padding:
                              const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32),
                              ),
                            ),
                            child: const Text(
                              'Cadastrar',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),

                        // Link voltar ao login
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(0, 0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            'Já tem uma conta? Entrar',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.green,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
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
