import 'package:expense_tracker/Category.dart';
import 'package:expense_tracker/Add expense.dart';
import 'package:expense_tracker/Profile.dart';
import 'package:expense_tracker/Reports.dart';
import 'package:expense_tracker/signin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
 // Import the AddExpenseScreen
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Expense {
  final String id;
  final String category;
  final double amount;
  final String description;
  final DateTime date;

  Expense({
    required this.id,
    required this.category,
    required this.amount,
    required this.description,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      "category":category,
      'amount': amount,
      'description': description,
      'date': date.toIso8601String(),

    };
  }

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'],
      category:json["category"],
      amount: json['amount'],
      description: json['description'],
      date: DateTime.parse(json['date']),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Color containerColor = Colors.deepPurple.withOpacity(0.2);
  final searchcontroller = TextEditingController();
  List<Expense> _filteredExpenses = [];
  String greeting = "";
  String _userName = '';
  List<Expense> _expenses = [];
  double _totalExpenses = 0;
  bool _isSearching = false;
  bool isanimated = false;
  List<Expense> filteredExpenses = [];
  Map<String, List<Expense>> categorizedExpenses = {
    'Essential Expenses': [],
    'Lifestyle': [],
  };
  double totalExpenses = 0;
  bool _issearching = false;

  @override
  void initState() {
    super.initState();
    _loadExpenses();
    _loadUserName();
    _updateGreeting();
  }

  Future<void>_loadUserName()async{
    final prefs=await SharedPreferences.getInstance();
    setState(() {
      _userName=prefs.getString("userName")??'';
    });
  }

  @override
  void _updateGreeting() {
    // use for time changing
    DateTime now = DateTime.now();
    int hour = now.hour;
    if (hour < 12) {
      greeting = "Good Morning";
    } else if (hour < 17) {
      greeting = "Good Afternoon";
    } else {
      greeting = "Good Night ";
    }
    setState(() {});
  }
  Future <void> _loadExpenses()async{
    final prefs=await SharedPreferences.getInstance();
    final expensesJson=prefs.getStringList("expenses")??[];
    setState(() {
      _expenses=expensesJson.map((e)=>Expense.fromJson(json.decode(e))).toList()
          ..sort((a,b)=>b.date.compareTo(a.date));
      _calculateTotal();
    });
  }


  // Save expenses to SharedPreferences}
  Future<void>_saveExpenses()async{
    final prefs=await SharedPreferences.getInstance();
    final expensesJson=_expenses.map((e)=>json.encode(e.toJson())).toList();
    await prefs.setStringList("expenses",expensesJson);
  }

   void _calculateTotal(){
    _totalExpenses=_expenses.fold(0, (sum,expense)=>sum+expense.amount);
  }
  Future<void>_deleteExpense(String id)async{
    setState(() {
      _expenses.removeWhere((expense)=>expense.id==id);
      _calculateTotal();
    });
    final prefs=await SharedPreferences.getInstance();
    final expensesJson=_expenses.map((e)=>json.encode(e.toJson())).toList();
    await prefs.setStringList('expenses',expensesJson);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.black87,
          ),
          width: 251,
          child: Drawer(
              backgroundColor: Colors.white,
              child: Column(children: [
                Container(
                    height: 250,
                    width: 300,
                    color: (Colors.black87),
                    child: Lottie.asset("assets/animation3.json")
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(CupertinoIcons.person),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                    return ProfilePage();
                                  }));
                            },
                            child:Text("PROFILE ",
                                style: GoogleFonts.lexend(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87)),
                          ),
                        ),

                      ]
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(CupertinoIcons.chart_bar_square),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                    return ReportsScreen();
                                  }));
                            },
                            child: Text("Report ",
                                style: GoogleFonts.lexend(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87)),
                          ),
                        ),
                      ]
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.category_outlined),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                    return CategoryScreen();
                                  }));
                            },
                            child: Text("Category",
                                style: GoogleFonts.lexend(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87)),
                          ),
                        ),

                      ]
                  ),
                ),

                Spacer(),
                Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Icon(
                              Icons.power_settings_new_rounded,
                              color: Colors.red,
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title:
                                          Padding(
                                            padding: const EdgeInsets.all(
                                                8.0),
                                            child: Text(
                                                "Are u sure you wants to logout"),
                                          ),
                                          // title: Text("Are you sure?",style: TextStyle(color: Colors.deepPurple),),
                                          icon: Icon(
                                            Icons.power_settings_new_rounded,
                                            size: 40, color: Colors.red,
                                          ),
                                          actions: [
                                            ElevatedButton(
                                                style: ElevatedButton
                                                    .styleFrom(
                                                    backgroundColor: Colors
                                                        .grey,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                    fixedSize: Size(130, 40)),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  "Cancel",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                )),
                                            ElevatedButton(
                                                style: ElevatedButton
                                                    .styleFrom(
                                                    backgroundColor: Colors
                                                        .red,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                    fixedSize: Size(110, 20)),
                                                onPressed: () {
                                                  Navigator.push(context,
                                                      MaterialPageRoute(
                                                          builder: (context) {
                                                            return SignIn();
                                                          }));
                                                },
                                                child: Text(
                                                  "Logout",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ))
                                          ],
                                        );
                                      });
                                },
                                child: Text(
                                  "LOGOUT",
                                  style: TextStyle(fontWeight: FontWeight
                                      .bold, color: Colors.red, fontSize: 19),
                                ),
                              )
                          )
                        ]
                    )
                )
              ]
              )
          )
      ),
      appBar: AppBar(
          title: const Text('Expense Tracker'),

          ),
      body:
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
            children: [
              // Header Section
              Container(
                padding: const EdgeInsets.all(20),
                height: 230,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme
                          .of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.9),
                      Theme
                          .of(context)
                          .colorScheme
                          .primary,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(16)

                  ),
                ),
                child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '$greeting ${_userName.isNotEmpty?_userName:""}',
                                // '$greeting ${_userName.isNotEmpty ? _userName : ''}',
                                style: TextStyle(fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              const Text(
                                'Total Expenses',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                '\$${_totalExpenses.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ]
                        ),
                      ),
                    ]
                ),
              ),
              Align(alignment: Alignment.topLeft,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Recent Expenses", style: TextStyle(
                          fontSize: 17, fontWeight: FontWeight.bold),),
                    )
                  ],
                ),
              ),
              // Expense List
              Expanded(
                child: _filteredExpenses.isNotEmpty
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.receipt_long,
                        size: 60,
                        color: Colors.black87
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No expenses added yet',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black87
                        ),
                      ),
                    ],
                  ),
                ) :
                    ListView.builder(itemCount: _expenses.length,
                        itemBuilder: (context,index) {
                          final expenses = _expenses[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            elevation: 2,
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Theme
                                    .of(context)
                                    .colorScheme
                                    .primary,
                                child: Text("\$", style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                                ),
                              ),
                              title: Text(expenses.category, style: TextStyle(
                                  fontSize: 18,fontWeight: FontWeight.bold),),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(expenses.description,
                                    style: TextStyle(fontSize: 17,color: Colors.purple),),
                                  Text(
                                      DateFormat.yMMMd().format(expenses.date,),style: TextStyle(color: Colors.purple),),

                                ],

                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "\$${expenses.amount.toStringAsFixed(2)}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold),),
                                  IconButton(onPressed: () {
                                    _deleteExpense(expenses.id);
                                  }, icon: Icon(CupertinoIcons.delete,size: 20,)),


                                ],
                              ),
                            ),
                          );
                        }),
                          ),
                          ]
                          ),
                        ),

                        floatingActionButton:
                        FloatingActionButton(backgroundColor: Colors.deepPurple,
                          onPressed: () async {
                            // Navigate to AddExpenseScreen to add a new expense
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AddExpenseScreen()
                              ),
                            );
                            if (result != null) {
                              setState(() {
                                _expenses.insert(0,
                                    result); // Insert the new expense at the top
                                _calculateTotal();
                                _saveExpenses(); // Save updated list of expenses
                              });
                            }
                          },
                          child: const Icon(Icons.add, color: Colors.white,),
                        )
    );
  }
}
