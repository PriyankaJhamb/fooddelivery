import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery/pages/restaurants.dart';
import 'package:fooddelivery/util/constants.dart';

class TagsPage extends StatefulWidget {
  const TagsPage({Key? key}) : super(key: key);

  @override
  _TagsPageState createState() => _TagsPageState();
}

class _TagsPageState extends State<TagsPage> {

  fetchtags(){
    Stream<DocumentSnapshot> stream= FirebaseFirestore.instance.collection(Util.EXTRAS_COLLECTION).doc('tags').snapshots();
    return stream;
  }
  void UpdateTag(BuildContext context, String string) {
    // print(Util.appUser!.uid);
    // print(Util. appUser!.imageUrl);
    // FirebaseFirestore.instance
    //     .collection(Util.EXTRAS_COLLECTION)
    //     .doc("tags")
    //     .update({"filterOption": string});
    //

    if (string=="all"){
      Util.filterlist=["all"];
    }
    else if( Util.filterlist.contains("all")){
      Util.filterlist=[];
      Util.filterlist.add(string);
    }
    else
      {
        Util.filterlist.add(string);
      }
    print(string);
    // then((value) => Navigator.pushReplacementNamed(context, "/home"));
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: fetchtags(),
      builder: (BuildContext context,AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
                "SOMETHING WENT WRONG", style: TextStyle(color: Colors.red)),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }


        // return new Text(userDocument["tags"]);
        return ListView(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(
          ),
          children: [
            Container(
                height: 30,
                margin: EdgeInsets.all(8),
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(
                    ),
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data["tags"].length,

                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(2.0),

                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              UpdateTag(context, snapshot.data["tags"][index]
                                  .toString());
                            });

                            // Util.filter=snapshot.data["tags"][index];
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Util.filterlist.contains(snapshot.data["tags"][index])?Colors.green:Colors.green.shade200
                          ),
                          child: Text(snapshot.data["tags"][index]
                                .toString()),

                        ),
                      );
                    }
                )
            ),
            // RestaurantsPage(filter: "all")
            RestaurantsPage()
          ],
        );
      }
    );
  }
}


