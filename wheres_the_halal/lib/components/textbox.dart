import 'package:flutter/material.dart';

class MyTextBox extends StatelessWidget {

  final String text;
  final String sectionName;
  void Function()? onPressed;
  MyTextBox({
    super.key,
    required this.text,
    required this.sectionName,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(5.0)
      ),
      padding: EdgeInsets.only(left: 15, bottom: 15),
      margin: EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section name
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                sectionName,
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 18.0
                )
              ),

              // edit button
              IconButton(
                onPressed: this.onPressed,
                icon: Icon(
                  Icons.settings,
                  color: Colors.grey[500],
                  size: 28
                )
              )
            ],
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: 18.0
            )
          )
        ],
      )
    );
  }

}



