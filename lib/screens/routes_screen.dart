import 'package:driver/screens/add_route_screen.dart';
import 'package:flutter/material.dart';

class RoutesScreen extends StatelessWidget {
  const RoutesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Routes Screen")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddRoutesScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
