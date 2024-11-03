// lib/widgets/compra_item.dart

import 'package:flutter/material.dart';
import '../models/compra.dart';
import '../screens/compra_form_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/compra_provider.dart';

class CompraItem extends StatelessWidget {
  final Compra compra;

  const CompraItem({Key? key, required this.compra}) : super(key: key);

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  // Função para retornar o ícone e cor da categoria
  IconData _getCategoryIcon(String categoria) {
    switch (categoria.toLowerCase()) {
      case 'eletrônicos':
        return Icons.devices;
      case 'alimentos':
        return Icons.fastfood;
      case 'vestuário':
        return Icons.shopping_bag;
      case 'casa':
        return Icons.home;
      case 'saúde':
        return Icons.local_hospital;
      default:
        return Icons.category;
    }
  }

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
      default:
        return Colors.grey;
    }
  }

  Future<void> _confirmarDelecao(BuildContext context, String compraId) async {
    final compraProvider = Provider.of<CompraProvider>(context, listen: false);
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar Deleção'),
        content: const Text('Você tem certeza que deseja deletar esta compra?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Deletar'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await compraProvider.deleteCompra(compraId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Compra deletada com sucesso.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CompraFormScreen(compra: compra),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        elevation: 3,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
          leading: Icon(
            _getCategoryIcon(compra.categoria),
            color: _getCategoryColor(compra.categoria),
            size: 30,
          ),
          title: Text(
            compra.titulo,
            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                compra.categoria,
                style: TextStyle(
                  fontSize: 14.0,
                  color: _getCategoryColor(compra.categoria),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              // Data da Compra
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(compra.dataCompra),
                    style: const TextStyle(fontSize: 14.0, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              // Valor Total
              Row(
                children: [
                  const Icon(Icons.attach_money, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    'R\$ ${compra.valorTotal.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 14.0, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CompraFormScreen(compra: compra),
                    ),
                  );
                },
                tooltip: 'Editar',
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _confirmarDelecao(context, compra.id),
                tooltip: 'Excluir',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
