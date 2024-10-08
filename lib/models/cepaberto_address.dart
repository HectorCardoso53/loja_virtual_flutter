class CepAbertoAddress {
  final double altitude;
  final String cep;
  final double latitude;
  final double longitude;
  final String logradouro;
  final String bairro;
  final Cidade cidade;
  final Estado estado;

  CepAbertoAddress.fromMap(Map<String, dynamic> map)
      : altitude = (map['altitude'] is String)
      ? double.tryParse(map['altitude']) ?? 0.0
      : (map['altitude'] as double? ?? 0.0),
        cep = map['cep'] as String? ?? '',
        latitude = (map['latitude'] is String)
            ? double.tryParse(map['latitude']) ?? 0.0
            : (map['latitude'] as double? ?? 0.0),
        longitude = (map['longitude'] is String)
            ? double.tryParse(map['longitude']) ?? 0.0
            : (map['longitude'] as double? ?? 0.0),
        logradouro = map['logradouro'] as String? ?? '',
        bairro = map['bairro'] as String? ?? '',
        cidade = Cidade.fromMap(map['cidade'] as Map<String, dynamic>? ?? {}),
        estado = Estado.fromMap(map['estado'] as Map<String, dynamic>? ?? {});

  @override
  String toString() {
    return 'CepAbertoAddress{altitude: $altitude, cep: $cep, latitude: $latitude, longitude: $longitude, logradouro: $logradouro, bairro: $bairro, cidade: $cidade, estado: $estado}';
  }
}

class Cidade {
  final String ddd;
  final String ibge;
  final String nome;

  Cidade.fromMap(Map<String, dynamic> map)
      : ddd = map['ddd'] != null ? map['ddd'].toString() : '',
        ibge = map['ibge'] != null ? map['ibge'].toString() : '',
        nome = map['nome'] != null ? map['nome'].toString() : '';

  @override
  String toString() {
    return 'Cidade{ddd: $ddd, ibge: $ibge, nome: $nome}';
  }
}

class Estado {
  final String sigla;

  Estado.fromMap(Map<String, dynamic> map)
      : sigla = map['sigla'] as String? ?? '';

  @override
  String toString() {
    return 'Estado{sigla: $sigla}';
  }
}
