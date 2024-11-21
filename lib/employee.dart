import 'package:isar/isar.dart';

part 'employee.g.dart'; // สำหรับการสร้างไฟล์เสริมด้วย isar_generator

@collection
class Employee {
  Id id = Isar.autoIncrement; // Primary key, Auto Increment

  late String userName;
  late String loginPin;
  late String firstName;
  late String lastName;
  late String address;
  late String aptSuite;
  late String city;
  late String state;
  late String zipCode;
  late String phone;
  late List<String> roles;
}