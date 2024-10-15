import 'package:flutter/material.dart';
import 'package:xml/xml.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  var enterAmount = 0;
  List<String> currencyNames = ["RUB", "USD", "EUR"];
  String dropdownValueIn = "RUB";
  String dropdownValueOut = "USD";

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              margin: EdgeInsets.symmetric(horizontal: 50),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0xff62e7d5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    // margin: EdgeInsets.fromLTRB(0, 50, 0, 50),
                    width: 100,
                    child: TextField(
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                        // decoration: InputDecoration(labelText: "Очков для победы"),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          enterAmount = int.parse(value);
                        }),
                  ),
                  DropdownButton<String>(
                    value: dropdownValueIn,
                    items: currencyNames.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(fontSize: 20),
                        ),
                      );
                    }).toList(),
                    onChanged: (_) {},
                  ),
                  // DropdownButton<String>(
                  //   value: dropdownValueOut,
                  //   items: currencyNames.map((String value) {
                  //     return DropdownMenuItem<String>(
                  //       value: value,
                  //       child: Text(value, style: TextStyle(fontSize: 20)),
                  //     );
                  //   }).toList(),
                  //   onChanged: (_) {},
                  // ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Icon(Icons.repeat_outlined, size: 35),
            SizedBox(
              height: 30,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              margin: EdgeInsets.symmetric(horizontal: 50),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0xff62e7d5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    // margin: EdgeInsets.fromLTRB(0, 50, 0, 50),
                    width: 100,
                    child: TextField(
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                        // decoration: InputDecoration(labelText: "Очков для победы"),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          enterAmount = int.parse(value);
                        }),
                  ),
                  DropdownButton<String>(
                    value: dropdownValueOut,
                    items: currencyNames.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(fontSize: 20),
                        ),
                      );
                    }).toList(),
                    onChanged: (_) {},
                  ),
                  // DropdownButton<String>(
                  //   value: dropdownValueOut,
                  //   items: currencyNames.map((String value) {
                  //     return DropdownMenuItem<String>(
                  //       value: value,
                  //       child: Text(value, style: TextStyle(fontSize: 20)),
                  //     );
                  //   }).toList(),
                  //   onChanged: (_) {},
                  // ),
                ],
              ),
            )
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
