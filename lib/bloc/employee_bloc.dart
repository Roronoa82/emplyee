import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../isar_service.dart';
import '../employee.dart';

part 'employee_event.dart';
part 'employee_state.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final IsarService isarService;

  EmployeeBloc(this.isarService) : super(EmployeeInitial()) {
    on<LoadEmployees>(_onLoadEmployees);
    on<AddEmployee>(_onAddEmployee);
    on<UpdateEmployee>(_onUpdateEmployee);
    on<DeleteEmployee>(_onDeleteEmployee);
  }

  Future<void> _onLoadEmployees(LoadEmployees event, Emitter<EmployeeState> emit) async {
    emit(EmployeeLoading());
    try {
      final employees = await isarService.getAllEmployees();
      debugPrint("Loaded employeessssssssssssssssssssssssssssss: $employees"); // พิมพ์ข้อมูลที่โหลด
      if (employees.isEmpty) {
        emit(EmployeeLoaded(employees)); // ถ้าไม่มีข้อมูล
      } else {
        emit(EmployeeLoaded(employees)); // ส่งข้อมูลที่โหลด
      }
    } catch (e) {
      emit(EmployeeError('Failed to load employees: ${e.toString()}'));
    }
  }

  Future<void> _onAddEmployee(AddEmployee event, Emitter<EmployeeState> emit) async {
    try {
      final existingEmployee = await isarService.getEmployeeByPin(event.employee.loginPin);

      if (existingEmployee != null) {
        // หากมี loginPin ซ้ำ ให้แสดงข้อผิดพลาด
        emit(const EmployeeError('Invalid PIN, Please try again.'));
      } else {
        await isarService.addEmployee(event.employee);
        final employees = await isarService.getAllEmployees();
        emit(EmployeeLoaded(employees));
      }
    } catch (e) {
      emit(EmployeeError(e.toString()));
    }
  }

  Future<void> _onUpdateEmployee(UpdateEmployee event, Emitter<EmployeeState> emit) async {
    try {
      await isarService.updateEmployee(event.employee);
      final employees = await isarService.getAllEmployees();
      emit(EmployeeLoaded(employees));
    } catch (e) {
      emit(EmployeeError(e.toString()));
    }
  }

  Future<void> _onDeleteEmployee(DeleteEmployee event, Emitter<EmployeeState> emit) async {
    try {
      await isarService.deleteEmployee(event.id);
      final employees = await isarService.getAllEmployees(); // ดึงข้อมูลใหม่
      emit(EmployeeLoaded(employees)); // แสดงผลข้อมูลที่อัปเดต
    } catch (e) {
      emit(EmployeeError(e.toString()));
    }
  }
}
