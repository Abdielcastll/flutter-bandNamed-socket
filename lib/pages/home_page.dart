import 'dart:io';

import 'package:band_named/services/socket.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:band_named/models/band_model.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [];

  @override
  void initState() {
    final socketservice = Provider.of<SocketService>(context, listen: false);
    socketservice.socket.on('active-bands', (payload) {
      this.bands = (payload as List).map((band) => Band.formMap(band)).toList();
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    final socketservice = Provider.of<SocketService>(context, listen: false);
    socketservice.socket.off('active-bands');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final socketservice = Provider.of<SocketService>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Bandas Favoritas',
          style: TextStyle(color: Colors.black87),
        ),
        centerTitle: true,
        actions: [
          Container(
              margin: EdgeInsets.only(right: 10.0),
              child: (socketservice.serverStatus == ServerStatus.Online)
                  ? Icon(Icons.check_circle, color: Colors.blue[300])
                  : Icon(Icons.offline_bolt, color: Colors.red[300]))
        ],
      ),
      body: Column(
        children: [
          _grafica(),
          Expanded(
            child: ListView.builder(
              itemCount: bands.length,
              itemBuilder: (context, i) => _bandTile(bands[i]),
            ),
          ),
        ],
      ),
      floatingActionButton:
          FloatingActionButton(child: Icon(Icons.add), onPressed: addNewBand),
    );
  }

  addNewBand() {
    final textController = TextEditingController();
    if (Platform.isAndroid) {
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Agregar nueva banda'),
            content: TextField(
              controller: textController,
            ),
            actions: [
              MaterialButton(
                  child: Text(
                    'Agregar',
                    style: TextStyle(color: Colors.blue),
                  ),
                  onPressed: () {
                    addBandList(textController.text);
                  })
            ],
          );
        },
      );
    }
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
            title: Text('Agregar Banda'),
            content: CupertinoTextField(
              controller: textController,
            ),
            actions: [
              CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text('Agregar'),
                  onPressed: () => addBandList(textController.text)),
              CupertinoDialogAction(
                  isDestructiveAction: true,
                  child: Text('Salir'),
                  onPressed: () => Navigator.pop(context))
            ]);
      },
    );
  }

  void addBandList(String name) {
    if (name.length > 1) {
      final socketservice = Provider.of<SocketService>(context, listen: false);
      setState(() {
        socketservice.socket.emit('add-band', {'name': name});
      });
    }
    Navigator.pop(context);
  }

  Widget _bandTile(Band band) {
    final _socketService = Provider.of<SocketService>(context, listen: false);

    return Dismissible(
      background: Container(
          color: Colors.red[900],
          padding: EdgeInsets.only(left: 10.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Borrando',
              style: TextStyle(color: Colors.white),
            ),
          )),
      onDismissed: (direction) {
        _socketService.socket.emit('borrar-band', {'id': band.id});
      },
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: CircleAvatar(
            child: Text(band.name.substring(0, 2)),
          ),
          title: Text(band.name),
          trailing: Text(band.votes.toString()),
          onTap: () {
            setState(() {
              _socketService.socket.emit('voto-band', {'id': band.id});
            });
            _socketService.socket.on('votos', (payload) {
              print(payload);
              setState(() {});
            });
          },
        ),
      ),
    );
  }

  Widget _grafica() {
    Map<String, double> dataMap = new Map();
      bands.forEach((band) {
        dataMap.putIfAbsent(band.name, () => band.votes.toDouble());
      }); 
      
    
    return Container(
      margin: EdgeInsets.only(top: 30.0),
      child: PieChart(
        dataMap: dataMap,
        animationDuration: Duration(milliseconds: 800),
        chartLegendSpacing: 32,
        chartRadius: MediaQuery.of(context).size.width / 3.2,
        initialAngleInDegree: 0,
        chartType: ChartType.ring,
        ringStrokeWidth: 40,
        centerText: "",
        legendOptions: LegendOptions(
          showLegendsInRow: false,
          legendPosition: LegendPosition.right,
          showLegends: true,
          legendTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        chartValuesOptions: ChartValuesOptions(
          showChartValueBackground: false,
          showChartValues: true,
          showChartValuesInPercentage: true,
          showChartValuesOutside: false,
        ),
      ),
    );

  }
}
