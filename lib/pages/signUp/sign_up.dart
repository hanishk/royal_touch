import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:royaltouch/bloc/signup_bloc/signup_bloc.dart';
import 'package:royaltouch/config/routes.dart';
import 'package:royaltouch/firebase/models.dart';
import 'package:royaltouch/utils/validators.dart';
import 'package:royaltouch/widgets/appbar.dart';
import 'package:royaltouch/widgets/buttons.dart';
import 'package:royaltouch/widgets/scaffold.dart';
import 'package:royaltouch/widgets/styles.dart';
import 'package:royaltouch/config/colors.dart';
import 'package:royaltouch/widgets/new_button.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController name, email, pass, address, contact;

  final _formKey = GlobalKey<FormState>();

  final FocusNode _emailNode = FocusNode(), _passwordNode = FocusNode();

  bool passInvisible = true;

  SizedBox sizedBox = const SizedBox(height: 20);
  @override
  void initState() {
    super.initState();
    name = TextEditingController();
    pass = TextEditingController();
    email = TextEditingController();
    address = TextEditingController();
    contact = TextEditingController();
  }

  @override
  Widget build(BuildContext context) => MainScaffold(
        appBar: mainAppBar(
          context,
          title: 'Sign Up',
        ),
        body: BlocConsumer<SignupBloc, SignupState>(
          listener: (context, state) {
            if (state is SignupSuccess) {
              Navigator.pushReplacementNamed(context, AppRouter.services);
            } else if (state is SignupFailed) {
              Flushbar<void>(
                message: state.message,
                flushbarStyle: FlushbarStyle.GROUNDED,
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              )..show(context);
            }
          },
          builder: (context, state) {
            return (state is SigningUp)
                ? const Center(child: CircularProgressIndicator())
                : Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/royal_touch.png',
                            height: MediaQuery.of(context).size.height * 0.08,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.05),
                          Padding(
                            padding: onlyHorizontal,
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              controller: email,
                              focusNode: _emailNode,
                              keyboardType: TextInputType.emailAddress,
                              validator: Validators.emailValidator,
                              style: TfDecoration.textInputStyle(),
                              decoration: TfDecoration.inputDecoration(
                                  textHint: 'Email Address'),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: onlyHorizontal,
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              controller: pass,
                              focusNode: _passwordNode,
                              obscureText: passInvisible,
                              style: TfDecoration.textInputStyle(),
                              validator: Validators.fullNameValidator,
                              decoration: InputDecoration(
                                isDense: true,
                                // contentPadding: bothHorAndVertical,
                                focusColor: white,
                                filled: true,
                                fillColor: white,
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: white),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: white, width: 0.0),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(color: white),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                hintText: 'Password',
                                hintStyle: GoogleFonts.publicSans(
                                  color: hintText,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    passInvisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      passInvisible = !passInvisible;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.03),
                          Padding(
                            padding: onlyHorizontal,
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              controller: name,
                              validator: Validators.fullNameValidator,
                              style: TfDecoration.textInputStyle(),
                              decoration: TfDecoration.inputDecoration(
                                  textHint: 'Name'),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: onlyHorizontal,
                            child: TextFormField(
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.number,
                              controller: contact,
                              validator: Validators.phoneValidator,
                              style: TfDecoration.textInputStyle(),
                              decoration: TfDecoration.inputDecoration(
                                  textHint: 'Phone'),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: onlyHorizontal,
                            child: TextFormField(
                              controller: address,
                              textInputAction: TextInputAction.done,
                              validator: Validators.addressValidator,
                              maxLines: 4,
                              style: TfDecoration.textInputStyle(),
                              decoration: TfDecoration.inputDecoration(
                                  textHint: 'Address'),
                            ),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.07),
                          Button(
                            color: bluePrimary,
                            text: 'Proceed',
                            style: GoogleFonts.poppins(),
                            showIcon: true,
                            position: P.Right,
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                BlocProvider.of<SignupBloc>(context).add(
                                  OnSignupClick(
                                    password: pass.text,
                                    userDetails: UserDetails(
                                      name: name.text.trim(),
                                      address: address.text.trim(),
                                      contact: contact.text.trim(),
                                      email: email.text.trim().toLowerCase(),
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                          // const SizedBox(height: 32),
                          // RichText(
                          //   text: TextSpan(
                          //       text: 'By proceeding you agree to our ',
                          //       style: GoogleFonts.publicSans(
                          //         fontWeight: FontWeight.w400,
                          //         fontSize: 12,
                          //         color: statusBarColor,
                          //       ),
                          //       children: [
                          //         TextSpan(
                          //           text: 'Terms of Use',
                          //           style: GoogleFonts.publicSans(
                          //             fontWeight: FontWeight.w700,
                          //             fontSize: 12,
                          //             color: statusBarColor,
                          //           ),
                          //         )
                          //       ]),
                          // ),
                        ],
                      ),
                    ));
          },
        ),
      );
}
