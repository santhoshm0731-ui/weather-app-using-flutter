import 'package:flutter/material.dart';

class AdditinalInfo extends StatelessWidget{

  final IconData icon;
  String text;
  String value;

   AdditinalInfo({
    super.key,
    required this.icon,
    required this.text,
    required this.value
    
    
    }
    );
  @override
  Widget build(BuildContext context) {
    return Column(
                        children: [
                          Icon(icon, size: 32,),
                          SizedBox(height: 8),
                          Text(text,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                           SizedBox(height: 8),
                          Text(value,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)
                          
                        ],
                      )  ;
    
  }
}