import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class CotacaoPage extends StatefulWidget {
  const CotacaoPage({Key? key}) : super(key: key);

  @override
  State<CotacaoPage> createState() => _CotacaoPageState();
}

class _CotacaoPageState extends State<CotacaoPage> {
  double? dolar;
  double? euro;
  List<FlSpot> dolarHistorico = [];
  List<String> datas = [];
  String _status = 'Carregando cotações...';
  final TextEditingController _controller = TextEditingController(text: '1.00');
  double brlValue = 1.00;

  @override
  void initState() {
    super.initState();
    fetchCotacoes();
  }

  Future<void> fetchCotacoes() async {
    try {
      final response = await http.get(Uri.parse('https://api.frankfurter.app/latest?from=BRL&to=USD,EUR'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          dolar = (data['rates']['USD'] as num).toDouble();
          euro = (data['rates']['EUR'] as num).toDouble();
          _status = 'Cotações carregadas com sucesso!';
        });
        fetchHistorico();
      } else {
        setState(() {
          _status = 'Erro ao carregar cotações.';
        });
      }
    } catch (e) {
      setState(() {
        _status = 'Erro: $e';
      });
    }
  }

  Future<void> fetchHistorico() async {
    try {
      final historicoResponse = await http.get(Uri.parse('https://api.frankfurter.app/2024-05-25..2024-06-01?from=BRL&to=USD'));
      if (historicoResponse.statusCode == 200) {
        final data = json.decode(historicoResponse.body);
        final rates = data['rates'] as Map<String, dynamic>;
        int index = 0;
        dolarHistorico = [];
        datas = [];
        final sortedKeys = rates.keys.toList()..sort();
        for (var date in sortedKeys) {
          final rateMap = rates[date];
          if (rateMap is Map<String, dynamic> && rateMap['USD'] != null) {
            final valor = rateMap['USD'];
            if (valor is num) {
              dolarHistorico.add(FlSpot(index.toDouble(), valor.toDouble()));
              datas.add(date);
              index++;
            }
          }
        }
        setState(() {});
      }
    } catch (e) {
      print('Erro ao buscar histórico: $e');
    }
  }

  Widget buildCurrencyCard({
    required String label,
    required IconData icon,
    required double? rate,
    required double brlValue,
    required Color color,
  }) {
    return AnimatedOpacity(
      opacity: rate == null ? 0.5 : 1.0,
      duration: const Duration(milliseconds: 500),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 6,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, color: color, size: 36),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(
                    rate == null
                        ? '---'
                        : '${(brlValue * rate).toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 20, color: color),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildGraph() {
    return dolarHistorico.isEmpty
        ? const Center(child: Text("Gráfico indisponível"))
        : SizedBox(
      height: 240,
      child: LineChart(
        LineChartData(
          lineTouchData: LineTouchData(
            enabled: true,
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: Colors.green[900]!,
              tooltipRoundedRadius: 8,
              getTooltipItems: (List<LineBarSpot> touchedSpots) {
                return touchedSpots.map((spot) {
                  return LineTooltipItem(
                    'R\$ ${spot.y.toStringAsFixed(2)}',
                    const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }).toList();
              },
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            getDrawingHorizontalLine: (value) => FlLine(
              color: Colors.grey.shade300,
              strokeWidth: 0.8,
            ),
            getDrawingVerticalLine: (value) => FlLine(
              color: Colors.grey.shade300,
              strokeWidth: 0.8,
            ),
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 0.1,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toStringAsFixed(2),
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 12,
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  int index = value.toInt();
                  if (index >= 0 && index < datas.length) {
                    final date = DateFormat('dd/MM').format(
                      DateTime.parse(datas[index]),
                    );
                    return Text(
                      date,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 10,
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: dolarHistorico.length.toDouble() - 1,
          lineBarsData: [
            LineChartBarData(
              spots: dolarHistorico,
              isCurved: true,
              color: Colors.green[700],
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) =>
                    FlDotCirclePainter(
                      radius: 3,
                      color: Colors.green[800]!,
                      strokeWidth: 1,
                      strokeColor: Colors.white,
                    ),
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.green.withOpacity(0.25),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF325f2a),
        centerTitle: true,
        title: const Text(
          'Cotação',
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Valor em BRL',
                prefixIcon: const Icon(Icons.attach_money),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (value) {
                final parsed = double.tryParse(value.replaceAll(',', '.'));
                if (parsed != null) {
                  setState(() {
                    brlValue = parsed;
                  });
                }
              },
            ),
            const SizedBox(height: 20),
            buildCurrencyCard(
              label: 'Dólar (USD)',
              icon: Icons.attach_money,
              rate: dolar,
              brlValue: brlValue,
              color: Colors.green[800]!,
            ),
            buildCurrencyCard(
              label: 'Euro (EUR)',
              icon: Icons.euro,
              rate: euro,
              brlValue: brlValue,
              color: Colors.blue[800]!,
            ),
            const SizedBox(height: 20),
            const Text(
              'Histórico do Dólar (últimos dias)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(child: buildGraph()),
          ],
        ),
      ),
    );
  }
}
