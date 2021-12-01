import 'package:flutter/material.dart';
import 'package:untitled/screens/browser_page.dart';
import 'package:untitled/screens/paste_link_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late  int _currentIndex = 0 ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.pinkAccent,
        title: const Center(child: Text("Youtube downloader"),),
      ),

      body: pages[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
          selectedItemColor: Colors.pinkAccent,
          items: item ,
          onTap: (value){
          setState(() {
            _currentIndex = value ;
          });
    },
      ),

    );
  }

  List <Widget> pages = [
     const PasteLink() ,
     const BrowserPage()
  ] ;

  List <BottomNavigationBarItem> item =[
    const BottomNavigationBarItem(icon: Icon(Icons.paste), label: 'paste link' ) ,
    const BottomNavigationBarItem(icon: Icon(Icons.network_cell_outlined), label: 'Browser') ,
  ];
}


