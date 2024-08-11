class Payment {
  final double amount;
  final String method;
  final String status; // "success" or "failed"
  final DateTime date;

  Payment({
    required this.amount,
    required this.method,
    required this.status,
    required this.date,
  });
}
