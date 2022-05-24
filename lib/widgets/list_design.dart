// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:techintern_app_project/models/posts.dart';

class ListDesign extends StatelessWidget {
  final Posts listData;
  const ListDesign({Key? key, required this.listData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Color(0xff3B7753),
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            children: [
              CachedNetworkImage(
                imageUrl: listData.imagePath!,
                height: 40,
                width: 40,
                placeholder: (context, url) => CircularProgressIndicator(
                  color: const Color(0xff3B7753),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
              Text(listData.companyName ?? "",
                  style: TextStyle(color: Colors.grey)),
            ],
          ),
          Row(
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              Text("Language : "),
              Text(
                listData.programmingLang!,
                style: TextStyle(color: const Color(0xff3B7753)),
              ),
            ],
          ),
          SizedBox(
            height: 3,
          ),
          Row(
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              Text("Specialization : "),
              Text(
                listData.sepcialization!,
                style: TextStyle(color: const Color(0xff3B7753)),
              ),
            ],
          ),
          SizedBox(
            height: 3,
          ),
          Row(
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              Text("Salary : "),
              Text(
                listData.salary!,
                style: TextStyle(color: const Color(0xff3B7753)),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              listData.description!,
              maxLines: 3,
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.032,
            ),
            Icon(Icons.location_on, color: Colors.grey),
            Text(
              listData.city ?? "",
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.032,
            ),
            Text(
              "${listData.sDate} - ${listData.eDate}",
              style: TextStyle(color: Colors.grey),
            ),
          ])
        ],
      ),
    );
  }
}
