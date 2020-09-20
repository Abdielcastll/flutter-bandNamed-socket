import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:band_named/models/band_model.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> band = [
    Band(id: '1', name: 'Metallica', votes: 8),
    Band(id: '2', name: 'Bon Jovi', votes: 6),
    Band(id: '3', name: 'Rammstein', votes: 10),
    Band(id: '4', name: 'Maroon 5', votes: 9),
    Band(id: '5', name: 'Aerosmith', votes: 7),
    Band(id: '6', name: 'Queen', votes: 10),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Bandas Favoritas',
          style: TextStyle(color: Colors.black87),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: band.length,
        itemBuilder: (context, i) => _bandTile(band[i]),
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
      setState(() {
        this
            .band
            .add(Band(id: DateTime.now().toString(), name: name, votes: 0));
      });
    }
    Navigator.pop(context);
  }

  Widget _bandTile(Band band) {
    return Dismissible(
      background: Container(
          color: Colors.red[900],
          padding: EdgeInsets.only(left: 10.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('Borrando', style: TextStyle(color: Colors.white),),
          )),
      onDismissed: (direction) {
        //TODO: borrar del Backend
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
        ),
      ),
    );
  }
}
