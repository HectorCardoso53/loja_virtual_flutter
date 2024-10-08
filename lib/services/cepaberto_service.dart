import 'dart:io';
import 'package:dio/dio.dart';
import 'package:loja_virtual/models/cepaberto_address.dart';

const token = '16b960f5b976f515ed015efc6a5967b6';

class CepAbertoService {
  Future<CepAbertoAddress> getAddressFromCep(String cep) async {
    final cleanCep = cep.replaceAll('.', '').replaceAll('-', '');
    final endpoint = "https://www.cepaberto.com/api/v3/cep?cep=$cleanCep";

    final Dio dio = Dio();
    dio.options.headers[HttpHeaders.authorizationHeader] = 'Token token=$token';

    try {
      final response = await dio.get<Map<String, dynamic>?>(endpoint);
      if (response.data == null || response.data!.isEmpty) {
        return Future.error('CEP Inválido');
      }

      final CepAbertoAddress address = CepAbertoAddress.fromMap(response.data!);
      return address;

    } on DioException {
      return Future.error('Erro ao buscar CEP');
    }
  }
}
