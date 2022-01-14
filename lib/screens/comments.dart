import 'dart:convert';

import 'package:eclipsetest/models/Comments.dart';
import 'package:eclipsetest/models/Post.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:eclipsetest/models/User.dart';
import 'package:http/http.dart';

class CommentsPage extends StatefulWidget {
  final User user;
  final Post post;

  const CommentsPage({Key key, this.user, this.post}) : super(key: key);

  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  Future<List<Comments>> fetchComments() async {
    var response = await http.get(
        'https://jsonplaceholder.typicode.com/comments?postId=' +
            widget.post.id.toString());

    if (response.statusCode == 200) {
      return List<Comments>.from(
          json.decode(response.body).map((x) => Comments.fromJson(x)));
    } else {
      throw Exception(
          'Failed to load' + widget.user.username + "'s post comments");
    }
  }

  final url = 'https://jsonplaceholder.typicode.com/comments';

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user.username + "'s post comments"),
        centerTitle: true,
        elevation: 1,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFFf2f1f6),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Container(
                  height: 170,
                  child: Column(
                    children: [
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(hintText: 'Name'),
                      ),
                      SizedBox(height: 12),
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(hintText: 'Email'),
                      ),
                      SizedBox(height: 12),
                      TextField(
                        controller: bodyController,
                        decoration: InputDecoration(hintText: 'Title'),
                      ),
                    ],
                  ),
                ),
                actions: [
                  Center(
                    child: TextButton(
                      onPressed: () {
                        postData();
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Add Todo',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  )
                ],
              );
            },
          );
          nameController.clear();
          emailController.clear();
          bodyController.clear();
        },
        elevation: 2,
        child: Icon(
          CupertinoIcons.add,
          color: Colors.black,
        ),
      ),
      body: Container(
        child: FutureBuilder(
          future: fetchComments(),
          builder:
              (BuildContext context, AsyncSnapshot<List<Comments>> snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: [
                  for (var item in snapshot.data)
                    Card(
                      elevation: 1,
                      child: ListTile(
                        onTap: () {},
                        title: Column(
                          children: [
                            Text(item.email,
                                maxLines: 1, overflow: TextOverflow.ellipsis),
                            Text(item.name,
                                maxLines: 1, overflow: TextOverflow.ellipsis),
                          ],
                        ),
                        subtitle: Text(
                          item.body,
                        ),
                      ),
                    ),
                ],
              );
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

  void postData() async {
    try {
      final response = await post(Uri.parse(url), body: {
        'name': nameController.text,
        'email': emailController.text,
        'body': bodyController.text,
        'postId': '${widget.post.id}'
      });
      print(response.body);
    } catch (e) {}
  }
}
