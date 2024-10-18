import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}
class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _locationController = TextEditingController();
  List<String> _savedLocations = [];

  @override
  void initState() {
    super.initState();
    _loadSavedLocations();
  }

  Future<void> _loadSavedLocations() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedLocations = prefs.getStringList('savedLocations') ?? [];
    });
  }

  Future<void> _saveLocation() async {
    if (_locationController.text.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _savedLocations.add(_locationController.text);
      });
      await prefs.setStringList('savedLocations', _savedLocations);
      _locationController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location saved')),
      );
    }
  }

  Future<void> _removeLocation(String location) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedLocations.remove(location);
    });
    await prefs.setStringList('savedLocations', _savedLocations);
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
            SizedBox(height: 20),
            Text(
              'Saved Locations:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _savedLocations.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_savedLocations[index]),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _removeLocation(_savedLocations[index]),
                    ),
                    onTap: () {
                      Navigator.pop(context, _savedLocations[index]); // Pass the selected location back
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
