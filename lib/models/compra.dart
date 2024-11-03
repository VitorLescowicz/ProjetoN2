// lib/models/compra.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'status_historico.dart';

class Compra {
  String id;
  String titulo;
  double valorTotal;
  String categoria;
  String statusEntrega;
  DateTime dataCompra;
  List<StatusHistorico> historicoStatus;
  String userId;

  Compra({
    this.id = '',
    required this.titulo,
    required this.valorTotal,
    required this.categoria,
    required this.statusEntrega,
    required this.dataCompra,
    required this.historicoStatus,
    required this.userId,
  });

  // Método para converter de Map para Compra
  factory Compra.fromMap(Map<String, dynamic> map, String documentId) {
    return Compra(
      id: documentId,
      titulo: map['titulo'] ?? '',
      valorTotal: (map['valorTotal'] ?? 0).toDouble(),
      categoria: map['categoria'] ?? 'Outros',
      statusEntrega: map['statusEntrega'] ?? 'Pendente',
      dataCompra: (map['dataCompra'] as Timestamp).toDate(),
      historicoStatus: (map['historicoStatus'] as List<dynamic>? ?? [])
          .map((item) => StatusHistorico.fromMap(item as Map<String, dynamic>))
          .toList(),
      userId: map['userId'] ?? '',
    );
  }

  // Método para converter de Compra para Map
  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'valorTotal': valorTotal,
      'categoria': categoria,
      'statusEntrega': statusEntrega,
      'dataCompra': dataCompra,
      'historicoStatus': historicoStatus.map((status) => status.toMap()).toList(),
      'userId': userId,
    };
  }
}
