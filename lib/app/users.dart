import 'package:flutter/material.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).secondaryHeaderColor,
      ),
      body: Center(
        child: Text('Users Page'),
      ),
    );
  }
}
