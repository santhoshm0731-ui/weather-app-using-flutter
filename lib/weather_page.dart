import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/additinal_info.dart';
import 'package:weather_app/theme_provider.dart';
import 'package:weather_app/weather_forecast.dart';



class WeatherPage extends StatefulWidget{
  const WeatherPage({super.key});

  @override
  State <WeatherPage> createState()=> _WeatherPageState();

  
}

class _WeatherPageState extends State<WeatherPage> {
double temp=0;
int humidity=0;
double air=0;
int pressure=0;
bool _isLoading=true;
bool _isFetching=false;
String currentState=" ";
String currentCity="London"; // Default fallback
String _lastSearchedCity="London"; // Stored city
TextEditingController _cityController= TextEditingController();


  @override
  void initState(){
    super.initState();
    _loadLastSearchedCity();
  }

  Future<void> _loadLastSearchedCity() async {
    final prefs = await SharedPreferences.getInstance();
    final lastCity = prefs.getString('last_searched_city') ?? 'London';
    setState(() {
      _lastSearchedCity = lastCity;
      currentCity = lastCity;
      _cityController.text = lastCity;
    });
    getCurrentWeather();
  }

Future getCurrentWeather() async{
  if (_isFetching) return;

  String city=_cityController.text.isEmpty
         ?_lastSearchedCity
        :_cityController.text;
  String apiKey = dotenv.env['Api_key'] ?? '';

  _isFetching = true;
  try{

  final result= await http.get(Uri.parse("https://api.openweathermap.org/data/2.5/weather?q=$city&APPID=$apiKey"));
  final data= jsonDecode(result.body);
  if (data['cod']!=200){
    setState(() {
      _isLoading=false;
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Unable to load data")));
    _isFetching = false;
    return;
  }

  // Save the successful city search
  await _saveLastSearchedCity(city);

  setState(() {
    currentCity=city;
    temp=data['main']['temp'];
    humidity=data['main']['humidity'];
    pressure=data['main']['pressure'];
    air=data['wind']['speed'];
    currentState=data['weather'][0]['main'];
    _isLoading=false;
  });
  _isFetching = false;
 
  
  }catch (e){
    setState(() {
      _isLoading=false;
    });
     ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("Failed to load weather")),
     );
     _isFetching = false;
  }

}

Future<void> _saveLastSearchedCity(String city) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('last_searched_city', city);
  setState(() {
    _lastSearchedCity = city;
  });
}

   void dispose(){
    _cityController.dispose();
    super.dispose();
   }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(title: Text("Weather APP",
            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),
                     ),
                    centerTitle: true,
                    actions: [
                      Consumer<ThemeProvider>(
                        builder: (context, themeProvider, child) {
                          return IconButton(
                            onPressed: () {
                              themeProvider.toggleTheme();
                            },
                            icon: Icon(
                              themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                            ),
                          );
                        },
                      ),
                      IconButton(onPressed: (){

                      setState(() {
                        _isLoading=true;
                      });
                      getCurrentWeather();
                    },
                     icon: Icon(Icons.refresh,))],
                 ),
                 body: _isLoading
                 ? Center(
                  child: CircularProgressIndicator(),
                 )
                 :Padding(
                   padding: const EdgeInsets.all(16),
                   child: SafeArea(
                    child:SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(width: double.infinity,
                          height: 30,
                          child: 
                             TextField(
                              controller: _cityController,
                              onSubmitted: (_) {
                                getCurrentWeather();
                              },
                              decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(5),
                              hintText: "Search Place or City(Eg. London)",
                              prefixIcon: Icon(Icons.search),
                              filled: true,
                              fillColor: Theme.of(context).cardColor,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),borderSide: BorderSide.none)

                            ),),
                            
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Card(
                              shape:RoundedRectangleBorder(side: BorderSide.none,borderRadius: BorderRadius.circular(15)),
                              elevation: 10,
                              child: Column(
                                children: [
                                  Text(currentCity,style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                                  SizedBox(height: 15),
                                  Text("$temp K",style: TextStyle(
                                     fontSize: 25,fontWeight: FontWeight.bold
                                      ),
                                  ),
                                  SizedBox(height: 10),
                                  Icon(Icons.cloud,size: 50,
                                  ),
                                  SizedBox(height: 10),
                                  Text(currentState,style: TextStyle(
                                     fontSize: 25,fontWeight: FontWeight.bold
                                      ),
                                  ),
                                  SizedBox(height: 15),
                      
                                ],
                              ),
                            ),
                          ),
                        SizedBox(height: 20,),
                        Align(
                          alignment: AlignmentGeometry.centerLeft,
                          child: Text("Weather Forecast",
                                    style: TextStyle(fontSize: 27,fontWeight: FontWeight.bold),
                                  ),
                        ),
                        SizedBox(height: 15),
                        SingleChildScrollView(
                         scrollDirection: Axis.horizontal,
                          child: Row( 
                            children: [
                              HourlyForecast(icon: Icons.cloud, time: "9:00", value: "330.1"),
                              SizedBox(width: 5),
                              HourlyForecast(icon: Icons.sunny, time: "12:00", value: "345.2"),
                              SizedBox(width: 5),
                              HourlyForecast(icon: Icons.wb_sunny, time: "3:00", value: "350.4"),
                              SizedBox(width: 5),
                              HourlyForecast(icon: Icons.nightlight_round, time: "6:00", value: "340.5"),
                              SizedBox(width: 5),
                              HourlyForecast(icon: Icons.bedtime, time: "9:00", value: "325.3")
                            ],
                              ),
                        ),
                        SizedBox(height:20),
                        Align(
                          alignment: AlignmentGeometry.centerLeft,
                          child: Text("Additional Information",
                                    style: TextStyle(fontSize: 27,fontWeight: FontWeight.bold),
                                  ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            AdditinalInfo(icon: Icons.water_drop,text: "Humidity", value: "$humidity %"),
                            AdditinalInfo(icon: Icons.air,text: "Wind Speed", value: "$air km/h"),
                            AdditinalInfo(icon: Icons.beach_access,text: "Pressure", value: "$pressure hPa"),
                      
                          ],
                        )                
                       
                        
                        ],
                      ),
                    )   
                      ),
                 ),
                  );
   }
  
}