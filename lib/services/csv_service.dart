// lib/services/csv_service.dart

import 'package:csv/csv.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/compra.dart';
import 'package:intl/intl.dart'; // Para formatação de data

class CsvService {
  Future<String> generateCsv(List<Compra> compras) async {
    List<List<String>> rows = [
      // Cabeçalho
      ['ID', 'Título', 'Valor Total (R\$)', 'Data da Compra', 'Status da Entrega', 'Categoria']
    ];

    // Dados
    for (var compra in compras) {
      List<String> row = [
        compra.id,
        compra.titulo,
        compra.valorTotal.toStringAsFixed(2),
        DateFormat('dd/MM/yyyy').format(compra.dataCompra),
        compra.statusEntrega,
        compra.categoria,
      ];
      rows.add(row);
    }

    String csv = const ListToCsvConverter().convert(rows);

    // Salvar o arquivo no dispositivo
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/compras_${DateTime.now().millisecondsSinceEpoch}.csv';
    final file = File(path);
    await file.writeAsString(csv);

    return path;
  }
}
