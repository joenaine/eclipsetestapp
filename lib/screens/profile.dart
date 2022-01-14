import 'dart:convert';
import 'package:eclipsetest/models/Album.dart';
import 'package:eclipsetest/screens/photos.dart';
import 'package:http/http.dart' as http;
import 'package:eclipsetest/Animation/FadeAnimation.dart';
import 'package:eclipsetest/helper/Colorsys.dart';
import 'package:eclipsetest/models/Post.dart';
import 'package:eclipsetest/models/User.dart';
import 'package:flutter/material.dart';

import 'comments.dart';

class ProfilePage extends StatefulWidget {
  final User user;
  const ProfilePage({Key key, this.user}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<List<Post>> fetchUsers() async {
    var response = await http.get(
        'https://jsonplaceholder.typicode.com/posts?userId=' +
            widget.user.id.toString());

    if (response.statusCode == 200) {
      return List<Post>.from(
          json.decode(response.body).map((x) => Post.fromJson(x)));
    } else {
      throw Exception('Failed to load' + widget.user.username + "'s posts");
    }
  }

  Future<List<Album>> fetchAlbums() async {
    var response = await http.get(
        'https://jsonplaceholder.typicode.com/albums?userId=' +
            widget.user.id.toString());

    if (response.statusCode == 200) {
      return List<Album>.from(
          json.decode(response.body).map((x) => Album.fromJson(x)));
    } else {
      throw Exception('Failed to load' + widget.user.username + "'s albums");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colorsys.grey,
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.more_horiz,
              size: 25,
              color: Colorsys.grey,
            ),
          )
        ],
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, value) {
          return [
            SliverToBoxAdapter(
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(15),
                                bottomRight: Radius.circular(15)),
                            color: Colors.white),
                        child: Column(
                          children: [
                            Hero(
                              transitionOnUserGestures: true,
                              tag: widget.user.id,
                              child: CircleAvatar(
                                child: Text(widget.user.id.toString()),
                                maxRadius: 40,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              widget.user.name,
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colorsys.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              widget.user.username,
                              style:
                                  TextStyle(fontSize: 15, color: Colorsys.grey),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                makeTagWidgets(
                                    tag: widget.user.email, name: "Email:"),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                makeTagWidgets(
                                    tag: widget.user.website, name: "Website:"),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                makeTagWidgets(
                                    tag: widget.user.phone, name: "Phone:"),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                makeTagWidgets(
                                    tag: widget.user.company.bs, name: "BS:"),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                makeTagWidgets(
                                    tag: '"${widget.user.company.catchPhrase}"',
                                    name: "Catch Phrase:",
                                    fS: FontStyle.italic),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                makeTagWidgets(
                                    tag: widget.user.address.city,
                                    name: "City:"),
                                Container(
                                  width: 2,
                                  height: 15,
                                  margin: EdgeInsets.symmetric(horizontal: 20),
                                  color: Colorsys.lightGrey,
                                ),
                                makeTagWidgets(
                                    tag: widget.user.address.street,
                                    name: "Street:"),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
            )
          ];
        },
        body: DefaultTabController(
          length: 2,
          child: Column(children: [
            FadeAnimation(
                2.2,
                Container(
                    child: TabBar(
                        labelColor: Colors.black,
                        unselectedLabelColor: Colors.grey.shade600,
                        indicatorColor: Colors.black,
                        tabs: [
                      Tab(
                        child: Text('Posts', style: TextStyle(fontSize: 18)),
                      ),
                      Tab(
                        child: Text('Albums', style: TextStyle(fontSize: 18)),
                      ),
                    ]))),
            Expanded(
                child: FadeAnimation(
                    2.2,
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: TabBarView(children: [
                          Container(
                            child: FutureBuilder(
                              future: fetchUsers(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<Post>> snapshot) {
                                if (snapshot.hasData) {
                                  return ListView(
                                    children: [
                                      for (var item in snapshot.data)
                                        Card(
                                          elevation: 1,
                                          child: ListTile(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      CommentsPage(
                                                    user: widget.user,
                                                    post: item,
                                                  ),
                                                ),
                                              );
                                            },
                                            title: Text(item.title,
                                                maxLines: 1,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                            subtitle: Text(item.body,
                                                maxLines: 1,
                                                overflow:
                                                    TextOverflow.ellipsis),
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
                          Container(
                            child: FutureBuilder(
                              future: fetchAlbums(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<Album>> snapshot) {
                                if (snapshot.hasData) {
                                  return ListView(
                                    children: [
                                      for (var item in snapshot.data)
                                        ListTile(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Photos(
                                                  user: widget.user,
                                                  album: item,
                                                ),
                                              ),
                                            );
                                          },
                                          title: Text(item.title),
                                          subtitle:
                                              Text('@' + widget.user.username),
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
                        ]))))
          ]),
        ),
      ),
    );
  }

  Widget makeTagWidgets({tag, name, fS}) {
    return Row(
      children: [
        Text(
          name,
          style: TextStyle(
              fontSize: 15, color: Colorsys.black, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: 5,
        ),
        Text(
          tag,
          style: TextStyle(
              fontSize: 15,
              color: Colorsys.darkGray,
              fontStyle: fS ?? FontStyle.normal),
        ),
      ],
    );
  }

  post(delay, image, type) {
    return FadeAnimation(
        delay,
        Container(
          margin: type == 'grid' ? EdgeInsets.all(0) : EdgeInsets.only(top: 20),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(image),
          ),
        ));
  }
}
