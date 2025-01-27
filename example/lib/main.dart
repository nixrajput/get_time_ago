import 'package:flutter/material.dart';
import 'package:get_time_ago/get_time_ago.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(GetTimeAgoExampleApp());
}

class GetTimeAgoExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GetTimeAgo Example',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: GetTimeAgoExampleScreen(),
    );
  }
}

class GetTimeAgoExampleScreen extends StatefulWidget {
  @override
  State<GetTimeAgoExampleScreen> createState() =>
      _GetTimeAgoExampleScreenState();
}

const Map<String, String> languageNames = {
  'ar': 'Arabic',
  'en': 'English',
  'es': 'Spanish',
  'fa': 'Persian (Farsi)',
  'fr': 'French',
  'hi': 'Hindi',
  'pt': 'Portuguese (Brazil)',
  'br': 'Portuguese (Brazil alternate)',
  'zh': 'Simplified Chinese',
  'zh_tr': 'Traditional Chinese',
  'ja': 'Japanese',
  'oc': 'Occitan',
  'ko': 'Korean',
  'de': 'German',
  'id': 'Indonesian',
  'tr': 'Turkish',
  'ur': 'Urdu',
  'vi': 'Vietnamese',
  'ro': 'Romanian',
  'nl': 'Dutch',
  "ne": 'Nepali'
};

class _GetTimeAgoExampleScreenState extends State<GetTimeAgoExampleScreen> {
  // Helper function to get the DateTime relative to now
  DateTime _getRelativeDateTime(Duration duration) {
    return DateTime.now().subtract(duration);
  }

  // Variable to hold the selected language code
  String? _selectedLanguage = Data.defaultLocale;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GetTimeAgo Example'),
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(16.0)),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Select Locale: ',
                        style: TextStyle(fontSize: 16)),
                    Expanded(
                      child: DropdownButton<String>(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(16.0)),
                        isExpanded: true,
                        isDense: true,
                        elevation: 0,
                        underline: Container(),
                        focusColor: Colors.transparent,
                        hint: const Text("Select Locale"),
                        value: _selectedLanguage,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedLanguage = newValue;
                          });
                        },
                        items: languageNames.entries.map((entry) {
                          var code = entry.key;
                          var name = entry.value;
                          return DropdownMenuItem<String>(
                            value: code,
                            child: Text('$name ($code)',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                )),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                const Divider(),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _buildExampleTile(
                        context,
                        'Just Now (Less than 15 seconds)',
                        GetTimeAgo.parse(
                          _getRelativeDateTime(const Duration(seconds: 10)),
                          locale: _selectedLanguage,
                        ),
                      ),
                      _buildExampleTile(
                        context,
                        '30 seconds ago',
                        GetTimeAgo.parse(
                          _getRelativeDateTime(const Duration(seconds: 30)),
                          locale: _selectedLanguage,
                        ),
                      ),
                      _buildExampleTile(
                        context,
                        '1 minute ago',
                        GetTimeAgo.parse(
                          _getRelativeDateTime(const Duration(minutes: 1)),
                          locale: _selectedLanguage,
                        ),
                      ),
                      _buildExampleTile(
                        context,
                        '2 minutes ago',
                        GetTimeAgo.parse(
                          _getRelativeDateTime(const Duration(minutes: 2)),
                          locale: _selectedLanguage,
                        ),
                      ),
                      _buildExampleTile(
                        context,
                        '1 hour ago',
                        GetTimeAgo.parse(
                          _getRelativeDateTime(const Duration(hours: 1)),
                          locale: _selectedLanguage,
                        ),
                      ),
                      _buildExampleTile(
                        context,
                        '2 hours ago',
                        GetTimeAgo.parse(
                          _getRelativeDateTime(const Duration(hours: 2)),
                          locale: _selectedLanguage,
                        ),
                      ),
                      _buildExampleTile(
                        context,
                        '1 day ago',
                        GetTimeAgo.parse(
                          _getRelativeDateTime(const Duration(days: 1)),
                          locale: _selectedLanguage,
                        ),
                      ),
                      _buildExampleTile(
                        context,
                        '3 days ago',
                        GetTimeAgo.parse(
                          _getRelativeDateTime(const Duration(days: 3)),
                          locale: _selectedLanguage,
                        ),
                      ),
                      _buildExampleTile(
                        context,
                        '10 days ago (beyond 7 days)',
                        GetTimeAgo.parse(
                          _getRelativeDateTime(const Duration(days: 10)),
                          locale: _selectedLanguage,
                        ),
                      ),
                      _buildExampleTile(
                        context,
                        'Custom format beyond 7 days',
                        GetTimeAgo.parse(
                          _getRelativeDateTime(
                            const Duration(days: 10),
                          ),
                          pattern: 'yyyy-MM-dd',
                          locale: _selectedLanguage,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExampleTile(BuildContext context, String title, String timeAgo) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).hintColor,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        timeAgo,
        style: const TextStyle(
          color: Colors.blue,
          fontSize: 16,
        ),
      ),
      isThreeLine: true,
    );
  }
}
