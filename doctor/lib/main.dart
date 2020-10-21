import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'add_record.dart';
import 'providers/record_provider.dart';
import 'providers/node_provider.dart';
import 'widgets/view_transaction.dart';
import 'screen.dart';
import 'view_record.dart';
import 'add_visit.dart';
import 'view_open_transactions.dart';

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
        title: 'EhrDoctor',
        theme: ThemeData(
          primaryColor: Color(0xff3FD5AE),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Screen(),
        routes: {
          'view_record': (ctx) => ViewRecord(),
          'view_transaction': (ctx) => ViewTransaction(),
          'add_record': (ctx) => AddRecord(),
          'view_open_transaction': (ctx) => ViewOpenTransactions(),
          'add_visit': (ctx) => AddVisit(),
        },
      ),
    );
  }
}
