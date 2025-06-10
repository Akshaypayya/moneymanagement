class NotificationListModel {
  final NotificationListData? data;
  final String status;

  NotificationListModel({
    this.data,
    required this.status,
  });

  factory NotificationListModel.fromJson(Map<String, dynamic> json) {
    return NotificationListModel(
      data: json['data'] != null
          ? NotificationListData.fromJson(json['data'])
          : null,
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.toJson(),
      'status': status,
    };
  }

  bool get isSuccess => status == 'Success';
}

class NotificationListData {
  final int iTotalRecords;
  final int pageNumber;
  final List<NotificationItem> aaData;
  final int unreadCount;
  final int iTotalDisplayRecords;

  NotificationListData({
    required this.iTotalRecords,
    required this.pageNumber,
    required this.aaData,
    required this.unreadCount,
    required this.iTotalDisplayRecords,
  });

  factory NotificationListData.fromJson(Map<String, dynamic> json) {
    return NotificationListData(
      iTotalRecords: json['iTotalRecords'] ?? 0,
      pageNumber: json['pageNumber'] ?? 0,
      aaData: json['aaData'] != null
          ? (json['aaData'] as List)
              .map((item) => NotificationItem.fromJson(item))
              .toList()
          : [],
      unreadCount: json['unreadCount'] ?? 0,
      iTotalDisplayRecords: json['iTotalDisplayRecords'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'iTotalRecords': iTotalRecords,
      'pageNumber': pageNumber,
      'aaData': aaData.map((item) => item.toJson()).toList(),
      'unreadCount': unreadCount,
      'iTotalDisplayRecords': iTotalDisplayRecords,
    };
  }
}

class NotificationItem {
  final int notificationId;
  final String message;
  final String notificationTime;
  final int status;
  final String type;
  final String name;
  final bool wallet;

  NotificationItem({
    required this.notificationId,
    required this.message,
    required this.notificationTime,
    required this.status,
    required this.type,
    required this.name,
    required this.wallet,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      notificationId: json['notificationId'] ?? 0,
      message: json['message'] ?? '',
      notificationTime: json['notificationTime'] ?? '',
      status: json['status'] ?? 0,
      type: json['type'] ?? '',
      name: json['name'] ?? '',
      wallet: json['wallet'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notificationId': notificationId,
      'message': message,
      'notificationTime': notificationTime,
      'status': status,
      'type': type,
      'name': name,
      'wallet': wallet,
    };
  }

  String get displayTitle {
    if (name.isNotEmpty) {
      return name;
    }

    switch (type.toLowerCase()) {
      case 'gold':
      case 'gold_purchase':
        return 'Gold Added to Your Goal!';
      case 'deposit':
      case 'wallet_deposit':
        return 'Amount Deposited';
      case 'withdrawal':
        return 'Withdrawal Processed';
      case 'goal':
      case 'goal_created':
        return 'Goal Created Successfully';
      case 'transfer':
        return 'Transfer Completed';
      default:
        return 'Notification';
    }
  }

  String get displayMessage => message;

  String get formattedTime {
    try {
      final dateTime = DateTime.parse(notificationTime);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inDays > 0) {
        return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return notificationTime;
    }
  }

  String get iconAsset {
    switch (type.toLowerCase()) {
      case 'gold':
      case 'gold_purchase':
        return 'assets/goldbsct.png';
      case 'deposit':
      case 'wallet_deposit':
        return 'assets/bhim.png';
      case 'withdrawal':
      case 'transfer':
        return 'assets/bank.jpg';
      case 'goal':
      case 'goal_created':
        return 'assets/customgoals.png';
      default:
        if (wallet) {
          return 'assets/bhim.png';
        }
        return 'assets/bank.jpg';
    }
  }

  bool get isRead => status == 1;
  bool get isUnread => status == 0;
}
