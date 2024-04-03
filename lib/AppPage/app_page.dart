import 'package:flutter/material.dart';

import 'PageManager/pages.dart';

class AppPage extends StatelessWidget {
  const AppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Pages(),
    );
  }
}