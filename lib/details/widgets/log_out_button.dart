import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasassy/app/bloc/app_bloc.dart';

class LogOutButton extends StatelessWidget {
  const LogOutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.read<AppBloc>().add(
            AppLogoutRequested(),
          ),
      child: const Text(
        'Login with another account?',
        style: TextStyle(color: Colors.blueAccent),
      ),
    );
  }
}
