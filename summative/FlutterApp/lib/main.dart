import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crop Yield Predictor',
      theme: ThemeData(primarySwatch: Colors.green),
      home: PredictionPage(),
    );
  }
}

class PredictionPage extends StatefulWidget {
  @override
  _PredictionPageState createState() => _PredictionPageState();
}

class _PredictionPageState extends State<PredictionPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController yearController = TextEditingController();
  final TextEditingController rainfallController = TextEditingController();
  final TextEditingController pesticideController = TextEditingController();
  final TextEditingController tempController = TextEditingController();

  String result = '';

  Future<void> predictYield() async {
    final url = Uri.parse('https://ml-linear-regression-model.onrender.com/predict');

    final Map<String, dynamic> data = {
      "Item_Potatoes": 1,
      "Area_United_Kingdom": 1,
      "Item_Sweet_potatoes": 1,
      "Area_Japan": 1,
      "Year": int.parse(yearController.text),
      "average_rain_fall_mm_per_year": double.parse(rainfallController.text),
      "pesticides_tonnes": double.parse(pesticideController.text),
      "avg_temp": double.parse(tempController.text),
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        setState(() {
          result = 'Predicted Yield: ${jsonDecode(response.body)} hg/ha';
        });
      } else {
        setState(() {
          result = 'Error: ${response.statusCode} ${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        result = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Crop Yield Prediction')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: yearController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Year'),
              ),
              TextFormField(
                controller: rainfallController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Average Rainfall (mm/year)'),
              ),
              TextFormField(
                controller: pesticideController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Pesticides Used (tonnes)'),
              ),
              TextFormField(
                controller: tempController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Average Temperature (°C)'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: predictYield,
                child: Text('Predict'),
              ),
              SizedBox(height: 20),
              Text(result),
            ],
          ),
        ),
      ),
    );
  }
}
