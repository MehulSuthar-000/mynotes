import 'package:flutter/material.dart';
import 'package:privateproject/constants/route.dart';
import 'package:privateproject/services/auth/auth_service.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
      ),
      body: Column(
        children: [
          const Text(
            "We've send you an verification mail. please open it to verify your account",
          ),
          const Text(
            'Incase you have\'nt received the email.',
          ),
          TextButton(
            onPressed: () async {
              await AuthService.firebase().sendEmailVerification();
            },
            child: const Text("Send Email Verification"),
          ),
          TextButton(
            onPressed: () async {
              await AuthService.firebase().logOut();
              Navigator.of(context).pushNamedAndRemoveUntil(
                registerRoute,
                (route) => false,
              );
            },
            child: const Text("Restart"),
          )
        ],
      ),
    );
  }
}
