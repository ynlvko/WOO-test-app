import 'package:flutter/foundation.dart';

class Market {
  final String base;
  final String quote;
  final MarketType type;
  final double lastPrice;
  final double volume;

  String get symbol {
    return type == MarketType.spot ? '$base/$quote' : '$base-PERP';
  }

  Market.fromJson(Map<String, dynamic> json)
      : base = json['base'],
        quote = json['quote'],
        type = MarketType.values
            .firstWhere((e) => describeEnum(e).toUpperCase() == json['type']),
        lastPrice = json['lastPrice'].toDouble(),
        volume = json['volume'].toDouble();
}

enum MarketType {
  spot,
  futures,
}
