import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wheres_the_halal/components/menu_drawer.dart';
import 'package:wheres_the_halal/components/restaurant.dart';
import 'package:wheres_the_halal/pages/filter_page.dart';
import 'package:wheres_the_halal/pages/restaurant_page.dart';
import 'package:wheres_the_halal/services/restaurant_data_fetch.dart';


class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();

}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _textController = TextEditingController();

  final CollectionReference restaurantCollection = FirebaseFirestore.instance.collection('restaurants');
  final String pageName = "Search";

  List _allResults = [];
  List _resultList = [];
  List _cuisinesList = [];
  List _selectedCuisines = [];

  initList() async {
    setState(() {
      _allResults = [];
    });
    // order restaurants by name, then by location name
    await RestaurantDataFetch.getClientStream();

    List temp = RestaurantDataFetch.getAllResults();
    // var data = await FirebaseFirestore.instance.collection('restaurants').orderBy('name').orderBy('location').get();

    setState(() {
      _allResults = temp;
    });
    print(_allResults.length);
    searchResultList();
  }

  _onSearchChanged() {
    // print(_textController.text);
    // to debug if app is seeing changes to _textController
    searchResultList();
  }

  // show matching results to search query
  searchResultList() {
    var showResults = [];
    if (_textController != '') {
      for (var restaurant in _allResults) {
        var name = restaurant.name.toString().toLowerCase();
        var cuisine = restaurant.cuisine;
        if (!_cuisinesList.contains(cuisine)) {
          _cuisinesList.add(cuisine);
        }
        if (!_selectedCuisines.isEmpty) {
          if (name.contains(_textController.text.toLowerCase()) && _selectedCuisines.contains(cuisine)) {
            showResults.add(restaurant);
          }
        } else {
          if (name.contains(_textController.text.toLowerCase())) {
            showResults.add(restaurant);
          }
        }
      }
    } else {
      showResults = List.from(_allResults);
    }

    setState(() {
      _resultList = showResults;
    });
  }

  // function to open filter page and pass all unique cuisines and currently filtered cuisines 
  Future<void> filterResults(BuildContext context) async {
    final filters = await Navigator.push(context, MaterialPageRoute(builder: (context) => FilterPage(cuisines: _cuisinesList, filters: _selectedCuisines,)));
    _selectedCuisines = filters;
    searchResultList();
  }

  @override
  void initState() {
   _textController.addListener(_onSearchChanged);
    super.initState();
  }

  @override
  void dispose() {
    _textController.removeListener(_onSearchChanged);
    _textController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    initList();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuDrawer(pageName),
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(
          color: Colors.black,
          size: 30.0
        ),
        actions: [
          // filter button
          Builder(
            builder: (context) {
              return IconButton(
                  // opens filter page
                  onPressed: () => filterResults(context),
                  icon: Icon(Icons.filter_alt_rounded),
                  iconSize: 36,
                );
            }
          ),
            
        ],
        // searchbar
        title: Container(
          height: 40.0,
          decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(5)
            ),
          child: TextField(
            controller: _textController,
            autocorrect: false,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(top: 4.0),
              // search icon, unfocuses textfield when pressed
              prefixIcon: IconButton(
                icon: Icon(
                  Icons.search_rounded,
                  color: Colors.black,
                ),
                onPressed: () => FocusScope.of(context).unfocus(),
              ),
              // undos whatever the user has searched
              suffixIcon: IconButton(
                  icon: Icon(
                    Icons.clear_rounded,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    _textController.text = "";
                  }),
              hintText: 'Search...',
              hintStyle: TextStyle(
                fontSize: 16.0,
              ),
              border: InputBorder.none,
            ),
          )
        )
      ),
      // list of restaurants
      body: ListView.separated(
        separatorBuilder: (BuildContext context, int index) => 
          const Divider(color: Colors.black, thickness: 0.5, height: 0.0),
        itemCount: _resultList.length,
        itemBuilder: (context, index) {
          return ListTile(
            // TODO: get images to display 
            // leading: CircleAvatar(
            //   radius: 25.0,
            //   backgroundColor: Colors.grey,
            // ),
            title: Text(_resultList[index].name,),
            subtitle: Text(_resultList[index].location),
            trailing: _resultList[index].cuisine != null
                        ? Text(_resultList[index].cuisine)
                              : Text(""),
            onTap: () => 
              Navigator.push(context, MaterialPageRoute(builder: (context) => 
                RestaurantPage(restaurant: _resultList[index]))
          ));
        },
      )
    );
  }
}