import 'package:flutter/material.dart';
import 'package:xml/xml.dart';
import 'package:http/http.dart' as http;

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
      home: const MyHomePage(title: 'Конвертер валют'),
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
  // List<String> currencyNames = ["RUB", "USD", "EUR"];
  List<String> currencyNames = ["None"];
  List<String> currencyNamesFull = [];
  List<String> currencyValues = [];
  Map<String, String> dictionary = {};
  String dropdownValueIn = 'None';
  String dropdownValueOut = 'None';

  @override
  void initState() {
    setState(() {
      super.initState();
      // Вызываем функцию при инициализации состояния
      fetchCurrencyDataToDropdown();
      // if (currencyNames[0] != 'None') {
      //   dropdownValueIn = currencyNames.first;
      //   dropdownValueOut = currencyNames.first;
      // } else {
      //   dropdownValueIn = ''; // Или любое другое значение по умолчанию
      //   dropdownValueOut = ''; // Или любое другое значение по умолчанию
      // }
    });
  }

  void _incrementCounter() {
    setState(() {
      // fetchCurrencyData();
    });
  }

  Future<void> fetchCurrencyData() async {
    final url = 'https://www.cbr.ru/scripts/XML_daily.asp';
    final response = await http.get(Uri.parse(url));
    currencyNames = [];
    if (response.statusCode == 200) {
      // Успешно получили данные
      final document = XmlDocument.parse(response.body);

      // Пример: получить информацию о всех валютах
      final currencies = document.findAllElements('Valute');

      for (var currency in currencies) {
        final charCode = currency.findElements('CharCode').first.text;
        currencyNames.add(charCode);
        final name = currency.findElements('Name').first.text;
        currencyNamesFull.add(name);
        final value = currency.findElements('Value').first.text;
        currencyValues.add(value);
        print('Валюта: $charCode, Название: $name, Стоимость: $value');
      }
      dictionary = Map.fromIterables(currencyNames, List.generate(currencyNames.length,
              (index) => currencyNamesFull[index]));
      print(dictionary);
      setState(() {});
      print(currencyNames);
    } else {
      throw Exception('Не удалось загрузить данные: ${response.statusCode}');
    }
  }

  Future<void> fetchCurrencyDataToDropdown() async {
    // Здесь вы подгружаете данные и обновляете currencyNames
    await fetchCurrencyData();

    // После подгрузки данных
    if (currencyNames.isNotEmpty) {
      // Устанавливаем dropdownValueOut на первое значение в currencyNames
      dropdownValueIn = currencyNames[0];
      dropdownValueOut = currencyNames[0];
    }

    // обновляем состояние
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Visibility(
                visible: currencyNames[0] == 'None',
                child: Center(child: CircularProgressIndicator()),
              ),
              Visibility(
                  visible: currencyNames[0] != 'None',
                  child: Container(
                    child: Column(
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
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                    textAlign: TextAlign.center,
                                    // decoration: InputDecoration(labelText: "Очков для победы"),
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      enterAmount = int.parse(value);
                                    }),
                              ),
                              // DropdownButton<String>(
                              //   value: dropdownValueIn,
                              //   items: currencyNames.map((String value) {
                              //     return DropdownMenuItem<String>(
                              //       value: value,
                              //       child: Text(
                              //         value,
                              //         style: TextStyle(fontSize: 20),
                              //       ),
                              //     );
                              //   }).toList(),
                              //   onChanged: (String? newValueSelected) {
                              //     print(dropdownValueIn);
                              //     setState(() {
                              //       dropdownValueIn = newValueSelected!;
                              //     });
                              //     print(dropdownValueIn);
                              //   },
                              // ),
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
                                onChanged: (String? newValueSelected) {
                                  print(dropdownValueIn);
                                  setState(() {
                                    dropdownValueIn = newValueSelected!;
                                  });
                                  print(dropdownValueIn);
                                },
                              ),
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
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                    textAlign: TextAlign.center,
                                    // decoration: InputDecoration(labelText: "Очков для победы"),
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      enterAmount = int.parse(value);
                                    }),
                              ),
                              Visibility(
                                visible: currencyNames[0] != 'None',
                                child: DropdownButton<String>(
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
                                  onChanged: (String? newValueSelected) {
                                    print(dropdownValueOut);
                                    setState(() {
                                      dropdownValueOut = newValueSelected!;
                                    });
                                    print(dropdownValueOut);
                                  },
                                ),
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
                  )),
            ])
        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
