import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:summarize_app/view_model/firebase/firebase_auth.dart';
import 'package:summarize_app/views/core/homepage.dart';
import 'package:summarize_app/views/onboarding/onboarding.dart';
import 'package:summarize_app/views/splash/splash.dart';

class ScreenController extends StatelessWidget {
  const ScreenController({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FirebaseAuthProvider>(
      builder: (context, authProvider, child) {
        return StreamBuilder(
          stream: authProvider.authState,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            //change this
            //Provider to change Status to un initialized

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Splash();
            }
            if (snapshot.hasData) {
              return HomePage(
                userName: authProvider.user.displayName!,
              );
            } else {
              return const OnBoarding();
            }
          },
        );
      },
    );
  }
}
