import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery/image-picker.dart';
import 'package:fooddelivery/model/user.dart';
import 'package:fooddelivery/pages/dishes-data-page.dart';
import 'package:fooddelivery/pages/restaurants-data-page.dart';
import 'package:fooddelivery/pages/restaurants.dart';
import 'package:fooddelivery/profile/user-profile.dart';
import 'package:fooddelivery/util/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? email;
  int index = 0;

  AppUser? appUser;
  Future fetchUserDetails() async {
    print("hello");
    String uid = await FirebaseAuth.instance.currentUser!.uid.toString();
    var document = await FirebaseFirestore.instance.collection(
        USERS_COLLECTION).doc(uid).get();
    // appUser =AppUser();
    // print("Hello $document.get['uid'].toString()");
    // appUser!.uid = document.get('uid').toString();
    // appUser!.name = document.get('name').toString();
    // appUser!.email = document.get('email').toString();
    // appUser!.imageUrl = document.get('imageUrl').toString();

    if (document.exists)
    {

      appUser =AppUser();
      // print("Hello $document.get['uid'].toString()");
      // appUser!.uid = document.get('uid').toString();
      // appUser!.name = document.get('name').toString();
      // appUser!.email = document.get('email').toString();
      // appUser!.imageUrl = document.get('imageUrl').toString();
      appUser!.isAdmin = document.get('isAdmin');
    }
    else{print("error");}
    return appUser;


  }
  check<Widget>(){
    // FirebaseApp secondaryApp = Firebase.app('FoodDelivery');
    User? user = FirebaseAuth.instance.currentUser;
    // firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instanceFor(app: secondaryApp);
    // firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref(user!.uid);
    // print("hi");
    return FutureBuilder(
        future: fetchUserDetails(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot){
          if (appUser!.isAdmin==true)
          {
            return IconButton(
                onPressed: (){

                  Navigator.push(
                      context, MaterialPageRoute(
                      builder: (context)=>
                          RestaurantsDataPage()
                  )
                  );
                },
                icon: Icon(Icons.add)
            );
          }
          else
            return Container();
        });

  }
  @override
  Widget build(BuildContext context) {
    print("Hi: ${context.runtimeType}");
    List<Widget> widgets = [
      RestaurantsPage(),
      Center(child: Text("Search Page"),),
      UserProfilePage()
    ];


    // check<Widget>(){
    //   User? user = FirebaseAuth.instance.currentUser;
    //   email=user!.email;
    //   if (email==ADMIN_EMAIL && index==0)
    //   {
    //     return IconButton(
    //         onPressed: (){
    //
    //           Navigator.push(
    //               context, MaterialPageRoute(
    //               builder: (context)=>
    //                   RestaurantsDataPage()
    //           )
    //           );
    //         },
    //         icon: Icon(Icons.add)
    //     );
    //   }
    //   else
    //     return Container();
    // }


    return Scaffold(

      appBar: AppBar(
        title: Text(APP_NAME),
        backgroundColor: Colors.yellow,
        actions: [
          check(),
          IconButton(
            onPressed: (){
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, "/login");
            }, icon: Icon(Icons.logout),
            tooltip: "Log Out",
          )
        ],
      ),

      body: widgets[index],

      bottomNavigationBar: BottomNavigationBar(
        items: [
          // 0
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "HOME"
          ),
          // 1
          BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: "SEARCH"
          ),
          //2
          BottomNavigationBarItem(
              icon: Icon(Icons.account_box),
              label: "PROFILE"
          )
        ],

        currentIndex: index,
        selectedFontSize: 16,
        selectedItemColor: Colors.yellow,
        onTap: (idx){ // idx will have value of the index of BottomNavBarItem
          setState(() {
            index = idx;
          });
        },
      ),

    );
  }
}