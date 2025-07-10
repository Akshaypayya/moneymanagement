import 'package:growk_v2/views.dart';
import 'package:intl/intl.dart';

String getTransactionDescription(TransactionApiModel transactionData) {
  return transactionData.transactionDescription;
}

getTransactionFormattedDate(TransactionApiModel transactionData) {
  String dateStr = transactionData.transactionDate;
  DateTime utcTime = DateTime.parse(dateStr);
  DateTime localTime = utcTime.toLocal();
  String formatted = DateFormat('dd MMM yyyy - hh:mm:ss a').format(localTime);
  return formatted;
}

String getTransactionIconAsset(TransactionApiModel transactionData) {
  final subGroup = transactionData.accountSubGroup.toLowerCase();
  final paymentMode = transactionData.paymentMode.toLowerCase();
  final transactionCode = transactionData.transactionCode.toLowerCase();

  // if (transactionData.isCredit && transactionData.currencyCode == 'XAU') {
  if (transactionData.currencyCode == 'XAU') {
    return 'assets/goldbsct.png';
  }

  if (subGroup.contains('education') || subGroup.contains('study')) {
    return 'assets/education.png';
  } else if (subGroup.contains('home') || subGroup.contains('house')) {
    return 'assets/home.png';
  } else if (subGroup.contains('wedding') || subGroup.contains('marriage')) {
    return 'assets/wedding.png';
  } else if (subGroup.contains('trip') || subGroup.contains('travel')) {
    return 'assets/trip.png';
  } else if (paymentMode.contains('upi')) {
    return 'assets/bhim.png';
  } else if (paymentMode.contains('bank') ||
      paymentMode.contains('netbanking')) {
    return 'assets/bank.jpg';
  } else if (paymentMode.contains('gold') || transactionCode.contains('gold')) {
    return 'assets/goldbsct.png';
  } else {
    return 'assets/customgoals.png';
  }
}

// IconData getTransactionIconData(TransactionApiModel transactionData) {
//   if (transactionData.currencyCode == 'XAU') {
//     return Icons.stars;
//   }
//   switch (transactionData.paymentMode.toLowerCase()) {
//     case 'bank transfer':
//       return Icons.account_balance_wallet;
//     case 'bank':
//     case 'netbanking':
//       return Icons.account_balance;
//     case 'gold':
//       return Icons.stars;
//     default:
//       return Icons.payment;
//   }
// }
Widget getTransactionIconData(TransactionApiModel transactionData) {
  if (transactionData.currencyCode == 'XAU') {
    return Icon(Icons.stars, size: 24, color: Colors.grey);
  }
  switch (transactionData.paymentMode.toLowerCase()) {
    case 'bank transfer':
      return Icon(Icons.account_balance_wallet, size: 24, color: Colors.grey);
    case 'bank':
    case 'netbanking':
      return Icon(Icons.account_balance, size: 24, color: Colors.grey);
    case 'gold':
      return Icon(Icons.stars, size: 24, color: Colors.grey);
    default:
      return Image.asset(
        'assets/customgoals.png',
        width: 24,
        height: 24,
        errorBuilder: (context, error, stackTrace) {
          return Icon(Icons.help_outline, size: 24, color: Colors.grey);
        },
      );
  }
}

String getTransactionCategory(TransactionApiModel transactionData) {
  if (transactionData.currencyCode == 'XAU') {
    return 'Gold';
  }
  if (transactionData.accountSubGroup.isNotEmpty) {
    return transactionData.accountSubGroup
        .split(' ')
        .map((word) => word.isNotEmpty
            ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
            : word)
        .join(' ');
  }

  return transactionData.paymentMode.toUpperCase();
}

Widget buildTransactionIcon(TransactionApiModel transactionData) {
  String iconAsset = getTransactionIconAsset(transactionData);

  return Image.asset(
    iconAsset,
    errorBuilder: (context, error, stackTrace) {
      // return Icon(
      //   getTransactionIconData(transactionData),
      //   size: 24,
      //   color: Colors.grey,
      // );
      return getTransactionIconData(transactionData);
    },
  );
}
