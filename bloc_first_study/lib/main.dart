import 'package:bloc_first_study/views/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
  MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
    primarySwatch: Colors.blue,
    ),
    home: const HomePage(),
  ),
  );
}
