import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growk_v2/core/constants/app_url.dart';
import 'package:growk_v2/core/network/network_service.dart';
import 'package:growk_v2/core/storage/shared_preference/shared_preference_service.dart';
import 'package:growk_v2/features/goals/goal_detail_page/model/goal_transaction_model.dart';
import 'package:flutter/foundation.dart';

class GoalTransactionRepository {
  final NetworkService _networkService;
  final Ref ref;

  GoalTransactionRepository(this._networkService, this.ref);

  Future<GoalTransactionModel> getGoalTransactions({
    required String goalName,
    int iDisplayStart = 0,
    int iDisplayLength = 10,
  }) async {
    try {
      final token = SharedPreferencesHelper.getString("access_token");
      if (token == null || token.isEmpty) {
        debugPrint('GOAL TRANSACTION ERROR: Authentication token is missing');
        return GoalTransactionModel(
          status: 'failed',
          data: null,
        );
      }

      final endpoint = AppUrl.goalTransactionByNameUrl(
          goalName, iDisplayStart.toString(), iDisplayLength.toString());

      debugPrint('GOAL TRANSACTION REQUEST: GET $endpoint');
      debugPrint('GOAL TRANSACTION: Goal name: $goalName');
      debugPrint('GOAL TRANSACTION: Display start: $iDisplayStart');
      debugPrint('GOAL TRANSACTION: Display length: $iDisplayLength');

      final response = await _networkService.get(
        endpoint,
        headers: {
          'Authorization': 'Bearer $token',
          'app': 'SA',
        },
      );

      debugPrint('GOAL TRANSACTION RESPONSE: $response');

      if (response != null && response is Map<String, dynamic>) {
        final transactionModel = GoalTransactionModel.fromJson(response);

        if (transactionModel.isSuccess) {
          debugPrint(
              'GOAL TRANSACTION: Successfully retrieved ${transactionModel.data?.aaData.length ?? 0} transactions for goal: $goalName');

          if (transactionModel.data != null) {
            final data = transactionModel.data!;
            debugPrint('Total records: ${data.iTotalRecords}');
            debugPrint('Total display records: ${data.iTotalDisplayRecords}');

            for (var i = 0; i < data.aaData.length; i++) {
              final transaction = data.aaData[i];
              debugPrint('Transaction $i:');
              debugPrint('  - Amount: ${transaction.amount}');
              debugPrint('  - Currency: ${transaction.currencyCode}');
              debugPrint('  - Type: ${transaction.transactionType}');
              debugPrint('  - Payment Mode: ${transaction.paymentMode}');
              debugPrint('  - Date: ${transaction.getFormattedDate()}');
            }
          }
        } else {
          debugPrint('GOAL TRANSACTION: Failed to get transactions');
          debugPrint('Status: ${transactionModel.status}');
        }

        return transactionModel;
      } else {
        debugPrint('GOAL TRANSACTION: Invalid response format');
        debugPrint('Response type: ${response.runtimeType}');
        debugPrint('Response: $response');
        return GoalTransactionModel(
          status: 'failed',
          data: null,
        );
      }
    } catch (e, stackTrace) {
      debugPrint('GOAL TRANSACTION ERROR: ${e.toString()}');
      debugPrint('STACK TRACE: $stackTrace');
      return GoalTransactionModel(
        status: 'failed',
        data: null,
      );
    }
  }
}
