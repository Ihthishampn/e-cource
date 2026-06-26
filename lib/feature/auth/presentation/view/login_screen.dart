import 'package:e_cource/feature/auth/presentation/provider/auth_provider.dart';
import 'package:e_cource/feature/auth/presentation/widgets/custom_button_login.dart';
import 'package:e_cource/general/enums/app_state.dart';
import 'package:e_cource/general/widgets/custom_textfield.dart';
import 'package:e_cource/general/core/services/go_route/route_names.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController(
    text: "testadmin@gmail.com",
  );
  final TextEditingController passController = TextEditingController(
    text: "222222",
  );
  final globalKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: 450,
          child: Form(
            key: globalKey,
            child: Column(
              mainAxisAlignment: .center,
              crossAxisAlignment: .center,

              children: [
                Column(
                  mainAxisAlignment: .center,

                  children: [
                    // logo image
                    Image(
                      image: AssetImage(
                        "assets/image/ecource_logo-removebg-preview.png",
                      ),
                      height: 200,
                    ),
                  ],
                ),

                CustomTextField(
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Email is required";
                    }

                    if (!value.contains("@gmail.com")) {
                      return "enter an valid email";
                    }

                    return null;
                  },
                  hint: "enter email",
                  icons: Icons.alternate_email_sharp,
                ),
                Gap(15),
                CustomTextField(
                  controller: passController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "enter a password";
                    }

                    if (value.length <= 5) {
                      return "your password is too short keep minum count ${value.length}/6";
                    }
                    return null;
                  },
                  hint: "enter password",
                  icons: Icons.lock_person_rounded,
                  isPass: true,
                ),

                // button
                const Gap(20),

                Consumer<AuthProviders>(
                  builder: (context, value, child) => CustomButtonLogin(
                    ontap: () async {
                      if (!globalKey.currentState!.validate()) return;

                      final email = emailController.text.trim();
                      final pass = passController.text.trim();
                      await value.handleLogin(email: email, password: pass);
                      if (!mounted) return;
                      final loginResult = value.loginState;
                      if (loginResult == AppState.error) {
                        toastification.show(
                          type: ToastificationType.error,
                          title: Text(value.error ?? "Unknown error"),
                        );
                        return;
                      }

                      if (loginResult == AppState.success) {
                        toastification.show(
                          type: ToastificationType.success,
                          title: Text("Login success"),
                        );

                        emailController.clear();
                        passController.clear();

                        GoRouter.of(this.context).go(RouteNames.dahsboard);
                      }
                    },
                    widget: value.loginState == AppState.loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
