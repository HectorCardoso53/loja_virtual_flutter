import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/section_item.dart';
import 'package:uuid/uuid.dart';

class Section extends ChangeNotifier {
  String id;
  String name;
  String type;
  List<SectionItem> items;
  List<SectionItem> originalItem;
  String _error;

  Section({
    this.id = '',
    this.name = '',
    required this.type,
    List<SectionItem>? items,
  })  : items = items ?? [],
        originalItem = List.from(items ?? []),
        _error = '';

  Section.fromDocument(DocumentSnapshot document)
      : id = document.id,
        name = (document.data() as Map<String, dynamic>?)?['name'] as String? ?? '',
        type = (document.data() as Map<String, dynamic>?)?['type'] as String? ?? '',
        items = ((document.data() as Map<String, dynamic>?)?['items'] as List<dynamic>?)
            ?.map((e) => SectionItem.fromMap(e as Map<String, dynamic>))
            .toList() ?? [],
        originalItem = ((document.data() as Map<String, dynamic>?)?['items'] as List<dynamic>?)
            ?.map((e) => SectionItem.fromMap(e as Map<String, dynamic>))
            .toList() ?? [],
        _error = '';

  final FirebaseStorage storage = FirebaseStorage.instance;

  Reference get storageRef => storage.ref().child('home').child(id);

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  DocumentReference get firestoreRef {
    return id.isNotEmpty ? firestore.doc('home/$id') : firestore.doc('home/placeholder');
  }

  String get error => _error;

  set error(String value) {
    _error = value;
    notifyListeners();
  }

  Section clone() {
    return Section(
      id: id,
      name: name,
      type: type,
      items: items.map((e) => e.clone()).toList(),
    );
  }

  Future<void> save() async {
    final Map<String, dynamic> data = {
      'name': name,
      'type': type,
    };

    try {
      if (id.isEmpty) {
        final doc = await firestore.collection('home').add(data);
        id = doc.id;
        print('Novo documento criado com ID: $id');
      } else {
        await firestoreRef.update(data);
        print('Documento atualizado com sucesso.');
      }
    } catch (e) {
      print('Erro ao atualizar a seção: $e');
      rethrow;
    }

    // Inicialize a lista para armazenar URLs das imagens atualizadas
    final List<String> updateImages = [];

    for (final item in items) {
      if (item.image is File) {
        final File file = item.image as File;

        if (await file.exists()) {
          try {
            final UploadTask task = storageRef.child(Uuid().v1()).putFile(file);
            final TaskSnapshot snapshot = await task;
            final String url = await snapshot.ref.getDownloadURL();
            item.image = url; // Atualiza a imagem com a URL
          } catch (e) {
            print('Erro ao fazer upload da imagem: $e');
            error = 'Erro ao fazer upload da imagem';
          }
        } else {
          print('Arquivo não encontrado: ${item.image.path}');
        }
      } else if (item.image is String) {
        // Se já for uma URL, não precisa fazer nada
        updateImages.add(item.image);
      } else {
        print('item.image não é um arquivo válido: ${item.image}');
      }
    }

    // Deletar as imagens que foram removidas
    for (final original in originalItem) {
      if (!items.contains(original)) {
        try {
          final ref = storage.refFromURL(original.image); // Certifique-se de que `original` tem um campo `image`
          await ref.delete();
          print('Imagem ${original.image} deletada com sucesso.');
        } catch (e) {
          print('Falha ao deletar ${original.image}: $e');
        }
      }
    }

    // Atualizar a lista de itens no Firestore
    final Map<String, dynamic> itemData = {
      'items': items.map((e) => e.toMap()).toList()
    };

    await firestoreRef.update(itemData);
  }

  bool valid() {
    if (name.isEmpty) {
      error = 'Título inválido';
      return false;
    } else if (items.isEmpty) {
      error = 'Insira pelo menos uma imagem';
      return false;
    } else {
      error = '';
      return true;
    }
  }

  void removeItem(SectionItem item) {
    items.remove(item);
    notifyListeners();
  }

  void addItem(SectionItem item) {
    items.add(item);
    notifyListeners();
  }

  @override
  String toString() {
    return 'Section{name: $name, type: $type, items: $items}';
  }
}
