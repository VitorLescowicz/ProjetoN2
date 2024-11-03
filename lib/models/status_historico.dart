// lib/models/status_historico.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class StatusHistorico {
  String status;
  DateTime data;

  StatusHistorico({
    required this.status,
    required this.data,
  });

  factory StatusHistorico.fromMap(Map<String, dynamic> map) {
    return StatusHistorico(
      status: map['status'] ?? '',
      data: (map['data'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'data': data,
    };
  }
}
