// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class FilterPage extends StatefulWidget {
  List cuisines;
  List filters;
  FilterPage({
    super.key,
    required this.cuisines,
    required this.filters,
  });

  List? tempList;

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {

  // get the initial filters in case user cancels applying filters
  @override
  void initState() {
    widget.tempList = List.from(widget.filters);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[300],
      child: Column(
        children: [
          // drawer header
          Container(
            height: 140.0,
            width: 500,
            child: DrawerHeader(
              decoration: BoxDecoration(color: Colors.green[400]),
              child: Text(
                "Filter by cuisine",
                style: TextStyle( 
                  fontWeight: FontWeight.bold,
                  fontSize: 24
                )
              )
            ),
          ),
          // filter buttons for each cuisine
          Wrap(
            children: 
              widget.cuisines.map((cuisine) => 
              cuisine != null
              ? Padding(
                padding: const EdgeInsets.only(left: 4.0, right: 4.0, top: 2.0),
                child: FilterChip(
                  label: Text(cuisine, style: TextStyle(color: Colors.black)), 
                  selected: widget.filters.contains(cuisine),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        widget.filters.add(cuisine);
                      } else {
                        widget.filters.remove(cuisine);
                      }
                    });
                  },
                  showCheckmark: false,
                  selectedColor: Colors.green,
                  side: BorderSide(color: Colors.black)
                )
              )
              : SizedBox())
            .toList()
              
          ),

          SizedBox(height: 25.0),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // cancel filters
              SizedBox(
                width: 80.0,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context, widget.tempList),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        "Cancel",
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(width: 15.0),

              // Apply filters
              SizedBox(
                width: 80.0,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context, widget.filters),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        "Apply",
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              
            ],
          )

        ],
      )
    
    );
  }
}