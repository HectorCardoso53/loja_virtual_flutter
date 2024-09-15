import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:loja_virtual/common/custom_drawer/custom_drawer.dart';
import 'package:loja_virtual/home/components/section_header.dart';
import 'package:loja_virtual/models/home_manager.dart';
import '../../models/section.dart';
import 'item_tile.dart';
import 'add_tile_widget.dart'; // Adicionei o AddTileWidget
import 'package:provider/provider.dart';

class SectionStaggered extends StatelessWidget {
  const SectionStaggered(this.section);

  final Section section;

  @override
  Widget build(BuildContext context) {
    final homeManager = context.watch<HomeManager>();

    return ChangeNotifierProvider.value(
      value: section,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(),
            // StaggeredGrid.count substitui o countBuild
            Consumer<Section>(
              builder: (_,section,__){
                return StaggeredGrid.count(
                  crossAxisCount: 4, // Quantidade de colunas na grid
                  mainAxisSpacing: 4.0, // Espaçamento entre os itens
                  crossAxisSpacing: 4.0,
                  children: List.generate(
                    homeManager.editing
                        ? section.items.length + 1 // Adiciona um item extra se estiver editando
                        : section.items.length,
                        (index) {
                      if (index < section.items.length) {
                        return StaggeredGridTile.count(
                          crossAxisCellCount: 2, // Número de colunas ocupadas pelo item
                          mainAxisCellCount: index.isEven ? 2 : 1, // Alterna o tamanho do item
                          child: ItemTile(section.items[index]),
                        );
                      } else {
                        // Mostra o botão "Adicionar" se for o último item e estiver em modo de edição
                        return StaggeredGridTile.count(
                          crossAxisCellCount: 2,
                          mainAxisCellCount: 1,
                          child: AddTileWidget(),
                        );
                      }
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
