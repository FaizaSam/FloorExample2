import 'package:floor/floor.dart';
import 'package:floor_eg2/Employee.dart';
import 'package:flutter/widgets.dart';

@dao
abstract class EmployeeDAO {
  @Query('SELECT * FROM Employee')
  Stream<List<Employee>> getAllEmployee();

  @Query('SELECT * FROM Employee WHERE id=:id')
  Stream<Employee> getAllEmployeeById(int id);

  @Query('DELETE FROM Employee')
  Stream<void> deleteAllEmployee();

  @Insert()
  Future<void> insertEmployee(Employee employee);

  @Update()
  Future<void> updateEmployee(Employee employee);

  @delete
  Future<void> deleteEmployee(Employee employee);
}
