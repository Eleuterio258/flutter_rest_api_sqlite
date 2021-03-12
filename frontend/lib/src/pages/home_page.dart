import 'package:app/src/providers/db_provider.dart';
import 'package:app/src/providers/employee_api_provider.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

enum MenuOption { Scronizar, Limpar, Sair }

class _HomePageState extends State<HomePage> {
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Api to sqlite'),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<MenuOption>(itemBuilder: (context) {
            return <PopupMenuEntry<MenuOption>>[
              PopupMenuItem(
                child: GestureDetector(
                  child: Text("Scronizar"),
                  onTap: () async {
                    await _loadFromApi();
                  },
                ),
                value: MenuOption.Limpar,
              ),
              PopupMenuItem(
                child: GestureDetector(
                  child: Text("Limpar"),
                  onTap: () async {
                    await _deleteData();
                  },
                ),
                value: MenuOption.Scronizar,
              ),
              PopupMenuItem(
                child: Text("Scronizar"),
                value: MenuOption.Sair,
              )
            ];
          })
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _buildEmployeeListView(),
    );
  }

  _loadFromApi() async {
    setState(() {
      isLoading = true;
    });

    var apiProvider = EmployeeApiProvider();
    await apiProvider.getAllEmployees();

    // wait for 2 seconds to simulate loading of data
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isLoading = false;
    });
  }

  _deleteData() async {
    setState(() {
      isLoading = true;
    });

    await DBProvider.db.deleteAllEmployees();

    // wait for 1 second to simulate loading of data
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      isLoading = false;
    });

    print('All employees deleted');
  }

  _buildEmployeeListView() {
    return FutureBuilder(
      future: DBProvider.db.getAllEmployees(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int i) {
              return ListTile(
                leading: Text(
                  "${i + 1}",
                  style: TextStyle(fontSize: 20.0),
                ),
                title: Text(snapshot.data[i].firstName),
                subtitle: Text(snapshot.data[i].email),
              );
            },
          );
        }
      },
    );
  }
}
