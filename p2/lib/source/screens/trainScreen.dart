import 'dart:async';

import 'package:quiver/async.dart';

import 'package:flutter/material.dart';

class TrainScreen extends StatefulWidget {
  final exercises;

  TrainScreen({this.exercises});

  @override
  State<StatefulWidget> createState() {
    return TrainScreenState();
  }
}

class TrainScreenState extends State<TrainScreen> {
  StreamSubscription<CountdownTimer> controller;
  bool isPlaying = false;
  int index = 0;
  int duration;
  int current;

  @override
  void initState() {
    super.initState();
    parse();
  }

  @override
  void dispose() {
    controller?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var exercise = widget.exercises[index];
    return Scaffold(
      appBar: AppBar(
        title: Text('Training'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            exercise[0],
            style: TextStyle(
              fontSize: 48.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            duration < 0 ? exercise[1] : '$current',
            style: TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FlatButton(
                child: Icon(
                  Icons.arrow_back,
                  size: 22.0,
                ),
                onPressed: index == 0
                    ? null
                    : () {
                        setState(() {
                          index--;
                          isPlaying = false;
                          parse();
                        });
                        controller?.cancel();
                      },
              ),
              FlatButton(
                child: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                  size: 22.0,
                ),
                onPressed: duration < 0
                    ? null
                    : () {
                        if (isPlaying) {
                          setState(() {
                            isPlaying = false;
                            duration = current;
                          });
                          controller.cancel();
                          return;
                        }
                        setState(() {
                          isPlaying = true;
                        });
                        controller = startTimer();
                      },
              ),
              FlatButton(
                child: Icon(
                  Icons.arrow_forward,
                  size: 22.0,
                ),
                onPressed: index == widget.exercises.length - 1
                    ? null
                    : () {
                        setState(() {
                          index++;
                          isPlaying = false;
                          parse();
                        });
                        controller?.cancel();
                      },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void parse() {
    String duration = widget.exercises[index][1];
    if (duration.contains('rep')) {
      this.duration = -1;
      return;
    }
    this.duration = current =
        int.parse(duration.substring(0, duration.length - 1)) *
            (duration.contains('"') ? 1 : 60);
  }

  startTimer() {
    CountdownTimer timer =
        CountdownTimer(Duration(seconds: current), Duration(seconds: 1));

    StreamSubscription<CountdownTimer> sub = timer.listen(null);

    sub.onData((dur) {
      setState(() {
        current = duration - dur.elapsed.inSeconds;
        if (current == 0) {
          isPlaying = false;
        }
      });
    });

    sub.onDone(() {
      sub.cancel();
    });

    return sub;
  }
}
