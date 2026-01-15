
import 'package:flutter/material.dart';

class HomeViewModel {
  void goToStartRun(BuildContext context) {
    Navigator.pushNamed(context, '/start-run');
  }
}
