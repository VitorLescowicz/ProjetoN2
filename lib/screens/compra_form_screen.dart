// lib/screens/compra_form_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/compra_provider.dart';
import '../providers/auth_provider.dart';
import '../models/compra.dart';
import '../models/status_historico.dart';
import 'package:intl/intl.dart'; // Para formatação de data

class CompraFormScreen extends StatefulWidget {
  static const routeName = '/compra-form';

  final Compra? compra;

  const CompraFormScreen({Key? key, this.compra}) : super(key: key);

  @override
  State<CompraFormScreen> createState() => _CompraFormScreenState();
}

class _CompraFormScreenState extends State<CompraFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String _titulo = '';
  double _valorTotal = 0.0;
  DateTime _dataCompra = DateTime.now();
  String _statusEntrega = 'Pendente';
  String _categoria = 'Outros';

  final List<String> _categorias = [
    'Eletrônicos',
    'Alimentos',
    'Vestuário',
    'Casa',
    'Saúde',
    'Educação',
    'Outros',
  ];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.compra != null) {
      _titulo = widget.compra!.titulo;
      _valorTotal = widget.compra!.valorTotal;
      _dataCompra = widget.compra!.dataCompra;
      _statusEntrega = widget.compra!.statusEntrega;
      _categoria = widget.compra!.categoria;
    }
  }

  Future<void> _saveCompra() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final compraProvider = Provider.of<CompraProvider>(context, listen: false);

    setState(() {
      _isLoading = true;
    });

    try {
      if (widget.compra == null) {
        // Adicionar nova compra
        Compra novaCompra = Compra(
          titulo: _titulo,
          valorTotal: _valorTotal,
          dataCompra: _dataCompra,
          statusEntrega: _statusEntrega,
          categoria: _categoria,
          historicoStatus: [
            StatusHistorico(status: _statusEntrega, data: _dataCompra)
          ],
          userId: authProvider.user!.uid,
        );
        await compraProvider.addCompra(novaCompra);
      } else {
        // Atualizar compra existente
        Compra compraAtualizada = Compra(
          id: widget.compra!.id,
          titulo: _titulo,
          valorTotal: _valorTotal,
          dataCompra: _dataCompra,
          statusEntrega: _statusEntrega,
          categoria: _categoria,
          historicoStatus: widget.compra!.historicoStatus,
          userId: widget.compra!.userId,
        );
        // Atualizar histórico se o status mudou
        if (_statusEntrega != widget.compra!.statusEntrega) {
          compraAtualizada.historicoStatus.add(
            StatusHistorico(status: _statusEntrega, data: DateTime.now()),
          );
        }
        await compraProvider.updateCompra(compraAtualizada);
      }

      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.compra == null ? 'Compra adicionada com sucesso!' : 'Compra atualizada com sucesso!')),
      );
    } catch (e) {
      // Trate erros ao salvar a compra
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar compra: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dataCompra,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _dataCompra) {
      setState(() {
        _dataCompra = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.compra != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Compra' : 'Adicionar Compra'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Campo Título
                TextFormField(
                  initialValue: _titulo,
                  decoration: const InputDecoration(labelText: 'Título da Compra'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o título da compra.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _titulo = value!;
                  },
                ),
                const SizedBox(height: 16),
                // Campo Valor Total
                TextFormField(
                  initialValue:
                      _valorTotal != 0.0 ? _valorTotal.toStringAsFixed(2) : '',
                  decoration: const InputDecoration(labelText: 'Valor Total (R\$)'),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o valor total.';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Por favor, insira um valor válido.';
                    }
                    if (double.parse(value) <= 0) {
                      return 'O valor deve ser maior que zero.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _valorTotal = double.parse(value!);
                  },
                ),
                const SizedBox(height: 16),
                // Campo Data da Compra
                InkWell(
                  onTap: _pickDate,
                  child: InputDecorator(
                    decoration:
                        const InputDecoration(labelText: 'Data da Compra'),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(DateFormat('dd/MM/yyyy').format(_dataCompra)),
                        const Icon(Icons.calendar_today),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Campo Status de Entrega
                DropdownButtonFormField<String>(
                  value: _statusEntrega,
                  decoration:
                      const InputDecoration(labelText: 'Status de Entrega'),
                  items: <String>[
                    'Pendente',
                    'Em Transporte',
                    'Entregue',
                    'Cancelada'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _statusEntrega = newValue!;
                    });
                  },
                  onSaved: (value) {
                    _statusEntrega = value!;
                  },
                ),
                const SizedBox(height: 16),
                // Campo Categoria
                DropdownButtonFormField<String>(
                  value: _categoria,
                  decoration: const InputDecoration(labelText: 'Categoria'),
                  items: _categorias.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _categoria = newValue!;
                    });
                  },
                  onSaved: (value) {
                    _categoria = value!;
                  },
                ),
                const SizedBox(height: 32),
                // Botão Salvar
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _saveCompra,
                        style: ElevatedButton.styleFrom(
                          padding:
                              const EdgeInsets.symmetric(vertical: 16.0, horizontal: 40.0),
                          textStyle: const TextStyle(fontSize: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        child: Text(isEditing ? 'Atualizar' : 'Adicionar'),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
