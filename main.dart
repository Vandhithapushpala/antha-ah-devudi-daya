// import 'dart:js';

// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'UserPage.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MaterialApp(home: MainPage()));
}
class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('All Users'),
    ),
    body: StreamBuilder(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        if (streamSnapshot.hasData) {
          return ListView.builder(
            itemCount: streamSnapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final DocumentSnapshot documentSnapshot =
              streamSnapshot.data!.docs[index];
              // return Container(
              //
              //
              //   margin: EdgeInsets.all(30),
              //   padding: EdgeInsets.all(10),
              //   decoration: BoxDecoration(
              //       color: Colors.white,
              //
              //       borderRadius: BorderRadius.all(Radius.circular(10.0)),
              //       boxShadow: [
              //         BoxShadow(
              //           color: Color.fromARGB(255, 191, 219, 254),
              //           blurRadius: 20.0,
              //         ),
              //       ]),
              //   child: ListTile(
              //     title: Text(documentSnapshot['name']),
              //     subtitle: Text(documentSnapshot['section'].toString()),
              //   ),
              //
              //
              //
              // );

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text(documentSnapshot['name']),
                  subtitle: Text(documentSnapshot['section']),
                  trailing: SizedBox(
                    width: 100,
                    child: IconButton(
                        alignment: Alignment.topRight,
                        icon: const Icon(Icons.delete),
                        onPressed: (){
                          showDialog(context: context,
                          builder:(context){
                            return Container(
                            child: AlertDialog(
                            title: Text("Do you want to delete?"),
                            actions: [
                              TextButton(onPressed: (){
                                Navigator.pop(context);
              }, child: Text("NO")),
                              TextButton(onPressed: (){
                                _delete(documentSnapshot.id);
                                Navigator.pop(context);
                              }, child: Text("YES"))
              ],
                            ),
                            );

              });
              },
                        // onPressed: () =>
                        //     _delete(documentSnapshot.id)),
                    // child: Row(
                    //   children: [
                    //     IconButton(
                    //         icon: const Icon(Icons.edit),
                    //         onPressed: (){},
                    //         // onPressed: () =>
                    //         //     _update(documentSnapshot)
                    //     ),
                    //     IconButton(
                    //       alignment: Alignment.topRight,
                    //         icon: const Icon(Icons.delete),
                    //         onPressed: () =>
                    //             _delete(documentSnapshot.id)),
                    //   ],
                    // ),
                  ),
                ),
              ));
            },
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    ),


    floatingActionButton: FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: (){
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context)=> Udd(),
        ));
      },
    ),
  );
  Future<void> _delete(String productId) async {
    context: context;
    await FirebaseFirestore.instance.collection('users').doc(productId).delete();

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully deleted a product')));

  }
  Widget buildUser(User user) => ListTile(
    //leading: CircleAvatar(child: Text('${user.name}')),
    title: Text(user.name),
    subtitle: Text(user.section),
  );
  Future createUser(User user) async{
    final docUser = FirebaseFirestore.instance.collection('users').doc();
    user.id=docUser.id;
    final json = user.toJson();
    await docUser.set(json);
  }
  Stream<List<User>> readUsers() => FirebaseFirestore.instance
      .collection('users')
      .snapshots()
      .map((snapshots) => snapshots.docs.map((doc) => User.fromJson(doc.data())).toList());
}

// static User fromJson(Map < String,dynamic> json) => User(
// id: json['id'],
// name: json['name'],
// section: json['section'],
// );