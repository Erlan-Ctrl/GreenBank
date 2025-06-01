import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  @override
  void dispose() {
    _valorController.dispose();
    _chaveController.dispose();
    super.dispose();
  }

  void _showQRCodeScanner() {
    // Simulação da leitura de QR Code
    // Em um app real, você usaria um pacote como qr_code_scanner
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ler QR Code'),
        content: const Text('Simulação: QR Code lido com sucesso. Chave PIX preenchida.'),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _chaveController.text = '123.456.789-09'; // CPF simulado
              });
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
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
              Text('Tipo: ${_selectedTransferType == 0 ? 'PIX' : 'TED/DOC'}'),
              Text('Valor: R\$ ${_valorController.text}'),
              if (_selectedTransferType == 0) Text('Chave PIX: ${_chaveController.text}'),
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
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Transferência realizada com sucesso!'),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pop(context); // Volta para a tela anterior
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
        title: const Text(
          'Transferência',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
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
                        onTap: () => setState(() => _selectedTransferType = 0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _selectedTransferType == 0 
                                ? const Color(0xFF325F2A).withOpacity(0.1) 
                                : Colors.transparent,
                            borderRadius: const BorderRadius.horizontal(
                              left: Radius.circular(8)),
                          ),
                          child: Column(
                            children: [
                              const Icon(Icons.pix, color: Color(0xFF325F2A)),
                              const SizedBox(height: 4),
                              Text(
                                'PIX',
                                style: TextStyle(
                                  fontWeight: _selectedTransferType == 0 
                                      ? FontWeight.bold 
                                      : FontWeight.normal,
                                  color: const Color(0xFF325F2A)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () => setState(() => _selectedTransferType = 1),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _selectedTransferType == 1 
                                ? const Color(0xFF325F2A).withOpacity(0.1) 
                                : Colors.transparent,
                            borderRadius: const BorderRadius.horizontal(
                              right: Radius.circular(8)),
                          ),
                          child: Column(
                            children: [
                              const Icon(Icons.account_balance, color: Color(0xFF325F2A)),
                              const SizedBox(height: 4),
                              Text(
                                'TED/DOC',
                                style: TextStyle(
                                  fontWeight: _selectedTransferType == 1 
                                      ? FontWeight.bold 
                                      : FontWeight.normal,
                                  color: const Color(0xFF325F2A)),
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
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
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
                    if (_selectedTransferType == 0 && (value == null || value.isEmpty)) {
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
                    color: Colors.grey[600]),
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
                      color: Colors.white),
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