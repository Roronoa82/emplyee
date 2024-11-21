import 'package:isar/isar.dart';
import '../employee.dart';

class EmployeeRepository {
  final Isar isar;

  EmployeeRepository(this.isar);

  // เพิ่มพนักงานใหม่
  Future<void> addEmployee(Employee employee) async {
    // ตรวจสอบว่า LoginPin ซ้ำหรือไม่
    final existingEmployee = await isar.employees
        .filter()
        .loginPinEqualTo(employee.loginPin)
        .findFirst();

    if (existingEmployee != null) {
      throw Exception('Login PIN must be unique');
    }

    // เพิ่มข้อมูลพนักงาน
    await isar.writeTxn(() async {
      await isar.employees.put(employee);
    });
  }

  // ดึงข้อมูลพนักงานทั้งหมด
  Future<List<Employee>> getAllEmployees() async {
    return await isar.employees.where().findAll();
  }

  // แก้ไขข้อมูลพนักงาน
  Future<void> updateEmployee(Employee employee) async {
    final existingEmployee = await isar.employees
        .filter()
        .loginPinEqualTo(employee.loginPin)
        .findFirst();

    if (existingEmployee != null && existingEmployee.id != employee.id) {
      throw Exception('Login PIN must be unique');
    }

    await isar.writeTxn(() async {
      await isar.employees.put(employee);
    });
  }

  // ลบพนักงาน
  Future<void> deleteEmployee(Employee employee) async {
    await isar.writeTxn(() async {
      await isar.employees.delete(employee.id);
    });
  }
}
