import 'package:eclipsetest/models/User.dart';
import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  final User user;
  const UserPage({Key key, this.user}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.user.username),
          centerTitle: true,
          elevation: 1,
        ),
        body: Container(
          child: Text(widget.user.name),
        ));
  }
}
