import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String cpf = '';
  String senha = '';

  void _login() {
    if (_formKey.currentState!.validate()) {
      if (cpf == "001.002.003-45" && senha == "123456") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login bem-sucedido!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("CPF ou senha inválidos.")),
        );
      }
    }
  }

  void _cadastreSe() {
    Navigator.pushNamed(context, '/cadastro');
  }

  void _esqueciSenha() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Navegar para recuperação de senha")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ✅ Cor de fundo alterada
      backgroundColor: Color(0xFFF1F8E9),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logobank.jpg',
                width: 100,
                height: 100,
              ),
              SizedBox(height: 12),
              Text(
                'GreenBank',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: Colors.green[900],
                ),
              ),
              SizedBox(height: 32),
              Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Text(
                          'Que bom ter você de volta!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[900],
                          ),
                        ),
                        SizedBox(height: 24),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Digite seu CPF',
                            prefixIcon: Icon(Icons.credit_card),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'CPF obrigatório';
                            }
                            if (!RegExp(r'^\d{3}\.\d{3}\.\d{3}-\d{2}$')
                                .hasMatch(value)) {
                              return 'CPF inválido (ex: 000.000.000-00)';
                            }
                            return null;
                          },
                          onChanged: (value) => cpf = value,
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Digite sua senha',
                            prefixIcon: Icon(Icons.lock),
                          ),
                          obscureText: true,
                          validator: (value) =>
                              value != null && value.length >= 6
                                  ? null
                                  : 'Senha muito curta',
                          onChanged: (value) => senha = value,
                        ),
                        SizedBox(height: 28),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.black,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              'Entrar',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                        // ✅ Centralizado
                        Align(
                          alignment: Alignment.center,
                          child: TextButton(
                            onPressed: _esqueciSenha,
                            child: Text(
                              'Esqueci a senha',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Ainda não é cliente?',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.green[800],
                ),
              ),
              SizedBox(height: 12),
              OutlinedButton(
                onPressed: _cadastreSe,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.green[900],
                  side: BorderSide(color: Colors.green[900]!),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                ),
                child: Text(
                  'Cadastre-se',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
