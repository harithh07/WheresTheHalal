import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();

}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _textController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();

  final CollectionReference restaurantCollection = FirebaseFirestore.instance.collection('restaurants');

  List _allResults = [];
  List _resultList = [];

  getClientStream() async {
    // order restaurants by name, then by location name
    var data = await FirebaseFirestore.instance.collection('restaurants').orderBy('name').orderBy('location').get();

    setState(() {
      _allResults = data.docs;
    });
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
      for (var clientSnapshot in _allResults) {
        var name = clientSnapshot['name'].toString().toLowerCase();
        if (name.contains(_textController.text.toLowerCase())) {
          showResults.add(clientSnapshot);
        }
      }
    } else {
      showResults = List.from(_allResults);
    }

    setState(() {
      _resultList = showResults;
    });
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
    getClientStream();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.green,
        // searchbar
        title: Container(
          height: 40.0,
          decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(5)
            ),
          child: TextField(
            controller: _textController,
            
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(top: 4.0),
              prefixIcon: IconButton(
                icon: Icon(
                  Icons.search_rounded,
                  color: Colors.black,
                ),
                onPressed: () => FocusScope.of(context).unfocus(),
              ),
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
      body: ListView.builder(
        itemCount: _resultList.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              radius: 25.0,
              backgroundColor: Colors.grey,
            ),
            title: Text(_resultList[index]['name'],),
            subtitle: Text(_resultList[index]['location']),
            trailing: Text(_resultList[index]['cuisine']),
            onTap: () => print(_resultList[index]['name'] + ' ' + _resultList[index]['location'])
          );
        },
      )
    );
  }
}