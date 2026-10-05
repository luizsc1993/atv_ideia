import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/ideias_provider.dart';

class NovaIdeiaPage extends StatefulWidget {
  const NovaIdeiaPage({super.key});

  @override
  State<NovaIdeiaPage> createState() => _NovaIdeiaPageState();
}

class _NovaIdeiaPageState extends State<NovaIdeiaPage> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _autorController = TextEditingController();

  bool _salvando = false;

  @override
  void dispose() {
    _tituloController.dispose();
    _descricaoController.dispose();
    _autorController.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _salvando = true);

    try {
      await context.read<IdeiasProvider>().cadastrarIdeia(
        titulo: _tituloController.text.trim(),
        descricao: _descricaoController.text.trim(),
        autor: _autorController.text.trim(),
      );

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _salvando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar ideia'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(
                  labelText: 'Título',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Digite o título';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descricaoController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Digite a descrição';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _autorController,
                decoration: const InputDecoration(
                  labelText: 'Nome do autor',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Digite o nome do autor';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _salvando ? null : _salvar,
                  icon: _salvando
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.save),
                  label: Text(
                    _salvando ? 'Salvando...' : 'Salvar ideia',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
