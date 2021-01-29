import 'dart:io';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';



class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final wordPair = WordPair.random();
    return Container(
      child: Center(
        child: Text(wordPair.asPascalCase),
      ),
    );
  }
}