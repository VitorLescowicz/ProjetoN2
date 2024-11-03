// lib/screens/signup_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'compra_list_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  String _email = '';
  String _password = '';
  //String _confirmPassword = '';

  bool _isLoading = false;

  Future<void> _submit() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (!_formKey.currentState!.validate()) {
      // Formulário inválido
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await authProvider.signUp(_email, _password);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const CompraListScreen()),
      );
    } catch (e) {
      // Trate erros de autenticação aqui
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao cadastrar: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _navigateToLogin() {
    Navigator.of(context).pop(); // Volta para a tela anterior (auth_screen.dart)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro'),
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  // Campo de Email
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          !value.contains('@')) {
                        return 'Por favor, insira um email válido.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _email = value!;
                    },
                  ),
                  // Campo de Senha
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Senha'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.length < 6) {
                        return 'A senha deve ter pelo menos 6 caracteres.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _password = value!;
                    },
                  ),
                  // Campo de Confirmar Senha
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Confirmar Senha'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, confirme sua senha.';
                      }
                      if (value != _password) {
                        return 'As senhas não correspondem.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      
                    },
                  ),
                  const SizedBox(height: 20),
                  // Botão de Submissão
                  _isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                            padding:
                                const EdgeInsets.symmetric(vertical: 16.0),
                            textStyle: const TextStyle(fontSize: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          child: const Text('Cadastrar'),
                        ),
                  // Botão para Voltar ao Login
                  TextButton(
                    onPressed: _navigateToLogin,
                    child: const Text(
                      'Já tem uma conta? Entre',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
