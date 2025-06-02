// lib/pagamento_concluido_page.dart

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class PagamentoConcluidoPage extends StatelessWidget {
  final String valor;
  final String destino;

  const PagamentoConcluidoPage({
    Key? key,
    required this.valor,
    required this.destino,
  }) : super(key: key);

  void _compartilharComprovante(BuildContext context) {
    final mensagem = 'Comprovante de pagamento:\n\n'
        'Destinatário: $destino\n'
        'Valor: $valor\n'
        'Status: Concluído ✅';

    // Chama o share nativo com a mensagem de texto
    Share.share(mensagem);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8E9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF325f2a),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        title: const Text(
          'Pagamento Concluído',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 80),
                const SizedBox(height: 16),
                const Text(
                  'Pagamento realizado com sucesso!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.account_balance_wallet, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(
                      valor,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.storefront, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(
                      destino,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // ESTE É O BOTÃO DECOMPARTILHAR – ele deve aparecer logo abaixo
                ElevatedButton.icon(
                  onPressed: () => _compartilharComprovante(context),
                  icon: const Icon(Icons.share),
                  label: const Text('Compartilhar comprovante'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF325f2a),
                    foregroundColor: Colors.white,
                    padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                ),

                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Voltar',
                    style: TextStyle(
                      color: Color(0xFF325f2a),
                      fontSize: 16,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
