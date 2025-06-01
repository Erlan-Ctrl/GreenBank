import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class Pagar extends StatefulWidget {
  const Pagar({Key? key}) : super(key: key);

  @override
  State<Pagar> createState() => _PagarState();
}

class _PagarState extends State<Pagar> with TickerProviderStateMixin {
  String _scanResult = '';
  bool _scanCompleted = false;
  bool _showScanEffect = false;

  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
      lowerBound: 0.8,
      upperBound: 1.2,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
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
    });

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFF325f2a),
            title: const Text('Escanear QR Code'),
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
  }

  void _simularPagamento() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.symmetric(horizontal: 40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 64),
              SizedBox(height: 16),
              Text(
                'Pagamento realizado com sucesso!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4CAF50),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop();
      setState(() {
        _scanResult = '';
        _scanCompleted = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8E9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF325f2a),
        elevation: 0,
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: const Text(
          'Área de pagamento',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.white, // Texto branco
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_showScanEffect)
                ScaleTransition(
                  scale: _pulseController,
                  child: const Icon(Icons.qr_code_scanner, size: 100, color: Colors.green),
                )
              else
                Image.asset(
                  'assets/qrcode-icon.png',
                  width: 160,
                  height: 160,
                ),

              const SizedBox(height: 40),

              ElevatedButton(
                onPressed: _abrirScanner,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF325f2a),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                ),
                child: const Text(
                  'Escanear QR Code / Código de Barras',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),
              ),

              const SizedBox(height: 50),

              if (_scanResult.isNotEmpty)
                ElevatedButton(
                  onPressed: _simularPagamento,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF325f2a),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: const Text(
                    'Pagar',
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
