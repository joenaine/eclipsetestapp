import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:eclipsetest/models/Album.dart';
import 'package:eclipsetest/models/Photo.dart';
import 'package:eclipsetest/models/User.dart';
import 'package:eclipsetest/screens/image_viewer.dart';

class Photos extends StatefulWidget {
  final User user;
  final Album album;

  const Photos({Key key, this.user, this.album}) : super(key: key);

  @override
  _PhotosState createState() => _PhotosState();
}

class _PhotosState extends State<Photos> {
  Future<List<Photo>> fetchAlbums() async {
    var response = await http.get(
        'https://jsonplaceholder.typicode.com/photos?albumId=' +
            widget.album.id.toString());

    if (response.statusCode == 200) {
      return List<Photo>.from(
          json.decode(response.body).map((x) => Photo.fromJson(x)));
    } else {
      throw Exception('Failed to load' + widget.user.username + "'s photos");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user.username + "'s photos"),
        centerTitle: true,
        elevation: 1,
      ),
      body: Container(
        child: FutureBuilder(
          future: fetchAlbums(),
          builder: (BuildContext context, AsyncSnapshot<List<Photo>> snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  Container(
                    child: CarouselSlider(
                      options: CarouselOptions(
                        aspectRatio: 2.0,
                        enlargeCenterPage: true,
                        enableInfiniteScroll: false,
                        initialPage: 2,
                        autoPlay: true,
                      ),
                      items: [
                        for (var item in snapshot.data)
                          Container(
                            child: Container(
                              margin: EdgeInsets.all(5.0),
                              child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                  child: Stack(
                                    children: [
                                      Image.network(item.url,
                                          fit: BoxFit.cover, width: 1000.0),
                                      Positioned(
                                        bottom: 0.0,
                                        left: 0.0,
                                        right: 0.0,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Color.fromARGB(200, 0, 0, 0),
                                                Color.fromARGB(0, 0, 0, 0)
                                              ],
                                              begin: Alignment.bottomCenter,
                                              end: Alignment.topCenter,
                                            ),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10.0, horizontal: 20.0),
                                          child: Text(
                                            item.title,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                          )
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: GridView.count(
                      primary: false,
                      padding: const EdgeInsets.all(10),
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                      crossAxisCount: 3,
                      children: [
                        for (var item in snapshot.data)
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ImageViewer(
                                    photo: item,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              color:
                                  Theme.of(context).accentColor.withAlpha(10),
                              child: Image.network(
                                item.thumbnailUrl,
                              ),
                            ),
                          ),
                      ],
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
}
