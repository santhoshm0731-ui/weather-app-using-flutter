import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather_app/weather_page.dart';

Future<void> main() async { 
  await dotenv.load(fileName: ".env");
   runApp(WeatherApp());
    }

// void main(){
//   runApp(WeatherApp());
// }

class WeatherApp extends StatelessWidget{
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const WeatherPage(),
      theme: ThemeData.dark(useMaterial3: true),
    );
  
  }
}
