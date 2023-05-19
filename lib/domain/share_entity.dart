class ShareEntity{
  final String borrower;
  final String lender;
  final double cost;
  final String? description;

  ShareEntity({required this.borrower, required this.lender, required this.cost, this.description});

  @override
  String toString() {
    return "borrower: $borrower, lender: $lender, cost: $cost, description: $description";
  }
}