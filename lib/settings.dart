import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSavedLocation();
  }

  Future<void> _loadSavedLocation() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _locationController.text = prefs.getString('savedLocation') ?? '';
    });
  }

  Future<void> _saveLocation() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('savedLocation', _locationController.text);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Location saved')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: 'Enter location',
                hintText: 'e.g., London, UK',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveLocation,
              child: Text('Save Location'),
            ),
          ],
        ),
      ),
    );
  }
}
