class ItemSize {
  String name;
  num price;
  int stock;

  bool get hasStock => stock > 0;

  ItemSize({this.name = '', this.price = 0, this.stock = 0});

  ItemSize clone(){
    return ItemSize(
      name: name,
      price: price,
      stock: stock
    );
  }

  Map<String,dynamic> toMap(){
    return {
      'name':name,
      'price': price,
      'stock': stock,
    };
  }

  // Método para criar o objeto a partir de um Map
  ItemSize.fromMap(Map<String, dynamic> map)
      : name = map['name'] ?? '', // Define valores padrão caso estejam ausentes
        price = map['price'] ?? 0,
        stock = map['stock'] ?? 0;

  @override
  String toString() {
    return 'ItemSize{name: $name, price: $price, stock: $stock}';
  }

}


