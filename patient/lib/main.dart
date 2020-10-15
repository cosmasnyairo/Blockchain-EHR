import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'share_record.dart';
import 'providers/record_provider.dart';
import 'providers/node_provider.dart';
import 'widgets/view_transaction.dart';
import 'screen.dart';
import 'view_record.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => RecordsProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => NodeProvider(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'EhrPatient',
        theme: ThemeData(
          primaryColor: Color(0xff3FD5AE),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Screen(),
        routes: {
          'view_record': (ctx) => ViewRecord(),
          'view_transaction': (ctx) => ViewTransaction(),
          'share_record': (ctx) => ShareRecord(),
        },
      ),
    );
  }
}
