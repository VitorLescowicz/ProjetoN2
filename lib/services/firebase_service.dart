// lib/services/firebase_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/compra.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Método para obter compras por usuário
  Future<List<Compra>> getComprasByUser(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('compras')
          .where('userId', isEqualTo: userId)
          .orderBy('dataCompra', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => Compra.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print('Erro ao obter compras: $e');
      return [];
    }
  }

  // Método para adicionar uma nova compra
  Future<String> addCompra(Compra compra) async {
    try {
      DocumentReference docRef = await _firestore.collection('compras').add(compra.toMap());
      return docRef.id;
    } catch (e) {
      print('Erro ao adicionar compra: $e');
      rethrow; // Repassa o erro para ser tratado no provider
    }
  }

  // Método para deletar uma compra
  Future<void> deleteCompra(String compraId) async {
    try {
      await _firestore.collection('compras').doc(compraId).delete();
    } catch (e) {
      print('Erro ao deletar compra: $e');
      rethrow;
    }
  }

  // Método para atualizar uma compra
  Future<void> updateCompra(Compra compra) async {
    try {
      await _firestore.collection('compras').doc(compra.id).update(compra.toMap());
    } catch (e) {
      print('Erro ao atualizar compra: $e');
      rethrow;
    }
  }
}
