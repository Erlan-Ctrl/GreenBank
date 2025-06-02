import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExtratoScreen extends StatefulWidget {
  const ExtratoScreen({Key? key}) : super(key: key);

  @override
  State<ExtratoScreen> createState() => _ExtratoScreenState();
}

class Transacao {
  final String titulo;
  final String descricao;
  final DateTime data;
  final double valor;
  final bool ehDespesa;

  Transacao({
    required this.titulo,
    required this.descricao,
    required this.data,
    required this.valor,
    required this.ehDespesa,
  });
}

class _ExtratoScreenState extends State<ExtratoScreen> {
  final List<Transacao> todasTransacoes = [
    Transacao(
      titulo: "Supermercado",
      descricao: "Compra no Mercado BomPreço",
      data: DateTime(2025, 5, 30),
      valor: 187.50,
      ehDespesa: true,
    ),
    Transacao(
      titulo: "Salário",
      descricao: "Empresa X S.A",
      data: DateTime(2025, 5, 28),
      valor: 5200.00,
      ehDespesa: false,
    ),
    Transacao(
      titulo: "Netflix",
      descricao: "Assinatura mensal",
      data: DateTime(2025, 5, 27),
      valor: 55.90,
      ehDespesa: true,
    ),
    Transacao(
      titulo: "Pix recebido",
      descricao: "Transferência do João",
      data: DateTime(2025, 5, 25),
      valor: 300.00,
      ehDespesa: false,
    ),
  ];

  DateTime? _inicio;
  DateTime? _fim;

  List<Transacao> get transacoesFiltradas {
    return todasTransacoes.where((tx) {
      if (_inicio != null && tx.data.isBefore(_inicio!)) return false;
      if (_fim != null && tx.data.isAfter(_fim!)) return false;
      return true;
    }).toList();
  }

  void _filtrarDatas() async {
    final intervalo = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
    );

    if (intervalo != null) {
      setState(() {
        _inicio = intervalo.start;
        _fim = intervalo.end;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8E9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF325F2A),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Extrato de Gastos",
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: _filtrarDatas,
          ),
        ],
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: transacoesFiltradas.length,
        itemBuilder: (context, index) {
          final tx = transacoesFiltradas[index];
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: Icon(
                tx.ehDespesa ? Icons.arrow_downward : Icons.arrow_upward,
                color: tx.ehDespesa ? Colors.red : Colors.green,
              ),
              title: Text(tx.titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("${tx.descricao}\n${DateFormat('dd/MM/yyyy').format(tx.data)}"),
              isThreeLine: true,
              trailing: Text(
                "R\$ ${tx.valor.toStringAsFixed(2)}",
                style: TextStyle(
                  color: tx.ehDespesa ? Colors.red : Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
