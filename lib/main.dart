import 'package:flutter/material.dart';
import 'package:xml/xml.dart';
import 'package:http/http.dart' as http;
import 'package:charset/charset.dart';

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
  double enterAmount = 0;
  // List<String> currencyNames = ["RUB", "USD", "EUR"];
  List<String> currencyNames = ["None"];
  List<String> currencyNamesFull = [];
  List<double> currencyValues = [];
  Map<String, String> dictionary = {};
  String dropdownValueIn = 'None';
  String dropdownValueOut = 'None';
  String convertString = '';
  String inValue = '';
  String outValue = '';
  double inAmount = 0;
  double outAmount = 0;
  TextEditingController _inController = TextEditingController();
  TextEditingController _outController = TextEditingController();

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

  @override
  void dispose() {
    _inController.dispose();
    _outController.dispose();
    super.dispose();
  }

  Future<void> fetchCurrencyData() async {
    final url = 'https://www.cbr.ru/scripts/XML_daily.asp';
    final response = await http.get(Uri.parse(url));
    currencyNames = [];
    if (response.statusCode == 200) {
      // Успешно получили данные
      final document = XmlDocument.parse(response.body);

      final currencies = document.findAllElements('Valute');

      currencyNames.add("RUB");
      currencyNamesFull.add("Российский рубль");
      currencyValues.add(1);

      for (var currency in currencies) {
        final charCode = currency.findElements('CharCode').first.innerText;
        currencyNames.add(charCode);

        final bytes = currency
            .findElements('Name')
            .first
            .innerText
            .codeUnits; // Получаем коды символов
        // Преобразуйте кодовые единицы в байты
        List<int> windows1251Bytes = bytes;
        // Декодируем байты Windows-1251 в строку
        String name = windows1251.decode(windows1251Bytes);
        currencyNamesFull.add(name);

        final value = currency.findElements('Value').first.innerText;
        currencyValues.add(double.parse(value.replaceAll(',', '.')));
        print('Валюта: $charCode, Название: $name, Стоимость: $value');
      }
      setState(() {});
      print(currencyNames);
    } else {
      throw Exception('Не удалось загрузить данные: ${response.statusCode}');
    }
  }

  void makeConvertString(inValue, outValue) {
    convertString = "Переводим\n${inValue}\nв\n${outValue}";
  }

  // // Метод для получения полного названия валюты
  // String getFullCurrencyName(String code) {
  //   int index = currencyNames.indexOf(code);
  //   return currencyNamesFull[index];
  // }

  Future<void> fetchCurrencyDataToDropdown() async {
    // Здесь вы подгружаете данные и обновляете currencyNames
    await fetchCurrencyData();

    // После подгрузки данных
    if (currencyNames.isNotEmpty) {
      // Устанавливаем dropdownValueOut на первое значение в currencyNames
      dropdownValueIn = currencyNames[0];
      dropdownValueOut = currencyNames[1];
    }
    if (currencyNamesFull.isNotEmpty) {
      inValue = currencyNamesFull[0];
      outValue = currencyNamesFull[1];
    }
    makeConvertString(inValue, outValue);
    // обновляем состояние
    setState(() {});
  }

  double convertValue(inAmount, inV, outV) {
    // currencyNamesFull[currencyNames.indexOf(dropdownValueIn)]
    outAmount = inAmount / inV * outV;
    return outAmount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
            child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
              Visibility(
                visible: currencyNames[0] == 'None',
                child: Container(
                    // margin: EdgeInsets.only(top: 100),
                    height: MediaQuery.of(context)
                        .size
                        .height, // Занять всю высоту экрана
                    width: MediaQuery.of(context).size.width,
                    child: Center(child: CircularProgressIndicator())),
              ),
              Visibility(
                  visible: currencyNames[0] != 'None',
                  child: Container(
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 60, 0, 70),
                          child: Text(
                            convertString,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 23, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          margin: EdgeInsets.symmetric(horizontal: 25),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Color(0xff62e7d5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                // margin: EdgeInsets.fromLTRB(0, 50, 0, 50),
                                width: 150,
                                child: TextField(
                                    controller: _inController,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                    textAlign: TextAlign.center,
                                    // decoration: InputDecoration(labelText: "Очков для победы"),
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      enterAmount = double.parse(value);
                                      inAmount = double.parse(
                                          enterAmount.toStringAsFixed(2));
                                    }),
                              ),
                              DropdownButton<String>(
                                value: dropdownValueIn,
                                items: currencyNames.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Container(
                                      child: Text(
                                        value,
                                        style: TextStyle(
                                            fontSize: 18),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                style: TextStyle(color: Colors.black),
                                onChanged: (String? newValueSelected) {
                                  setState(() {
                                    dropdownValueIn = newValueSelected!;
                                    inValue = currencyNamesFull[
                                        currencyNames.indexOf(dropdownValueIn)];
                                    makeConvertString(inValue, outValue);
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        IconButton(
                          icon: Icon(Icons.repeat_outlined, size: 35),
                          onPressed: () {
                            print("inAmount = ${inAmount}");
                            outAmount = convertValue(
                                inAmount,
                                currencyValues[
                                    currencyNamesFull.indexOf(outValue)],
                                currencyValues[
                                    currencyNamesFull.indexOf(inValue)]);
                            print("Перевели ${inAmount} в ${outAmount}");
                            _inController.text = inAmount.toStringAsFixed(2);
                            _outController.text = outAmount.toStringAsFixed(2);
                          },
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          margin: EdgeInsets.symmetric(horizontal: 25),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Color(0xff62e7d5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                // margin: EdgeInsets.fromLTRB(0, 50, 0, 50),
                                width: 150,
                                child: TextField(
                                    controller: _outController,
                                    readOnly: true,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      // enterAmount = double.parse(value);
                                      _outController.text =
                                          outAmount.toString();
                                    }),
                              ),
                              DropdownButton<String>(
                                  value: dropdownValueOut,
                                  // hint: Text('Select an item'),
                                  items: currencyNames.map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Container(
                                        // constraints: BoxConstraints(
                                        //   maxWidth:
                                        //       150, // Установите нужную максимальную ширину
                                        // ),
                                        child: Text(
                                          value,
                                          style: TextStyle(
                                              fontSize: 18),
                                          // overflow: TextOverflow
                                          //     .ellipsis, // Добавляем многоточие, если текст слишком длинный
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  // icon: Icon(Icons.arrow_drop_down),
                                  style: TextStyle(color: Colors.black),
                                  onChanged: (String? newValueSelected) {
                                    setState(() {
                                      dropdownValueOut = newValueSelected!;
                                      outValue = currencyNamesFull[currencyNames
                                          .indexOf(dropdownValueOut)];
                                      makeConvertString(inValue, outValue);
                                    });
                                  },
                                ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
            ])
            // This trailing comma makes auto-formatting nicer for build methods.
            ));
  }
}
