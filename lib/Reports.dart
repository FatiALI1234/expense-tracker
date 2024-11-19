import 'dart:convert';
import 'package:expense_tracker/Homepage.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
final TextEditingController _amountController=TextEditingController();
final TextEditingController _descriptionController=TextEditingController();
List<Expense>expenses=[];
double totalExpense=0;
@override
void initState(){
  super.initState();
  loadExpenses();
}
Future<void>loadExpenses()async{
  final prefs=await SharedPreferences.getInstance();
  final expenseData =prefs.getStringList('expenses')??[];
  setState(() {
    expenses=expenseData.map((e)=>Expense.fromJson(jsonDecode(e))).toList();
    calculateTotal();
  });
}
Future<void>saveExpenses()async{
  final prefs=await SharedPreferences.getInstance();
  final expenseData=expenses.map((e)=>jsonEncode(e.toJson())).toList();
  await prefs.setStringList('expenses', expenseData);
}
void calculateTotal(){
  totalExpense=expenses.fold(0, (sum,expense)=>sum+expense.amount);
}
  void addExpense(){
  if(_amountController.text.isEmpty)return;
  final newExpense=Expense(amount: double.parse(_amountController.text), description: _descriptionController.text, date:  DateTime.now());
  setState(() {
    expenses.add(newExpense);
    calculateTotal();
  });
  saveExpenses();
  _amountController.clear();
  _descriptionController.clear();
  }
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(leading: IconButton(icon:Icon(Icons.arrow_back_rounded),onPressed: (){
      Navigator.pop(context);
    }, ),
      centerTitle: true,
      title: Text("Report analysis",style: TextStyle(fontWeight: FontWeight.bold),),
  ),
    backgroundColor: Colors.grey[100],
    body: SingleChildScrollView(
    child: Column(
    children: [
      SafeArea(child: Padding(padding: const EdgeInsets.only(top: 50.0),
    child:  SizedBox(
    height: 350,
    child: BarChart(BarChartData(
    alignment:  BarChartAlignment.spaceAround,
    maxY: expenses.isEmpty?100:expenses.map((e)=>e.amount).reduce((a,b)=>a>b?a:b)*1.2,
    barGroups: expenses.asMap().entries.map((entry){
      return BarChartGroupData(x: entry.key,
      barRods: [
                  BarChartRodData(
                    toY: entry.value.amount,
                    color: Colors.blue,
                  ),
                ],
              );
    }).toList(),
    titlesData: FlTitlesData(
    show: true,
    bottomTitles: AxisTitles(
    sideTitles: SideTitles(
    showTitles: true,
    getTitlesWidget: (value,meta) {
      if (value >= 0 && value < expenses.length) {
        return Text(expenses[value.toInt()].date.day.toString(),
          style: const TextStyle(fontSize: 10),);
      }
      return const Text("");
    })
      )
    )
    )
    )
    )

    ),
      ),
      Text(
        'Total Expenses: \$${totalExpense.toStringAsFixed(2)}',
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    ]
    )
    )
  );

  }}
class Expense {
  final double amount;
  final String description;
  final DateTime date;

  Expense({
    required this.amount,
    required this.description,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {

      'amount': amount,
      'description': description,
      'date': date.toIso8601String(),

    };
  }

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      amount: json['amount'],
      description: json['description'],
      date: DateTime.parse(json['date']),
    );
  }
}





