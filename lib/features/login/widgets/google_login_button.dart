import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:formz/formz.dart';
import 'package:kasassy/constants/palette.dart';
import 'package:kasassy/constants/widgets.dart';
import 'package:kasassy/features/login/cubit/login_cubit.dart';

class GoogleLoginButton extends StatelessWidget {
  const GoogleLoginButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? Progress.circularProgress()
            : Column(
                children: [
                  OutlinedButton.icon(
                    label: const Text(
                      'SIGN IN WITH GOOGLE',
                    ),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    icon: const Icon(
                      FontAwesomeIcons.google,
                      color: Palette.secondaryColor,
                    ),
                    onPressed: () =>
                        context.read<LoginCubit>().logInWithGoogle(),
                  ),
                ],
              );
      },
    );
  }
}
