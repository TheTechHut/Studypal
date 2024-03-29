import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:summarize_app/const/app_text_style.dart';
import 'package:summarize_app/const/spacing.dart';
import 'package:summarize_app/const/user_header.dart';
import 'package:summarize_app/services/toast_service.dart';
import 'package:summarize_app/view_model/firebase/firebase_auth.dart';
import 'package:summarize_app/view_model/network_provider/questions_provider.dart';
import 'package:summarize_app/view_model/pdf_handler/pdf_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class QuestionsPage extends StatelessWidget {
  const QuestionsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final pdfProvider = Provider.of<PdfProvider>(context);
    final authProvider = Provider.of<FirebaseAuthProvider>(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Spacing.height(48),
              UserHeader(
                message: "Hey ${authProvider.username}",
              ),
              const SizedBox(
                height: 64,
              ),
              Text(
                "Your document",
                style: AppTextStyle.heading3,
              ),
              Container(
                constraints: const BoxConstraints(
                    maxHeight: 300, maxWidth: double.infinity),
                margin: const EdgeInsets.all(15),
                padding: const EdgeInsets.all(15),
                child: SingleChildScrollView(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Text(
                        pdfProvider.myText,
                        style: AppTextStyle.body6,
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                "Your Summary",
                style: AppTextStyle.heading3,
              ),
              Container(
                padding: const EdgeInsets.all(15),
                margin: const EdgeInsets.all(15),
                child: Consumer<QuestionsProvider>(
                  builder: (context, value, child) {
                    if (value.result.choices!.isNotEmpty) {
                      return SingleChildScrollView(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Text(
                              value.result.choices!.first.text.toString(),
                              style: AppTextStyle.summaryText,
                            ),
                          ),
                        ),
                      );
                    } else if (value.hasError) {
                      return Row(
                        children: [
                          const Icon(Icons.error),
                          showErrorDialog(value.errorMessage, context),
                        ],
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

showErrorDialog(String errorMessage, BuildContext context) =>
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(16),
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  launchwhatsapp(errorMessage);
                },
                child: const Text("Report Error"),
              ),
            ));
      },
    );
launchwhatsapp(String errormessage) async {
  var contact = "+254115017058";
  var androidUrl =
      "whatsapp://send?phone=$contact&text=Help I'm Using The StudyPalApp And I'm Getting The Following ErrorCode $errormessage";
  var iosUrl =
      "https://wa.me/$contact?text=${Uri.parse('Hi, I need some help')}";

  try {
    if (Platform.isIOS) {
      await launchUrl(Uri.parse(iosUrl));
    } else {
      await launchUrl(Uri.parse(androidUrl));
    }
  } on Exception {
    showToast("error");
  }
}
