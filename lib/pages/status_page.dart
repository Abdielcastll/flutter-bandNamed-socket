import 'package:band_named/services/socket.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatusPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final socketservice = Provider.of<SocketService>(context);


    return Scaffold(
      body: Center(
        child: Text('Connection: ${socketservice.serverStatus}'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.message),
        onPressed: () {
          socketservice.socket.emit('emitir-mensaje', [ 'Hola desde FLUTTER' ]);
        },
        ),
    );
  }
}
