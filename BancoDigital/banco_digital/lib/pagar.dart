import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'pagamento_concluido_page.dart';

class Pagar extends StatefulWidget {
  const Pagar({Key? key}) : super(key: key);

  @override
  State<Pagar> createState() => _PagarState();
}

class _PagarState extends State<Pagar> with TickerProviderStateMixin {
  String _scanResult = '';
  bool _scanCompleted = false;
  bool _showScanEffect = false;
  bool _isProcessing = false;
  bool _usingTestQR = false;

  late AnimationController _pulseController;
  late AnimationController _loadingController;

  final List<Map<String, String>> _recentes = [
    {'nome': 'Loja A', 'icone': 'assets/recent1.svg'},
    {'nome': 'Loja B', 'icone': 'assets/recent2.svg'},
    {'nome': 'Loja C', 'icone': 'assets/recent3.svg'},
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
      lowerBound: 0.9,
      upperBound: 1.1,
    )..repeat(reverse: true);

    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _loadingController.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_scanCompleted || capture.barcodes.isEmpty) return;

    final barcode = capture.barcodes.first;
    final value = barcode.rawValue;

    if (value != null && value.isNotEmpty) {
      setState(() {
        _scanResult = value;
        _scanCompleted = true;
        _showScanEffect = true;
      });

      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _showScanEffect = false;
        });
      });

      Navigator.pop(context);
    }
  }

  Future<void> _abrirScanner() async {
    setState(() {
      _scanCompleted = false;
      _scanResult = '';
      _usingTestQR = false;
    });

    try {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(
              backgroundColor: const Color(0xFF325f2a),
              iconTheme: const IconThemeData(color: Colors.white),
              title: const Text(
                'Escanear QR Code',
                style: TextStyle(color: Colors.white),
              ),
            ),
            body: MobileScanner(
              controller: MobileScannerController(
                detectionSpeed: DetectionSpeed.normal,
                facing: CameraFacing.back,
                torchEnabled: true,
              ),
              onDetect: _onDetect,
            ),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao acessar câmera'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _usarQRCodeTeste() {
    setState(() {
      _scanResult = 'QR_TESTE:{"valor":"R\$ 150,00","destino":"Supermercado XYZ"}';
      _scanCompleted = true;
      _usingTestQR = true;
    });
  }

  void _simularPagamento() async {
    setState(() {
      _isProcessing = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isProcessing = false;
    });

    String valor = "R\$ 0,00";
    String destino = "Desconhecido";

    if (_usingTestQR) {
      final regex = RegExp(r'"valor"\s*:\s*"([^"]+)"');
      final matchValor = regex.firstMatch(_scanResult);
      final destRegex = RegExp(r'"destino"\s*:\s*"([^"]+)"');
      final matchDestino = destRegex.firstMatch(_scanResult);
      if (matchValor != null) valor = matchValor.group(1)!;
      if (matchDestino != null) destino = matchDestino.group(1)!;
    } else {
      valor = "R\$ 50,00";
      destino = _scanResult.length > 10 ? _scanResult.substring(0, 10) : _scanResult;
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => PagamentoConcluidoPage(
          valor: valor,
          destino: destino,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? Colors.grey[900] : const Color(0xFFF1F8E9);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFF325f2a),
        elevation: 0,
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
          'Área de Pagamento',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isLarge = constraints.maxWidth > 600;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isLarge ? 64 : 24,
              vertical: 0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Ilustração SVG (opcional)
                if (!isLarge)
                  SvgPicture.asset(
                    'assets/illustration_payment.svg',
                    height: 150,
                  ),
                if (isLarge)
                  SvgPicture.asset(
                    'assets/illustration_payment.svg',
                    height: 200,
                  ),

                const SizedBox(height: 12),
                const Text(
                  'Escaneie o código para realizar o pagamento',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF325f2a),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),

                Card(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: ListTile(
                    leading: Icon(
                      Icons.info_outline,
                      color: isDark ? Colors.white70 : const Color(0xFF325f2a),
                    ),
                    title: Text(
                      'Dica:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF325f2a),
                      ),
                    ),
                    subtitle: Text(
                      'Aproxime o código da câmera em um ambiente bem iluminado.',
                      style: TextStyle(
                        color: isDark ? Colors.white60 : Colors.black87,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: isLarge ? 400 : double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[850] : Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.15),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _showScanEffect
                          ? ScaleTransition(
                        scale: _pulseController,
                        child: Image.asset(
                          'assets/qrcode-icon.png',
                          width: isLarge ? 200 : 140,
                          height: isLarge ? 200 : 140,
                        ),
                      )
                          : Image.asset(
                        'assets/qrcode-icon.png',
                        width: isLarge ? 200 : 140,
                        height: isLarge ? 200 : 140,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _abrirScanner,
                        icon: const Icon(Icons.camera_alt_rounded),
                        label: const Text('Escanear QR Code'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF325f2a),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 28, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: _usarQRCodeTeste,
                        child: const Text(
                          'Usar QR de teste',
                          style: TextStyle(
                            fontSize: 14,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                if (_recentes.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pagamentos recentes',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : const Color(0xFF325f2a),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _recentes.length,
                          itemBuilder: (context, index) {
                            final item = _recentes[index];
                            return Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Column(
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? Colors.grey[800]
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: SvgPicture.asset(
                                      item['icone']!,
                                      color: isDark
                                          ? Colors.white70
                                          : Colors.green[700],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    item['nome']!,
                                    style: TextStyle(
                                      color: isDark
                                          ? Colors.white70
                                          : Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),

                if (_scanResult.isNotEmpty)
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Text(
                            'QR Code Lido:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xFF325f2a),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _scanResult,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 20),
                          _isProcessing
                              ? Column(
                            children: [
                              const Text(
                                'Processando...',
                                style: TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 12),
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.green),
                              ),
                            ],
                          )
                              : ElevatedButton.icon(
                            onPressed: _simularPagamento,
                            icon: const Icon(Icons.payment_rounded),
                            label: const Text('Confirmar Pagamento'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                              const Color(0xFF388E3C),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}
