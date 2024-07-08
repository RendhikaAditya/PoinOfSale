import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poinofsale/utils/sesionManager.dart';
import 'package:poinofsale/view/history/hitoryPage.dart';
import 'package:poinofsale/view/main/cashierPage.dart';
import 'package:poinofsale/view/main/favoritePage.dart';
import 'package:poinofsale/view/main/manualInputPage.dart';
import 'package:poinofsale/view/manageStore/manageStorePage.dart';
import 'package:poinofsale/view/profile/profilePage.dart';
import 'package:poinofsale/view/report/reportPage.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    CashierPage(),
    FavoritePage(),
    ManualInputPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Padding(padding: EdgeInsets.only(right: 50),child: Text('Cashier', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),),),),
      ),
      drawer: Drawer(
        backgroundColor: Colors.blue,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Image.asset("images/ic_home.png"),
              title: Text('Cashier', style: TextStyle(color: Colors.white),),
              onTap: (){
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                      (route) => false,
                );
              },
            ),
            ListTile(
              leading: Image.asset("images/ic_histori.png"),
              title: Text('History', style: TextStyle(color: Colors.white),),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          HistoryPage()),
                );
              },
            ),
            Visibility(
              visible: sessionManager.role=="owner"?true:false,
                child: ListTile(
                  leading: Image.asset("images/ic_report.png"),
                  title: Text('Report', style: TextStyle(color: Colors.white),),
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ReportPage()),
                    );
                  },
                ),
            ),
            Visibility(
              visible: sessionManager.role=="owner"?true:false,
              child: ListTile(
                leading: Image.asset("images/ic_shop.png"),
                title: Text('Manage Store', style: TextStyle(color: Colors.white),),
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ManageStorePage()),
                  );
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.person_outline, color: Colors.white,),
              title: Text('Account', style: TextStyle(color: Colors.white),),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ProfilePage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star_rounded),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.note_alt),
            label: 'Manual Input',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
