import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/common/custom_icon_button.dart';
import 'package:loja_virtual/common/empty_cart.dart';
import 'package:loja_virtual/models/admin_orders_manager.dart';
import 'package:loja_virtual/common/order_tile.dart';
import 'package:loja_virtual/models/order.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../common/custom_drawer/custom_drawer.dart';

class AdminOrdersScreen extends StatefulWidget {

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
   final PanelController panelController = PanelController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 4, 125, 141),
        title: Text(
          'Todos os Pedidos',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<AdminOrdersManager>(
        builder: (_, adminOrdersManager, __) {
          final filterOrders = adminOrdersManager.filteredOrders;

          return SlidingUpPanel(
            controller: panelController,
            body: Column(
              children: [
                if (adminOrdersManager.userFilter != null) ...[
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 2),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Pedidos de ${adminOrdersManager.userFilter!.name}',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        CustomIconButton(
                          iconData: Icons.close,
                          color: Colors.white,
                          onTap: () {
                            // Limpa o filtro de usuário
                            adminOrdersManager.setUserFilter(null);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
                if (filterOrders.isEmpty)
                  Expanded(
                    child: EmptyCart(
                      title: 'Nenhuma venda realizada!!',
                      iconData: Icons.border_clear,
                    ),
                  )
                else
                  Expanded(
                    // Adicionei Expanded para evitar erro de overflow
                    child: ListView.builder(
                      itemCount: filterOrders.length,
                      itemBuilder: (_, index) {
                        return OrderTile(
                          filterOrders.reversed.toList()[index],
                          showControls: true,
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 120,),
              ],
            ),
            minHeight: 40,
            maxHeight: 240,
            panel: Column(
              crossAxisAlignment:CrossAxisAlignment.stretch ,
              children: [
                GestureDetector(
                  onTap: (){
                    if(panelController.isPanelClosed){
                      panelController.open();
                    }else{
                      panelController.close();
                    }
                  },
                  child: Container(
                    height: 40,
                    color: Colors.white,
                    alignment: Alignment.center,
                    child: Text(
                      'Filtros',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: Status.values.map((s) {
                      return CheckboxListTile(
                        title: Text(Orders.getStatusText(s)),
                        dense: true,
                        activeColor: Theme.of(context).primaryColor,
                        value: adminOrdersManager.statusFilter.contains(s),
                        onChanged: (v) {
                          adminOrdersManager.setStatusFilter(
                            s, // Passando 's' como o status
                            v!, // Passando 'v' como o valor enabled (use '!' para garantir que não seja nulo)
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
