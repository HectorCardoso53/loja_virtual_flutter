class SectionItem {
  dynamic image;
  String? product; // `product` agora é opcional (pode ser nulo)

  SectionItem clone() {
    return SectionItem(
      image: image,
      product: product,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'image': image is String ? image : null, // Se for String, inclua. Caso contrário, use null.
      'product': product,
    };
  }

  // Construtor para inicializar a classe, com `product` opcional
  SectionItem({required this.image, this.product});

  // Método de fábrica para criar um SectionItem a partir de um Map
  factory SectionItem.fromMap(Map<String, dynamic> map) {
    return SectionItem(
      image: map['image'] != null ? map['image'] as String : '',
      product: map['product'] != null ? map['product'] as String? : null,
    );
  }

  @override
  String toString() {
    return 'SectionItem{image: $image, product: $product}';
  }
}
