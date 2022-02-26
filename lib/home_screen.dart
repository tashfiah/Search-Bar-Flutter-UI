import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //step 3

  _HomeScreenState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          filteredNames = names;
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  //step 1

  final TextEditingController _filter = new TextEditingController();
  final dio = new Dio();
  String _searchText = "";
  List names = [];
  List filteredNames = [];
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text('Search Example');

  // step 2

  void _getNames() async {
    final response =
        await dio.get('https://jsonplaceholder.typicode.com/users');

    print(response.data);
    List tempList = [];
    for (int i = 0; i < response.data.length; i++) {
      tempList.add(response.data(i));
    }
    setState(() {
      names = tempList;
      filteredNames = names;
    });
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          controller: _filter,
          decoration: new InputDecoration(
              prefixIcon: new Icon(Icons.search), hintText: 'Search....'),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text('Search Example');
        filteredNames = names;
        _filter.clear();
      }
    });
  }

  //step 4

  Widget _buildList() {
    if (!(_searchText.isEmpty)) {
      List tempList = [];
      for (int i = 0; i < filteredNames.length; i++) {
        if (filteredNames[i]['name']
            .toLowerCase()
            .contains(_searchText.toLowerCase())) {
          tempList.add(filteredNames[i]);
        }
      }
      filteredNames = tempList;
    }
    return ListView.builder(
        itemCount: names == null ? 0 : filteredNames.length,
        itemBuilder: (BuildContext context, int index) {
          return new ListTile(
            title: Text(filteredNames[index]['name']),
            onTap: () => print(filteredNames[index]['name']),
          );
        });
  }

  //step5

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      centerTitle: true,
      title: _appBarTitle,
      leading: new IconButton(onPressed: _searchPressed, icon: _searchIcon),
    );
  }

  @override
  void initState() {
    _getNames();
    super.initState();
  }

  //step6

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context) as PreferredSizeWidget?,
      body: Container(
        child: _buildList(),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
