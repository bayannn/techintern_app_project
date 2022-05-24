import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:techintern_app_project/models/posts.dart';
import 'package:techintern_app_project/widgets/list_design.dart';

class OfferList extends StatefulWidget {
  final String? city,
      salary,
      language,
      specialization,
      endOfTheDay,
      startOfTheDay;
  const OfferList(
      {Key? key,
      required this.city,
      required this.salary,
      required this.language,
      required this.specialization,
      required this.endOfTheDay,
      required this.startOfTheDay})
      : super(key: key);

  @override
  State<OfferList> createState() => _OfferListState();
}

class _OfferListState extends State<OfferList> {
  List<Posts> listdata = [];
  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {});
    print("data__:${widget.language}");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Training",
            style: TextStyle(color: Color(0xff3B7753)),
          ),
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Color(0xff3B7753)),
          centerTitle: true,
        ),
        body: FutureBuilder(
            future: getList(),
            builder: (context, AsyncSnapshot<List<Posts>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator());
              }
              if (snapshot.connectionState == ConnectionState.done) {
                var total = snapshot.data ?? "";
                if (total != "") {
                  if (snapshot.data!.length > 0) {
                    print('found');
                    return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: ((context, index) {
                          return ListDesign(
                              listData: snapshot.data!.elementAt(index));
                        }));
                  } else {
                    return Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.hourglass_empty),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "No Results found",
                              style: TextStyle(),
                            )
                          ],
                        ));
                  }
                } else {
                  return Container(
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.hourglass_empty),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "No Results found",
                            style: TextStyle(),
                          )
                        ],
                      ));
                }
              }

              return const CircularProgressIndicator();
            }));
  }

  Future<List<Posts>> getList() async {
    Query<Map<String, dynamic>> query =
        FirebaseFirestore.instance.collection("posts");

    if (widget.city != "") {
      query = query.where('city', isEqualTo: widget.city);
    }
    if (widget.salary != "") {
      query = query.where('salary', isEqualTo: widget.salary);
    }
    if (widget.specialization != "") {
      query = query.where('sepcialization', isEqualTo: widget.specialization);
    }
    if (widget.language != "") {
      query = query.where('programmingLang', isEqualTo: widget.language);
    }

    query = query.where('sDate', isEqualTo: widget.startOfTheDay);
    query = query.where('eDate', isEqualTo: widget.endOfTheDay);

    QuerySnapshot<Map<String, dynamic>> data = await query.get();

    List<Posts> listdataLocal = [];

    for (var element in data.docs) {
      Posts _listData = Posts.fromMap(element.data());

      listdataLocal.add(_listData);
      print('found it');
    }

    return listdataLocal;
  }
}
