import 'package:flutter/material.dart';
import 'package:inven/screens/businesstypes/medicine/salesdetails.dart';
import 'package:inven/screens/businesstypes/medicine/topten.dart';
import 'package:inven/screens/customcard.dart';
import 'package:inven/screens/button.dart';
import 'package:pie_chart/pie_chart.dart';

import '../../../code/salesapi.dart';
import '../../../code/toptenitemsapi.dart';
import '../../../models/salesperformancemodel.dart';

class SalesPerformanceWidget extends StatefulWidget {
  final List<String> businessNames;

  SalesPerformanceWidget({
    required this.businessNames,
  });

  @override
  _SalesPerformanceWidgetState createState() => _SalesPerformanceWidgetState();
}

class _SalesPerformanceWidgetState extends State<SalesPerformanceWidget> {
  String? selectedBusinessName;
  String? selectedTimePeriod;

  double totalRevenue = 0.0;
  double totalCogs = 0.0;
  double totalProfitLoss = 0.0;
  double totalProfitLossPercentage = 0.0;

  late Future<SalesPerformance> salesPerformanceFuture;

  @override
  void initState() {
    super.initState();
    selectedBusinessName = widget.businessNames.first;
    selectedTimePeriod = 'This Year';
    salesPerformanceFuture = fetchSalesPerformance(timePeriod: 9, businessName: selectedBusinessName!);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
          CustomCard(
          child: Column(
          children: [
            DropdownButtonFormField<String>(
            decoration: InputDecoration(
            labelText: 'Business Name',
          ),
          value: selectedBusinessName,
          items: widget.businessNames
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                selectedBusinessName = newValue;
                salesPerformanceFuture = fetchSalesPerformance(timePeriod: 9, businessName: selectedBusinessName!);
              });
            }
          },
        ),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Time Period',
          ),
          value: selectedTimePeriod,
          items: [
            'Today',
            'Last 30 Days',
            'This Year',
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                selectedTimePeriod = newValue;
                int timePeriodValue = 9; // Default to 'This Year'
                if (newValue == 'Today') {
                  timePeriodValue = 1;
                } else if (newValue == 'Last 30 Days') {
                  timePeriodValue = 30;
                }
                salesPerformanceFuture = fetchSalesPerformance(timePeriod: timePeriodValue, businessName: selectedBusinessName!);
              });
            }
          },
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: MyButton(
                  text: 'SALES',
                  onPressed: () async {
                    int timePeriodValue;
                    switch (selectedTimePeriod) {
                      case 'Today':
                        timePeriodValue = 1;
                        break;
                      case 'Last 30 Days':
                        timePeriodValue = 2;
                        break;
                      default:
                        timePeriodValue = 9;
                    }
                    SalesPerformance salesPerformance = await fetchSalesPerformance(
                      businessName: selectedBusinessName!,
                      timePeriod: timePeriodValue,
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SalesDetailWidget(salesData: salesPerformance.salesData),
                      ),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: MyButton(
                  text: 'TOP ITEMS',
                  onPressed: () async {
                    List<dynamic> topItemsData = await fetchTopItems(businessName: selectedBusinessName!);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TopTenWidget(topItems: topItemsData.cast<Map<String, dynamic>>()),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
          ],
      ),
    ),
    SizedBox(height: 10),
    FutureBuilder<SalesPerformance>(
    future: salesPerformanceFuture,
    builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
    return CircularProgressIndicator();
    } else if (snapshot.hasError) {
    return Text('Error: ${snapshot.error}');
    } else if (snapshot.hasData) {
    SalesPerformance salesPerformance = snapshot.data!;
    totalRevenue = salesPerformance.totalRevenue;
    totalCogs = salesPerformance.totalCogs;
    totalProfitLoss = salesPerformance.totalProfitLoss;
    totalProfitLossPercentage = salesPerformance.totalProfitLossPercentage;

    return CustomCard(
      child: Column(
        children: [
          PieChart(
            dataMap: {
              'Total Revenue': totalRevenue,
              'Total COGS': totalCogs,
              'Total Profit/Loss': totalProfitLoss,
            },
            chartType: ChartType.disc,
          ),
          SizedBox(height: 10),
          Text(
            'Total Profit/Loss Percentage: ${totalProfitLossPercentage.toStringAsFixed(2)}%',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
    } else {
      return Text('No data available');
    }
    },
    ),
            ],
          ),
        ),
      ),
    );
  }
}

