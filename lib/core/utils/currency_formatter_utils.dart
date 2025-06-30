import 'package:intl/intl.dart';

final currencyFormatter = NumberFormat.currency(
  locale: 'en_IN',
  symbol: '',
  decimalDigits: 2,
);

String formatCurrency(num? amount) {
  if (amount == null) return '0.00';
  return currencyFormatter.format(amount);
}
String formatGoldQuantity(num? grams) {
  if (grams == null) return '0.000 g';
  return '${grams.toStringAsFixed(3)} g';
}
