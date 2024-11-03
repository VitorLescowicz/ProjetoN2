// lib/screens/auth_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'compra_list_screen.dart';

enum AuthMode { Login, Signup }

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  AuthMode _authMode = AuthMode.Login;

  String _email = '';
  String _password = '';

  bool _isLoading = false;

  void _switchAuthMode() {
    setState(() {
      _authMode = _authMode == AuthMode.Login ? AuthMode.Signup : AuthMode.Login;
    });
  }

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
      if (_authMode == AuthMode.Login) {
        await authProvider.signIn(_email, _password);
      } else {
        await authProvider.signUp(_email, _password);
      }
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const CompraListScreen()),
      );
    } catch (e) {
      // Trate erros de autenticação aqui
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildAuthForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          // Campo de Email
          TextFormField(
            decoration: const InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty || !value.contains('@')) {
                return 'Por favor, insira um email válido.';
              }
              return null;
            },
            onSaved: (value) {
              _email = value!.trim();
            },
          ),
          const SizedBox(height: 16),
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
              _password = value!.trim();
            },
          ),
          const SizedBox(height: 16),
          // Campo de Confirmar Senha (apenas no cadastro)
          if (_authMode == AuthMode.Signup)
            TextFormField(
              decoration: const InputDecoration(labelText: 'Confirmar Senha'),
              obscureText: true,
              validator: _authMode == AuthMode.Signup
                  ? (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, confirme sua senha.';
                      }
                      if (value.trim() != _password) {
                        return 'As senhas não correspondem.';
                      }
                      return null;
                    }
                  : null,
            ),
          const SizedBox(height: 20),
          // Botão de Submissão
          _isLoading
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 40.0),
                    textStyle: const TextStyle(fontSize: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: Text(_authMode == AuthMode.Login ? 'Entrar' : 'Cadastrar'),
                ),
          const SizedBox(height: 10),
          // Botão para Alternar Modo
          TextButton(
            onPressed: _switchAuthMode,
            child: Text(
              _authMode == AuthMode.Login
                  ? 'Não tem uma conta? Cadastre-se'
                  : 'Já tem uma conta? Entre',
              style: const TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Remove a AppBar para um design mais limpo
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Nome do app
              const Text(
                'Registro de Compras Online',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 8.0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildAuthForm(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
