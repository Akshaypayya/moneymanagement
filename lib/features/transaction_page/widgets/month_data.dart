import 'package:growk_v2/core/constants/common_providers.dart';
import 'package:growk_v2/views.dart';

String getTransactionMonthName(int month, WidgetRef ref) {
  final texts = ref.watch(appTextsProvider);
  final months = [
    texts.monthJanuary,
    texts.monthFebruary,
    texts.monthMarch,
    texts.monthApril,
    texts.monthMay,
    texts.monthJune,
    texts.monthJuly,
    texts.monthAugust,
    texts.monthSeptember,
    texts.monthOctober,
    texts.monthNovember,
    texts.monthDecember
  ];
  if (month >= 1 && month <= 12) {
    return months[month - 1];
  }
  return texts.unknown;
}
