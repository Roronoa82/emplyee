//  import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:supercharged/supercharged.dart';
// import '../bloc/employee_bloc.dart';
// import '../employee.dart';
// import '../isar_service.dart';
// import 'employee_page.dart';

// class AddEmployeeScreen extends StatefulWidget {
//   final Employee? employee;

//   const AddEmployeeScreen({Key? key, this.employee}) : super(key: key);
//   @override
//   State<AddEmployeeScreen> createState() => _AddEmployeeScreenState();
// }

// class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
//   final TextEditingController _userNameController = TextEditingController();
//   final TextEditingController _loginPinController = TextEditingController();
//   final TextEditingController _firstNameController = TextEditingController();
//   final TextEditingController _lastNameController = TextEditingController();
//   final TextEditingController _addressController = TextEditingController();
//   final TextEditingController _aptSuiteController = TextEditingController();
//   final TextEditingController _cityController = TextEditingController();
//   final TextEditingController _stateController = TextEditingController();
//   final TextEditingController _zipCodeController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();

//   bool _isPasswordVisible = false;

//   final Map<String, bool> _roles = {
//     "Delivery (\$10.00)": false,
//     "Kitchen Staff (\$12.00)": false,
//     "Manager (\$14.00)": false,
//     "Owner (\$18.00)": false,
//     "Supervisor (\$10.00)": false,
//     "Waiter / Waitress (\$10.00)": false,
//   };

//   dynamic localExistingEmployee = null;

//   @override
//   void initState() {
//     super.initState();

//     if (widget.employee != null) {
//       final employee = widget.employee!;
//       _userNameController.text = employee.userName;
//       _loginPinController.text = employee.loginPin;
//       _firstNameController.text = employee.firstName;
//       _lastNameController.text = employee.lastName;
//       _addressController.text = employee.address;
//       _aptSuiteController.text = employee.aptSuite;
//       _cityController.text = employee.city;
//       _stateController.text = employee.state;
//       _zipCodeController.text = employee.zipCode;
//       _phoneController.text = employee.phone;

//       for (var role in employee.roles) {
//         if (_roles.containsKey(role)) {
//           _roles[role] = true;
//         }
//       }
//     }
//   }

//   final IsarService isarService = IsarService();

//   void _onSave() async {
//     final newEmployee = Employee()
//       ..userName = _userNameController.text
//       ..loginPin = _loginPinController.text
//       ..firstName = _firstNameController.text
//       ..lastName = _lastNameController.text
//       ..address = _addressController.text
//       ..aptSuite = _aptSuiteController.text
//       ..city = _cityController.text
//       ..state = _stateController.text
//       ..zipCode = _zipCodeController.text
//       ..phone = _phoneController.text
//       ..roles = _roles.entries.where((entry) => entry.value).map((entry) => entry.key).toList();
//     final existingEmployee = (await isarService.getEmployeeByPin(newEmployee.loginPin));
//     setState(() {
//       localExistingEmployee = existingEmployee;
//     });

//     if (existingEmployee != null) {
//     } else {
//       if (widget.employee != null) {
//         newEmployee.id = widget.employee!.id;
//         context.read<EmployeeBloc>().add(UpdateEmployee(newEmployee));
//       } else {
//         context.read<EmployeeBloc>().add(AddEmployee(newEmployee));
//       }

