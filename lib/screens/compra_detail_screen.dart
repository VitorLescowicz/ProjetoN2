// lib/screens/compra_detail_screen.dart

import 'package:flutter/material.dart';
import '../models/compra.dart';
import 'package:intl/intl.dart'; // Para formatação de data

class CompraDetailScreen extends StatelessWidget {
  final Compra compra;

  const CompraDetailScreen({Key? key, required this.compra}) : super(key: key);

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da Compra'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: const Text('Título'),
              subtitle: Text(compra.titulo),
            ),
            ListTile(
              title: const Text('Valor Total'),
              subtitle: Text('R\$ ${compra.valorTotal.toStringAsFixed(2)}'),
            ),
            ListTile(
              title: const Text('Categoria'),
              subtitle: Text(compra.categoria),
            ),
            ListTile(
              title: const Text('Status de Entrega'),
              subtitle: Text(compra.statusEntrega),
            ),
            ListTile(
              title: const Text('Data da Compra'),
              subtitle: Text(_formatDate(compra.dataCompra)),
            ),
            const SizedBox(height: 20),
            const Text(
              'Histórico de Status',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Expanded(
              child: compra.historicoStatus.isEmpty
                  ? const Center(child: Text('Nenhum histórico disponível.'))
                  : ListView.builder(
                      itemCount: compra.historicoStatus.length,
                      itemBuilder: (context, index) {
                        final historico = compra.historicoStatus[index];
                        return ListTile(
                          leading: const Icon(Icons.history),
                          title: Text(historico.status),
                          subtitle: Text(_formatDate(historico.data)),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
