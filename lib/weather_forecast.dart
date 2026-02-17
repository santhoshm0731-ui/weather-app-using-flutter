import 'package:flutter/material.dart';

class HourlyForecast extends StatelessWidget{
  String time;
  String value;
  final IconData icon;

   HourlyForecast({
    super.key,
    required this.icon,
    required this.time,
    required this.value
    
    
    }
    );

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      width: 120,
      
      child: Card(
        
        elevation: 8,
        child:Container(
          padding: EdgeInsets.all(20),
                                         decoration: BoxDecoration(border: Border.all(width: 1),
            borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: [
              Text(time,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
              SizedBox(height: 8),
              Icon(icon,size: 32,),
              SizedBox(height: 8),
              Text(value,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
              
    
            ],
          ),
        )
      ),
    );
    
  }
}