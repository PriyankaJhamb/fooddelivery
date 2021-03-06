import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery/custom-widgets/ShowSnackBar.dart';

import 'package:fooddelivery/pages/location-page.dart';
import 'package:fooddelivery/pages/restaurants-data-page.dart';
import 'package:fooddelivery/pages/restaurants.dart';
import 'package:fooddelivery/pages/tags-page.dart';
import 'package:fooddelivery/profile/user-profile.dart';
import 'package:fooddelivery/util/constants.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // String? email;
  int index = 0;
  // Future fetchUserDetails() async {
  //   print("hello");
  //   String uid = await FirebaseAuth.instance.currentUser!.uid.toString();
  //   var document = await FirebaseFirestore.instance.collection(
  //       Util.USERS_COLLECTION).doc(uid).get();
    // if (document.exists)
    // {
    //
    //   appUser =AppUser();
    //   // print("Hello $document.get['uid'].toString()");
    //   // appUser!.uid = document.get('uid').toString();
    //   // appUser!.name = document.get('name').toString();
    //   // appUser!.email = document.get('email').toString();
    //   // appUser!.imageUrl = document.get('imageUrl').toString();
    //   appUser!.isAdmin = document.get('isAdmin');
    // }
    // else{
    //   appUser =AppUser();
    //   appUser!.isAdmin = false;
    //   print("error");
    // }
  //   return appUser;
  // }


  check<Widget>(){
    print("if (Util.appUser!.isAdmin == true && index==0) {");
    if (Util.appUser!.isAdmin == true && index==0) {
      return IconButton(
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => RestaurantsDataPage()));
          },
          icon: Icon(Icons.add)
      );
    }
    else
    {
      return Container();
    }
  }


  @override
  Widget build(BuildContext context) {
    print("Home Page : Util.appUser: ${Util.appUser}");
    if (Util.appUser==null)
    {
      print("function Util.fetchUserDetails(); starts");
      Util.fetchUserDetails();
      print("Inside function  Home Page : Util.appUser: ${Util.appUser}");
      print("function Util.fetchUserDetails(); ends");
    }

    print("Hi: ${context.runtimeType}");
    List<Widget> widgets = [
      TagsPage(),
      // Center(child: Text("Search Page"),),
      // ImagePickerWidget(),
      Center(child: Text("Search Page"),),
      UserProfilePage()
    ];


    //

    // Util.fetchUserDetails();

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
        title: Text(Util.APP_NAME),
        backgroundColor: Util.APP_COLOR,
        actions: [
          check(),
          IconButton(
            onPressed: (){
              Navigator.pushNamed(context, "/cart");
            }, icon: Icon(Icons.shopping_cart),
            tooltip: "Shopping Cart",
          ),

          IconButton(
            onPressed: (){
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, "/login");
            }, icon: Icon(Icons.logout),
            tooltip: "Log Out",
          )
        ],
      ),

      body:  Util.appUser!=null ?widgets[index]:Center(child: Text("Loading...........")),

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
        selectedItemColor: Util.APP_COLOR,
        onTap: (idx){ // idx will have value of the index of BottomNavBarItem
          setState(() {
            index = idx;
          });
        },
      ),

    );
  }
}




class ImagePickerWidget extends StatefulWidget {
  const ImagePickerWidget({Key? key}) : super(key: key);

  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {

  XFile? file;
  final ImagePicker Image_Picker = ImagePicker();

  ChooseImage_G() async {
    XFile? file = await Image_Picker.pickImage(source: ImageSource.gallery);
    setState(() {
      this.file = file;
    });
    return file;
  }
  Future<String> UploadImage(ImageFile) async {
    Show_Snackbar(context: context, message: "Uploading...");
    var uploadTask = await FirebaseStorage.instance.ref('profile-pics/'+"23dfdew23212"+'.png').putFile(ImageFile);
    Show_Snackbar(context: context, message: "Uploaded");
    String downlaodUrl = await uploadTask.ref.getDownloadURL();
    return downlaodUrl;
  }

  Future<String> handleUpdateUserProfile() async {
    Show_Snackbar(context: context, message: "start");
    var url = await ChooseImage_G();
    String mediaUrl = await UploadImage(url!.path); // Pass your file variable
    Show_Snackbar(context: context, message: "end");
    return mediaUrl;
    // Create/Update firesotre document
    // usersRef.document(userId).updateData(
    //     {
    //       "avatar": mediaUrl,
    //     }
    // );
  }

  var file_name = "";


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      padding:
      EdgeInsets.symmetric(horizontal: 11, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.black38,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.image,color: Colors.black45,size: 20,),
          SizedBox(width: 13,),
          SizedBox(
            width: 150,
            child: Text(
              file_name==""?"Select Image":file_name,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              textWidthBasis: TextWidthBasis.parent,
              style: TextStyle(
                  color: Color.fromARGB(148, 0, 0, 0),
                  fontSize: 16
              ),
            ),
          ),
          // SizedBox(
          //   height: 10,
          // ),
          Spacer(),
          OutlinedButton(
              child: Text("CHOOSE"),
              style: ButtonStyle(

              ),
              onPressed: () async{
                var file = await ChooseImage_G();
                setState(() {
                  file_name = file.name.toString().replaceAll("image_picker", "Image_edadasdad");
                });
                var url = await UploadImage(File(file!.path));
                Show_Snackbar(context: context, message: url);
              }
          )
        ],
      ),
    );
  }
}