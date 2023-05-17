import 'package:flutter/material.dart';
import 'package:inven/code/inventoryapi.dart';
import 'package:inven/models/inventorymodel.dart';
import 'package:inven/screens/button.dart';
import 'package:inven/screens/customcard.dart';
import 'package:inven/screens/footer.dart';
import 'package:inven/screens/header.dart';
import 'package:inven/screens/businesstypes/medicine/searchresult.dart';
import 'package:inven/screens/widgetbackground.dart';

class SearchWidget extends StatefulWidget {
  final String businessName;

  SearchWidget({required this.businessName});

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  int _currentIndex = 0;

  final TextEditingController _medicineNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<Item> medicines = [];
  String? _selectedMedicine;

  List<String> _distributorOptions = [];
  String? _selectedDistributor;

  List<String> _categoryOptions = [];
  String? _selectedCategory;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onCategoryChanged(String value) {
    setState(() {
      _selectedCategory = value;
    });
  }

  void _onDistributorChanged(String value) {
    setState(() {
      _selectedDistributor = value;
    });
  }

  Future<List<Item>> _searchMedicineName(String query) async {
    List<Item> searchResults = await InventoryApi.searchItems(
      businessName: widget.businessName,
      category: '',
      distributorName: '',
      itemName: query,
    );

    Set<String> uniqueNames = searchResults.map((item) => item.itemName).toSet();
    List<Item> distinctMedicines = uniqueNames.map((name) {
      return searchResults.firstWhere((item) => item.itemName == name);
    }).toList();

    return distinctMedicines.take(4).toList();
  }

  Future<void> _fetchDistributorOptions() async {
    List<Item> medicines = await InventoryApi.searchItems(
      businessName: widget.businessName,
      itemName: _selectedMedicine!,
      distributorName: '',
      category: '',
    );
    setState(() {
      _distributorOptions = medicines.map((medicine) => medicine.distributorName).toSet().toList();
    });
  }

  Future<void> _fetchCategoryOptions() async {
    List<Item> medicines = await InventoryApi.searchItems(
      businessName: widget.businessName,
      itemName: _selectedMedicine!,
      distributorName: _selectedDistributor!,
      category: '',
    );
    setState(() {
      _categoryOptions = medicines.map((medicine) => medicine.category).toSet().toList();
    });
  }

  void _onSearchPressed() async {
    List<Item> medicineList = await InventoryApi.searchItems(
        businessName: widget.businessName,
        category: _selectedCategory!,
        distributorName: _selectedDistributor!,
        itemName: _selectedMedicine!);
    setState(() {
      medicines = medicineList;
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultWidget(medicines: medicines, businessName: widget.businessName),
      ),
    );
  }


  @override
  void dispose() {
    _medicineNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: Header(title: widget.businessName),
      body: Column(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: CustomCard(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Autocomplete<Item>(
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue == '') {
                          return const Iterable<Item>.empty();
                        }
                        return _searchMedicineName(textEditingValue.text);
                      },
                      displayStringForOption: (Item option) => option.itemName,
                      onSelected: (Item selection) async {
                        setState(() {
                          _selectedMedicine = selection.itemName;
                          _medicineNameController.text = selection.itemName;
                        });
                        await _fetchDistributorOptions();
                      },
                      fieldViewBuilder: (BuildContext context,
                          TextEditingController fieldTextEditingController,
                          FocusNode fieldFocusNode,
                          VoidCallback onFieldSubmitted) {
                        _medicineNameController.addListener(() {
                          fieldTextEditingController.text = _medicineNameController.text;
                        });
                        return TextFormField(
                          controller: _medicineNameController,
                          focusNode: fieldFocusNode,
                          decoration: InputDecoration(hintText: 'Item'),
                          onChanged: (value) {
                            setState(() {
                              _selectedMedicine = value;
                            });
                          },
                        );
                      },
                    ),
                    SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: _selectedDistributor,
                      hint: Text('Distributor'),
                      onChanged: (String? value) {
                        _onDistributorChanged(value!);
                        _fetchCategoryOptions();
                      },
                      items: _distributorOptions.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      hint: Text('Category'),
                      onChanged: (String? value) {
                        _onCategoryChanged(value!);
                      },
                      items: _categoryOptions.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: MyButton(
                        onPressed: _onSearchPressed,
                        text: 'SEARCH',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Footer(
      currentIndex: _currentIndex,
        onTabTapped: _onTabTapped,
        businessName: widget.businessName,
      ),
    );
  }
}
