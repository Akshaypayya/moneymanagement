import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growk_v2/core/constants/app_url.dart';
import 'package:growk_v2/core/network/network_service.dart';
import 'package:growk_v2/core/storage/shared_preference/shared_preference_service.dart';
import 'package:growk_v2/features/transaction_page/model/transaction_model.dart';
import 'package:flutter/foundation.dart';

class TransactionRepository {
  final NetworkService _networkService;
  final Ref ref;

  TransactionRepository(this._networkService, this.ref);

  Future<TransactionModel> getAllTransactions({
    int iDisplayStart = 0,
    int iDisplayLength = 10,
  }) async {
    try {
      final token = SharedPreferencesHelper.getString("access_token");
      if (token == null || token.isEmpty) {
        debugPrint('TRANSACTION ERROR: Authentication token is missing');
        return TransactionModel(
          status: 'failed',
          data: null,
        );
      }

      // Use backend pagination parameters exactly as they expect
      final endpoint = '/user-service/goals/getAllTransaction'
          '?iDisplayStart=$iDisplayStart'
          '&iDisplayLength=$iDisplayLength';

      debugPrint('TRANSACTION REQUEST: GET $endpoint');
      debugPrint(
          'TRANSACTION REQUEST: iDisplayStart=$iDisplayStart, iDisplayLength=$iDisplayLength');

      final response = await _networkService.get(
        endpoint,
        headers: {
          'Authorization': 'Bearer $token',
          'app': 'SA',
        },
      );

      debugPrint(
          'TRANSACTION RESPONSE STATUS: ${response != null ? 'SUCCESS' : 'NULL'}');
      debugPrint('TRANSACTION RESPONSE TYPE: ${response.runtimeType}');

      if (response != null) {
        debugPrint(
            'TRANSACTION RESPONSE KEYS: ${response.keys?.toList() ?? 'NO KEYS'}');

        if (response.containsKey('status')) {
          debugPrint('TRANSACTION API STATUS: ${response['status']}');
        }

        if (response.containsKey('data')) {
          final data = response['data'];
          debugPrint('TRANSACTION DATA TYPE: ${data?.runtimeType}');
          if (data != null && data is Map) {
            debugPrint('TRANSACTION DATA KEYS: ${data.keys?.toList()}');
            if (data.containsKey('aaData')) {
              final aaData = data['aaData'];
              debugPrint('TRANSACTION aaData TYPE: ${aaData?.runtimeType}');
              if (aaData is List) {
                debugPrint('TRANSACTION aaData LENGTH: ${aaData.length}');
                if (aaData.isNotEmpty) {
                  debugPrint(
                      'TRANSACTION FIRST ITEM KEYS: ${aaData[0]?.keys?.toList() ?? 'NO KEYS'}');
                } else {
                  debugPrint(
                      'TRANSACTION WARNING: aaData is empty but API returned success');
                  debugPrint(
                      'TRANSACTION: This might indicate end of pagination or backend issue');
                }
              }
            }
            if (data.containsKey('iTotalRecords')) {
              debugPrint('TRANSACTION TOTAL RECORDS: ${data['iTotalRecords']}');
            }
            if (data.containsKey('iTotalDisplayRecords')) {
              debugPrint(
                  'TRANSACTION TOTAL DISPLAY RECORDS: ${data['iTotalDisplayRecords']}');
            }
          }
        }

        debugPrint('TRANSACTION FULL RESPONSE: $response');
      }

      if (response != null && response is Map<String, dynamic>) {
        try {
          final transactionModel = TransactionModel.fromJson(response);

          debugPrint('TRANSACTION MODEL CREATED');
          debugPrint(
              'TRANSACTION MODEL SUCCESS: ${transactionModel.isSuccess}');
          debugPrint('TRANSACTION MODEL STATUS: ${transactionModel.status}');

          if (transactionModel.isSuccess) {
            if (transactionModel.data != null) {
              final data = transactionModel.data!;
              debugPrint(
                  'TRANSACTION: Successfully retrieved ${data.aaData.length} transactions');
              debugPrint('TRANSACTION: Total records: ${data.iTotalRecords}');
              debugPrint(
                  'TRANSACTION: iTotalDisplayRecords: ${data.iTotalDisplayRecords}');

              // Check for pagination issues
              if (data.aaData.isEmpty &&
                  data.iTotalRecords > 0 &&
                  iDisplayStart < data.iTotalRecords) {
                debugPrint('TRANSACTION PAGINATION ISSUE DETECTED:');
                debugPrint('  - iTotalRecords: ${data.iTotalRecords}');
                debugPrint(
                    '  - iTotalDisplayRecords: ${data.iTotalDisplayRecords}');
                debugPrint('  - aaData length: ${data.aaData.length}');
                debugPrint(
                    '  - Request params: iDisplayStart=$iDisplayStart, iDisplayLength=$iDisplayLength');
                debugPrint(
                    '  - Expected: Should return data since iDisplayStart ($iDisplayStart) < iTotalRecords (${data.iTotalRecords})');
              }

              if (data.aaData.isNotEmpty) {
                final firstTransaction = data.aaData.first;
                debugPrint(
                    'TRANSACTION SAMPLE - Amount: ${firstTransaction.amount}');
                debugPrint(
                    'TRANSACTION SAMPLE - Payment Mode: ${firstTransaction.paymentMode}');
                debugPrint(
                    'TRANSACTION SAMPLE - Date: ${firstTransaction.transactionDate}');
              }
            } else {
              debugPrint('TRANSACTION: Success but data is null');
            }
          } else {
            debugPrint(
                'TRANSACTION: API returned non-success status: ${transactionModel.status}');
          }

          return transactionModel;
        } catch (parseError, parseStackTrace) {
          debugPrint('TRANSACTION PARSE ERROR: $parseError');
          debugPrint('TRANSACTION PARSE STACK: $parseStackTrace');
          debugPrint('TRANSACTION RAW RESPONSE: $response');

          return TransactionModel(
            status: 'failed',
            data: null,
          );
        }
      } else {
        debugPrint('TRANSACTION: Invalid response format');
        debugPrint('Response type: ${response.runtimeType}');
        debugPrint('Response content: $response');
        return TransactionModel(
          status: 'failed',
          data: null,
        );
      }
    } catch (e, stackTrace) {
      debugPrint('TRANSACTION ERROR: ${e.toString()}');
      debugPrint('TRANSACTION STACK TRACE: $stackTrace');
      return TransactionModel(
        status: 'failed',
        data: null,
      );
    }
  }
}
