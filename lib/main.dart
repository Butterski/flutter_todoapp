import 'dart:io';
import 'package:flutter/material.dart';
import 'views/app.dart';
import 'db_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (Platform.isWindows || Platform.isLinux) {
      await DBHelper.initDesktop();
    } else {
      await DBHelper.initMobile();
    }
  } catch (e) {
    await DBHelper.initMobile();
  }

  runApp(const MyApp());
}
