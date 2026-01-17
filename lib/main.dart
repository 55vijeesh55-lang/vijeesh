import 'package:flutter/material.dart';

void main() {
  //runApp(BMydemo());
  runApp(const Mydema()); 
}

class Mydema extends StatefulWidget {
  const Mydema({super.key});

  @override
  State<Mydema> createState() => MydemoState();
}

class MydemoState extends State<Mydema> {
  @override
  Widget build(BuildContext context) {
    return (MaterialApp(
        home: Column(children: <Widget>[
      Container(
          height: MediaQuery.of(context).size.height / 5,
          color: Colors.blue,
        padding: new EdgeInsets.all(8.0),
          width: MediaQuery.of(context).size.width,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            color: Colors.greenAccent,
            elevation: 5,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const ListTile(

                  title: Text(' Suseela Software innovation.AI', style: TextStyle(fontSize: 20.0)),
                  subtitle: Text(' Technopark', style: TextStyle(fontSize: 18.0)),
                ),
/*
                ButtonBar(
                  children: <Widget>[
                    ElevatedButton(
                      child: const Text('available'),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Mydema()));
                      },
                    ),
                    ElevatedButton(
                      child: const Text('Register'),
                      onPressed: () {},
                    ),
                  ],
                ),
*/
              ],
            ),
          )),

          Container(
              height: MediaQuery.of(context).size.height / 5,
              color: Colors.blue,
              padding: new EdgeInsets.all(8.0),
              width: MediaQuery.of(context).size.width,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                color: Colors.greenAccent,
                elevation: 5,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const ListTile(
                      //leading: Icon(Icons.account_balance_outlined, size: 20),
                      title: Text('software information', style: TextStyle(fontSize: 20.0)),
                      subtitle: Text(' Mob app Web applications.', style: TextStyle(fontSize: 18.0)),
                    ),
               /*     ButtonBar(
                      children: <Widget>[
                        ElevatedButton(
                          child: const Text('available'),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Mydema()));
                          },
                        ),
                        ElevatedButton(
                          child: const Text('Register'),
                          onPressed: () {},
                        ),
                      ],
                    ),*/
                  ],
                ),
              )),
          Container(
              height: MediaQuery.of(context).size.height / 5,
              color: Colors.purple,
              padding: new EdgeInsets.all(8.0),
              width: MediaQuery.of(context).size.width,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                color: Colors.white70,
                elevation: 5,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const ListTile(
                      //leading: Icon(Icons.account_balance_outlined, size: 20),
                      title: Text('Hadware Chiplevel Servicing', style: TextStyle(fontSize: 20.0)),
                     subtitle: Text(' Sale', style: TextStyle(fontSize: 18.0)),
                    ),
              /*      ButtonBar(
                      children: <Widget>[
                        ElevatedButton(
                          child: const Text('available'),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Mydema()));
                          },
                        ),
                        ElevatedButton(
                          child: const Text('Register'),
                          onPressed: () {},
                        ),
                      ],
                    ),*/
                  ],
                ),
              )),
          Container(
              height: MediaQuery.of(context).size.height / 4,
              color: Colors.blue,
              padding: new EdgeInsets.all(8.0),
              width: MediaQuery.of(context).size.width,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                color: Colors.greenAccent,
                elevation: 5,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const ListTile(
                      //leading: Icon(Icons.account_balance_outlined, size: 20),
                      title: Text('our mob applicatioss', style: TextStyle(fontSize: 20.0)),
                      subtitle: Text(' new update technology', style: TextStyle(fontSize: 18.0)),
                    ),
                    ButtonBar(
                      children: <Widget>[
                        ElevatedButton(
                          child: const Text('appdown load'),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Mydema()));
                          },
                        ),
                        ElevatedButton(
                          child: const Text('moreenquery'),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              )),

          /*Container(
              height: MediaQuery.of(context).size.height /9,
              color: Colors.red,
              padding: new EdgeInsets.all(1.0),
              width: MediaQuery.of(context).size.width,
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
                      title: Text(' Emergeny Help Police Station ' , style: TextStyle(fontSize: 30.0)),
                      //subtitle: Text(' around 5.5 km.', style: TextStyle(fontSize: 18.0)),
                    ),
             *//*       ButtonBar(
                      children: <Widget>[
                        ElevatedButton(
                          child: const Text('available'),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Mydema()));
                          },
                        ),
                        ElevatedButton(
                          child: const Text('Register'),
                          onPressed: () {},
                        ),
                      ],
                    ),*//*
                  ],
                ),
              ))*/


    ]),));
  }
}

/*
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => MyhomePageState();
}

class MyhomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: Colors.greenAccent,
        elevation: 10,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
                height: 50.0,
                width: 300.0,
                child: const ListTile(
                  title: Text('Aya  ', style: TextStyle(fontSize: 30.0)),
                  subtitle: Text('8*', style: TextStyle(fontSize: 18.0)),
                )),
            OverflowBar(
              children: <Widget>[
                ElevatedButton(
                  child: const Text('call'),
                  onPressed: () {},
                ),
                ElevatedButton(
                  child: const Text('map'),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
*/
/*
MaterialApp(
theme: ThemeData(
brightness: Brightness.dark,
),
home: Row(
children: <Widget>[
Expanded(
child:
Text('Deliver features faster'),
),
Expanded(
child: Text('Craft beautiful UIs'),
),
Expanded(
child: Container(color: Colors.red,
child: FlutterLogo(),
),
),
]
)

//home: Center(child: Text('woww'))

);*/
