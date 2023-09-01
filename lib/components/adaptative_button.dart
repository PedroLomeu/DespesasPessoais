import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class BotaoAdaptativo extends StatelessWidget {

  final String label;
  final Function onPressed;
  
  const BotaoAdaptativo({super.key, 
    required this.label,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS ? CupertinoButton(
      onPressed: onPressed(),
       padding: const EdgeInsets.symmetric(
        horizontal: 20,
       ),
      child: Text(label),
       )
       : ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
        child: Text(label,
        // style: TextStyle(backgroundColor: Colors.white),
        ),
        onPressed: () =>onPressed(),
       );
        }
}
