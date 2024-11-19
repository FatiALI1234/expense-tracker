
import 'package:expense_tracker/Category.dart';
import 'package:expense_tracker/Profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:expense_tracker/Homepage.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {

  String selectedCategory="";
  String _selectedCategory="";
  bool isAnimated = false;
  final formkey = GlobalKey<FormState>();
  DateTime _selectedDate = DateTime.now();
  int isSelected = -1;
  int changeColor = -1;
  Color containerColor = Colors.grey.withOpacity(0.3);
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  IconData _selectedIcon = CupertinoIcons.cube_box; // Default icon
  Color _selectedColor = Colors.blue; // Default color
  List<String>_categories=["Food",
    'Work',
    "personal",
    "Shopping",
    "Health",
    "finance",
    "Education",
    "Social"];
  List<String>categories=["Food",
    'Work',
    "personal",
    "Shopping",
    "Health",
    "finance",
    "Education",
    "Social"];
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formkey,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: Text(
            'Add Expense',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.deepPurple,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
              children: [
                // body: Padding(
                // padding: const EdgeInsets.all(16.0),
                // child: Column(
                //   children: [
                // Input Fields
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'New Expense',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Fill in the details below',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  height: 610,
                  width: double.infinity,
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            // this controller is add so when user click on category that category will be add to text feild
                            controller: TextEditingController(text: _selectedCategory, ),
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: "Category",
                              prefixIcon: Icon(_selectedIcon,color: _selectedColor,
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              filled: true,
                              fillColor: containerColor,
                            ),
                          ),
                          SizedBox(height: 20,),
                          // Amount Field
                          TextFormField(
                            validator: validateAmount,
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Amount',
                              prefixIcon: Icon(CupertinoIcons.money_dollar,
                                color: Colors.black87,),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              filled: true,
                              fillColor: containerColor,
                            ),
                          ),
                          SizedBox(height: 20),

                          // Description Field
                          TextFormField(
                            validator: validateDescription,
                            controller: _descriptionController,
                            keyboardType: TextInputType.multiline,
                            maxLines: 3,
                            decoration: InputDecoration(
                              labelText: 'Description',
                              prefixIcon: Icon(CupertinoIcons.doc_append,
                                color: Colors.black87,),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              filled: true,
                              fillColor: containerColor,
                            ),
                          ),
                          SizedBox(height: 20),

                          // Date Picker
                          InkWell(
                            onTap: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: _selectedDate,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2025),
                              );
                              if (picked != null) {
                                setState(() {
                                  _selectedDate = picked;
                                });
                              }
                            },
                            child: Container(
                              height: 60,
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.black87!),
                                color: containerColor,
                              ),
                              child: Row(
                                children: [
                                  Icon(CupertinoIcons.calendar_today),
                                  SizedBox(width: 10),
                                  Text(
                                    DateFormat('dd MMM yyyy').format(
                                        _selectedDate),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                                children: [
                                  Row(
                                      children: [
                                        Text("Select Category",style: TextStyle(fontWeight: FontWeight.bold),),


                                        Padding(
                                            padding: const EdgeInsets.only(left: 130.0),
                                            child:
                                            IconButton(
                                                onPressed: () {
                                                  _showAddCategoryDialog();// Show dialog on add button press
                                                },
                                                icon: Icon(Icons.add))
                                        ),
                                      ]
                                  ),
                                ]
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Wrap(
                              direction: Axis.horizontal,
                              spacing: 10,
                              runSpacing: 10,
                              children: [
                                //use for loop here so loop chly aur container banty jay
                                for (var i = 0; i <_categories.length; i++)
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isSelected = (isSelected == i) ? -1 : i;
                                      });
                                    },
                                    child: GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          _selectedCategory=_categories[i];
                                        });
                                      },
                                      child: Container(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            _categories[i],
                                            style: TextStyle(
                                                color: isSelected == i
                                                    ? Colors.white
                                                    : Colors.black87),
                                          ),
                                        ),
                                        decoration: BoxDecoration(
                                          //use colors.primaries so it automatically assign different colors to every containers
                                            color: isSelected == i
                                                ? Colors.purpleAccent
                                                : Colors.primaries[i % Colors.primaries.length]
                                                .shade100,
                                            borderRadius: BorderRadius.circular(12)),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          // Shows confirmation dialog and handles category deletion
                          Align(alignment: Alignment.center,
                            child: ElevatedButton(
                              onPressed: () {
                                if (formkey.currentState!.validate()) {
                                  // Add expense logic
                                  final description = _descriptionController.text;
                                  final amount = double.tryParse(_amountController.text
                                  );

                                  if (description.isEmpty || amount == null || amount <= 0) {
                                    return;
                                  }

                                  final newExpense = Expense(
                                    id: Uuid().v4(),
                                    category:_selectedCategory,// Generate unique ID
                                    description: description,
                                    amount: amount,
                                    date: _selectedDate,
                                  );

                                  // Return the new expense object back to the HomeScreen
                                  Navigator.pop(context, newExpense);
                                }
                              },
                              // child: Text(
                              //   _selectedCategory == null || _selectedCategory!.isEmpty
                              //       ? 'Select Category'  // Default text if no category selected
                              //       : 'Save Expense - $_selectedCategory',  // Display selected category
                              //   style: TextStyle(color: Colors.white)),
                              child: const Text('Save Expense',
                                style: TextStyle(color: Colors.white),),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius
                                        .circular(10)),


                              ),
                            ),
                          ),
                        ]
                    ),
                  ),
                ),
              ]
          ),
        ),
      ),
    );
  }
  void _showAddCategoryDialog(){
    String?categoryName;
    IconData selectedIcon = _selectedIcon; // Initialize with current icon
    Color selectedColor = _selectedColor; // Initialize with current color

    showDialog(context: context, builder: (context)=>AlertDialog(
        title: Text("Add Category"),
        backgroundColor: Colors.grey,
        content: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText:"Category name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (value) {
                    categoryName=
                        value;
                  },
                ),
                SizedBox(height: 16,),
                Text("Select Color"),

                Wrap(
                  spacing: 5,
                  children:Colors.primaries.map((color){
                    return InkWell(
                      onTap: (){
                        setState(() {
                          selectedColor=color;
                        });
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        width: 35,
                        height: 40,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: selectedColor==color?Border.all(color: Colors.white,width: 2):null,
                        ),
                      ),


                    );
                  }).toList(),
                ),
              ]
          ),
        ),



        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text("Cancel")),
          TextButton(onPressed: (){
            if(categoryName!=null&&categoryName!.isNotEmpty){
              setState(() {
                categories.add(categoryName!);
                _selectedCategory=categoryName!;
                _selectedIcon=selectedIcon;
                _selectedColor=selectedColor;
              });
            }
            Navigator.pop(context);
          }, child: Text("Add")),
        ])
    );
  }
}


String? validateAmount(String? Amount) {
  if (Amount!.isEmpty) {
    return "Amount  is required";

    return null;
  }
}
// for password validation:-
String? validateDescription(String? Description) {
  if (Description!.isEmpty) {
    return "Description is required";
  }
  return null;
}
String? validateDate(String? Date) {
  if (Date!.isEmpty) {
    return "Date is required";

  }
  return null;
}
class Category{
  String name;
  IconData icon;
  Color color;
  Category({required this.name, required this.icon, required this.color});
}