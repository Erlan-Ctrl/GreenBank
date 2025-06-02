// lib/home_screen.dart

import 'package:flutter/material.dart';
import 'em_desenvolvimento.dart';
import 'area_de_tranferencia.dart';
import 'pagar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _saldoVisivel = false;
  String? _userName;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_userName == null) {
      final args = ModalRoute.of(context)!.settings.arguments;
      if (args is String && args.isNotEmpty) {
        _userName = args;
      } else {
        _userName = 'Usuário';
      }
    }
  }

  void _onNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _navegarParaEmDesenvolvimento() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EmDesenvolvimentoScreen(),
      ),
    );
  }

  void _navegarParaTransferencia() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TransferenciaScreen(),
      ),
    );
  }

  void _navegarParaPagamento() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const Pagar(),
      ),
    );
  }

  Widget _buildFunctionItem(IconData icon, String label) {
    return GestureDetector(
      onTap: () {
      if (label == 'Transferir') {
        _navegarParaTransferencia();
      } else if (label == 'Pagar') {
        _navegarParaPagamento();
      } else if (label == 'Cotação') {
        Navigator.pushNamed(context, '/cotacao');
      } else {
        _navegarParaEmDesenvolvimento();
      }
    },
      child: SizedBox(
        width: 70,
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 28, color: Color(0xFF325F2A)),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayName = _userName ?? 'Usuário';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF325F2A),
        elevation: 0,
        toolbarHeight: 120,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white70,
              backgroundImage: AssetImage('assets/profile.jpg'),
            ),
            const SizedBox(height: 8),
            Text(
              'Olá, $displayName',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _saldoVisivel ? Icons.visibility : Icons.visibility_off,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _saldoVisivel = !_saldoVisivel;
              });
            },
          ),
          const IconButton(
            icon: Icon(Icons.help_outline, color: Colors.white),
            onPressed: null,
          ),
          const IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: null,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16 + kBottomNavigationBarHeight),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cartão "Saldo em conta"
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Saldo em conta',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _saldoVisivel ? 'R\$ 5.234,87' : 'R\$ ●●●●',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: Divider(color: Colors.black, thickness: 0.7),
            ),
            const SizedBox(height: 16),

            // Barra horizontal de funcionalidades
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  _buildFunctionItem(Icons.sync_alt, 'Transferir'),
                  _buildFunctionItem(Icons.qr_code, 'Pagar'),
                  _buildFunctionItem(Icons.attach_money, 'Cotação'),
                  _buildFunctionItem(Icons.account_balance_wallet, 'Caixinha'),
                  _buildFunctionItem(Icons.trending_up, 'Investir'),
                  const SizedBox(width: 8),
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: Divider(color: Colors.black, thickness: 0.7),
            ),
            const SizedBox(height: 16),

            // Cartão "Cartão de crédito"
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Cartão de crédito',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500)),
                      SizedBox(height: 8),
                      Text('Fatura atual', style: TextStyle(fontSize: 14)),
                      SizedBox(height: 4),
                      Text('R\$ 800,00',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('Limite disponível de R\$ 0,00',
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: Divider(color: Colors.black, thickness: 0.7),
            ),
            const SizedBox(height: 16),

            // Banner inferior
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF325F2A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset('assets/banner_forest.png', fit: BoxFit.cover),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavTap,
        selectedItemColor: const Color(0xFF325F2A),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_outlined), label: 'Carteira'),
          BottomNavigationBarItem(icon: Icon(Icons.credit_card), label: 'Cartão'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: 'Shop'),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Menu'),
        ],
      ),
    );
  }
}
