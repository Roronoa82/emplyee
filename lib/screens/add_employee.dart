import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/employee_bloc.dart';
import '../employee.dart';
import '../isar_service.dart';
import 'employee_page.dart';

class AddEmployeeScreen extends StatefulWidget {
  final Employee? employee;

  AddEmployeeScreen({Key? key, this.employee}) : super(key: key);
  @override
  State<AddEmployeeScreen> createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
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

  final Map<String, bool> _roles = {
    "Delivery (\$10.00)": false,
    "Kitchen Staff (\$12.00)": false,
    "Manager (\$14.00)": false,
    "Owner (\$18.00)": false,
    "Supervisor (\$10.00)": false,
    "Waiter / Waitress (\$10.00)": false,
  };

  @override
  void initState() {
    super.initState();

    // ถ้ามีข้อมูล Employee ที่ส่งเข้ามา (โหมดแก้ไข)
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

      // ตั้งค่า roles ที่ถูกเลือกไว้
      for (var role in employee.roles) {
        if (_roles.containsKey(role)) {
          _roles[role] = true;
        }
      }
    }
  }

  final IsarService isarService =
      IsarService(); // สร้าง instance ของ IsarService

  void _onSave() async {
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
      ..roles = _roles.entries
          .where((entry) => entry.value)
          .map((entry) => entry.key)
          .toList();

    // context.read<EmployeeBloc>().add(getEmployeeByPin(employee));

    // if (widget.employee != null) {
    //   newEmployee.id = widget.employee!.id; // เก็บ ID เดิมสำหรับอัปเดต
    //   context.read<EmployeeBloc>().add(UpdateEmployee(newEmployee));
    // } else {
    //   context.read<EmployeeBloc>().add(AddEmployee(newEmployee));
    // }
    final existingEmployee =
        await isarService.getEmployeeByPin(newEmployee.loginPin);

    // if (existingEmployee != null) {

    if (existingEmployee != null) {
      // หากมี loginPin ซ้ำ แสดงข้อผิดพลาดและไม่เพิ่มพนักงานใหม่
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Column(
              children: [
                Icon(Icons.warning_amber_rounded),
                SizedBox(width: 8),
                Text('Error')
              ],
            ),
            content: Text('PIN นี้มีอยู่ในระบบแล้ว'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // ปิด Dialog
                },
                child: Center(
                  child: Container(
                    height: 50,
                    width: 200,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(254, 255, 0, 0),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Text(
                        'OK',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );
    } else {
      // ถ้าไม่มี loginPin ซ้ำ ให้เพิ่มพนักงานใหม่
      if (widget.employee != null) {
        newEmployee.id = widget.employee!.id; // เก็บ ID เดิมสำหรับอัปเดต
        context.read<EmployeeBloc>().add(UpdateEmployee(newEmployee));
      } else {
        context.read<EmployeeBloc>().add(AddEmployee(newEmployee));
      }

      showDialog(
        context: context,
        barrierDismissible: false, // ป้องกันการปิด Dialog ด้วยการคลิกภายนอก
        builder: (BuildContext context) {
          return AlertDialog(
            title: Column(
              children: [
                Image.asset(
                  'assets/currect.gif',
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
                ),
                // Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 8),
                Text('Success')
              ],
            ),
            content: Text('Saved successfully'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // ปิด Dialog
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EmployeePageScreen(),
                    ),
                  ); // กลับไปยังหน้าหลัก
                },
                child: Center(
                  child: Container(
                    height: 50,
                    width: 200,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(254, 0, 138, 0),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Text(
                        'OK',
                        style: TextStyle(
                            color: const Color.fromARGB(255, 255, 255, 255)),
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
      // เปิด AlertDialog เพื่อยืนยันการลบ
      showDialog(
        context: context,
        barrierDismissible: false, // ไม่ให้ปิด Dialog โดยไม่ได้ตั้งใจ
        builder: (BuildContext context) {
          return AlertDialog(
            title: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.delete_outline, size: 50, color: Colors.red),
                SizedBox(height: 8),
                Text('Delete Confirmation'),
              ],
            ),
            content: Text('Are you sure you want to delete?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // ปิด Dialog
                },
                child: Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // สีปุ่ม Delete
                ),
                onPressed: () {
                  // ปิด Dialog แรก
                  Navigator.of(context).pop();
                  context
                      .read<EmployeeBloc>()
                      .add(DeleteEmployee(widget.employee!.id));
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Column(
                          children: [
                            Image.asset(
                              'assets/currect.gif',
                              width: 200,
                              height: 200,
                              fit: BoxFit.contain,
                            ),
                            SizedBox(width: 8),
                            Text('Success')
                          ],
                        ),
                        content: Text('Deleted successfully'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // ปิด Dialog
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EmployeePageScreen(),
                                ),
                              ); // กลับไปยังหน้าหลัก
                            },
                            child: Center(
                              child: Container(
                                height: 50,
                                width: 200,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(254, 0, 138, 0),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Center(
                                  child: Text(
                                    'OK',
                                    style: TextStyle(color: Colors.white),
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
                child: Text('Delete'),
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
          print('Employee data loaded!!!!!!!!!!!!!!!!!');
        } else if (state is EmployeeError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        body: Center(
          child: Card(
            margin: const EdgeInsets.all(16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              Color.fromARGB(254, 238, 238, 238), // สีพื้นหลัง
                          borderRadius:
                              BorderRadius.circular(12), // ความโค้งของมุม
                        ),
                        padding:
                            const EdgeInsets.all(16.0), // ระยะห่างภายใน Contain

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Add / Edit Employees',
                              style: TextStyle(
                                  fontSize: 34, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 20),
                            _buildTextField("User Name", _userNameController),
                            _buildTextField("Login PIN", _loginPinController,
                                isPassword: true),
                            _buildTextField("First Name", _firstNameController),
                            _buildTextField("Last Name", _lastNameController),
                            _buildTextField("Address", _addressController),
                            _buildTextField("Apt./Suite", _aptSuiteController),
                            Row(
                              children: [
                                Expanded(
                                    child: _buildTextField(
                                        "City", _cityController)),
                                const SizedBox(width: 10),
                                Expanded(
                                    child: _buildTextField(
                                        "State", _stateController)),
                                const SizedBox(width: 10),
                                Expanded(
                                    child: _buildTextField(
                                        "ZIP Code", _zipCodeController)),
                              ],
                            ),
                            _buildTextField("Phone", _phoneController),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              Color.fromARGB(254, 238, 238, 238), // สีพื้นหลัง
                          borderRadius:
                              BorderRadius.circular(12), // ความโค้งของมุม
                        ),
                        padding:
                            const EdgeInsets.all(16.0), // ระยะห่างภายใน Contain
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Allowed Login Roles",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              ..._roles.keys.map((role) {
                                return CheckboxListTile(
                                  title: Text(role),
                                  value: _roles[role],
                                  onChanged: (value) {
                                    setState(() {
                                      _roles[role] = value!;
                                    });
                                  },
                                );
                              }).toList(),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[300],
                          ),
                          child: const Text("Cancel",
                              style: TextStyle(color: Colors.black)),
                        ),
                        if (widget.employee != null)
                          ElevatedButton(
                            onPressed: _onDelete,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            child: const Text("Delete"),
                          ),
                        ElevatedButton(
                          onPressed: _onSave,
                          child: const Text("Save"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          obscureText: isPassword,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
