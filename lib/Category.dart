import 'package:expense_tracker/Homepage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// represents a group of categories with a unique identifier and name
class CategoryGroup{
  final String id;
  final String name;
  final List<Category> Categories;
  CategoryGroup({
    required this.id,
    required this.name,
    required this.Categories,
  });
}
// class for category
class Category {
  String id;
  String name;
  IconData icon;
  Color color;
  List<Category>subcategories;

  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    this.subcategories = const[]
  });

}
class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}
class _CategoryScreenState extends State<CategoryScreen> {
  // Controllers and state variables
  final TextEditingController searchController = TextEditingController();
  List<CategoryGroup> categoryGroups = [];
  String searchQuery = "";
  bool isAnimated = false;
  int changeColor = -1;
  Color containerColor = Colors.red;
  Category? selectedcategory;

  @override
  void initState() {
    super.initState();
    _initializeCategories();
    _loadSelectedCategory();
  }
  // Initializes the category data structure with predefined categories and groups
  void _initializeCategories(){
    // Food & Dining Category with subcategories
    categoryGroups=[
      CategoryGroup(id: '1', name: "Essential Expenses",Categories: [
        Category(id: "1", name: "Food and Dinning", icon: Icons.restaurant, color: Colors.deepPurple,
          subcategories: [
            Category(id: "1.1", name: "Restaurants", icon: Icons.restaurant, color: Colors.deepPurple),
            Category(id: "1.2", name: "Groceries", icon: Icons.shopping_basket, color: Colors.deepPurple),
          ],
        ),
        Category(
          id: '2',
          name: 'Transportation',
          icon: Icons.directions_car,
          color: Colors.blue,
          subcategories: [
            Category(
              id: '2.1',
              name: 'Public Transit',
              icon: Icons.train,
              color: Colors.blue.shade300,
            ),
            Category(
              id: '2.2',
              name: 'Fuel',
              icon: Icons.local_gas_station,
              color: Colors.blue.shade300,
            ),
          ],
        ),
      ],
      ),
      CategoryGroup(
        id: '2',
        name: 'Lifestyle',
        Categories: [
          Category(
            id: '3',
            name: 'Entertainment',
            icon: Icons.movie,
            color: Colors.purple,
            subcategories: [
              Category(
                id: '3.1',
                name: 'Movies',
                icon: Icons.movie_creation,
                color: Colors.purple.shade300,
              ),
              Category(
                id: '3.2',
                name: 'Games',
                icon: Icons.sports_esports,
                color: Colors.purple.shade300,
              ),
            ],
          ),
        ],
      ),
    ];
  }
  Future<void> _loadSelectedCategory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? selectedCategoryId = prefs.getString('selectedCategoryId');
    if (selectedCategoryId != null) {
      // Optionally, you can handle the loaded category here if needed
      print('Loaded category ID: $selectedCategoryId');
    }
  }
  // Filters categories based on search query
  // Returns filtered category groups containing only matching categories and subcategories
  List<CategoryGroup>_getFilteredCategories(){
    if (searchQuery.isEmpty) {
      return categoryGroups;
    }
    return categoryGroups.map((group) {
      // Filter categories within each group
      final filteredCategories = group.Categories.where((category) {
        final matchInMain = category.name.toLowerCase().contains(
            searchQuery.toLowerCase());
        final matchinInSub = category.subcategories.any((sub) =>
            sub.name.toLowerCase().contains(searchQuery.toLowerCase()),
        );
        return matchInMain || matchinInSub;
      }).toList();
      return CategoryGroup(
          id: group.id, name: group.name, Categories: filteredCategories);
    }).where((group)=>group.Categories.isNotEmpty).toList();
  }
  // Shows dialog for adding new category or editing existing one
  // [category] parameter is null for new category, contains category data for editing
  void _showAddEditCategoryDialog([Category? category]){
    final isEditing=category !=null;
    final nameController=TextEditingController(text: category?.name);
    var selectedIcon = category?.icon ?? Icons.category;
    var selectedColor = category?.color ?? Colors.blue;
    var selectedGroupId=categoryGroups.first.id;
    showDialog(context: context, builder: (context)=>StatefulBuilder(
      builder:(context,setState)=>AlertDialog(
        title:Text(isEditing?"Edit Category":"Add Category"),
        content:SingleChildScrollView(
          child:Column(
            mainAxisSize:MainAxisSize.min,
            children:[
              TextField(
                  controller:nameController,
                  decoration:const InputDecoration(
                    labelText:"Category Name",
                    border:OutlineInputBorder(),
                  )
              ),
              const SizedBox(height: 16,),
              // Group selection dropdown (only for new categories)
              if(!isEditing)
                DropdownButtonFormField<String>(
                  value:  selectedGroupId,decoration: const InputDecoration(labelText: "Group",border: OutlineInputBorder(

                ),
                ),
                  items:categoryGroups.map((group) {
                    return DropdownMenuItem(
                      value: group.id, child: Text(group.name),
                    );
                  }).toList(),
                  onChanged:(value) {
                    setState(() {
                      selectedGroupId = value!;
                    });
                  },
                ),
              const SizedBox(height: 16,),
              const Text("Selected icon"),
              Wrap(
                spacing: 8,
                children: [
                  Icons.shopping_basket,
                  Icons.restaurant,
                  Icons.movie,
                  Icons.sports,
                  Icons.school,
                  Icons.medical_services,
                  Icons.house,
                  Icons.flight,
                ].map((icon){
                  return IconButton(
                    icon:Icon(icon),
                    color:icon==selectedIcon?selectedColor:null,
                    onPressed:(){
                      setState((){
                        selectedIcon=icon;
                      });
                    },
                  );
                }).toList(),
              ),
              // Color selection

              const SizedBox(height: 16,),
              const Text("Select Color"),
              Wrap(
                spacing: 8,
                children: Colors.primaries.map((color){
                  return InkWell(
                    onTap: () {
                      setState(() {
                        selectedColor = color;
                      });
                    },
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: color==selectedColor?Border.all(color: Colors.white,width: 2):null,
                      ),
                    ),
                  );
                }).toList(),
              ),
          TextButton(onPressed: (){
            Navigator.pop(context);
          },style: TextButton.styleFrom(
            foregroundColor: Colors.red,
          ), child: const Text("Cancel")),
          TextButton(onPressed: () {
            if (isEditing) {
              setState(() {
                category.name = nameController.text;
                category.icon = selectedIcon;
                category.color = selectedColor;
              });
            } else {
              final newCategory = Category(id: DateTime.now().toString(),
                  name: nameController.text,
                  icon: selectedIcon,
                  color: selectedColor);
              setState(() {
                categoryGroups
                    .firstWhere((group) => group.id == selectedGroupId)
                    .Categories
                    .add(newCategory);
              });
              // todo
              Future<void> setCategory(String newCategoryId) async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setString('selectedCategoryId', newCategory.id);
              }
              Navigator.pop(context);
            }
          },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(isEditing?"Save":"Add",),
          ),
        ],
      ),
    ),
      )
    ));
  }
  // Shows confirmation dialog and handles category deletion
  void _deleteCategory(Category category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Category'),
        content: Text('Are you sure you want to delete"${category.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                for (var group in categoryGroups) {
                  group.Categories.remove(category);
                  for (var mainCat in group.Categories) {
                    mainCat.subcategories.remove(category);
                  }
                }
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
  void _selectCategory(Category category){
    setState(() {
      selectedcategory=category;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredGroups = _getFilteredCategories();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories',style: TextStyle(fontWeight: FontWeight.bold),),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddEditCategoryDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search categories',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredGroups.length,
              itemBuilder: (context, groupIndex) {
                final group = filteredGroups[groupIndex];
                return ExpansionTile(
                  title: Text(
                    group.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  children: group.Categories.map((category) {
                    return ExpansionTile(
                      leading: CircleAvatar(
                        backgroundColor: category.color.withOpacity(0.2),
                        child: Icon(category.icon, color: category.color),
                      ),
                      title: Text(category.name),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _showAddEditCategoryDialog(category),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete,color: Colors.red,),
                            onPressed: () => _deleteCategory(category),
                          ),
                        ],
                      ),
                      children: category.subcategories.map((subcategory) {
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: subcategory.color.withOpacity(0.2),
                            child: Icon(subcategory.icon, color: subcategory.color),
                          ),
                          title: Text(subcategory.name),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _showAddEditCategoryDialog(subcategory),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete,color: Colors.red,),
                                onPressed: () => _deleteCategory(subcategory),
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context){
                              return HomeScreen();
                            }));
                            // Navigator.pop(context, subcategory);
                          },
                        );
                      }).toList(),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
