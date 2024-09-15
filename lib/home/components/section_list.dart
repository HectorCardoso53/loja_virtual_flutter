import 'package:flutter/material.dart';
import 'package:loja_virtual/home/components/item_tile.dart';
import 'package:loja_virtual/home/components/section_header.dart';
import 'package:loja_virtual/models/home_manager.dart';
import 'package:loja_virtual/models/section.dart';
import 'package:provider/provider.dart';

import 'add_tile_widget.dart';

class SectionList extends StatelessWidget {
  const SectionList(this.section);

  final Section section;

  @override
  Widget build(BuildContext context) {
    final homeManager = context.watch<HomeManager>();

    return ChangeNotifierProvider.value(
      value: section, // Agora 'section' é gerenciado pelo ChangeNotifierProvider
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(), // Cabeçalho da seção
            SizedBox(
              height: 150, // Altura da lista de itens
              child: Consumer<Section>( // Ouvinte de mudanças na Section
                builder: (_, section, __) {
                  return ListView.separated(
                    scrollDirection: Axis.horizontal, // Lista horizontal
                    itemBuilder: (_, index) {
                      if (index < section.items.length) {
                        return ItemTile(section.items[index]); // Exibe o item
                      } else {
                        return AddTileWidget(); // Botão de adicionar
                      }
                    },
                    separatorBuilder: (_, __) => const SizedBox(
                      width: 4, // Espaçamento entre os itens
                    ),
                    itemCount: homeManager.editing
                        ? section.items.length + 1
                        : section.items.length, // Adiciona o botão "Adicionar" se estiver editando
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
