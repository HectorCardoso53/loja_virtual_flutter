import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';
import 'item_size.dart';

class Product extends ChangeNotifier {
  String id;
  String name;
  String description;
  List<String> images;
  List<ItemSize> sizes;

  bool deleted;

  List<dynamic> newImages = [];
  ItemSize? _selectedSize;
  ItemSize? get selectedSize => _selectedSize;

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  set selectedSize(ItemSize? value) {
    _selectedSize = value;
    notifyListeners();
  }

  int get totalStock {
    int stock = 0;
    for (final size in sizes) {
      stock += size.stock;
    }
    return stock;
  }

  bool get hasStock => totalStock > 0 && !deleted;

  num get basePrice {
    num lowest = double.infinity;
    for (final size in sizes) {
      if (size.price < lowest ) {
        lowest = size.price;
      }
    }
    return lowest;
  }

  void delete(){
    firestoreRef.update({'deleted': true});
  }

  ItemSize? findSize(String name) {
    try {
      return sizes.firstWhere((s) => s.name == name);
    } catch (e) {
      return null;
    }
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  DocumentReference get firestoreRef => firestore.doc('products/$id');
  Reference get storageRef => storage.ref().child('products').child(id);

  List<Map<String, dynamic>> exportSizeList() {
    return sizes.map((size) => size.toMap()).toList();
  }

  Future<void> save() async {
    loading = true;
    final Map<String, dynamic> data = {
      'name': name,
      'description': description,
      'sizes': exportSizeList(),
      'images': images,
      'deleted': deleted,
    };

    try {
      if (id.isEmpty) {
        final doc = await firestore.collection('products').add(data);
        id = doc.id;
        print('Novo documento criado com ID: $id');
      } else {
        await firestoreRef.update(data);
        print('Documento atualizado com sucesso.');
      }
    } catch (e) {
      print('Erro ao atualizar o produto: $e');
      rethrow;
    }

    final List<String> updateImages = [];

    // Upload das novas imagens
    for (final newImage in newImages) {
      if (images.contains(newImage)) {
        updateImages.add(newImage as String); // Imagem já existente
      } else if (newImage is File) {
        // Upload do arquivo
        try {
          final UploadTask task = storageRef.child(Uuid().v1()).putFile(newImage);
          final TaskSnapshot snapshot = await task;
          final String url = await snapshot.ref.getDownloadURL();
          updateImages.add(url); // Adiciona a nova URL
        } catch (e) {
          print('Erro ao fazer upload da imagem: $e');
        }
      } else {
        print('newImage não é um arquivo válido: $newImage');
      }
    }

    // Deletar as imagens que foram removidas
    for (final image in images) {
      if (!newImages.contains(image)) {
        // Verifica se a URL pertence ao Firebase Storage
        if (_isFirebaseStorageUrl(image)) {
          try {
            final ref = storage.refFromURL(image);
            await ref.delete();
            print('Imagem $image deletada com sucesso.');
          } catch (e) {
            print('Falha ao deletar $image: $e');
          }
        } else {
          print('URL não é do Firebase Storage: $image');
        }
      }
    }

    // Atualizar a lista de imagens no Firestore
    await firestoreRef.update({'images': updateImages});
    images = updateImages;

    loading = false;
  }

  // Verifica se a URL pertence ao Firebase Storage
  bool _isFirebaseStorageUrl(String url) {
    return url.startsWith('https://firebasestorage.googleapis.com/');
  }

  Product clone() {
    return Product(
      id: id,
      name: name,
      description: description,
      images: List.from(images),
      sizes: sizes.map((size) => size.clone()).toList(),
      deleted: deleted
    );
  }

  Product({
    this.id = '',
    this.name = '',
    this.description = '',
    this.deleted = false,
    List<String>? images,
    List<ItemSize>? sizes,
    List<dynamic>? newImages,
  })  : images = images ?? [],
        sizes = sizes ?? [],
        newImages = newImages ?? [];

  Product.fromDocument(DocumentSnapshot documentSnapshot)
      : id = documentSnapshot.id,
        name = '',
        description = '',
        deleted = false,
        images = [],
        sizes = [] {
    final data = documentSnapshot.data() as Map<String, dynamic>?;

    if (data != null) {
      name = data['name'] as String? ?? '';
      description = data['description'] as String? ?? '';
      deleted = (data['deleted'] ?? false ) as bool;
      images = List<String>.from(data['images'] as List<dynamic>? ?? []);

      if (data['sizes'] is List) {
        sizes = (data['sizes'] as List<dynamic>)
            .map((s) => ItemSize.fromMap(s as Map<String, dynamic>))
            .toList();
      } else {
        sizes = [];
      }

      print('Produto: $name, Sizes: $sizes');
    } else {
      print('Documento do produto sem dados.');
    }
  }

  @override
  String toString() {
    return 'Product{id: $id, name: $name, description: $description, images: $images, sizes: $sizes, newImages: $newImages}';
  }
}
