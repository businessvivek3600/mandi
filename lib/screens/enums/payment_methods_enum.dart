import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum PaymentMethod {
  bank,
  card,
  paytm,
  upi,
  phonepe,
  googlepay,
  amazonpay,
  paypal,
  skrill,
  none,
}

extension PaymentMethodExtension on PaymentMethod {
  String get name {
    switch (this) {
      case PaymentMethod.bank:
        return 'Bank Account';
      case PaymentMethod.card:
        return 'Card';
      case PaymentMethod.paytm:
        return 'Paytm';
      case PaymentMethod.upi:
        return 'UPI';
      case PaymentMethod.phonepe:
        return 'PhonePe';
      case PaymentMethod.googlepay:
        return 'Google Pay';
      case PaymentMethod.amazonpay:
        return 'Amazon Pay';
      case PaymentMethod.paypal:
        return 'PayPal';
      case PaymentMethod.skrill:
        return 'Skrill';
      default:
        return 'Unknown';
    }
  }

  dynamic get icon {
    switch (this) {
      case PaymentMethod.bank:
        return FontAwesomeIcons.buildingColumns;
      case PaymentMethod.card:
        return FontAwesomeIcons.creditCard;
      case PaymentMethod.paytm:
        return FontAwesomeIcons.paypal;
      case PaymentMethod.upi:
        return FontAwesomeIcons.buildingColumns;
      case PaymentMethod.phonepe:
        return FontAwesomeIcons.buildingColumns;
      case PaymentMethod.googlepay:
        return FontAwesomeIcons.buildingColumns;
      case PaymentMethod.amazonpay:
        return FontAwesomeIcons.buildingColumns;
      case PaymentMethod.paypal:
        return FontAwesomeIcons.buildingColumns;
      case PaymentMethod.skrill:
        return FontAwesomeIcons.buildingColumns;
      default:
        return FontAwesomeIcons.circleQuestion;
    }
  }
}
