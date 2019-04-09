import 'package:intl/intl.dart';

class AddRecordBloc {
  final dateFormat = DateFormat.yMMMd();

  String dateString(DateTime date) {
    return dateFormat.format(date);
  }
}