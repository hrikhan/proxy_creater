import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(IPGeneratorApp());

class IPGeneratorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: IPGeneratorScreen(),
    );
  }
}

class IPGeneratorScreen extends StatefulWidget {
  @override
  _IPGeneratorScreenState createState() => _IPGeneratorScreenState();
}

class _IPGeneratorScreenState extends State<IPGeneratorScreen> {
  List<String> generatedIPs = [];
  final TextEditingController ipCountController = TextEditingController();
  final TextEditingController stringLengthController = TextEditingController();
  final random = Random();

  // Function to generate user-defined number of IPs
  void generateIPs() {
    final count = int.tryParse(ipCountController.text) ?? 0;
    final stringLength = int.tryParse(stringLengthController.text) ?? 0;

    if (count <= 0 || stringLength <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter valid numbers for both fields")),
      );
      return;
    }

    List<String> ips = [];
    for (int i = 0; i < count; i++) {
      String domain = "b2b-s10.liveproxies.io";
      int port = 7000 + random.nextInt(1000);
      String identifier = "LV${10000000 + random.nextInt(90000000)}-lv_US-${random.nextInt(999999)}";
      String randomString = generateRandomString(stringLength);
      ips.add("$domain:$port:$identifier:$randomString");
    }

    setState(() {
      generatedIPs = ips;
    });
  }

  // Generate random alphanumeric string
  String generateRandomString(int length) {
    const characters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return List.generate(length, (index) => characters[random.nextInt(characters.length)]).join();
  }

  // Copy all IPs to clipboard
  void copyToClipboard() {
    String allIPs = generatedIPs.join('\n');
    Clipboard.setData(ClipboardData(text: allIPs));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Generated IPs copied to clipboard")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("IP Generator"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: ipCountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Number of IPs",
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: stringLengthController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Length of Random String",
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal),
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: generateIPs,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              child: Text("Generate IPs"),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: generatedIPs.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(generatedIPs[index]),
                    tileColor: index % 2 == 0 ? Colors.teal.shade50 : Colors.white,
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: copyToClipboard,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              child: Text("Copy All IPs"),
            ),
          ],
        ),
      ),
    );
  }
}
