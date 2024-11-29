import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/employee_bloc.dart';
import 'isar_service.dart';
import 'screens/employee_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              EmployeeBloc(IsarService())..add(LoadEmployees()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Employee Manager',
        theme: ThemeData(primarySwatch: Colors.grey),
        home: const EmployeePageScreen(),
      ),
    );
  }
}
