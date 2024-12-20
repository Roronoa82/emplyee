// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'employee.dart';
import 'dart:async';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = _openDB();
  }

  Future<Isar> _openDB() async {
    final directory = await getApplicationDocumentsDirectory();
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open(
        [EmployeeSchema],
        directory: directory.path,
        inspector: true,
      );
    }
    return Future.value(Isar.getInstance());
  }

  // เพิ่ม Employee
  Future<void> addEmployee(Employee employee) async {
    final isar = await db;
    try {
      await isar.writeTxn(() async {
        await isar.employees.put(employee);
      });
      debugPrint("Employee added successfully: $employee");
    } catch (e) {
      debugPrint("Error adding employee: $e");
    }
  }

  // ดึงข้อมูล Employee ทั้งหมด
  Future<List<Employee>> getAllEmployees() async {
    try {
      final isar = await db;
      final employees = await isar.employees.where().findAll();
      debugPrint("Loaded employees: $employees"); // ตรวจสอบผลลัพธ์ที่ดึงมา
      return employees;
    } catch (e) {
      debugPrint('Error getting all employees: $e');
      return [];
    }
  }

  // อัปเดต Employee
  Future<void> updateEmployee(Employee employee) async {
    final isar = await db;

    await isar.writeTxn(() async {
      await isar.employees.put(employee);
    });
  }

  // ลบ Employee
  Future<void> deleteEmployee(int id) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.employees.delete(id);
    });
  }

  // ค้นหา Employee ตาม ID
  Future<Employee?> getEmployeeById(int id) async {
    final isar = await db;
    return await isar.employees.get(id);
  }

  // ฟังการเปลี่ยนแปลงข้อมูล Employee
  Stream<List<Employee>> listenToEmployees() async* {
    final isar = await db;
    yield* isar.employees.watchLazy().asyncMap((_) async {
      return await getAllEmployees();
    });
  }

  // ฟังก์ชันการค้นหาพนักงานที่มี loginPin ซ้ำ
  Future<Employee?> getEmployeeByPin(String loginPin) async {
    final isar = await db;
    final employee = await isar.employees.filter().loginPinEqualTo(loginPin).findFirst();
    print(employee);
    return employee;
  }
}
