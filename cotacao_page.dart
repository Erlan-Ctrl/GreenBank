import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CotacaoPage extends StatefulWidget {
  const CotacaoPage({Key? key}) : super(key: key);

  @override
  State<CotacaoPage> createState() => _CotacaoPageState();
}

class _CotacaoPageState extends State<CotacaoPage> {
  String _status = 'Carregando cotações...';
  double? dolar;
  double? euro;

  @override
  void initState() {
    super.initState();
    fetchCotacoes();
  }

  Future<void> fetchCotacoes() async {
    final url = Uri.parse('https://api.exchangerate.host/latest?base=BRL&symbols=USD,EUR');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          dolar = (data['rates']['USD'] as num).toDouble();
          euro = (data['rates']['EUR'] as num).toDouble();
          _status = 'Cotações carregadas com sucesso!';
        });
      } else {
        setState(() {
          _status = 'Erro ao carregar cotações';
        });
      }
    } catch (e) {
      setState(() {
        _status = 'Erro na requisição: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cotação'),
        backgroundColor: const Color(0xFF2E7D32),
      ),
      body: Center(
        child: dolar == null || euro == null
            ? Text(
                _status,
                style: TextStyle(fontSize: 18, color: Colors.green[900]),
                textAlign: TextAlign.center,
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '1 BRL = ${dolar!.toStringAsFixed(4)} USD',
                    style: TextStyle(fontSize: 20, color: Colors.green[900]),
                  ),
                  SizedBox(height: 12),
                  Text(
                    '1 BRL = ${euro!.toStringAsFixed(4)} EUR',
                    style: TextStyle(fontSize: 20, color: Colors.green[900]),
                  ),
                ],
              ),
      ),
    );
  }
}
