import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/employee_bloc.dart';
import '../employee.dart';
import '../isar_service.dart';
import 'add_employee.dart';

class EmployeePageScreen extends StatelessWidget {
  const EmployeePageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EmployeeBloc(IsarService())..add(LoadEmployees()),
      child: BlocListener<EmployeeBloc, EmployeeState>(
        listener: (context, state) {
          if (state is EmployeeLoaded) {
            print('Employees data loaded!');
          } else if (state is EmployeeError) {
            print('Error: ${state.message}');
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Employees & Job Roles',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: Color.fromARGB(254, 73, 110, 226),
              ),
            ),
            backgroundColor: Colors.white,
            elevation: 1,
            toolbarHeight: 90,
          ),
          body: Row(
            // padding: const EdgeInsets.all(16.0),
            // child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(left: 15, right: 15, bottom: 650),
                width: 270,
                height: 200,
                color: Color.fromARGB(254, 73, 110, 226),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.group,
                          color: Color.fromARGB(253, 255, 255, 255)),
                      title: const Text(
                        'Employees',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(254, 238, 238, 238), // สีพื้นหลัง
                    borderRadius: BorderRadius.circular(12), // ความโค้งของมุม
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 10.0, bottom: 12.0, left: 25, right: 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Row: หัวข้อ "Employees"
                        Row(
                          children: [
                            Icon(Icons.group,
                                color: Color.fromRGBO(60, 60, 60, 0.996),
                                size: 28),
                            const SizedBox(width: 8),
                            const Text(
                              'Employees',
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(254, 60, 60, 60)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (_) {
                                return Container(
                                  height: 950,
                                  child: AddEmployeeScreen(),
                                );
                              },
                            );
                          },
                          icon: const Icon(Icons.add,
                              color: Color.fromARGB(254, 73, 110, 226)),
                          label: const Text(
                            'Add Employees',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 20,
                              color: Color.fromARGB(254, 73, 110, 226),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),

                        Expanded(
                          child: BlocBuilder<EmployeeBloc, EmployeeState>(
                            builder: (context, state) {
                              if (state is EmployeeLoading) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (state is EmployeeLoaded) {
                                return Card(
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ListView.builder(
                                    itemCount: state.employees.length,
                                    itemBuilder: (context, index) {
                                      final employee = state.employees[index];
                                      return Column(
                                        children: [
                                          ListTile(
                                            leading: CircleAvatar(
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      254, 73, 110, 226),
                                              child: Text(
                                                employee.firstName.isNotEmpty
                                                    ? employee.userName[0]
                                                        .toUpperCase() // ตัวอักษรแรก
                                                    : "?",
                                                style: const TextStyle(
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                    fontSize: 20),
                                              ),
                                            ),
                                            title: Text(
                                              employee.userName,
                                              style: const TextStyle(
                                                //  fontWeight: FontWeight.bold,
                                                fontFamily: 'Inter',
                                                fontSize: 22,
                                              ),
                                            ),
                                            subtitle: Text(
                                              'First Name: ${employee.firstName} - Last Name: ${employee.lastName}',
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'Inter'),
                                            ),
                                            trailing: Wrap(
                                              spacing: 8,
                                              runSpacing: 4,
                                              children:
                                                  employee.roles.map((role) {
                                                return Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 4,
                                                      horizontal: 8),
                                                  decoration: BoxDecoration(
                                                    color: const Color.fromARGB(
                                                        254, 237, 242, 254),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  child: Text(
                                                    role,
                                                    style: const TextStyle(
                                                      fontFamily: 'Inter',
                                                      fontSize: 18,
                                                      // fontWeight: FontWeight.w600,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                            onTap: () async {
                                              // ใช้ await เพื่อรอผลลัพธ์จาก showModalBottomSheet
                                              final result =
                                                  await showModalBottomSheet(
                                                context: context,
                                                isScrollControlled: true,
                                                builder: (_) {
                                                  return Container(
                                                    height: 950,
                                                    child: AddEmployeeScreen(
                                                        employee: employee),
                                                  );
                                                },
                                              );

                                              // ตรวจสอบผลลัพธ์หลังจากปิด Modal
                                              if (result == 'refresh') {
                                                debugPrint(result);
                                                context
                                                    .read<EmployeeBloc>()
                                                    .add(LoadEmployees());
                                              }
                                            },
                                          ),
                                          const Divider(),
                                        ],
                                      );
                                    },
                                  ),
                                );
                              } else if (state is EmployeeError) {
                                return Center(
                                    child: Text(
                                  'Error: ${state.message}',
                                  style: const TextStyle(color: Colors.red),
                                ));
                              }
                              return const Center(
                                  child: Text('No employees found.'));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 600, vertical: 15),
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                elevation: 0,
              ),
              child: const Text(
                'Close',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
