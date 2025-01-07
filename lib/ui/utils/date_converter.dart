class DateConverter{
 static String formatDateWithMonthName() {
  final now = DateTime.now();
  const monthNames = [
    'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
    'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'
  ];

  final day = now.day.toString().padLeft(2, '0');
  final month = monthNames[now.month - 1];
  final year = now.year;

  return '$day de $month de $year';
}



}