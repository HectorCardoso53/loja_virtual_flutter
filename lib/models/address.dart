class Address {
  String street;
  String number;
  String complement;
  String district;
  String zipCode;
  String city;
  String state;
  double lat;
  double long;

  // Construtor com valores padrão
  Address({
    this.street = '',
    this.number = '',
    this.complement = '',
    this.district = '',
    this.zipCode = '',
    this.city = '',
    this.state = '',
    this.lat = 0.0,
    this.long = 0.0,
  });

  // Construtor que inicializa os campos a partir de um Map e trata valores nulos
  Address.fromMap(Map<String, dynamic> map)
      : street = map['street'] ?? '',
        number = map['number'] ?? '',
        complement = map['complement'] ?? '',
        district = map['district'] ?? '',
        zipCode = map['zipcode'] ?? '',
        city = map['city'] ?? '',
        state = map['state'] ?? '',
        lat = (map['lat'] ?? 0.0).toDouble(),
        long = (map['long'] ?? 0.0).toDouble();

  // Converte o endereço para um mapa
  Map<String, dynamic> toMap() {
    return {
      'street': street,
      'number': number,
      'complement': complement,
      'district': district,
      'zipcode': zipCode,
      'city': city,
      'state': state,
      'lat': lat,
      'long': long,
    };
  }

  @override
  String toString() {
    return 'Address{street: $street, number: $number, complement: $complement, district: $district, zipCode: $zipCode, city: $city, state: $state, lat: $lat, long: $long}';
  }
}
