import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/section_item.dart';

class Section extends ChangeNotifier {
  // Construtor com parâmetros opcionais
  Section({
    this.name = '', // Valor padrão para 'name'
    required this.type, // 'type' ainda é obrigatório
    List<SectionItem>? items, // 'items' é opcional
  }) : items = items ?? []; // Se 'items' não for fornecido, será uma lista vazia

  // Construtor fromDocument para o Firestore
  Section.fromDocument(DocumentSnapshot document)
      : name = (document.data() as Map<String, dynamic>?)?['name'] as String? ?? '',
        type = (document.data() as Map<String, dynamic>?)?['type'] as String? ?? '',
        items = ((document.data() as Map<String, dynamic>?)?['items'] as List<dynamic>?)
            ?.map((e) => SectionItem.fromMap(e as Map<String, dynamic>))
            .toList() ?? [];

  late final String name;
  final String type;
  List<SectionItem> items;

  Section clone() {
    return Section(
      name: name,
      type: type,
      items: items.map((e) => e.clone()).toList(),
    );
  }

  void removeItem(SectionItem item){
    items.remove(item);
    notifyListeners();
  }

  void addItem(SectionItem item) {
    items.add(item);
    notifyListeners(); // Notifica os listeners das mudanças
  }

  @override
  String toString() {
    return 'Section{name: $name, type: $type, items: $items}';
  }
}
