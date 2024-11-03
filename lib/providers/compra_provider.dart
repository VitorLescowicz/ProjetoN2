// lib/providers/compra_provider.dart

import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../models/compra.dart';

class CompraProvider extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  List<Compra> _compras = [];

  List<Compra> get compras => _compras;

  // Método para obter compras do usuário
  Future<void> getComprasByUser(String userId) async {
    _compras = await _firebaseService.getComprasByUser(userId);
    notifyListeners();
  }

  // Método para adicionar uma nova compra
  Future<void> addCompra(Compra compra) async {
    try {
      String docId = await _firebaseService.addCompra(compra);
      compra.id = docId; // Atualiza o ID da compra com o ID gerado pelo Firestore
      _compras.add(compra);
      notifyListeners();
    } catch (e) {
      // Trate o erro conforme necessário
      print('Erro ao adicionar compra no provider: $e');
      rethrow;
    }
  }

  // Método para deletar uma compra
  Future<void> deleteCompra(String compraId) async {
    try {
      await _firebaseService.deleteCompra(compraId);
      _compras.removeWhere((compra) => compra.id == compraId);
      notifyListeners();
    } catch (e) {
      print('Erro ao deletar compra no provider: $e');
      rethrow;
    }
  }

  // Método para atualizar uma compra
  Future<void> updateCompra(Compra compra) async {
    try {
      await _firebaseService.updateCompra(compra);
      int index = _compras.indexWhere((c) => c.id == compra.id);
      if (index != -1) {
        _compras[index] = compra;
        notifyListeners();
      }
    } catch (e) {
      print('Erro ao atualizar compra no provider: $e');
      rethrow;
    }
  }

  // Método para obter o total gasto mensal
  double getTotalGastoMensal(int month, int year) {
    double total = 0.0;
    for (var compra in _compras) {
      if (compra.dataCompra.month == month && compra.dataCompra.year == year) {
        total += compra.valorTotal;
      }
    }
    return total;
  }

  // Método para obter o total gasto por categoria
  Map<String, double> getTotalGastoPorCategoria() {
    Map<String, double> totalPorCategoria = {};
    for (var compra in _compras) {
      if (totalPorCategoria.containsKey(compra.categoria)) {
        totalPorCategoria[compra.categoria] =
            totalPorCategoria[compra.categoria]! + compra.valorTotal;
      } else {
        totalPorCategoria[compra.categoria] = compra.valorTotal;
      }
    }
    return totalPorCategoria;
  }
}
