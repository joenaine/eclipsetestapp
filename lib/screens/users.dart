import 'dart:convert';

import 'package:eclipsetest/main.dart';
import 'package:eclipsetest/screens/profile.dart';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:eclipsetest/models/User.dart';

class Users extends StatefulWidget {
  @override
  _UsersState createState() => _UsersState();
}

class _UsersState extends State<Users> {
  Future<List<User>> fetchUsers() async {
    var response = await http.get('https://jsonplaceholder.typicode.com/users');

    if (response.statusCode == 200) {
      return List<User>.from(
          json.decode(response.body).map((x) => User.fromJson(x)));
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future getUsers() async {
    final users = Hive.box(API_BOX).get('users', defaultValue: []);
    if (users.isNotEmpty) return users;
    final http.Response res =
        await http.get('https://jsonplaceholder.typicode.com/users');
    final resJson = jsonDecode(res.body);
    Hive.box(API_BOX).put('users', resJson);
    return resJson;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Users"),
        centerTitle: true,
        elevation: 1,
      ),
      body: Container(
        child: FutureBuilder(
          future: fetchUsers(),
          builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
            if (snapshot.hasData) {
              return ListView(children: [
                for (var item in snapshot.data)
                  ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfilePage(
                            user: item,
                          ),
                        ),
                      );
                    },
                    leading: Hero(
                      transitionOnUserGestures: true,
                      tag: item.id,
                      child: CircleAvatar(
                        child: Text(item.id.toString()),
                      ),
                    ),
                    title: Text(item.username),
                    subtitle: Text(item.name),
                  ),
              ]);
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
