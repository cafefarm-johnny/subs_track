import 'package:intl/intl.dart';
import 'package:subs_track/models/subscription/subscription_model.dart';

class CurrencyUtils {
  static final _instance = CurrencyUtils._internal();

  CurrencyUtils._internal();

  factory CurrencyUtils() => _instance;

  static String formatCurrency(int amount, Currency currency) {
    final formatter = NumberFormat.currency(
      locale: currency.isKRW ? 'ko_KR' : 'en_US',
      symbol: currency.isKRW ? '' : '\$',
      decimalDigits: 0,
    );

    return formatter.format(amount);
  }
}
