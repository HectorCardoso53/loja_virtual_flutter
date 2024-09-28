import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'address.dart';


enum StoreStatus{ closed, open, closing }

class Store {
  String name = '';
  String image = '';
  String phone = '';
  Address? address;
  Map<String, Map<String, TimeOfDay>> opening = {};
  StoreStatus? status;

  Store.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    name = data['name'] as String? ?? '';
    image = data['image'] as String? ?? '';
    phone = data['phone'] as String? ?? '';
    address = data['address'] != null
        ? Address.fromMap(data['address'] as Map<String, dynamic>)
        : null;

    opening = (data['opening'] as Map<String, dynamic>).map((key, value) {
      final timesString = value as String?;

      if (timesString != null && timesString.isNotEmpty) {
        final splitted = timesString.split(RegExp(r"[:-]"));
        return MapEntry(
          key,
          {
            "from": TimeOfDay(
              hour: int.parse(splitted[0]),
              minute: int.parse(splitted[1]),
            ),
            "to": TimeOfDay(
              hour: int.parse(splitted[2]),
              minute: int.parse(splitted[3]),
            ),
          },
        );
      } else {
        return MapEntry(key, {});
      }
    });
    updateStatus();
  }

  String get addresstext {
    if (address == null) return 'Endereço não disponível';
    return '${address!.street}, ${address!.number}, '
        '${address!.complement.isNotEmpty ? '-${address!.complement}' : ''} - '
        '${address!.district}, ${address!.city}/${address!.state}';
  }

  String openingText(BuildContext context) {
    return 'Seg-Sex: ${formattedPeriod(opening['monfri'], context)}\n'
        'Sab: ${formattedPeriod(opening['saturday'], context)}\n'
        'Dom: ${formattedPeriod(opening['sunday'], context)}';
  }

  String formattedPeriod(Map<String, TimeOfDay>? period, BuildContext context) {
    if (period == null || period['from'] == null || period['to'] == null) {
      return 'Fechada';
    }
    return '${period['from']!.format(context)} - ${period['to']!.format(context)}';
  }


  void updateStatus() {
    final weekDay = DateTime.now().weekday;

    Map<String, TimeOfDay>? period;

    // Seleciona o período de acordo com o dia da semana
    if (weekDay >= 1 && weekDay <= 5) {
      period = opening['monfri'];
    } else if (weekDay == 6) {
      period = opening['saturday'];
    } else {
      period = opening['sunday'];
    }

    if (period == null || period['from'] == null || period['to'] == null) {
      status = StoreStatus.closed; // Se não houver horários, a loja está fechada
      return;
    }

    final now = TimeOfDay.now();
    final closingTime = period['to']!;

    // Verifica se a loja está aberta
    if (now.hour > closingTime.hour ||
        (now.hour == closingTime.hour && now.minute > closingTime.minute)) {
      status = StoreStatus.closed; // Loja fechada
    } else if (now.hour == closingTime.hour &&
        now.minute >= closingTime.minute - 15) {
      // Perto de fechar (30 minutos antes)
      status = StoreStatus.closing;
    } else {
      status = StoreStatus.open; // Loja aberta
    }
  }

  String get statustext {
    switch(status){
      case StoreStatus.closed:
        return 'Fechada';
      case StoreStatus.open:
        return 'Aberta';
      case StoreStatus.closing:
        return ' Fechando';
      default:
        return '';
    }
  }

  String get cleanPhone => phone.replaceAll(RegExp(r"[^\d]"), "");

}
