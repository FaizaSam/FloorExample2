import 'dart:async';
import 'package:floor/floor.dart';
import '../Employee.dart';
import '../EmployeeDAO.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'database.g.dart';

@Database(version: 1, entities: [Employee])
abstract class AppDatabase extends FloorDatabase {
  EmployeeDAO get employeeDAO;
}
