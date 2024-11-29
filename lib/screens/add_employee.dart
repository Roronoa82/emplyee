// ignore_for_file: avoid_init_to_null, use_build_context_synchronously, prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, sort_child_properties_last, must_be_immutable, avoid_print, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supercharged/supercharged.dart';
import '../bloc/employee_bloc.dart';
import '../employee.dart';
import '../isar_service.dart';
import 'employee_page.dart';

class AddEmployeeScreen extends StatefulWidget {
  final Employee? employee;
  String? errorMessage;

  AddEmployeeScreen({Key? key, this.employee}) : super(key: key);
  @override
  State<AddEmployeeScreen> createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _loginPinController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _aptSuiteController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final controller = TextEditingController();
  bool _isPasswordVisible = false;
  String? errorMessage;

  final Map<String, bool> _roles = {
    "Delivery (\$10.00)": false,
    "Kitchen Staff (\$12.00)": false,
    "Manager (\$14.00)": false,
    "Owner (\$18.00)": false,
    "Supervisor (\$10.00)": false,
    "Waiter / Waitress (\$10.00)": false,
  };

  dynamic localExistingEmployee = null;

  @override
  void initState() {
    super.initState();

    if (widget.employee != null) {
      final employee = widget.employee!;
      _userNameController.text = employee.userName;
      _loginPinController.text = employee.loginPin;
      _firstNameController.text = employee.firstName;
      _lastNameController.text = employee.lastName;
      _addressController.text = employee.address;
      _aptSuiteController.text = employee.aptSuite;
      _cityController.text = employee.city;
      _stateController.text = employee.state;
      _zipCodeController.text = employee.zipCode;
      _phoneController.text = employee.phone;

      for (var role in employee.roles) {
        if (_roles.containsKey(role)) {
          _roles[role] = true;
        }
      }
    }
  }

  final IsarService isarService = IsarService();

