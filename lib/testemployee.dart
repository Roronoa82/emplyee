// // ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, avoid_print, avoid_unnecessary_containers, sized_box_for_whitespace, sort_child_properties_last

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:supercharged/supercharged.dart';
// import '../bloc/employee_bloc.dart';

// import '../employee.dart';
// import '../isar_service.dart';
// import 'add_employee.dart';

// class EmployeePageScreen extends StatelessWidget {
//   const EmployeePageScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     List getEmployees = [];
//     return BlocProvider(
//       create: (context) => EmployeeBloc(IsarService())..add(LoadEmployees()),
//       child: BlocListener<EmployeeBloc, EmployeeState>(
//         listener: (context, state) {
//           if (state is EmployeeLoaded) {
//             debugPrint('Employees data loaded!');
//             getEmployees = state.employees;
//             print(getEmployees.length);
//           }
//           if (state is EmployeeError) {
//             print('Error: ${state.message}');
//           }
//         },
//         child: BlocBuilder<EmployeeBloc, EmployeeState>(
//           builder: (context, state) {
//             return Scaffold(
//               resizeToAvoidBottomInset: false,
//               appBar: AppBar(
//                 title: const Text(
//                   'Employees & Job Roles',
//                   style: TextStyle(
//                     fontFamily: 'Inter',
//                     fontSize: 32,
//                     fontWeight: FontWeight.w800,
//                     color: Color.fromARGB(254, 73, 110, 226),
//                   ),
//                 ),
//                 shadowColor: Colors.black,
//                 backgroundColor: Colors.white,
//                 elevation: 8,
//                 toolbarHeight: 90,
//                 automaticallyImplyLeading: false,
//               ),
//               body: Row(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(top: 30, left: 20),
//                     child: Align(
//                       alignment: Alignment.topCenter,
//                       child: Container(
//                         width: 270,
//                         height: 75,
//                         padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                         decoration: BoxDecoration(
//                           border: Border.all(
//                             color: Color.fromARGB(51, 0, 0, 0),
//                             width: 1,
//                           ),
//                           color: Color.fromARGB(254, 73, 110, 226),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Icon(Icons.group, color: Color.fromARGB(253, 255, 255, 255), size: 35),
//                             SizedBox(width: 20),
//                             Text(
//                               'Employees',
//                               style: TextStyle(
//                                 fontFamily: 'Inter',
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.w600,
//                                 color: Color.fromARGB(255, 255, 255, 255),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.only(bottom: 15, top: 30, left: 30, right: 30),
//                       child: Container(
//                         height: MediaQuery.of(context).size.height * 0.9,
//                         decoration: BoxDecoration(
//                           border: Border.all(
//                             color: Color.fromARGB(254, 195, 195, 195),
//                             width: 1,
//                           ),
//                           color: Color.fromARGB(254, 238, 238, 238),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Padding(
//                           padding: EdgeInsets.only(top: 20, bottom: 8, left: 30, right: 50),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Row(
//                                 children: [
//                                   Icon(Icons.group, color: Color.fromARGB(255, 60, 60, 60), size: 35),
//                                   const SizedBox(width: 8),
//                                   const Text(
//                                     'Employees',
//                                     style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: Color.fromARGB(255, 60, 60, 60)),
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(height: 20),
//                               Container(
//                                 child: ElevatedButton(
//                                   onPressed: () {
//                                     showModalBottomSheet(
//                                       context: context,
//                                       isScrollControlled: true,
//                                       builder: (_) {
//                                         return Container(
//                                           height: MediaQuery.of(context).size.height * 0.973,
//                                           child: AddEmployeeScreen(),
//                                         );
//                                       },
//                                     );
//                                   },
//                                   child: const Text(
//                                     ' + Add Employees',
//                                     style: TextStyle(
//                                       fontFamily: 'Inter',
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.w600,
//                                       color: Color.fromARGB(255, 73, 110, 226),
//                                     ),
//                                   ),
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.white,
//                                     minimumSize: Size(150, 55),
//                                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                                     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                                     side: BorderSide(
//                                       color: Color.fromARGB(255, 195, 195, 195),
//                                       width: 1,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(height: 15),
//         Expanded(
//           child: BlocListener<EmployeeBloc, EmployeeState>(
//             listener: (context, state) {},
//             child: BlocBuilder<EmployeeBloc, EmployeeState>(
//               builder: (context, state) {
//                 if (state is EmployeeLoading) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (state is EmployeeLoaded) {
//                   return Card(
//                     elevation: 2,
//                     shape: RoundedRectangleBorder(
//                       side: BorderSide(
//                         color: Color.fromARGB(254, 195, 195, 195),
//                         width: 1,
//                       ),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Column(
//                       children: [
//                         Padding(
//                             padding: const EdgeInsets.all(7.0),
//                             child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//                               Text(
//                                 'All Employees',
//                                 style: const TextStyle(
//                                     fontFamily: 'Inter',
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.w500,
//                                     color: Color.fromARGB(255, 60, 60, 60)),
//                               ),
//                               SizedBox(
//                                 width: 10,
//                               ),
//                               Container(
//                                 padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//                                 decoration: BoxDecoration(
//                                   color: const Color.fromARGB(254, 227, 233, 239),
//                                   borderRadius: BorderRadius.circular(5),
//                                 ),
//                                 child: Text(
//                                   '${getEmployees.length}',
//                                   style: const TextStyle(
//                                       fontFamily: 'Inter', fontSize: 18, color: Color.fromARGB(255, 60, 60, 60)),
//                                   textAlign: TextAlign.center,
//                                 ),
//                               ),
//                             ])),
//                         Divider(),
//                         Expanded(
//                           child: Scrollbar(
//                             thickness: 10,
//                             radius: Radius.circular(10),
//                             thumbVisibility: true,
//                             child: ListView.builder(
//                               shrinkWrap: true,
//                               itemCount: state.employees.length,
//                               itemBuilder: (context, index) {
//                                 final employee = state.employees[index];
//                                 return Column(
//                                   children: [
//                                     ListTile(
//                                       leading: CircleAvatar(
//                                         radius: 50,
//                                         backgroundColor: const Color.fromARGB(254, 73, 110, 226),
//                                         child: Text(
//                                           (employee.userName.isNotEmpty) ? employee.userName[0].toUpperCase() : "?",
//                                           style: const TextStyle(
//                                               fontFamily: 'Inter',
//                                               fontWeight: FontWeight.bold,
//                                               color: Colors.white,
//                                               fontSize: 30),
//                                         ),
//                                       ),
//                                       title: Text(
//                                         employee.userName,
//                                         style: const TextStyle(
//                                           fontFamily: 'Inter',
//                                           fontSize: 18,
//                                         ),
//                                       ),
//                                       subtitle: Text(
//                                         'First Name: ${employee.firstName} - Last Name: ${employee.lastName}',
//                                         style: const TextStyle(
//                                           fontSize: 14,
//                                           fontFamily: 'Inter',
//                                         ),
//                                       ),
//                                       trailing: SizedBox(
//                                         width: 300,
//                                         height: 50,
//                                         child: Align(
//                                           alignment: (employee.roles.length < 3) ? Alignment.centerRight : Alignment.centerLeft,
//                                           child: SingleChildScrollView(
//                                             scrollDirection: Axis.horizontal,
//                                             child: Row(
//                                               children: employee.roles.map((role) {
//                                                 return Container(
//                                                   padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
//                                                   margin: const EdgeInsets.only(right: 8),
//                                                   decoration: BoxDecoration(
//                                                     color: "#EDF2FE".toColor(),
//                                                     borderRadius: BorderRadius.circular(20),
//                                                     border: Border.all(
//                                                       color: "#C3C3C3".toColor(),
//                                                       width: 1,
//                                                     ),
//                                                   ),
//                                                   child: Text(
//                                                     role.toString().split(' ')[0],
//                                                     style: const TextStyle(
//                                                       fontFamily: 'Inter',
//                                                       fontSize: 18,
//                                                       color: Colors.black,
//                                                     ),
//                                                   ),
//                                                 );
//                                               }).toList(),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       onTap: () async {
//                                         final result = await showModalBottomSheet(
//                                           context: context,
//                                           isScrollControlled: true,
//                                           backgroundColor: Colors.black,
//                                           builder: (_) {
//                                             return Container(
//                                               height: MediaQuery.of(context).size.height * 0.972,
//                                               child: AddEmployeeScreen(employee: employee),
//                                             );
//                                           },
//                                         );
//                                         if (result == 'refresh') {
//                                           debugPrint(result);
//                                           context.read<EmployeeBloc>().add(LoadEmployees());
//                                         }
//                                       },
//                                     ),
//                                     Divider(
//                                       color: "#C3C3C3".toColor(),
//                                     ),
//                                   ],
//                                 );
//                               },
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 } else if (state is EmployeeError) {
//                   return Center(
//                     child: Text(
//                       'Error: ${state.message}',
//                       style: const TextStyle(color: Colors.red),
//                     ),
//                   );
//                 }
//                 return const Center(child: Text('No employees found.'));
//               },
//             ),
//           ),
//         )
//       ],
//     ),
//   ),
// ),
//                     ),
//                   ),
//                 ],
//               ),
//               bottomNavigationBar: Container(
//                 height: 105,
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Divider(
//                       thickness: 2,
//                       color: const Color.fromARGB(254, 195, 195, 195),
//                     ),
//                     SizedBox(
//                       height: 15,
//                     ),
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 30),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           Container(
//                             width: 235,
//                             height: 55,
//                             child: ElevatedButton(
//                               onPressed: () => Navigator.pop(context),
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: "#F2F2F2".toColor(),
//                                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                                 padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                                 side: BorderSide(
//                                   color: "#C3C3C3".toColor(),
//                                   width: 1,
//                                 ),
//                               ),
//                               child: const Text(
//                                 'Close',
//                                 style:
//                                     TextStyle(fontFamily: 'Inter', fontSize: 20, fontWeight: FontWeight.w500, color: Color.fromARGB(255, 79, 79, 79)),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }