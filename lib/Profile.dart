
import 'package:animate_do/animate_do.dart';
import 'package:expense_tracker/Homepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import"package:country_picker/country_picker.dart";
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _userName = '';
  TextEditingController dateInput = TextEditingController();
  final formkey = GlobalKey<FormState>();
  final CountryController = TextEditingController();
  final locationController = TextEditingController();
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  String?selectedCountry;
  DateTime selectedDate = DateTime.now();
  String? savedName, savedDate, savedCountry;


  @override
  void initState() {
    super.initState();
    _loadUserData();
    _saveUserData();// Load saved data when the page is initialized
  }
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      savedName = prefs.getString('name') ?? '';
      savedDate = prefs.getString('date') ?? '';
      savedCountry = prefs.getString('country') ?? '';
      nameController.text=savedName??'';
      dateInput.text=savedDate??'';
      locationController.text=savedCountry??'';
    });
  }
  Future<void>_saveUserData()async{
    final prefs=await SharedPreferences.getInstance();
    await prefs.setString("name", nameController.text);
    await prefs.setString("date", dateInput.text);
    await prefs.setString("country", locationController.text);
  }
  Future<void>_saveUserName()async{
    final prefs=await SharedPreferences.getInstance();
    await prefs.setString("userName", nameController.text);
    setState(() {
      _userName=nameController.text;
    });
  }
  // Future<void> _saveUserName() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('userName', nameController.text);
  //   setState(() {
  //     _userName = nameController.text;
  //   });
  // }

  @override
  @override
  Widget build(BuildContext context) {
    return Form(
      key:formkey ,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body:SingleChildScrollView(
          child: Column(
            children: [
            Container(
            height: 350,
            width: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/new 2.png'),
                    fit: BoxFit.fill
                )
            ),
            child: Stack(
                children: <Widget>[
                  Positioned(
                    left: 30,
                    width: 80,
                    height: 200,
                    child: FadeInUp(duration: Duration(seconds: 1), child: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/light-1.png')
                          )
                      ),
                    )),
                  ),
                  Positioned(
                    left: 140,
                    width: 80,
                    height: 150,
                    child: FadeInUp(duration: Duration(milliseconds: 1200), child: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/light-2.png')
                          )
                      ),
                          ),
                    ),
                          ),
            ]
            ),
                  ),
                              //Profile Picture

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: nameController,
                                  validator: validateUsername,
                                  decoration: InputDecoration(
                                    labelText: "Enter Name",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12)
                                    ),
                                    prefixIcon: Icon(Icons.person),
                                    hintStyle: TextStyle(
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: MediaQuery
                                    .of(context)
                                    .size
                                    .height * 0.02,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: TextFormField(
                                          validator: validatedate,
                                          controller: dateInput,
                                          readOnly: true,
                                          //validator: validatedateofbirth,
                                          decoration: InputDecoration(
                                            // use showdatepicker for showing date on screen
                                            prefixIcon: IconButton(
                                                onPressed: () async{
    DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(1950),
    lastDate: DateTime(2100));
    if(pickedDate!=null){
    print(pickedDate);
    String formattedDate=DateFormat('yyy-MM-dd').format(pickedDate);
    print(formattedDate);
    setState(() {
    dateInput.text=formattedDate;
    });
    }else{}
    },
    icon: Icon(CupertinoIcons.calendar_today,),),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12)),
                                            hintText: ("Select Date"),
            )

                                        ))
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: MediaQuery
                                    .of(context)
                                    .size
                                    .height * 0.02,
                              ),
                      Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              showCountryPicker(
                                context: context,
                                onSelect: (Country country) {
                                  print(
                                      'Select country: ${country
                                          .displayName}');
                                  setState(() {
                                    // make 2 conditions first make variables of selected country and controller of location controller
                                    selectedCountry = country.name;
                                    locationController.text = country.name;
                                  });
                                },
                              );
                            },
                            child: TextFormField(
                              validator: validatecountry,
                              onTap: () {
                                showCountryPicker(
                                  context: context,
                                  onSelect: (Country country) {
                                    print(
                                        'Select country: ${country
                                            .displayName}');
                                    setState(() {
                                      // make 2 conditions first make variables of selected country and controller of location controller
                                      selectedCountry = country.name;
                                      locationController.text = country.name;
                                    });
                                  },
                                );
                              },
                              controller: locationController,
                              // use when we dont want to open a keyboard
                              readOnly: true,
                              decoration: InputDecoration(
                                  prefixIcon: IconButton(
                                      onPressed: () {
                                        //add library of countrypicker
                                        showCountryPicker(
                                          context: context,
                                          onSelect: (Country country) {
                                            print(
                                                'Select country: ${country
                                                    .displayName}');
                                            setState(() {
                                              // make 2 conditions first make variables of selected country and controller of location controller
                                              selectedCountry = country.name;
                                              locationController.text =
                                                  country.name;
                                            });
                                          },
                                        );
                                      },
                                      icon: Icon(Icons.location_on_rounded)),
                                  border: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(12)),
                                  labelText: "select country"),
                            ),
                          ),
                        ),
                      ]),
                    ),

                Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(child: Text("Get Started",
                style: TextStyle(color: Colors.white),),
                style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(
                borderRadius: BorderRadius
          .circular(10)),
                fixedSize: Size(130, 40)),
                onPressed: () {
                  _saveUserName();
                  // _saveUserName();
                  _saveUserData();
                  if(_userName.isNotEmpty) ;
                  Text('Saved Name:$_userName');// Save data before navigation
                  // if (_userName.isNotEmpty)
                  // Text(
                  // 'Saved Name: $_userName');

                  if(formkey.currentState!.validate())
                  Navigator.push(context, MaterialPageRoute(builder: (context){
          return HomeScreen();
                  }));
                }
                )
                )
                      ]
                      ),
      ),

                    )
      );
  }
  String? validateUsername(String? Username) {
    if (Username!.isEmpty) {
      return "Name is requried";
    }
    return null;
  }
  String? validatecountry(String? country) {
    if (country!.isEmpty) {
      return "please select the country";
    }
    return null;
  }
}
String? validatedate(String? date) {
  if (date!.isEmpty) {
    return "please select the Date";
  }
  return null;
}
