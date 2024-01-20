import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../utils/utils_index.dart';

enum TradePaymentStatus {
  pending, // 0
  paid, // 1
  def, // 2
  cancelled, // 3
  completed, // 4
  disputed, // 5
  funded, // 6
  released, // 7
}

extension TradePaymentStatusExt on TradePaymentStatus {
  String get name {
    switch (this) {
      case TradePaymentStatus.pending:
        return 'Pending';
      case TradePaymentStatus.paid:
        return 'Buyer Paid';
      case TradePaymentStatus.cancelled:
        return 'Cancelled';
      case TradePaymentStatus.disputed:
        return 'Disputed';
      case TradePaymentStatus.completed:
        return 'Completed';
      case TradePaymentStatus.funded:
        return 'Funded';
      case TradePaymentStatus.released:
        return 'Released';
      case TradePaymentStatus.def:
        return 'Default';
      default:
        return 'Unknown';
    }
  }

  Color get color {
    switch (this) {
      case TradePaymentStatus.pending:
        return holdColor;
      case TradePaymentStatus.paid:
        return runningColor;
      case TradePaymentStatus.cancelled:
        return cancelledColor;
      case TradePaymentStatus.disputed:
        return inProgressColor;
      case TradePaymentStatus.completed:
        return completedColor;
      case TradePaymentStatus.funded:
        return runningColor;
      case TradePaymentStatus.released:
        return completedColor;
      case TradePaymentStatus.def:
        return Colors.grey;

      default:
        return Colors.grey;
    }
  }

  int get index {
    switch (this) {
      case TradePaymentStatus.pending:
        return 0;
      case TradePaymentStatus.paid:
        return 1;
      case TradePaymentStatus.cancelled:
        return 3;
      case TradePaymentStatus.completed:
        return 4;
      case TradePaymentStatus.disputed:
        return 5;
      default:
        return 2;
    }
  }

  IconData get icon {
    switch (this) {
      case TradePaymentStatus.pending:
        return FontAwesomeIcons.hourglassStart;
      case TradePaymentStatus.paid:
        return FontAwesomeIcons.moneyBills;
      case TradePaymentStatus.cancelled:
        return CupertinoIcons.clear_circled;
      case TradePaymentStatus.completed:
        return FontAwesomeIcons.circleCheck;
      case TradePaymentStatus.disputed:
        return FontAwesomeIcons.triangleExclamation;
      case TradePaymentStatus.funded:
        return FontAwesomeIcons.moneyBill1Wave;
      case TradePaymentStatus.released:
        return FontAwesomeIcons.personCircleCheck;
      default:
        return FontAwesomeIcons.question;
    }
  }

  static TradePaymentStatus fromInt(int index) {
    switch (index) {
      case 0:
        return TradePaymentStatus.pending;
      case 1:
        return TradePaymentStatus.paid;
      case 2:
        return TradePaymentStatus.def;
      case 3:
        return TradePaymentStatus.cancelled;
      case 4:
        return TradePaymentStatus.completed;
      case 5:
        return TradePaymentStatus.disputed;
      case 6:
        return TradePaymentStatus.funded;
      case 7:
        return TradePaymentStatus.released;
      default:
        return TradePaymentStatus.def;
    }
  }
}
