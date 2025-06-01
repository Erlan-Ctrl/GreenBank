import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mobile_scanner/mobile_scanner.dart'; // 3.5.5

class TransferenciaScreen extends StatefulWidget {
  const TransferenciaScreen({super.key});

  @override
  _TransferenciaScreenState createState() => _TransferenciaScreenState();
}

class _TransferenciaScreenState extends State<TransferenciaScreen> {
  int _selectedTransferType = 0; // 0 = PIX, 1 = TED/DOC
  final TextEditingController _valorController = TextEditingController();
  final TextEditingController _chaveController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Simulação de dados do usuário logado
  final Map<String, dynamic> _userData = {
    'cpf': '123.456.789-09',
    'nome': 'Usuário Banco Digital',
    'banco': '123',
    'conta': '987654-3',
  };

  @override
  void dispose() {
    _valorController.dispose();
    _chaveController.dispose();
    super.dispose();
  }

  // Abre tela de scanner com MobileScanner (sem allowDuplicates)
  Future<void> _showQRCodeScanner() async {
    final result = await Navigator.push<String?>(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Ler QR Code PIX'),
            backgroundColor: const Color(0xFF325F2A),
          ),
          body: MobileScanner(
            onDetect: (capture) {
              // capture.barcodes é uma lista de 'Barcode'
              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
                Navigator.pop(context, barcodes.first.rawValue);
              }
            },
          ),
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _chaveController.text = result;
      });
    }
  }

  Future<void> _realizarTransferenciaPIX() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Simulação de chamada à API PIX usando http
      final response = await http.post(
        Uri.parse('https://api-banco-digital.com/pix/transferencia'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer seu_token_aqui',
        },
        body: jsonEncode({
          'valor': double.parse(_valorController.text),
          'chaveDestino': _chaveController.text,
          'remetente': {
            'cpf': _userData['cpf'],
            'nome': _userData['nome'],
            'banco': _userData['banco'],
            'conta': _userData['conta'],
          },
          'tipo': 'pix',
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
            Text('PIX realizado com sucesso! ID: ${responseData['id']}'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        throw Exception(responseData['message'] ?? 'Erro ao realizar PIX');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _confirmarTransferencia() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Confirmar Transferência'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  'Tipo: ${_selectedTransferType == 0 ? 'PIX' : 'TED/DOC'}'),
              Text('Valor: R\$ ${_valorController.text}'),
              if (_selectedTransferType == 0)
                Text('Chave PIX: ${_chaveController.text}'),
              const SizedBox(height: 16),
              const Text('Deseja confirmar a transferência?'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                if (_selectedTransferType == 0) {
                  _realizarTransferenciaPIX();
                } else {
                  // TED/DOC ainda em desenvolvimento
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                      Text('Funcionalidade TED/DOC em desenvolvimento'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                }
              },
              child: const Text('Confirmar'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8E9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF325F2A),
        centerTitle: true,
        title: const Text(
          'Transferência',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Seletor de tipo de transferência
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => setState(
                                () => _selectedTransferType = 0),
                        child: Container(
                          padding:
                          const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _selectedTransferType == 0
                                ? const Color(0xFF325F2A)
                                .withOpacity(0.1)
                                : Colors.transparent,
                            borderRadius:
                            const BorderRadius.horizontal(
                              left: Radius.circular(8),
                            ),
                          ),
                          child: Column(
                            children: [
                              const Icon(Icons.pix,
                                  color: Color(0xFF325F2A)),
                              const SizedBox(height: 4),
                              Text(
                                'PIX',
                                style: TextStyle(
                                  fontWeight:
                                  _selectedTransferType == 0
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: const Color(0xFF325F2A),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () => setState(
                                () => _selectedTransferType = 1),
                        child: Container(
                          padding:
                          const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _selectedTransferType == 1
                                ? const Color(0xFF325F2A)
                                .withOpacity(0.1)
                                : Colors.transparent,
                            borderRadius:
                            const BorderRadius.horizontal(
                              right: Radius.circular(8),
                            ),
                          ),
                          child: Column(
                            children: [
                              const Icon(Icons.account_balance,
                                  color: Color(0xFF325F2A)),
                              const SizedBox(height: 4),
                              Text(
                                'TED/DOC',
                                style: TextStyle(
                                  fontWeight:
                                  _selectedTransferType == 1
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: const Color(0xFF325F2A),
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

              const SizedBox(height: 24),

              // Campo de valor
              TextFormField(
                controller: _valorController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+\.?\d{0,2}')),
                ],
                decoration: InputDecoration(
                  labelText: 'Valor',
                  prefixText: 'R\$ ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o valor';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Valor inválido';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Valor deve ser maior que zero';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Campo de chave PIX (visível apenas para PIX)
              if (_selectedTransferType == 0) ...[
                TextFormField(
                  controller: _chaveController,
                  decoration: InputDecoration(
                    labelText: 'Chave PIX',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.qr_code_scanner),
                      onPressed: _showQRCodeScanner,
                    ),
                  ),
                  validator: (value) {
                    if (_selectedTransferType == 0 &&
                        (value == null || value.isEmpty)) {
                      return 'Informe a chave PIX';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                Text(
                  'Tipos de chave: CPF/CNPJ, e-mail, telefone ou chave aleatória',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Botão de confirmar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF325F2A),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _confirmarTransferencia,
                  child: const Text(
                    'Confirmar Transferência',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
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
