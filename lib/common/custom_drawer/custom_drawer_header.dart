import 'package:flutter/material.dart';
import 'package:loja_virtual/models/page_manager.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:provider/provider.dart';

class CustomDrawerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(32, 24, 16, 8),
      height: 180,
      child: Consumer<UserManager>(
        builder: (context, userManager, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'Loja da \nHL Digital',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Olá, ${userManager.user?.name ?? ''}',
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
             GestureDetector(
               onTap:(){
                 if(userManager.isLoggedIn){
                   context.read<PageManager>().setPage(0);
                   userManager.signOut();
                 }else{
                   Navigator.of(context).pushNamed('/login');
                 }
               },
               child: Text(
                   userManager.isLoggedIn
                       ? 'Sair' : 'Entre ou Cadastre-se >',
                 style: TextStyle(
                   color: Theme.of(context).primaryColor,
                   fontSize: 16,
                   fontWeight: FontWeight.bold,
                 ),
               ),
             ),
            ],
          );
        },
      ),
    );
  }
}
