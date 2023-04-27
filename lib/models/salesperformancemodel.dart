class SalesPerformance {
  double totalRevenue;
  double totalCogs;
  double totalProfitLoss;
  double totalProfitLossPercentage;
  List<SalesData> salesData;

  SalesPerformance({
    required this.totalRevenue,
    required this.totalCogs,
    required this.totalProfitLoss,
    required this.totalProfitLossPercentage,
    required this.salesData,
  });

  factory SalesPerformance.fromJson(Map<String, dynamic> json) {
    return SalesPerformance(
      totalRevenue: json['total_revenue'].toDouble(),
      totalCogs: json['total_cogs'].toDouble(),
      totalProfitLoss: json['total_profit_loss'].toDouble(),
      totalProfitLossPercentage: json['total_profit_loss_percentage'].toDouble(),
      salesData: (json['sales_data'] as List<dynamic>)
          .map((data) => SalesData.fromJson(data))
          .toList(),
    );
  }
}

class SalesData {
  String itemName;
  String distributor;
  String category;
  int unitsSold;
  double revenue;
  double cogs;
  double profitLoss;
  double profitLossPercentage;

  SalesData({
    required this.itemName,
    required this.distributor,
    required this.category,
    required this.unitsSold,
    required this.revenue,
    required this.cogs,
    required this.profitLoss,
    required this.profitLossPercentage,
  });

  factory SalesData.fromJson(Map<String, dynamic> json) {
    return SalesData(
      itemName: json['item_name'],
      distributor: json['distributor'],
      category: json['category'],
      unitsSold: json['units_sold'],
      revenue: json['revenue'].toDouble(),
      cogs: json['cogs'].toDouble(),
      profitLoss: json['profit_loss'].toDouble(),
      profitLossPercentage: json['profit_loss_percentage'].toDouble(),
    );
  }
}
