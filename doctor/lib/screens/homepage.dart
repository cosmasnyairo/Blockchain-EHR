import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../models/block.dart';
import '../models/transaction.dart';
import '../providers/record_provider.dart';
import '../widgets/custom_floating_action_button.dart';
import '../widgets/custom_image.dart';
import '../widgets/custom_text.dart';
import '../widgets/custom_tile.dart';
import '../widgets/error_screen.dart';
import 'visit_details.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Block> _updatedrecords = [];
  Map<DateTime, List> _events = {};
  List _selectedEvents;
  CalendarController _calendarController;

  var _isloading = false;
  var _erroroccurred = false;
  var i = 0;
  var _chosen = DateTime.now();
  final _selectedDay = DateTime.now();

  @override
  void initState() {
    setState(() {
      _isloading = true;
    });
    fetch().then((value) => {
          setState(() {
            _isloading = false;
          }),
        });
    _calendarController = CalendarController();

    super.initState();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  Future<void> fetch() async {
    final provider = Provider.of<RecordsProvider>(context, listen: false);
    try {
      await provider.getPortNumber(context);
      await provider.loadKeys(provider.peernode);
      await provider.resolveConflicts(provider.peernode);
      await provider.getChain(provider.peernode, provider.publickey);

      _updatedrecords = provider.records;
      print(_updatedrecords);
      while (i < _updatedrecords.length) {
        _events.putIfAbsent(
          DateTime.fromMillisecondsSinceEpoch(
              double.parse(_updatedrecords[i].timestamp).toInt() * 1000),
          () => _updatedrecords[i].transaction,
        );
        i++;
      }
      _selectedEvents = _events[_selectedDay] ?? [];
      _calendarController = CalendarController();
    } catch (e) {
      setState(() {
        _erroroccurred = true;
        _isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceheight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: _erroroccurred
          ? null
          : AppBar(title: CustomText('Ehr Kenya', fontsize: 20)),
      body: _erroroccurred
          ? ErrorPage()
          : _isloading
              ? Center(child: CircularProgressIndicator())
              : Container(
                  height: deviceheight,
                  padding: EdgeInsets.all(10),
                  child: RefreshIndicator(
                    onRefresh: () async {
                      setState(() {
                        _isloading = true;
                      });
                      fetch().then((_) {
                        setState(() {
                          _isloading = false;
                        });
                      });
                    },
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        CustomText(
                          'Change calender view by tapping the view button below',
                          fontsize: 12,
                          color: Colors.grey,
                          alignment: TextAlign.center,
                        ),
                        TableCalendar(
                          headerStyle: HeaderStyle(
                            formatButtonShowsNext: false,
                            centerHeaderTitle: false,
                            formatButtonDecoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            formatButtonPadding: EdgeInsets.all(7),
                          ),
                          events: _events,
                          availableCalendarFormats: {
                            CalendarFormat.month: 'Month view',
                            CalendarFormat.week: 'Week view',
                            CalendarFormat.twoWeeks: 'Two Week view'
                          },
                          formatAnimation: FormatAnimation.scale,
                          calendarController: _calendarController,
                          startingDayOfWeek: StartingDayOfWeek.sunday,
                          availableGestures: AvailableGestures.horizontalSwipe,
                          initialCalendarFormat: deviceheight < 768
                              ? CalendarFormat.twoWeeks
                              : CalendarFormat.month,
                          daysOfWeekStyle: DaysOfWeekStyle(
                              weekendStyle: TextStyle(
                                  color: Theme.of(context).accentColor)),
                          calendarStyle: CalendarStyle(
                            weekendStyle:
                                TextStyle(color: Theme.of(context).accentColor),
                            selectedColor:
                                Theme.of(context).accentColor.withOpacity(0.7),
                            todayColor: Colors.grey,
                            markersColor: Theme.of(context).primaryColor,
                            outsideDaysVisible: false,
                            outsideWeekendStyle:
                                TextStyle(color: Theme.of(context).accentColor),
                          ),
                          onDaySelected: (day, events, holidays) {
                            _chosen = day;
                            setState(() {
                              _selectedEvents = events;
                            });
                          },
                          builders: CalendarBuilders(
                            markersBuilder: (context, date, events, holidays) {
                              final children = <Widget>[];
                              if (events.isNotEmpty) {
                                children.add(
                                  Positioned(
                                    right: 1,
                                    bottom: 1,
                                    child: _buildEventsMarker(date, events),
                                  ),
                                );
                              }
                              return children;
                            },
                          ),
                        ),
                        SizedBox(height: 30),
                        _buildEventList(_chosen)
                      ],
                    ),
                  ),
                ),
      floatingActionButton: _erroroccurred
          ? CustomFAB(
              'Try again',
              Icons.refresh,
              () {
                setState(() {
                  _erroroccurred = false;
                  _isloading = true;
                });
                fetch().then(
                  (value) => {
                    setState(() {
                      _isloading = false;
                    }),
                  },
                );
              },
            )
          : null,
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _calendarController.isSelected(date)
            ? Theme.of(context).accentColor
            : Theme.of(context).accentColor.withOpacity(0.7),
      ),
      width: 8.0,
      height: 8.0,
    );
  }

  Widget _buildEventList(DateTime day) {
    final deviceheight = MediaQuery.of(context).size.height;
    final f = DateFormat('dd-MM-yyyy');
    final transactionformat = DateFormat().add_jms();

    String tapped = DateFormat().add_yMMMMEEEEd().format(day);
    String chosenday = f.format(day);

    final List<Transaction> fetchedtransaction = [];

    final _newupdatedrecords = _updatedrecords
        .where(
          (element) =>
              f.format(
                DateTime.fromMillisecondsSinceEpoch(
                    double.parse(element.timestamp).toInt() * 1000),
              ) ==
              chosenday,
        )
        .toList();

    _newupdatedrecords.forEach((element) {
      element.transaction.forEach((element) {
        fetchedtransaction.add(element);
      });
    });
    return fetchedtransaction.length > 0
        ? Card(
            margin: EdgeInsets.all(20),
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.all(10),
              physics: ClampingScrollPhysics(),
              children: [
                SizedBox(height: 10),
                CustomText(
                  '$tapped \n ${fetchedtransaction.length} visits',
                  fontsize: 16,
                  alignment: TextAlign.center,
                  fontweight: FontWeight.bold,
                ),
                SizedBox(height: 10),
                ListView.separated(
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  separatorBuilder: (context, index) => Divider(
                    indent: 20,
                    endIndent: 20,
                  ),
                  itemBuilder: (context, index) => CustomTile(
                    leadingiconData: Icons.description_outlined,
                    title: 'Health record',
                    subtitle:
                        'Visit at ${transactionformat.format(fetchedtransaction[index].timestamp)}',
                    iconData: Icons.navigate_next,
                    onpressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              VisitDetails(fetchedtransaction[index], false),
                        ),
                      );
                    },
                  ),
                  itemCount: fetchedtransaction.length,
                ),
              ],
            ),
          )
        : ListView(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            children: [
              CustomText(
                'You have no visits for this date',
                alignment: TextAlign.center,
                fontweight: FontWeight.bold,
              ),
              SizedBox(height: 20),
              Container(
                height: deviceheight * 0.25,
                child: CustomImage('assets/pending.png', BoxFit.contain),
              ),
              SizedBox(height: 20),
            ],
          );
  }
}
