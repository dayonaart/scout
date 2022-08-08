import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_pdf/open_pdf.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final loginController = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: GetBuilder<LoginController>(builder: (_) {
        return SafeArea(
            top: true,
            child: Scaffold(
                backgroundColor: Colors.grey[200],
                body: Center(
                  child: FutureBuilder<Widget>(
                      future: OpenPdf()
                          .openAssets(path: 'assets/icons/Kontrak Kerja Arifa Dayona signed.pdf'),
                      builder: (context, snap) {
                        if (snap.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else {
                          return snap.data!;
                        }
                      }),
                )));
      }),
    );
  }

  SingleChildScrollView _mainW(LoginController _) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lightbulb_outline_sharp, color: Colors.blueAccent, size: 40),
            Column(
                children: List.generate(_.textCoatroller.length, (i) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: _textFeld(
                    controller: _.textCoatroller[i],
                    placeholder: _.placeholder[i],
                    focusNode: _.focusNode[i],
                    textInputAction: _.textInputAction[i],
                    onSubmitted: _.onSubmitted[i]),
              );
            })),
            ElevatedButton(onPressed: () {}, child: const Text("Sign In"))
          ],
        ),
      ),
    );
  }
}

class LoginController extends GetxController {
  late List<TextEditingController> textCoatroller;
  late List<FocusNode> focusNode;
  late List<TextInputAction> textInputAction;
  final List<String> placeholder = ["email", "password"];
  List<void Function(String)?> get onSubmitted => List.generate(2, (i) {
        switch (i) {
          case 0:
            return (val) {};
          case 1:
            return (val) {
              focusNode[i].unfocus();
            };
          default:
            return null;
        }
      });

  @override
  void onInit() {
    textCoatroller = List.generate(2, (i) => TextEditingController());
    focusNode = List.generate(2, (i) => FocusNode());
    textInputAction = List.generate(2, (i) {
      if (i > 0) {
        return TextInputAction.done;
      } else {
        return TextInputAction.next;
      }
    });
    super.onInit();
  }
}

SizedBox _textFeld({
  @required TextEditingController? controller,
  @required String? placeholder,
  @required FocusNode? focusNode,
  @required TextInputAction? textInputAction,
  @required void Function(String)? onSubmitted,
}) {
  return SizedBox(
      height: 40,
      child: CupertinoTextField(
        controller: controller,
        placeholder: placeholder,
        focusNode: focusNode,
        textInputAction: textInputAction,
        onSubmitted: onSubmitted,
      ));
}
