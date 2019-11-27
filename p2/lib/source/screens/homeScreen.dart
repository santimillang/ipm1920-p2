import 'package:flutter/material.dart';
import 'package:p2/source/bloc/routineBloc.dart';
import 'package:p2/source/models/routine.dart';
import 'package:p2/source/screens/detailScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  final RoutineBloc bloc = RoutineBloc();
  Routine workout;

  @override
  void initState() {
    super.initState();
    bloc.workoutsEvent.add(0);
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('IPM'),
      ),
      body: StreamBuilder(
        stream: bloc.workouts,
        builder: (context, snapshot) {
          if (MediaQuery.of(context).size.width < 840) {
            return _buildList(snapshot);
          }
          return _buildTablet(snapshot);
        },
      ),
    );
  }

  Widget _buildTablet(AsyncSnapshot snapshot) {
    return Row(
      children: <Widget>[
        Flexible(
          flex: 2,
          child: Material(
            elevation: 4.0,
            child: _buildList(snapshot),
          ),
        ),
        Flexible(
          flex: 5,
          child: DetailScreen(
            routine: workout,
            phone: false,
          ),
        ),
      ],
    );
  }

  Widget _buildList(AsyncSnapshot snapshot) {
    if (!snapshot.hasData) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (snapshot.hasError) {
      return Center(
        child: Text('Error importing data'),
      );
    } else {
      return ListView.builder(
        itemCount: snapshot.data.length,
        itemBuilder: (context, index) {
          Routine routine = snapshot.data[index];
          return ListTile(
            selected: workout == routine,
            title: Text(routine.name),
            subtitle: Text(routine.date),
            onTap: () => MediaQuery.of(context).size.width < 840
                ? Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                    return DetailScreen(
                      routine: routine,
                      phone: true,
                    );
                  }))
                : setState(() {
                    workout = routine;
                  }),
          );
        },
      );
    }
  }
}
