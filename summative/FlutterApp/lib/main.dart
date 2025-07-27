import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(CropYieldApp());

class CropYieldApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crop Yield Predictor',
      theme: ThemeData(primarySwatch: Colors.green),
      home: CropYieldForm(),
    );
  }
}

class CropYieldForm extends StatefulWidget {
  @override
  _CropYieldFormState createState() => _CropYieldFormState();
}

class _CropYieldFormState extends State<CropYieldForm> {
  final _formKey = GlobalKey<FormState>();

  // ✅ Replace this with your actual API endpoint
  final String apiUrl = "https://your-api-url.onrender.com/predict";

  final TextEditingController rainfallController = TextEditingController();
  final TextEditingController temperatureController = TextEditingController();
  final TextEditingController pesticideController = TextEditingController();

  String result = "";

  Future<void> predictYield() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final double rainfall = double.parse(rainfallController.text);
      final double temperature = double.parse(temperatureController.text);
      final double pesticide = double.parse(pesticideController.text);

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "rainfall": rainfall,
          "temperature": temperature,
          "pesticide": pesticide,
        }),
      );

      if (response.statusCode == 200) {
        final prediction = json.decode(response.body);
        setState(() {
          result =
              "✅ Predicted Yield: ${prediction['prediction'].toStringAsFixed(2)} tons/ha";
        });
      } else {
        setState(() {
          result = "❌ Error: ${response.reasonPhrase}";
        });
      }
    } catch (e) {
      setState(() {
        result = "❌ Exception: ${e.toString()}";
      });
    }
  }

  @override
  void dispose() {
    rainfallController.dispose();
    temperatureController.dispose();
    pesticideController.dispose();
    super.dispose();
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) return 'Field required';
        if (double.tryParse(value) == null) return 'Enter valid number';
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Crop Yield Predictor')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(
                label: 'Rainfall (mm)',
                controller: rainfallController,
              ),
              SizedBox(height: 16),
              _buildTextField(
                label: 'Temperature (°C)',
                controller: temperatureController,
              ),
              SizedBox(height: 16),
              _buildTextField(
                label: 'Pesticide Use (kg/ha)',
                controller: pesticideController,
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: predictYield,
                child: Text('Predict'),
              ),
              SizedBox(height: 20),
              Text(
                result,
                style: TextStyle(fontSize: 18, color: Colors.black87),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
