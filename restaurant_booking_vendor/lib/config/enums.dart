///
/// Created by Sunil Kumar on 29-04-2020 08:04 AM.
///
enum UserType { vendor, user }

extension UserTypeToString on UserType {
  String get string {
    if (this == UserType.vendor)
      return 'res';
    else
      return 'user';
  }
}

enum OrderStatus { created, onGoing, completed, cancelled }

extension OrderStatusToString on OrderStatus {
  String get string {
    switch (this) {
      case OrderStatus.cancelled:
        return 'Cancelled';
      case OrderStatus.onGoing:
        return 'On Going';
      case OrderStatus.completed:
        return 'Completed';
      case OrderStatus.created:
        return 'Created';
      default:
        return 'Unknown';
    }
  }

  int get toInt {
    switch (this) {
      case OrderStatus.cancelled:
        return 4;
      case OrderStatus.onGoing:
        return 2;
      case OrderStatus.completed:
        return 3;
      case OrderStatus.created:
        return 1;
      default:
        return 0;
    }
  }
}

enum OrderTimeSlot { slot1, slot2, slot3, slot4, slot5, slot6 }

extension OrderTimeSlotToString on OrderTimeSlot {
  String get string {
    switch (this) {
      case OrderTimeSlot.slot1:
        return '11:00 AM - 1:00 PM';
      case OrderTimeSlot.slot2:
        return '1:00 PM - 3:00 PM';
      case OrderTimeSlot.slot3:
        return '3:00 PM - 5:00 PM';
      case OrderTimeSlot.slot4:
        return '5:00 PM - 7:00 PM';
      case OrderTimeSlot.slot5:
        return '7:00 PM - 9:00 PM';
      case OrderTimeSlot.slot6:
        return '9:00 PM - 11:00 PM';
      default:
        return 'Unknown';
    }
  }

  int get toInt {
    switch (this) {
      case OrderTimeSlot.slot1:
        return 1;
      case OrderTimeSlot.slot2:
        return 2;
      case OrderTimeSlot.slot3:
        return 3;
      case OrderTimeSlot.slot4:
        return 4;
      case OrderTimeSlot.slot5:
        return 5;
      case OrderTimeSlot.slot6:
        return 6;
      default:
        return 0;
    }
  }
}

String slotFromIntToString(int i) {
  if (i == OrderTimeSlot.slot1.toInt) return '11:00 AM - 1:00 PM';
  if (i == OrderTimeSlot.slot2.toInt) return '1:00 PM - 3:00 PM';
  if (i == OrderTimeSlot.slot3.toInt) return '3:00 PM - 5:00 PM';
  if (i == OrderTimeSlot.slot4.toInt) return '5:00 PM - 7:00 PM';
  if (i == OrderTimeSlot.slot5.toInt) return '7:00 PM - 9:00 PM';
  if (i == OrderTimeSlot.slot6.toInt) return '9:00 PM - 11:00 PM';
  return 'Unknown';
}

enum PaymentStatus { initiated, success, refunded }

extension PaymentStatusToString on PaymentStatus {
  String get string {
    switch (this) {
      case PaymentStatus.initiated:
        return 'Initiated';
      case PaymentStatus.refunded:
        return 'Refunded';
      case PaymentStatus.success:
        return 'Success';
      default:
        return 'Unknown';
    }
  }

  int get toInt {
    switch (this) {
      case PaymentStatus.initiated:
        return 1;
      case PaymentStatus.refunded:
        return 3;
      case PaymentStatus.success:
        return 2;
      default:
        return 0;
    }
  }
}

String paymentFromIntToString(int i) {
  if (i == PaymentStatus.success.toInt) return PaymentStatus.success.string;
  if (i == PaymentStatus.initiated.toInt) return PaymentStatus.initiated.string;
  if (i == PaymentStatus.refunded.toInt) return PaymentStatus.refunded.string;
  return 'Unknown';
}

String orderFromIntToString(int i) {
  if (i == OrderStatus.created.toInt) return OrderStatus.created.string;
  if (i == OrderStatus.completed.toInt) return OrderStatus.completed.string;
  if (i == OrderStatus.cancelled.toInt) return OrderStatus.cancelled.string;
  if (i == OrderStatus.onGoing.toInt) return OrderStatus.onGoing.string;
  return 'Unknown';
}
