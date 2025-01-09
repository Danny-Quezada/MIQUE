class DateConverter {
  static const monthNames = [
    'enero',
    'febrero',
    'marzo',
    'abril',
    'mayo',
    'junio',
    'julio',
    'agosto',
    'septiembre',
    'octubre',
    'noviembre',
    'diciembre'
  ];
  static String formatDateWithMonthName({DateTime? date}) {
    final datetime = date ?? DateTime.now();

    final day = datetime.day.toString().padLeft(2, '0');
    final month = monthNames[datetime.month - 1];
    final year = datetime.year;

    return '$day de $month de $year';
  }

  static DateTime parseDate(String date) {
    final parts = date.split(' de ');
    final day = int.parse(parts[0]);
    final month = DateConverter.monthNames.indexOf(parts[1]) + 1;
    final year = int.parse(parts[2]);
    return DateTime(year, month, day);
  }
}
