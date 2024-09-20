import 'package:flutter/material.dart';
import 'package:loja_virtual/common/custom_drawer/custom_drawer.dart';
import 'package:loja_virtual/models/home_manager.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:provider/provider.dart';

import 'components/add_section_widget.dart';
import 'components/section_list.dart';
import 'components/section_staggered.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 211, 118, 130),
                  Color.fromARGB(255, 253, 181, 168),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          CustomScrollView(
            slivers: [
              SliverAppBar(
                snap: true,
                floating: true,
                elevation: 0,
                backgroundColor: Colors.transparent,
                flexibleSpace: const FlexibleSpaceBar(
                  title: Text(
                    'HL Digital',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                  centerTitle: true,
                ),
                actions: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pushNamed('/cart'),
                    icon: Icon(Icons.shopping_cart),
                    color: Colors.white,
                  ),
                  Consumer2<UserManager, HomeManager>(
                    builder: (_, userManager, homeManager, __) {
                      if (userManager.adminEnabled && !homeManager.loading) {
                        if (homeManager.editing) {
                          return PopupMenuButton(
                            onSelected: (e) {
                              if (e == 'Salvar') {
                                homeManager.saveEditing();
                              } else {
                                homeManager.discartEditing();
                              }
                            },
                            itemBuilder: (_) {
                              return ['Salvar', 'Descartar'].map((e) {
                                return PopupMenuItem(
                                  value: e,
                                  child: Text(e),
                                );
                              }).toList();
                            },
                          );
                        } else {
                          return IconButton(
                            onPressed: homeManager.enterEditing,
                            icon: Icon(Icons.edit),
                          );
                        }
                      } else {
                        return Container();
                      }
                    },
                  ),
                ],
              ),
              Consumer<HomeManager>(builder: (_, homeManager, __) {
                if (homeManager.loading) {
                  print(
                      'Carregando...'); // Para verificar se o estado de loading é chamado
                  return SliverToBoxAdapter(
                    child: LinearProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                      backgroundColor: Colors.transparent,
                    ),
                  );
                }

                // Renderiza as seções
                final List<Widget> children =
                    homeManager.sections.map<Widget>((section) {
                  switch (section.type) {
                    case 'List':
                      return SectionList(section);
                    case 'Staggered':
                      return SectionStaggered(section);
                    default:
                      return Container();
                  }
                }).toList();

                if (homeManager.editing)
                  children.add(AddSectionWidget(homeManager));

                return SliverList(
                  delegate: SliverChildListDelegate(children),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }
}
