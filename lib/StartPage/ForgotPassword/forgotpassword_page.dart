import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:hlibrary/StartPage/Login/login_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  bool emailSent = false;
  bool isSending = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> passwordReset() async {
    setState(() {
      isSending = true;
    });

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text.trim());
      setState(() {
        emailSent = true;
      });

      // Navigate back to login page after 2 seconds
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
      });
    } on FirebaseAuthException catch (e) {
      print(e);
      // Handle Firebase Auth exceptions here
    } finally {
      setState(() {
        isSending = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              colors: [Color(0xFFFFB800), Color.fromARGB(255, 172, 120, 0)],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 80),
              const Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Recover Password", style: TextStyle(color: Colors.white, fontSize: 40)),
                     SizedBox(height: 35),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(50),
                    child: Column(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.background,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromARGB(255, 47, 47, 47),
                                blurRadius: 20,
                                offset: Offset(0, 10),
                              )
                            ],
                          ),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Theme.of(context).colorScheme.background)),
                                ),
                                child: TextFormField(
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  controller: _emailController,
                                  onChanged: (value) {},
                                  decoration: const InputDecoration(
                                    hintText: "Email",
                                    prefixIcon: Icon(Icons.email_outlined),
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                  ),
                                  validator: (email) => email != null && !EmailValidator.validate(email) ? 'Enter Valid Email' : null,
                                ),
                              ),

                            ],
                          ),
                        ),

                        const SizedBox(height: 10,),
                        if (_emailController.text.isNotEmpty && !_emailController.text.contains('@'))
                          const Padding(
                            padding:  EdgeInsets.symmetric(horizontal: 20.0),
                            child: Text(
                              "Enter Valid Email",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        SizedBox(height: emailSent ? 20 : 0), // Spacing for the success message
                        if (emailSent)
                          const Padding(
                            padding:  EdgeInsets.symmetric(horizontal: 20.0),
                            child: Text(
                              "If an account exists with the provided email, a password reset email has been sent.",
                              style: TextStyle(color: Colors.green),
                            ),
                          ),
                        const SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginPage(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Sign In",
                                style: TextStyle(fontSize: 15, color: Color.fromARGB(255, 255, 162, 0)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                        MaterialButton(
                          onPressed: isSending ? null : passwordReset,
                          height: 50,
                          color: const Color(0xFFFFB800),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Center(
                            child: isSending
                                ? const CircularProgressIndicator(color: Colors.black) // Show loading indicator when sending
                                : emailSent
                                ? const Text("Email Sent", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600))
                                : const Text("Send Email", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
