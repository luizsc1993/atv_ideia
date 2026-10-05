import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/ideias_provider.dart';
import 'nova_ideia_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> _abrirCadastro(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const NovaIdeiaPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('⚔️ Batalha de Ideias'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _abrirCadastro(context),
        icon: const Icon(Icons.add),
        label: const Text('Nova ideia'),
      ),
      body: Consumer<IdeiasProvider>(
        builder: (context, provider, _) {
          if (provider.erro != null) {
            return Center(
              child: Text('Erro: ${provider.erro}'),
            );
          }

          if (!provider.temIdeias) {
            return const Center(
              child: Text('Nenhuma ideia cadastrada ainda.'),
            );
          }

          final melhor = provider.ideiaMaisVotada!;

          return Column(
            children: [
              Card(
                margin: const EdgeInsets.all(16),
                child: ListTile(
                  leading: const Text(
                    '🏆',
                    style: TextStyle(fontSize: 30),
                  ),
                  title: const Text(
                    'IDEIA MAIS VOTADA',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(melhor.titulo),
                  trailing: Text(
                    '${melhor.votos} votos',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                  itemCount: provider.ideias.length,
                  itemBuilder: (context, index) {
                    final ideia = provider.ideias[index];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ideia.titulo,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 6),
                            Text(ideia.descricao),
                            const SizedBox(height: 10),
                            Text('Autor: ${ideia.autor}'),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Text(
                                  '❤️ ${ideia.votos} votos',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Spacer(),
                                OutlinedButton.icon(
                                  onPressed: () async {
                                    await provider.votar(ideia.id);
                                  },
                                  icon: const Icon(Icons.thumb_up),
                                  label: const Text('VOTAR'),
                                ),
                                IconButton(
                                  tooltip: 'Excluir',
                                  color: Colors.red,
                                  onPressed: () => _confirmarExclusao(
                                    context,
                                    ideia.id,
                                  ),
                                  icon: const Icon(Icons.delete),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _confirmarExclusao(
    BuildContext context,
    String id,
  ) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Excluir ideia?'),
          content: const Text(
            'Esta ideia será removida para todos os usuários.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (confirmar == true && context.mounted) {
      await context.read<IdeiasProvider>().excluir(id);
    }
  }
}
