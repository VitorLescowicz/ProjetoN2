// lib/screens/estatisticas_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/compra_provider.dart';
import 'package:fl_chart/fl_chart.dart';

class EstatisticasScreen extends StatelessWidget {
  const EstatisticasScreen({Key? key}) : super(key: key);

  Color _getCategoryColor(String categoria) {
    switch (categoria.toLowerCase()) {
      case 'eletrônicos':
        return Colors.blue;
      case 'alimentos':
        return Colors.green;
      case 'vestuário':
        return Colors.orange;
      case 'casa':
        return Colors.purple;
      case 'saúde':
        return Colors.red;
      case 'educação':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  List<PieChartSectionData> _buildPieChartSections(Map<String, double> totalPorCategoria) {
    final total = totalPorCategoria.values.fold(0.0, (a, b) => a + b);
    return totalPorCategoria.entries.map((entry) {
      final double percentage = (entry.value / total) * 100;
      return PieChartSectionData(
        color: _getCategoryColor(entry.key),
        value: entry.value,
        title: '${entry.key}\n${percentage.toStringAsFixed(1)}%',
        radius: 100,
        titleStyle: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final compraProvider = Provider.of<CompraProvider>(context);
    final totalPorCategoria = compraProvider.getTotalGastoPorCategoria();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Estatísticas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: totalPorCategoria.isEmpty
            ? const Center(child: Text('Nenhuma compra para exibir estatísticas.'))
            : Column(
                children: [
                  const Text(
                    'Total Gasto por Categoria',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: PieChart(
                      PieChartData(
                        sections: _buildPieChartSections(totalPorCategoria),
                        centerSpaceRadius: 40,
                        sectionsSpace: 2,
                        borderData: FlBorderData(show: false),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
