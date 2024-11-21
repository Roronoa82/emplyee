// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../bloc/employee_bloc.dart';
// import '../employee.dart';

// class EditEmployeePage extends StatefulWidget {
//   final Employee employee;
//   EditEmployeePage({required this.employee});

//   @override
//   _EditEmployeePageState createState() => _EditEmployeePageState();
// }

// class _EditEmployeePageState extends State<EditEmployeePage> {
//   final _formKey = GlobalKey<FormState>();
//   late TextEditingController _userNameController;
//   late TextEditingController _loginPinController;
//   late TextEditingController _firstNameController;
//   late TextEditingController _lastNameController;
//   late TextEditingController _rolesController;

//   @override
//   void initState() {
//     super.initState();
//     _userNameController = TextEditingController(text: widget.employee.userName);
//     _loginPinController = TextEditingController(text: widget.employee.loginPin);
//     _firstNameController =
//         TextEditingController(text: widget.employee.firstName);
//     _lastNameController = TextEditingController(text: widget.employee.lastName);
//     _rolesController =
//         TextEditingController(text: widget.employee.roles.join(', '));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Edit Employee')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 controller: _userNameController,
//                 decoration: InputDecoration(labelText: 'User Name'),
//                 validator: (value) =>
//                     value?.isEmpty == true ? 'Please enter user name' : null,
//               ),
//               TextFormField(
//                 controller: _loginPinController,
//                 decoration: InputDecoration(labelText: 'Login Pin'),
//                 validator: (value) =>
//                     value?.isEmpty == true ? 'Please enter login pin' : null,
//               ),
//               TextFormField(
//                 controller: _firstNameController,
//                 decoration: InputDecoration(labelText: 'First Name'),
//                 validator: (value) =>
//                     value?.isEmpty == true ? 'Please enter first name' : null,
//               ),
//               TextFormField(
//                 controller: _lastNameController,
//                 decoration: InputDecoration(labelText: 'Last Name'),
//                 validator: (value) =>
//                     value?.isEmpty == true ? 'Please enter last name' : null,
//               ),
//               TextFormField(
//                 controller: _rolesController,
//                 decoration:
//                     InputDecoration(labelText: 'Roles (comma separated)'),
//                 validator: (value) =>
//                     value?.isEmpty == true ? 'Please enter roles' : null,
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   if (_formKey.currentState?.validate() == true) {
//                     final roles = _rolesController.text
//                         .split(',')
//                         .map((e) => e.trim())
//                         .toList();
//                     final updatedEmployee = widget.employee
//                       ..userName = _userNameController.text
//                       ..loginPin = _loginPinController.text
//                       ..firstName = _firstNameController.text
//                       ..lastName = _lastNameController.text
//                       ..roles = roles;

//                     context
//                         .read<EmployeeBloc>()
//                         .add(UpdateEmployeeEvent(updatedEmployee));
//                     Navigator.pop(context);
//                   }
//                 },
//                 child: Text('Update Employee'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
