

import 'package:flutter/material.dart';
import 'package:vijeesh/page3.dart';
import 'package:vijeesh/page5.dart';
import 'package:vijeesh/page6.dart';
import 'package:vijeesh/user_model.dart';

import 'page4.dart';


void main()
{
  runApp(const Mydemo());
}


class Mydemo extends StatefulWidget {
  const Mydemo({ super.key });

  @override
  State<Mydemo> createState() => MydemoState();
}

class MydemoState extends State<Mydemo> {
  @override
  Widget build(BuildContext context)
  {
    return (MaterialApp(home: const MyHomePage(),));
  }
}
class MyHomePage extends StatefulWidget {
  const MyHomePage({ super.key });

  @override
  State<MyHomePage> createState() => MyhomePageState();
}

class MyhomePageState extends State<MyHomePage> {

//  UserModel _userModel = UserModel();

  @override
  Widget build(BuildContext context) {
    return (Column(children: <Widget>[ Container(
      width: 400,
      height: 150,
      padding: new EdgeInsets.all(2.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: Colors.orange,
        elevation: 10,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const ListTile(
              leading: Icon(Icons.account_balance_outlined, size: 20),
              title: Text(
                  ' Home Stay  ',
                  style: TextStyle(fontSize: 30.0)
              ),
              subtitle: Text(
                  '5.5 km.',
                  style: TextStyle(fontSize: 18.0)
              ),
            ),
            ButtonBar(
              children: <Widget>[

                ElevatedButton
                  (
                  child: const Text('available'),
                  onPressed: () {Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                          MyFirestoreDataDisplay()));
                  },
                ),
                ElevatedButton(
                  child: const Text('Register'),
                  onPressed: ()
                  { Navigator.push(context,MaterialPageRoute(builder:( context)=> ProfilePage ())); },
                ),
              ],
            ),
          ],
        ),
      ),
    ),



      Container(
        width: 400,
        height: 150,
        padding: new EdgeInsets.all(2.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          color: Colors.greenAccent,
          elevation: 10,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const ListTile(
                leading: Icon(Icons.account_balance_outlined, size: 20),
                title: Text(
                    'Ayurveda  ',
                    style: TextStyle(fontSize: 30.0)
                ),
                subtitle: Text(
                    '5.5 km.',
                    style: TextStyle(fontSize: 18.0)
                ),
              ),
              ButtonBar(
                children: <Widget>[

                  ElevatedButton
                    (
                    child: const Text('available'),
                    onPressed: () { /*Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                            const Mydema()));*/
                    },
                  ),
                  ElevatedButton(
                    child: const Text('Register'),
                    onPressed: ()
                    {  },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),

      Container(
        width: 400,
        height: 150,
        padding: new EdgeInsets.all(2.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          color: Colors.amber,
          elevation: 10,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const ListTile(
                leading: Icon(Icons.account_balance_outlined, size: 20),
                title: Text(
                    'Bar & Hotel ',
                    style: TextStyle(fontSize: 30.0)
                ),
                subtitle: Text(
                    '5.5 km.',
                    style: TextStyle(fontSize: 18.0)
                ),
              ),
              ButtonBar(
                children: <Widget>[

                  ElevatedButton
                    (
                    child: const Text('available'),
                    onPressed: () { /*Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                            const Mydema()));*/
                    },
                  ),
                  ElevatedButton(
                    child: const Text('Register'),
                    onPressed: ()
                    { /*Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                            const BMydemo ()));*/ },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      Container( //width: MediaQuery(data: data, child: child),
          width: 400,
          height: 150,
          padding: new EdgeInsets.all(2.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            color: Colors.blue,
            elevation: 5,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const ListTile(
                  // leading: Icon(Icons.accessibility_new_outlined, size: 20),
                  title: Text(
                      'Tourist Place ',
                      style: TextStyle(fontSize: 30.0)
                  ),
                  subtitle: Text(
                      '5.5 km.',
                      style: TextStyle(fontSize: 15.0)
                  ),
                ),
                ButtonBar(
                  children: <Widget>[

                    /* ElevatedButton
                  (
                  child: const Text('available'),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                            const Mydema()));

                  },
                ),*/
                    ElevatedButton(
                      child: const Text('Register'),
                      onPressed: ()
                      {
                        /*Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const BMydemo ()));*/  },
                    ),
                  ],
                ),
              ],
            ),
          )),
      Container(
          height: 150,
          color: Colors.red,
          padding: new EdgeInsets.all(1.0),
          width: 400,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            color: Colors.amber,
            elevation:5,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const ListTile(
                  //leading: Icon(Icons.account_balance_outlined, size: 20),
                  title: Text(' Emergeny Help Police Station ' , style: TextStyle(fontSize: 10.0)),
                  //subtitle: Text(' around 5.5 km.', style: TextStyle(fontSize: 18.0)),
                ),
                ButtonBar(
                  children: <Widget>[
                    ElevatedButton(
                      child: const Text('available'),
                      onPressed: () {
                        /*Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const ));*/
                      },
                    ),
                    ElevatedButton(
                      child: const Text('Register'),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ))

    ],));
  }


}


