import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:p2/source/bloc/exerciseBloc.dart';
import 'package:p2/source/models/routine.dart';
import 'package:youtube_player/youtube_player.dart';

ImageProvider buildImageProvider(var namespace) {
  if (namespace.image != '') {
    String imageString = utf8.decode(namespace.image.byteList);
    return MemoryImage(base64Decode(imageString));
  }
  return AssetImage('assets/notavailable.png');
}

class DetailScreen extends StatefulWidget {
  final Routine routine;
  final bool phone;

  DetailScreen({this.routine, this.phone});

  @override
  State<StatefulWidget> createState() {
    return DetailScreenState();
  }
}

class DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    Widget build;

    if (widget.routine == null) {
      build = Center(
        child: Text('Nothing here'),
      );
    } else {
      build = ListView(
        children: <Widget>[
          Image(
            image: buildImageProvider(widget.routine),
          ),
          Text(widget.routine.description),
          Column(
            children: _buildTiles(widget.routine.exercises),
          ),
        ],
      );
    }

    if (widget.phone) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.routine.name),
        ),
        body: build,
      );
    }
    return Center(
      child: build,
    );
  }

  List<Widget> _buildTiles(var exercises) {
    List<Widget> tiles = List<Widget>();
    for (var exercise in exercises) {
      tiles.add(ListTile(
        title: Text(exercise[0]),
        subtitle: Text(exercise[1]),
        onTap: () => _load(exercise[0]),
      ));
    }
    return tiles;
  }

  Future<void> _load(String name) {
    ExerciseBloc bloc = ExerciseBloc();
    bloc.videoEvent.add(name);
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(name),
          content: StreamBuilder(
            stream: bloc.video,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('There was an error.');
              } else if (snapshot.data == '') {
                return Text('No video available.');
              } else {
                return YoutubePlayer(
                  context: context,
                  source: snapshot.data,
                  onVideoEnded: () => true,
                  quality: YoutubeQuality.HD,
                  playerMode: YoutubePlayerMode.NO_CONTROLS,
                );
              }
            },
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Close'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}
