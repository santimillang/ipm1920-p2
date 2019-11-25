import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:p2/source/models/routine.dart';

ImageProvider buildImageProvider(var namespace) {
  if (namespace.image != '') {
    String imageString = utf8.decode(namespace.image.byteList);
    return MemoryImage(base64Decode(imageString));
  }
  return AssetImage('assets/notavailable.png');
}

List<Widget> buildTiles(var exercises) {
  List<Widget> tiles = List<Widget>();
  for (var exercise in exercises) {
    tiles.add(ListTile(
      title: Text(exercise[0]),
      subtitle: Text(exercise[1]),
    ));
  }
  return tiles;
}

class DetailScreen extends StatefulWidget {
  final Routine routine;

  DetailScreen({this.routine});

  @override
  State<StatefulWidget> createState() {
    return DetailScreenState();
  }
}

class DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.routine.name),
      ),
      body: ListView(
        children: <Widget>[
          Image(
            image: buildImageProvider(widget.routine),
          ),
          Text(widget.routine.description),
          Column(
            children: buildTiles(widget.routine.exercises),
          ),
        ],
      ),
    );
  }
}
