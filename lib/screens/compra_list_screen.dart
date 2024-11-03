// lib/screens/compra_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/compra_provider.dart';
import '../providers/auth_provider.dart';
import 'compra_form_screen.dart';
import 'estatisticas_screen.dart';
import 'auth_screen.dart';
import '../widgets/compra_item.dart';

class CompraListScreen extends StatefulWidget {
  const CompraListScreen({Key? key}) : super(key: key);

  @override
  State<CompraListScreen> createState() => _CompraListScreenState();
}

class _CompraListScreenState extends State<CompraListScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchCompras();
  }

  Future<void> _fetchCompras() async {
    setState(() {
      _isLoading = true;
    });
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final compraProvider = Provider.of<CompraProvider>(context, listen: false);
    await compraProvider.getComprasByUser(authProvider.user!.uid);
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _logout() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const AuthScreen()),
    );
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
    final compraProvider = Provider.of<CompraProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Compras'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const EstatisticasScreen()),
              );
            },
            tooltip: 'Ver Estatísticas',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Sair',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : compraProvider.compras.isEmpty
              ? const Center(child: Text('Nenhuma compra registrada.'))
              : RefreshIndicator(
                  onRefresh: _fetchCompras,
                  child: ListView.builder(
                    itemCount: compraProvider.compras.length,
                    itemBuilder: (context, index) {
                      final compra = compraProvider.compras[index];
                      return CompraItem(compra: compra);
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const CompraFormScreen(),
            ),
          );
        },
        tooltip: 'Adicionar Compra',
        child: const Icon(Icons.add),
      ),
    );
  }
}
