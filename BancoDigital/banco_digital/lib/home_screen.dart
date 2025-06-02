import 'dart:io';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'em_desenvolvimento.dart';
import 'area_de_transferencia.dart';
import 'pagar.dart';
import 'extrato_page.dart';
import 'cadastro_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _saldoVisivel = false;
  String? _userName;
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_userName == null) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is String && args.isNotEmpty) {
        _userName = args;
      } else {
        _userName = 'Usuário';
      }
    }
  }

  String _saudacao() {
    final hora = DateTime.now().hour;
    if (hora >= 5 && hora < 12) {
      return 'Bom dia';
    } else if (hora >= 12 && hora < 18) {
      return 'Boa tarde';
    } else {
      return 'Boa noite';
    }
  }

  void _onNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _pickImageSource() async {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Tirar foto'),
                onTap: () {
                  Navigator.pop(context);
                  _pickFromCamera();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Escolher da galeria'),
                onTap: () {
                  Navigator.pop(context);
                  _pickFromGallery();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickFromCamera() async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
      maxHeight: 600,
    );
    if (photo != null) {
      setState(() {
        _profileImage = File(photo.path);
      });
    }
  }

  Future<void> _pickFromGallery() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
      maxHeight: 600,
    );
    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

  void _navegarPara(String rota) {
    Navigator.pushNamed(context, rota);
  }

  @override
  Widget build(BuildContext context) {
    final nome = _userName ?? 'Usuário';
    final saudacao = _saudacao();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF325F2A),
        elevation: 0,
        toolbarHeight: 120,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: _pickImageSource,
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white70,
                backgroundImage: _profileImage != null
                    ? FileImage(_profileImage!)
                    : const AssetImage('assets/profile.jpg')
                as ImageProvider,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$saudacao, $nome',
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
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding:
        const EdgeInsets.fromLTRB(16, 16, 16, 16 + kBottomNavigationBarHeight),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ExtratoScreen()),
                );
              },
              child: SaldoCard(
                saldoVisivel: _saldoVisivel,
              ),
            ),

            const SizedBox(height: 16),
            const Divider(color: Colors.black, thickness: 0.7),
            const SizedBox(height: 16),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  FuncaoItem(
                    icon: Icons.sync_alt,
                    label: 'Transferir',
                    onTap: () => _navegarPara('/transferencia'),
                  ),
                  FuncaoItem(
                    icon: Icons.qr_code,
                    label: 'Pagar',
                    onTap: () => _navegarPara('/pagar'),
                  ),
                  FuncaoItem(
                    icon: Icons.attach_money,
                    label: 'Cotação',
                    onTap: () => _navegarPara('/cotacao'),
                  ),
                  FuncaoItem(
                    icon: Icons.account_balance_wallet,
                    label: 'Caixinha',
                    onTap: () => _navegarPara('/em-desenvolvimento'),
                  ),
                  FuncaoItem(
                    icon: Icons.trending_up,
                    label: 'Investir',
                    onTap: () => _navegarPara('/em-desenvolvimento'),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),

            const SizedBox(height: 16),
            const Divider(color: Colors.black, thickness: 0.7),
            const SizedBox(height: 16),

            // Cartão de crédito
            CartaoWidget(
              valorFatura: 800.00,
              limite: 0.00,
              progresso: 1.0,
            ),

            const SizedBox(height: 16),
            const Divider(color: Colors.black, thickness: 0.7),
            const SizedBox(height: 16),

            // Banner
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF325F2A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/banner_forest.png',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 120,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SalomonBottomBar(
          currentIndex: _selectedIndex,
          onTap: _onNavTap,
          items: [
            SalomonBottomBarItem(
              icon: const Icon(Icons.home_outlined),
              title: const Text("Início"),
              selectedColor: const Color(0xFF325F2A),
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.account_balance_wallet_outlined),
              title: const Text("Carteira"),
              selectedColor: const Color(0xFF325F2A),
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.credit_card),
              title: const Text("Cartão"),
              selectedColor: const Color(0xFF325F2A),
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.shopping_bag_outlined),
              title: const Text("Shop"),
              selectedColor: const Color(0xFF325F2A),
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.menu),
              title: const Text("Menu"),
              selectedColor: const Color(0xFF325F2A),
            ),
          ],
        ),
      ),
    );
  }
}

class SaldoCard extends StatelessWidget {
  final bool saldoVisivel;

  const SaldoCard({
    required this.saldoVisivel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      width: double.infinity,
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
                saldoVisivel ? 'R\$ 5.234,87' : 'R\$ ●●●●',
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
    );
  }
}

class CartaoWidget extends StatelessWidget {
  final double valorFatura;
  final double limite;
  final double progresso;

  const CartaoWidget({
    required this.valorFatura,
    required this.limite,
    required this.progresso,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Cartão de crédito',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          const Text(
            'Fatura atual',
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            'R\$ ${valorFatura.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progresso,
            backgroundColor: Colors.grey.shade300,
            color: const Color(0xFF4CAF50),
          ),
          const SizedBox(height: 4),
          Text(
            'Limite disponível de R\$ ${limite.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Text(
            '${(progresso * 100).toStringAsFixed(0)}% do limite utilizado',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class FuncaoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const FuncaoItem({
    required this.icon,
    required this.label,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(60),
        onTap: onTap,
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF4CAF50), Color(0xFF325F2A)],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 28, color: Colors.white),
            ),
            const SizedBox(height: 6),
            SizedBox(
              width: 70,
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
