//import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MaterialApp(home: Udd()));
}
class Udd extends StatefulWidget {
  const Udd({Key? key}) : super(key: key);

  @override
  State<Udd> createState() => _UddState();
}

class _UddState extends State<Udd> {
  
  final controllerName =TextEditingController();
  final controllerSection =TextEditingController();

  List<String> items = ["CSE A","CSE B","CSE C","CSE D","CSE E","CSE F","CSE G","IT A","IT B","CSM A","CSM B","CSDS",];
  String? selectedItem = "CSE A";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add user'),
        ),
        body: ListView(
          padding:EdgeInsets.all(16),
          children: <Widget>[
            TextField(
              controller: controllerName,
              decoration: InputDecoration(
                hintText: "Name",
              ),
              // decoration: decoration('Name'),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: controllerSection,
              decoration: InputDecoration(
                hintText: "Section",
              ),
              //decoration: decoration('Section'),
              //keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 32),
            Container(
              child: DropdownButton<String>(
                  value: selectedItem,
                  items: items
                      .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  )).toList(),
                  onChanged: (item) => setState(() => selectedItem = item)
              ),
            ),
            ElevatedButton(onPressed: (){
              final user=User(
                  name: controllerName.text,
                  section: controllerSection.text,
                  branch :selectedItem?? "CSE E",
              );
              Future createUser(User user) async{
                final docUser = FirebaseFirestore.instance.collection('users').doc();
                user.id=docUser.id;
                final json = user.toJson();
                await docUser.set(json);
              }
              createUser(user);
              Navigator.pop(context);
            }, child:
            Text('create'))
          ],
        )
    );
  }
}
class User{
  String id;
  final String name;
  final String section;
  final String branch;
  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
      //id: doc.data()['id'],
      name: doc.get('name'),
      section: doc.get('section'),
      branch: doc.get("branch"),
      // email: doc.data()['email'],
      // username: doc.data()['username'],
      // photoUrl: doc.data()['photoUrl'],
      // displayName: doc.data()['displayName'],
      // bio: doc.data()['bio'],
      // fullNames: doc.data()['fullNames'],
      // practice: doc.data()['practice'],
      // speciality: doc.data()['speciality'],
      // phone: doc.data()['phone'],
      // mobile: doc.data()['mobile'],
      // emergency: doc.data()['emergency'],
      // address: doc.data()['address'],
      // city: doc.data()['city'],
      // location: doc.data()['location'],
    );
  }
  //final DateTime birthday;

  User({
    this.id=' ',
    required this.name,
    required this.section,
    required this.branch,
    //required this.birthday,
  });
  Map<String, dynamic> toJson() =>{
    'id':id,
    'name':name,
    'section':section,
    "branch":branch,
    // 'age': age,
    // 'birthday':birthday,
  };
  static User fromJson(Map < String,dynamic> json) => User(
  id: json['id'],
  name: json['name'],
  section: json['section'],
      branch: json["branch"],
  );
}