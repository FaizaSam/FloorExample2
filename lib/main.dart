//import 'dart:html';

// ignore_for_file: unused_local_variable

import 'package:faker/faker.dart';
import 'package:floor/floor.dart';
import 'package:floor_eg2/Employee.dart';
import 'package:floor_eg2/EmployeeDAO.dart';
import 'package:floor_eg2/database/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database =
      await $FloorAppDatabase.databaseBuilder('edmt database.db').build();
  final dao = database.employeeDAO;
  runApp(MyApp(dao: dao));
}

class MyApp extends StatelessWidget {
  //const MyApp({Key? key}) : super(key: key);
  final EmployeeDAO dao;
  MyApp({this.dao});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page', dao: dao),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.dao, this.title}) : super(key: key);
  final EmployeeDAO dao;
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () async {
                final employee = Employee(
                    firstName: Faker().person.firstName(),
                    lastName: Faker().person.lastName(),
                    email: Faker().internet.email());
                await widget.dao.insertEmployee(employee);
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('Add Success')));

                // showSnackBar(scaffoldKey.currentState, 'add Success');
              }),
          IconButton(
              icon: Icon(Icons.clear),
              onPressed: () async {
                await widget.dao.deleteAllEmployee();
                setState(() {
                  // showSnackBar(scaffoldKey.currentState, 'Clear Success');
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Clear Success')));
                });
              }),
        ],
      ),
      body: StreamBuilder(
        stream: widget.dao.getAllEmployee(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          } else if (snapshot.hasData) {
            var listEmployee = snapshot.data as List<Employee>;
            return ListView.builder(
                itemCount: listEmployee != null ? listEmployee.length : 0,
                itemBuilder: (context, index) {
                  return Slidable(
                    child: ListTile(
                      title: Text(
                          '${listEmployee[index].firstName} ${listEmployee[index].lastName}'),
                      subtitle: Text('${listEmployee[index].email}'),
                    ),
                    actionPane: SlidableDrawerActionPane(),
                    secondaryActions: [
                      IconSlideAction(
                        caption: 'Update',
                        color: Colors.blue,
                        icon: Icons.update,
                        onTap: () async {
                          final updateEmployee = listEmployee[index];
                          updateEmployee.firstName = Faker().person.firstName();
                          updateEmployee.lastName = Faker().person.lastName();
                          updateEmployee.email = Faker().internet.email();
                          await widget.dao.updateEmployee(updateEmployee);
                        },
                      ),
                      IconSlideAction(
                        caption: 'delete',
                        color: Colors.blue,
                        icon: Icons.delete,
                        onTap: () async {
                          final deleteEmployee = listEmployee[index];
                          deleteEmployee.firstName = Faker().person.firstName();
                          deleteEmployee.lastName = Faker().person.lastName();
                          deleteEmployee.email = Faker().internet.email();
                          await widget.dao.deleteEmployee(deleteEmployee);
                        },
                      )
                    ],
                  );
                });
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  void showSnackBar(ScaffoldState currentState, String s) {
    final snackBar = SnackBar(
      content: Text('s'),
    );
    currentState.showSnackBar(snackBar);
  }
}
