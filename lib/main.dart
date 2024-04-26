import 'package:flutter/material.dart';
import 'read.dart';
import 'package:dio/dio.dart';
import 'list.dart';
import 'writeform.dart';
import 'modify.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: '/writeform',
      routes: {
        '/read':(context) => ex01(),
        '/list':(context) => ex02(),
        '/writeform':(context) => ex03(),
        '/modifyform':(context) => ex04(),
        },
    );
  }
}
