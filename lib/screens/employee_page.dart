// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, avoid_unnecessary_containers, use_build_context_synchronously, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supercharged/supercharged.dart';
import '../bloc/employee_bloc.dart';
import '../isar_service.dart';
import 'add_employee.dart';

class EmployeePageScreen extends StatelessWidget {
  const EmployeePageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EmployeeBloc(IsarService())..add(LoadEmployees()),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: _buildAppBar(),
        body: _buildBody(context),
        bottomNavigationBar: _buildBottomNavigationBar(context),
      ),
    );
  }

  /// * AppBar
  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(
        'Employees & Job Roles',
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 32,
          fontWeight: FontWeight.w800,
          color: Color.fromARGB(254, 73, 110, 226),
        ),
      ),
      shadowColor: Colors.black,
      backgroundColor: Colors.white,
      elevation: 8,
      toolbarHeight: 90,
      automaticallyImplyLeading: false,
    );
  }

  /// * Body
  Widget _buildBody(BuildContext context) {
    return Row(
      children: [
        _buildSidebar(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 15, top: 30, left: 30, right: 30),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.9,
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color.fromARGB(254, 195, 195, 195),
                  width: 1,
                ),
                color: const Color.fromARGB(254, 238, 238, 238),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 8, left: 30, right: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 13),
                    _buildAddEmployeeButton(context),
                    const SizedBox(height: 15),
                    Expanded(child: _buildEmployeeList(context)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// * Sidebar
  Widget _buildSidebar() {
    return Padding(
      padding: const EdgeInsets.only(top: 35, left: 20),
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          width: 270,
          height: 75,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color.fromARGB(51, 0, 0, 0),
              width: 1,
            ),
            color: const Color.fromARGB(254, 73, 110, 226),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.group, color: Colors.white, size: 35),
              SizedBox(width: 20),
              Text(
                'Employees',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// * Header
  Widget _buildHeader() {
    return Row(
      children: [
        const Icon(Icons.group, color: Color.fromARGB(255, 60, 60, 60), size: 35),
        const SizedBox(width: 8),
        const Text(
          'Employees',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: Color.fromARGB(255, 60, 60, 60)),
        ),
      ],
    );
  }

  /// *ปุ่มเพิ่มพนักงาน
  Widget _buildAddEmployeeButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (_) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.973,
              child: AddEmployeeScreen(),
            );
          },
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        minimumSize: const Size(150, 55),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        side: const BorderSide(
          color: Color.fromARGB(255, 195, 195, 195),
          width: 1,
        ),
      ),
      child: Text(
        ' + Add Employees',
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: "#496EE2".toColor(),
        ),
      ),
    );
  }

  /// *รายการพนักงาน
  Widget _buildEmployeeList(BuildContext context) {
    final ScrollController _scrollController = ScrollController();
    return BlocBuilder<EmployeeBloc, EmployeeState>(
      builder: (context, state) {
        if (state is EmployeeLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is EmployeeLoaded) {
          return Stack(
            children: [
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Color.fromARGB(254, 195, 195, 195),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'All Employees',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 19,
                              fontWeight: FontWeight.w500,
                              color: "#3C3C3C".toColor(),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(254, 227, 233, 239),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              '${state.employees.length}',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 19,
                                fontWeight: FontWeight.w600,
                                color: "#3C3C3C".toColor(),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    Expanded(
                      child: Stack(
                        children: [
                          Scrollbar(
                            controller: _scrollController,
                            thickness: 8,
                            radius: Radius.circular(20),
                            scrollbarOrientation: ScrollbarOrientation.right,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 15.0),
                              child: ListView.builder(
                                controller: _scrollController,
                                itemCount: state.employees.length,
                                itemBuilder: (context, index) {
                                  final employee = state.employees[index];
                                  return Column(
                                    children: [
                                      Container(
                                        height: 60,
                                        child: ListTile(
                                          dense: true,
                                          contentPadding: EdgeInsets.only(left: 20, right: 20),
                                          leading: CircleAvatar(
                                            radius: 40,
                                            backgroundColor: "#496EE2".toColor(),
                                            child: Text(
                                              employee.userName.isNotEmpty ? employee.userName[0].toUpperCase() : "?",
                                              style: const TextStyle(
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                fontSize: 24,
                                              ),
                                            ),
                                          ),
                                          title: Text(
                                            employee.userName,
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: 19,
                                              color: "#3C3C3C".toColor(),
                                            ),
                                          ),
                                          subtitle: Text(
                                            'First Name: ${employee.firstName} - Last Name: ${employee.lastName}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'Inter',
                                              color: "#959595".toColor(),
                                            ),
                                          ),
                                          trailing: SizedBox(
                                            width: 300,
                                            height: 60,
                                            child: Align(
                                              alignment: (employee.roles.length < 3) ? Alignment.centerRight : Alignment.centerLeft,
                                              child: SingleChildScrollView(
                                                scrollDirection: Axis.horizontal,
                                                child: Row(
                                                  children: employee.roles.map((role) {
                                                    return Container(
                                                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                                                      margin: const EdgeInsets.only(right: 8),
                                                      decoration: BoxDecoration(
                                                        color: "#EDF2FE".toColor(),
                                                        borderRadius: BorderRadius.circular(20),
                                                        border: Border.all(
                                                          color: "#C3C3C3".toColor(),
                                                          width: 1,
                                                        ),
                                                      ),
                                                      child: Text(
                                                        role.toString().split(' ')[0],
                                                        style: const TextStyle(
                                                          fontFamily: 'Inter',
                                                          fontSize: 18,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                            ),
                                          ),
                                          onTap: () async {
                                            final result = await showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              builder: (_) {
                                                return Container(
                                                    height: MediaQuery.of(context).size.height * 0.973, child: AddEmployeeScreen(employee: employee));
                                              },
                                            );
                                            if (result == 'refresh') {
                                              context.read<EmployeeBloc>().add(LoadEmployees());
                                            }
                                          },
                                        ),
                                      ),
                                      if (index != state.employees.length - 1)
                                        Divider(
                                          color: "#C3C3C3".toColor(),
                                        ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        } else if (state is EmployeeError) {
          return Center(
            child: Text(
              'Error: ${state.message}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }
        return const Center(child: Text('No employees found.'));
      },
    );
  }

  /// * Bottom Navigation Bar
  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      height: 105,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(thickness: 2, color: Color.fromARGB(254, 195, 195, 195)),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 235,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: "#F2F2F2".toColor(),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      side: BorderSide(color: "#C3C3C3".toColor(), width: 1),
                    ),
                    child: const Text(
                      'Close',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Color.fromARGB(255, 79, 79, 79)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
