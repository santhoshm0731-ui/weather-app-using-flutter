import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/additinal_info.dart';
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
String currentState=" ";
  @override
  void initState(){
    super.initState();
   getCurrentWeather();
  }

Future getCurrentWeather() async{

  String city='London';
  String apiKey = dotenv.env['Api_key'] ?? '';
  try{
   
  final result= await http.get(Uri.parse("https://api.openweathermap.org/data/2.5/weather?q=$city,uk&APPID=$apiKey"));
  final data= jsonDecode(result.body);
  if (data['cod']!=200){
    throw "Unexpected Error Occured";   
  }

  setState(() {
    temp=data['main']['temp'];
    humidity=data['main']['humidity'];
    pressure=data['main']['pressure'];
    air=data['wind']['speed'];
    currentState=data['weather'][0]['main'];
    
    _isLoading=false;
  });
  
  
  }catch (e){
    throw e.toString();
  }

}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(title: Text("Weather APP",
            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30,color: Colors.white),
                     ),
                    centerTitle: true,
                    actions: [IconButton(onPressed: (){
                     
                      setState(() {
                        _isLoading=true; 
                      });
                      getCurrentWeather();
                      debugPrint("???????????");
                    },
                     icon: Icon(Icons.refresh,color: Colors.white,))],
                     
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
                             TextField(decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(5),
                              hintText: "Search Place or City(Eg. London)",
                              prefixIcon: Icon(Icons.search),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),borderSide: BorderSide.none)
                              
                            ),),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Card(
                              shape:RoundedRectangleBorder(side: BorderSide.none,borderRadius: BorderRadiusGeometry.circular(15)),
                              elevation: 10,
                              child: Column(
                                children: [
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