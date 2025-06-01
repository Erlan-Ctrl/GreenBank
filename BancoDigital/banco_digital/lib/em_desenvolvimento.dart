import 'package:flutter/material.dart';

class EmDesenvolvimentoScreen extends StatelessWidget {
  const EmDesenvolvimentoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8E9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF325F2A),
        title: const Text("Em Desenvolvimento", style: TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Image(image: AssetImage("assets/work_in_progress.png"), height: 300),
            SizedBox(height: 20),
            Text(
              "Em Desenvolvimento",
              style: TextStyle(
                fontFamily: 'Montaser Arabic',
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
