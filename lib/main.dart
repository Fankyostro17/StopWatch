import 'package:flutter/material.dart';
import 'dart:async';
import 'CustomIcons.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stop Watch!!',
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      home: const MyHomePage(title: 'Stop Watch'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _timeText = "00:00";
  String _extraTimeText = "";
  bool _isRunning = false;
  bool _isPaused = false;
  int _elapsedSeconds = 0;
  int _tickCount = 0;

  late Stream<int> _tickStream;
  late Stream<int> _stream;

  @override
  void initState() {
    super.initState();

    _tickStream = Stream.periodic(Duration(milliseconds: 100), (i) => i);

    _stream = _tickStream.where(
      (t) {
        if(_isRunning && !_isPaused && t != 0){
          _tickCount++;
          if(_tickCount % 10 == 0){
            return true;
          }
        }
        return false;
      }
    ).map(
      (_) {
        _elapsedSeconds++;
        int hours = _elapsedSeconds ~/ 3600;
        int min = (_elapsedSeconds % 3600) ~/ 60;
        int sec = _elapsedSeconds % 60;

        String timeStr;

        if(hours < 1){
          timeStr = "${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}";
        } else {
          timeStr = "${hours.toString().padLeft(2, '0')}:${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}";
        }

        String extraStr = hours > 24 ? calculateExtraTime(_elapsedSeconds, hours, min, sec) : "";

        setState(() {
          _timeText = timeStr;
          _extraTimeText = extraStr;
        });

        return _elapsedSeconds;
      }
    );

    _stream.listen((_) {});
  }

  String calculateExtraTime(int totalSeconds, int hoursData, int minData, int secData) {
    int days = totalSeconds ~/ 86400;

    int hours = hoursData % 24;

    int weeks = days ~/ 7;
    days = days % 7;

    int months = weeks ~/ 4;
    weeks = weeks % 4;

    int years = months ~/ 12;
    months = months % 12;

    List<String> parts = [];

    if (years > 0) {
      parts.add("${years} ${years == 1 ? 'anno' : 'anni'}");
    }
    if (months > 0) {
      parts.add("${months} ${months == 1 ? 'mese' : 'mesi'}");
    }
    if (weeks > 0) {
      parts.add("${weeks} ${weeks == 1 ? 'settimana' : 'settimane'}");
    }
    if (days > 0) {
      parts.add("${days} ${days == 1 ? 'giorno' : 'giorni'}");
    }
    if (hours > 0) {
      parts.add("${hours} ${hours == 1 ? 'ora' : 'ore'}");
    }
    if (minData > 0) {
      parts.add("${minData} ${minData == 1 ? 'minuto' : 'minuti'}");
    }
    if (secData > 0) {
      parts.add("${secData} ${secData == 1 ? 'secondo' : 'secondi'}");
    }

    return parts.join(", ");
  }

  void _start(){
    setState(() {
      _isRunning = true;
      _isPaused = false; 
    });
  }

  void _stop(){
    setState(() {
      _isRunning = false;
      _isPaused = false;
    });
  }

  void _reset(){
    setState(() {
      _isRunning = false;
      _isPaused = false;
      _elapsedSeconds = 0;
      _timeText = "00:00";
      _extraTimeText = "";
    });
  }

  void _pause(){
    setState(() {
      _isPaused = true;
    });
  }

  void _resume(){
    setState(() {
      _isPaused = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _timeText,
              style: TextStyle(fontSize: 120),
            ),
            if(_extraTimeText.isNotEmpty)
              Text(
                _extraTimeText,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              if(!_isRunning && _elapsedSeconds == 0){
                _start();
              } else if (_isRunning){
                _stop();
              } else if(!_isRunning && _elapsedSeconds > 0){
                _reset();
              }
            },
            child: Icon(!_isRunning && _elapsedSeconds == 0 ? 
                            CustomIcons.play : 
                            !_isRunning && _elapsedSeconds > 0 ?
                                CustomIcons.replay : 
                                CustomIcons.stop),
            heroTag: "startStopReset",
          ),
          SizedBox(width: 10,),
          FloatingActionButton(
            onPressed: () {
              if(_isRunning && !_isPaused){
                _pause();
              } else if (_isPaused){
                _resume();
              }
            },
            child: Icon(_isPaused ? CustomIcons.play : CustomIcons.pause),
            heroTag: "pauseResume",
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
