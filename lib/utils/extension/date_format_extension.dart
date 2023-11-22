import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String get homeHeaderDate {
    final dateFormatter = DateFormat('EEEE, d MMMM');
    return dateFormatter.format(this);
  }

  String get homeHeaderTime {
    final dateFormatter = DateFormat('hh:mm a');
    return dateFormatter.format(this);
  }

  String get customDate {
    final dateFormatter = DateFormat('dd-MM-yyyy');
    return dateFormatter.format(this);
  }

  String get orderDetailsDateFormat {
    final dateFormatter = DateFormat("MMMM dd, yyyy hh:mm a");
    return dateFormatter.format(this);
  }
}
