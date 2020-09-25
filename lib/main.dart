import 'package:band_named/pages/home_page.dart';
import 'package:band_named/pages/status_page.dart';
import 'package:band_named/services/socket.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SocketService())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: 'home',
        routes: {
          'home'   : (_) => HomePage(),
          'status' : (_) => StatusPage(),
        },
      ),
    );
  }
}