//       showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//             content: Container(
//               width: MediaQuery.of(context).size.width * 0.5,
//               height: MediaQuery.of(context).size.height * 0.35,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Image.asset(
//                     'assets/success2.gif',
//                     width: 150,
//                     height: 150,
//                     fit: BoxFit.cover,
//                   ),
//                   SizedBox(height: 50),
//                   Text(
//                     'Success',
//                     style: TextStyle(
//                       fontFamily: 'Inter',
//                       fontSize: 36,
//                       color: Color.fromARGB(254, 60, 60, 60),
//                       fontWeight: FontWeight.w900,
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   Text(
//                     'Saved successfully',
//                     style: TextStyle(
//                         fontFamily: 'Inter/assets/font/Inter/static/Inter_28pt-Bold.ttf',
//                         fontSize: 26,
//                         fontWeight: FontWeight.w700,
//                         color: Color.fromARGB(254, 85, 85, 85)),
//                     textAlign: TextAlign.center,
//                   ),
//                   SizedBox(height: 20),
//                   Divider(
//                     color: Color.fromARGB(254, 195, 195, 195),
//                     thickness: 1,
//                   ),
//                 ],
//               ),
//             ),
//             actionsAlignment: MainAxisAlignment.center,
//             actions: [
//               Padding(
//                 padding: const EdgeInsets.only(top: 10.0, bottom: 60),
//                 child: TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => EmployeePageScreen(),
//                       ),
//                     );
//                   },
//                   child: Center(
//                     child: Container(
//                       height: 60,
//                       width: 200,
//                       decoration: BoxDecoration(
//                         color: Color.fromARGB(254, 0, 138, 0),
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                       child: Center(
//                         child: Text(
//                           'OK',
//                           style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontFamily: 'Inter', fontSize: 20, fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       );
//     }
//   }

//   void _onDelete() {
//     if (widget.employee != null) {
//       showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//             content: Container(
//               width: MediaQuery.of(context).size.width * 0.5,
//               height: MediaQuery.of(context).size.height * 0.32,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Image.asset(
//                     'assets/tarsh11.png',
//                     width: 250,
//                     height: 200,
//                   ),
//                   Text(
//                     'Delete Confirmation',
//                     style: TextStyle(
//                       fontFamily: 'Inter/assets/font/Inter/static/Inter_28pt-Bold.ttf',
//                       fontSize: 36,
//                       color: Color.fromARGB(255, 83, 83, 83),
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   Text(
//                     'Are you sure you want to delete?',
//                     style: TextStyle(
//                         fontFamily: 'Inter/assets/font/Inter/static/Inter_28pt-Bold.ttf',
//                         fontSize: 24,
//                         fontWeight: FontWeight.w600,
//                         color: Color.fromARGB(255, 137, 137, 137)),
//                     textAlign: TextAlign.center,
//                   ),
//                   SizedBox(height: 20),
//                   Divider(
//                     color: Color.fromARGB(254, 195, 195, 195),
//                     thickness: 1,
//                   ),
//                 ],
//               ),
//             ),
//             actionsAlignment: MainAxisAlignment.center,
//             actions: [
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 30),
//                 child: TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop(); // ปิด Dialog
//                   },
//                   style: TextButton.styleFrom(
//                     backgroundColor: const Color.fromARGB(254, 242, 242, 242),
//                     padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                       side: const BorderSide(
//                         color: Color.fromARGB(254, 195, 195, 195),
//                         width: 1,
//                       ),
//                     ),
//                   ),
//                   child: Text(
//                     'Cancel',
//                     style: TextStyle(fontFamily: 'Inter', fontSize: 20, fontWeight: FontWeight.w700, color: Color.fromARGB(255, 79, 79, 79)),
//                   ),
//                 ),
//               ),
//               SizedBox(width: 5),
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 30.0),
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color.fromARGB(254, 222, 49, 18),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                     padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
//                     side: BorderSide(
//                       color: Color.fromARGB(254, 195, 195, 195),
//                       width: 1,
//                     ),
//                   ),
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                     context.read<EmployeeBloc>().add(DeleteEmployee(widget.employee!.id));

//                     showDialog(
//                       context: context,
//                       barrierDismissible: false,
//                       builder: (BuildContext context) {
//                         return AlertDialog(
//                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//                           content: Container(
//                             width: MediaQuery.of(context).size.width * 0.5,
//                             height: MediaQuery.of(context).size.height * 0.35,
//                             child: Column(
//                               mainAxisSize: MainAxisSize.min,
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Image.asset(
//                                   'assets/success2.gif',
//                                   width: 150,
//                                   height: 150,
//                                   fit: BoxFit.cover,
//                                 ),
//                                 SizedBox(height: 50),
//                                 Text(
//                                   'Success',
//                                   style: TextStyle(
//                                     fontFamily: 'Inter',
//                                     fontSize: 36,
//                                     color: Color.fromARGB(254, 60, 60, 60),
//                                     fontWeight: FontWeight.w900,
//                                   ),
//                                 ),
//                                 SizedBox(height: 20),
//                                 Text(
//                                   'Saved successfully',
//                                   style: TextStyle(
//                                       fontFamily: 'Inter/assets/font/Inter/static/Inter_28pt-Bold.ttf',
//                                       fontWeight: FontWeight.w700,
//                                       fontSize: 26,
//                                       color: Color.fromARGB(254, 85, 85, 85)),
//                                   textAlign: TextAlign.center,
//                                 ),
//                                 SizedBox(height: 20),
//                                 Divider(
//                                   color: Color.fromARGB(254, 195, 195, 195),
//                                   thickness: 1,
//                                 ),
//                               ],
//                             ),
//                           ),
//                           actions: [
//                             Padding(
//                               padding: const EdgeInsets.only(bottom: 60.0),
//                               child: TextButton(
//                                 onPressed: () {
//                                   Navigator.of(context).pop();
//                                   Navigator.pushReplacement(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => EmployeePageScreen(),
//                                     ),
//                                   );
//                                 },
//                                 child: Center(
//                                   child: Container(
//                                     height: 60,
//                                     width: 200,
//                                     decoration: BoxDecoration(
//                                       color: Color.fromARGB(254, 0, 138, 0),
//                                       borderRadius: BorderRadius.circular(15),
//                                     ),
//                                     child: Center(
//                                       child: Text(
//                                         'OK',
//                                         style: TextStyle(
//                                           color: Colors.white,
//                                           fontFamily: 'Inter',
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 20,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         );
//                       },
//                     );
//                   },
//                   child: Text(
//                     'Delete',
//                     style: TextStyle(fontFamily: 'Inter', fontSize: 20, fontWeight: FontWeight.w600, color: Color.fromARGB(255, 255, 255, 255)),
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       );
//     }
//   }
 
  // child: Scaffold(
  //   resizeToAvoidBottomInset: true,
  //   backgroundColor: Colors.grey[200],
  //   body: Center(
  //     child: Container(
  //       width: MediaQuery.of(context).size.width,
  //       height: MediaQuery.of(context).size.height,
  //       padding: EdgeInsets.all(16),
  //       decoration: BoxDecoration(
  //         color: Color.fromARGB(254, 255, 255, 255),
  //         borderRadius: BorderRadius.circular(8),
  //         boxShadow: [
  //           BoxShadow(
  //             color: Color.fromARGB(78, 102, 102, 102),
  //             blurRadius: 10,
  //           ),
  //         ],
  //       ),
        // child: SingleChildScrollView(
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       Row(
        //         mainAxisAlignment: MainAxisAlignment.end,
        //         children: [
        //           GestureDetector(
        //             onTap: () {
        //               Navigator.of(context).pop(); // ปิด Dialog
        //               Navigator.pushReplacement(
        //                 context,
        //                 MaterialPageRoute(
        //                   builder: (context) => EmployeePageScreen(),
        //                 ),
        //               );
        //             },
        //             child: Container(
        //               width: 50,
        //               height: 50,
        //               child: Icon(
        //                 Icons.clear,
        //                 size: 40,
        //                 color: Colors.black54,
        //               ),
        //               decoration: BoxDecoration(
        //                 borderRadius: BorderRadius.all(Radius.circular(99)),
        //                 color: Color.fromRGBO(167, 167, 167, 0.2),
        //               ),
        //             ),
        //           ),
        //         ],
        //       ),
        //       Padding(
        //         padding: EdgeInsets.only(left: 50),
        //         child: Text(
        //           'Add / Edit Employees',
        //           style: TextStyle(fontFamily: 'Inter', fontSize: 34, fontWeight: FontWeight.bold),
        //         ),
        //       ),
  //             SizedBox(height: 5),
  //             Card(
  //               margin: EdgeInsets.all(15),
  //               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  //               child: Container(
  //                 width: MediaQuery.of(context).size.width,
  //                 height: MediaQuery.of(context).size.height * 0.745,
  //                 decoration: BoxDecoration(
  //                   color: Color.fromARGB(254, 238, 238, 238),
  //                   border: Border.all(
  //                     color: Color.fromARGB(254, 195, 195, 195),
  //                     width: 1,
  //                   ),
  //                   borderRadius: BorderRadius.circular(12),
  //                 ),
  //                 padding: EdgeInsets.only(top: 20, left: 20, right: 20),
  //                 child: Column(
  //                   children: [
  //                     Row(
  //                       crossAxisAlignment: CrossAxisAlignment.center,
  //                       children: [
  //                         Expanded(
  //                           flex: 1,
  //                           child: Container(
  //                             height: MediaQuery.of(context).size.height * 0.705,
  //                             decoration: BoxDecoration(
  //                               color: Color.fromARGB(254, 255, 255, 255),
  //                               border: Border.all(
  //                                 color: Color.fromARGB(254, 195, 195, 195),
  //                                 width: 1,
  //                               ),
  //                               borderRadius: BorderRadius.circular(12),
  //                             ),
  //                             padding: EdgeInsets.only(left: 35.0, top: 10, right: 35),
  //                             child: SingleChildScrollView(
  //                               child: Column(
  //                                 crossAxisAlignment: CrossAxisAlignment.center,
  //                                 children: [
  //                                   SizedBox(height: 10),
  //                                   _buildTextField("User Name", _userNameController, isUserName: true),
  //                                   _buildTextField(
  //                                     "Login PIN",
  //                                     _loginPinController,
  //                                     isPassword: true,
  //                                   ),
  //                                   Divider(
  //                                     color: Color.fromARGB(254, 195, 195, 195),
  //                                   ),
  //                                   Row(children: [
  //                                     Expanded(child: _buildTextField("First Name", _firstNameController)),
  //                                     SizedBox(width: 10),
  //                                     Expanded(
  //                                       child: _buildTextField("Last Name", _lastNameController),
  //                                     )
  //                                   ]),
  //                                   _buildTextField("Address", _addressController),
  //                                   _buildTextField("Apt./Suite", _aptSuiteController),
  //                                   Row(
  //                                     children: [
  //                                       Expanded(flex: 2, child: _buildTextField("City", _cityController)),
  //                                       SizedBox(width: 10),
  //                                       Expanded(child: _buildTextField("State", _stateController)),
  //                                       SizedBox(width: 10),
  //                                       Expanded(child: _buildTextField("ZIP Code", _zipCodeController)),
  //                                     ],
  //                                   ),
  //                                   _buildTextField("Phone", _phoneController),
  //                                 ],
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                         SizedBox(width: 20),
  //                         Expanded(
  //                             flex: 1,
  //                             child: Container(
  //                               width: MediaQuery.of(context).size.width * 0.5,
  //                               height: MediaQuery.of(context).size.height * 0.705,
  //                               decoration: BoxDecoration(
  //                                   color: Color.fromARGB(254, 255, 255, 255),
  //                                   border: Border.all(
  //                                     color: Color.fromARGB(254, 195, 195, 195),
  //                                     width: 1,
  //                                   ),
  //                                   borderRadius: BorderRadius.circular(12)),
  //                               padding: EdgeInsets.all(16.0),
  //                               child: Padding(
  //                                 padding: EdgeInsets.all(16.0),
  //                                 child: Column(
  //                                   crossAxisAlignment: CrossAxisAlignment.start,
  //                                   children: [
  //                                     Text(
  //                                       "Allowed Login Roles",
  //                                       style: TextStyle(
  //                                         fontFamily: 'Inter',
  //                                         fontSize: 20,
  //                                       ),
  //                                     ),
  //                                     SizedBox(height: 20),
  //                                     ..._roles.keys.map((role) {
  //                                       return Row(
  //                                         children: [
  //                                           Transform.scale(
  //                                             scale: 2,
  //                                             child: Checkbox(
  //                                               side: BorderSide(color: Color.fromARGB(254, 195, 195, 195)),
  //                                               activeColor: Color.fromARGB(254, 73, 110, 226),
  //                                               value: _roles[role],
  //                                               onChanged: (value) {
  //                                                 setState(() {
  //                                                   _roles[role] = value!;
  //                                                 });
  //                                               },
  //                                             ),
  //                                           ),
  //                                           SizedBox(
  //                                             width: 20,
  //                                             height: 50,
  //                                           ),
  //                                           GestureDetector(
  //                                             onTap: () {
  //                                               setState(() {
  //                                                 _roles[role] = !_roles[role]!;
  //                                               });
  //                                             },
  //                                             child: Text(
  //                                               role,
  //                                               style: const TextStyle(
  //                                                 fontFamily: 'Inter',
  //                                                 fontSize: 20,
  //                                               ),
  //                                             ),
  //                                           ),
  //                                         ],
  //                                       );
  //                                     }).toList(),
  //                                   ],
  //                                 ),
  //                               ),
  //                             ))
  //                       ],
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             Align(
  //               alignment: Alignment.centerRight,
  //             ),
  //             SizedBox(height: 10),
  //             Padding(
  //               padding: EdgeInsets.symmetric(horizontal: 20),
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   if (widget.employee != null)
  //                     Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
  //                       Container(
  //                         width: 275,
  //                         height: 60,
  //                         child: ElevatedButton(
  //                             onPressed: _onDelete,
  //                             style: ElevatedButton.styleFrom(
  //                               backgroundColor: const Color.fromARGB(254, 222, 49, 18),
  //                               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  //                               padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //                               side: BorderSide(
  //                                 color: Color.fromARGB(254, 195, 195, 195),
  //                                 width: 1,
  //                               ),
  //                             ),
  //                             child: Row(children: [
  //                               Image.asset(
  //                                 'assets/tarsh2.png',
  //                                 width: 30,
  //                                 height: 30,
  //                               ),
  //                               SizedBox(
  //                                 width: 20,
  //                               ),
  //                               Text(
  //                                 "Delete Employees",
  //                                 style: TextStyle(fontFamily: 'Inter', fontSize: 22, color: Color.fromARGB(254, 255, 255, 255)),
  //                               ),
  //                             ])),
  //                       ),
  //                     ]),
  //                   Spacer(),
  //                   Container(
  //                     width: 235,
  //                     height: 60,
  //                     child: ElevatedButton(
  //                       onPressed: () => Navigator.pop(context),
  //                       style: ElevatedButton.styleFrom(
  //                         backgroundColor: const Color.fromARGB(254, 242, 242, 242),
  //                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  //                         padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //                         side: BorderSide(
  //                           color: Color.fromARGB(254, 195, 195, 195),
  //                           width: 1,
  //                         ),
  //                       ),
  //                       child: Text("Cancel", style: TextStyle(fontFamily: 'Inter', fontSize: 24, color: Colors.black)),
  //                     ),
  //                   ),
  //                   SizedBox(width: 15),
  //                   Container(
  //                     width: 365,
  //                     height: 60,
  //                     child: ElevatedButton(
  //                       onPressed: _onSave,
  //                       style: ElevatedButton.styleFrom(
  //                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  //                           padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //                           side: BorderSide(
  //                             color: Color.fromARGB(254, 195, 195, 195),
  //                             width: 1,
  //                           ),
  //                           backgroundColor: Color.fromARGB(254, 73, 110, 226)),
  //                       child: Text(
  //                         "Save",
  //                         style: TextStyle(
  //                           fontFamily: 'Inter',
  //                           color: const Color.fromARGB(254, 255, 255, 255),
  //                           fontSize: 24,
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   ),
  // ),

  // Widget _buildTextField(String label, TextEditingController controller, {TextStyle? style, bool isPassword = false, bool isUserName = false}) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         label,
  //         style: TextStyle(
  //             fontFamily: 'Inter',
  //             color: Color.fromARGB(255, 60, 60, 60),
  //             fontSize: isUserName ? 22 : 18,
  //             fontWeight: isUserName ? FontWeight.w500 : FontWeight.w400),
  //       ),
  //       SizedBox(height: 5),
  //       Container(
  //         height: 50,
  //         child: TextField(
  //           controller: controller,
  //           obscureText: isPassword ? !_isPasswordVisible : false,
  //           style: style ??
  //               TextStyle(
  //                 fontSize: 18,
  //                 color: Color.fromARGB(254, 60, 60, 60),
  //               ),
  //           decoration: InputDecoration(
  //             suffixIcon: isPassword
  //                 ? IconButton(
  //                     icon: Icon(
  //                       _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
  //                       color: const Color.fromARGB(255, 60, 60, 60),
  //                     ),
  //                     onPressed: () {
  //                       setState(() {
  //                         _isPasswordVisible = !_isPasswordVisible;
  //                       });
  //                     },
  //                   )
  //                 : null,
  //             border: OutlineInputBorder(
  //               borderRadius: BorderRadius.all(Radius.circular(8)),
  //             ),
  //           ),
  //         ),
  //       ),
  //       SizedBox(
  //         height: 5,
  //       ),
  //       if (localExistingEmployee != null && label == 'Login PIN') ...[
  //         Text("Invalid PIN, Please try again.",
  //             style: TextStyle(fontFamily: 'Inter', color: "#DE3112".toColor(), fontSize: 16, fontWeight: FontWeight.normal)),
  //       ],
  //       SizedBox(height: 10),
  //     ],
  //   );
  // }