  void _onSave() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      print("Form has errors. Cannot save.");
      return;
    }
    final newEmployee = Employee()
      ..userName = _userNameController.text
      ..loginPin = _loginPinController.text
      ..firstName = _firstNameController.text
      ..lastName = _lastNameController.text
      ..address = _addressController.text
      ..aptSuite = _aptSuiteController.text
      ..city = _cityController.text
      ..state = _stateController.text
      ..zipCode = _zipCodeController.text
      ..phone = _phoneController.text
      ..roles = _roles.entries.where((entry) => entry.value).map((entry) => entry.key).toList();
    final existingEmployee = (await isarService.getEmployeeByPin(newEmployee.loginPin));
    setState(() {
      localExistingEmployee = existingEmployee;
    });

    // เงื่อนไขการตรวจสอบ loginPin ว่ามีคนใช้หรือไม่
    if (existingEmployee != null && existingEmployee.id != widget.employee?.id) {
      errorMessage = 'Invalid PIN, Please try again.';
    } else {
      errorMessage = null;
      // ถ้าไม่มีการใช้ loginPin ซ้ำ หรือเป็นพนักงานคนเดิมที่กำลังแก้ไขข้อมูล
      if (widget.employee != null) {
        // ถ้าเป็นการอัพเดทข้อมูลพนักงานที่มีอยู่แล้ว
        newEmployee.id = widget.employee!.id;
        context.read<EmployeeBloc>().add(UpdateEmployee(newEmployee));
      } else {
        // ถ้าเป็นการเพิ่มพนักงานใหม่
        context.read<EmployeeBloc>().add(AddEmployee(newEmployee));
      }
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(
                color: "#00000033".toColor(),
                width: 2.0,
              ),
            ),
            content: Container(
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height * 0.32,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/success2.gif',
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 50),
                  Text(
                    'Success',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 36,
                      color: Color.fromARGB(254, 60, 60, 60),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Saved successfully',
                    style: TextStyle(
                        fontFamily: 'Inter/assets/font/Inter/static/Inter_28pt-Bold.ttf',
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: Color.fromARGB(254, 85, 85, 85)),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),
                  Divider(
                    color: Color.fromARGB(254, 195, 195, 195),
                    thickness: 1,
                  ),
                ],
              ),
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EmployeePageScreen(),
                      ),
                    );
                    {
                      // เมื่อกดบันทึกจะตรวจสอบฟอร์ม
                      if (_formKey.currentState?.validate() ?? false) {
                        print('Data saved');
                      } else {
                        print('Please correct errors');
                      }
                    }
                  },
                  child: Center(
                    child: Container(
                      height: 60,
                      width: 200,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(254, 0, 138, 0),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(
                          'OK',
                          style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontFamily: 'Inter', fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  void _onDelete() {
    if (widget.employee != null) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            content: Container(
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height * 0.35,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/tarsh11.png',
                    width: 250,
                    height: 200,
                  ),
                  Text(
                    'Delete Confirmation',
                    style: TextStyle(
                      fontFamily: 'Inter/assets/font/Inter/static/Inter_28pt-Bold.ttf',
                      fontSize: 37,
                      color: Color.fromARGB(255, 83, 83, 83),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Are you sure you want to delete?',
                    style: TextStyle(
                        fontFamily: 'Inter/assets/font/Inter/static/Inter_28pt-Bold.ttf',
                        fontSize: 29,
                        fontWeight: FontWeight.w600,
                        color: Color.fromARGB(255, 137, 137, 137)),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 35),
                  Divider(
                    color: "#00000033".toColor(),
                    thickness: 1,
                  ),
                ],
              ),
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // ปิด Dialog
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: "#F2F2F2".toColor(),
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: "#C3C3C3".toColor(),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(fontFamily: 'Inter', fontSize: 20, fontWeight: FontWeight.w700, color: Color.fromARGB(255, 79, 79, 79)),
                  ),
                ),
              ),
              SizedBox(width: 5),
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: "#DE3112".toColor(),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    side: BorderSide(
                      color: "#C3C3C3".toColor(),
                      width: 1,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.read<EmployeeBloc>().add(DeleteEmployee(widget.employee!.id));

                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          content: Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: MediaQuery.of(context).size.height * 0.32,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/success2.gif',
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                                SizedBox(height: 50),
                                Text(
                                  'Success',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 36,
                                    color: "#3C3C3C".toColor(),
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                SizedBox(height: 30),
                                Text(
                                  'Saved successfully',
                                  style: TextStyle(
                                      fontFamily: 'Inter/assets/font/Inter/static/Inter_28pt-Bold.ttf',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 26,
                                      color: "#555555".toColor()),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 30),
                                Divider(
                                  color: "#00000033".toColor(),
                                  thickness: 1,
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 40.0),
                              child: TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EmployeePageScreen(),
                                    ),
                                  );
                                },
                                child: Center(
                                  child: Container(
                                    height: 60,
                                    width: 200,
                                    decoration: BoxDecoration(
                                      color: "#008A00".toColor(),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'OK',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text(
                    'Delete',
                    style: TextStyle(fontFamily: 'Inter', fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EmployeeBloc, EmployeeState>(
      listener: (context, state) {
        if (state is EmployeeLoaded) {
          debugPrint('Employee data loaded!!!!!!!!!!!!!!!!!');
        } else if (state is EmployeeError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.grey[200],
        body: _buildMainContent(context),
      ),
    );
  }

  /// *เนื้อหาหลักในหน้าจอ
  Widget _buildMainContent(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color.fromARGB(254, 255, 255, 255),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(78, 102, 102, 102),
              blurRadius: 10,
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 5),
              _buildEmployeeForm(context),
              const SizedBox(height: 10),
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  /// * Header
  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const EmployeePageScreen()),
                );
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Color(0xFFA7A7A7).withOpacity(0.2),
                  borderRadius: BorderRadius.all(Radius.circular(99)),
                ),
                child: const Icon(
                  Icons.clear,
                  size: 40,
                  color: Colors.black54,
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(left: 50),
          child: Text(
            'Add / Edit Employees',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 32,
              fontWeight: FontWeight.w600,
              color: "#3C3C3C".toColor(),
            ),
          ),
        ),
      ],
    );
  }

  /// * EmployeeForm
  Widget _buildEmployeeForm(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.745,
        decoration: BoxDecoration(
          color: const Color.fromARGB(254, 238, 238, 238),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color.fromARGB(254, 195, 195, 195),
            width: 1,
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: _buildPersonalInfoSection(),
            ),
            const SizedBox(width: 20),
            Expanded(
              flex: 1,
              child: _buildRolesSection(),
            ),
          ],
        ),
      ),
    );
  }

  /// *Container ซ้าย
  Widget _buildPersonalInfoSection() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.705,
      decoration: BoxDecoration(
        color: "#FFFFFF".toColor(),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: "#C3C3C3".toColor()),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 15),
              _buildTextField("User Name", _userNameController, isUserName: true),
              _buildTextField("Login PIN", _loginPinController, isPassword: true, errorText: errorMessage),
              Divider(
                color: "#C3C3C3".toColor(),
              ),
              Row(
                children: [
                  Expanded(child: _buildTextField("First Name", _firstNameController)),
                  const SizedBox(width: 10),
                  Expanded(child: _buildTextField("Last Name", _lastNameController)),
                ],
              ),
              _buildTextField("Address", _addressController),
              _buildTextField("Apt./Suite", _aptSuiteController, isOptional: true),
              Row(
                children: [
                  Expanded(flex: 2, child: _buildTextField("City", _cityController)),
                  const SizedBox(width: 15),
                  Expanded(child: _buildTextField("State", _stateController)),
                  const SizedBox(width: 15),
                  Expanded(child: _buildTextField("ZIP Code", _zipCodeController, isNumeric: true)),
                ],
              ),
              _buildTextField("Phone", _phoneController, isPhone: true),
            ],
          ),
        ),
      ),
    );
  }

  /// *Container ขวา (Roles)
  Widget _buildRolesSection() {
    return Container(
      decoration: BoxDecoration(
        color: "#FFFFFF".toColor(),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: "#C3C3C3".toColor(), width: 1),
      ),
      padding: const EdgeInsets.only(top: 30, left: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Allowed Login Roles",
            style: TextStyle(fontFamily: 'Inter', fontSize: 20),
          ),
          const SizedBox(height: 23),
          ..._roles.keys.map((role) {
            return Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 14.0),
                  child: Transform.scale(
                    scale: 2,
                    child: Checkbox(
                      side: BorderSide(color: "#C3C3C3".toColor()),
                      activeColor: "#496EE2".toColor(),
                      value: _roles[role],
                      onChanged: (value) {
                        setState(() {
                          _roles[role] = value!;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _roles[role] = !_roles[role]!;
                    });
                  },
                  child: Text(role, style: const TextStyle(fontFamily: 'Inter', fontSize: 20)),
                ),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  /// *Botton Actions
  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (widget.employee != null)
            Container(
              width: 280,
              height: 57,
              child: ElevatedButton(
                  onPressed: _onDelete,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(254, 222, 49, 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    side: BorderSide(
                      color: Color.fromARGB(254, 195, 195, 195),
                      width: 1,
                    ),
                  ),
                  child: Row(children: [
                    Image.asset(
                      'assets/tarsh2.png',
                      width: 30,
                      height: 30,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Delete Employees",
                      style: TextStyle(fontFamily: 'Inter', fontSize: 22, color: Color.fromARGB(254, 255, 255, 255)),
                    ),
                  ])),
            ),
          Spacer(),
          Container(
            width: 235,
            height: 57,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: "#F2F2F2".toColor(),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                side: BorderSide(
                  color: "#C3C3C3".toColor(),
                  width: 1,
                ),
              ),
              child: Text("Cancel",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: "#3C3C3C".toColor(),
                  )),
            ),
          ),
          const SizedBox(width: 15),
          Container(
            width: 365,
            height: 57,
            child: ElevatedButton(
              onPressed: _onSave,
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  side: BorderSide(
                    color: Color.fromARGB(254, 195, 195, 195),
                    width: 1,
                  ),
                  backgroundColor: Color.fromARGB(254, 73, 110, 226)),
              child: Text(
                "Save",
                style: TextStyle(
                  fontFamily: 'Inter',
                  color: "#FFFFFF".toColor(),
                  fontSize: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool showMessage = true;
  Widget _buildTextField(String label, TextEditingController controller,
      {TextStyle? style,
      bool isPassword = false,
      bool isUserName = false,
      bool isOptional = false,
      bool isNumeric = false,
      bool isPhone = false,
      String? errorText}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
              fontFamily: 'Inter',
              color: Color.fromARGB(255, 60, 60, 60),
              fontSize: isUserName ? 23 : 19,
              fontWeight: isUserName ? FontWeight.w600 : FontWeight.w400),
        ),
        SizedBox(height: 7),
        Container(
          child: TextFormField(
            controller: controller,
            obscureText: isPassword ? !_isPasswordVisible : false,
            keyboardType: isNumeric || isPhone ? TextInputType.number : TextInputType.text,
            validator: (value) {
              if (isOptional && (value == null || value.isEmpty)) {
                return null; // ฟิลด์ที่ไม่จำเป็นไม่ต้องตรวจสอบ
              }
              if (isPassword && (value == null || value.isEmpty)) {
                return null;
              }

              if (value == null || value.isEmpty) {
                return '$label is required';
              }
              if (isUserName && value.length < 3) {
                return 'User Name must be at least 3 characters';
              }
              // if (isPassword && value.length < 4) {
              //   return 'Login PIN must be at least 4 digits';
              // }
              if (isNumeric && !RegExp(r'^\d+$').hasMatch(value)) {
                return '$label must be numeric';
              }
              if (isPhone && !RegExp(r'^(?:\d{10}|\d{3}-\d{3}-\d{4})$').hasMatch(value)) {
                return 'Phone number must be 10 digits';
              }
              return null; // ผ่านการตรวจสอบ
            },
            style: style ??
                TextStyle(
                  fontSize: 19,
                  color: Color.fromARGB(254, 60, 60, 60),
                ),
            decoration: InputDecoration(
              errorText: errorText,
              isDense: true,
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        color: const Color.fromARGB(255, 60, 60, 60),
                        size: 30,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
            onChanged: (value) {
              if (label == 'Login PIN') {
                setState(() {
                  showMessage = false;
                });
              }
            },
          ),
        ),
        SizedBox(
          height: 5,
        ),
        SizedBox(height: 5),
      ],
    );
  }
}
