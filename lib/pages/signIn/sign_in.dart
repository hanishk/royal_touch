import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:royaltouch/bloc/signIn_bloc/signIn_bloc.dart';
import 'package:royaltouch/config/colors.dart';
import 'package:royaltouch/config/routes.dart';
import 'package:royaltouch/utils/validators.dart';
import 'package:royaltouch/widgets/buttons.dart';
import 'package:royaltouch/widgets/new_button.dart';
import 'package:royaltouch/widgets/scaffold.dart';
import 'package:royaltouch/widgets/styles.dart';
import 'package:url_launcher/url_launcher.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController(),
      _passwordController = TextEditingController();
  final FocusNode _emailNode = FocusNode(), _passwordNode = FocusNode();

  bool passInvisible = true;

  RemoteConfig remoteConfig;
  bool loading = true;
  String phone = '+1 919 525 4946', email = 'royaltouchmd2@gmail.com';

  SizedBox sizedBox = const SizedBox(height: 20);

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    remoteConfig = await RemoteConfig.instance;
    final defaults = <String, dynamic>{
      'phone': phone,
      'email': email,
    };
    await remoteConfig.setDefaults(defaults);
    await remoteConfig.fetch(expiration: const Duration(hours: 5));
    await remoteConfig.activateFetched();
    phone = remoteConfig.getString('phone') ?? phone;
    email = remoteConfig.getString('email') ?? email;
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) => MainScaffold(
        body: BlocConsumer<SignInBloc, SignInState>(
          listener: (context, state) {
            if (state is SignInSuccess) {
              Navigator.pushReplacementNamed(
                context,
                AppRouter.services,
              );
            } else if (state is SigningIn) {
            } else if (state is SignInFailed) {
              Flushbar<void>(
                message: state.errorMsg,
                flushbarStyle: FlushbarStyle.GROUNDED,
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              )..show(context);
            }
          },
          builder: (context, state) {
            return MainScaffold(
              body: (state is SigningIn)
                  ? const Center(child: CircularProgressIndicator())
                  : ListView(
                      children: [
                        Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              sizedBox,
                              Image.asset(
                                'assets/royal_touch.png',
                                width: MediaQuery.of(context).size.width * 0.6,
                                fit: BoxFit.cover,
                              ),
                              // sizedBox,
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.1),
                              Padding(
                                padding: onlyHorizontal,
                                child: TextFormField(
                                  validator: (str) {
                                    return Validators.emailValidator(str);
                                  },
                                  controller: _emailController,
                                  focusNode: _emailNode,
                                  keyboardType: TextInputType.emailAddress,
                                  onFieldSubmitted: (_) =>
                                      FocusScope.of(context)
                                          .requestFocus(_passwordNode),
                                  style: TfDecoration.textInputStyle(),
                                  decoration: TfDecoration.inputDecoration(
                                      textHint: 'Email Address'),
                                ),
                              ),

                              const SizedBox(height: 8),
                              Padding(
                                padding: onlyHorizontal,
                                child: TextFormField(
                                  controller: _passwordController,
                                  focusNode: _passwordNode,
                                  obscureText: passInvisible,
                                  validator: (str) {
                                    if (str.isEmpty) {
                                      return 'Password cannot be blank';
                                    }
                                    return null;
                                  },
                                  style: TfDecoration.textInputStyle(),
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
                                      borderSide:
                                          const BorderSide(color: white),
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
                                      MediaQuery.of(context).size.height * 0.1),
                              Button(
                                color: bluePrimary,
                                text: 'Log In',
                                style: GoogleFonts.poppins(),
                                showIcon: true,
                                position: P.Right,
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    BlocProvider.of<SignInBloc>(context).add(
                                      OnSignInClick(
                                        email: _emailController.text,
                                        password: _passwordController.text,
                                      ),
                                    );
                                  }
                                },
                              ),
                              const SizedBox(height: 8),
                              Button(
                                color: white,
                                text: 'Dont have an account? Sign Up',
                                style: GoogleFonts.poppins(),
                                position: P.Right,
                                onPressed: () => Navigator.pushNamed(
                                    context, AppRouter.signUp),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.1),
                        Padding(
                          padding: const EdgeInsets.only(left: 15, bottom: 15),
                          child: GestureDetector(
                            onLongPress: () {
                              Clipboard.setData(ClipboardData(text: phone));
                              Flushbar<void>(
                                message: 'Copied to clipboard.',
                                duration: const Duration(seconds: 1),
                              )..show(context);
                            },
                            onTap: () async {
                              final String url = 'tel:$phone';
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                            child: Text(
                              '\u2014 ' + phone,
                              style: GoogleFonts.publicSans(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: bluePrimary,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15, bottom: 15),
                          child: GestureDetector(
                            onLongPress: () {
                              Clipboard.setData(ClipboardData(text: email));
                              Flushbar<void>(
                                message: 'Copied to clipboard.',
                                duration: const Duration(seconds: 1),
                              )..show(context);
                            },
                            onTap: () async {
                              final Uri _emailLaunchUri = Uri(
                                scheme: 'mailto',
                                path: email,
                              );
                              if (await canLaunch(_emailLaunchUri.toString())) {
                                await launch(_emailLaunchUri.toString());
                              } else {
                                throw 'Could not launch $_emailLaunchUri';
                              }
                            },
                            child: Text(
                              '\u2014 ' + email,
                              style: GoogleFonts.publicSans(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: bluePrimary,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05),
                        Center(
                          child: Text(
                            '\u00a9 Royal Touch 2021.All Rights Reserved.',
                            style: GoogleFonts.publicSans(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: hintText,
                            ),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05),
                        SizedBox(
                            height: MediaQuery.of(context).viewInsets.bottom),
                      ],
                    ),
            );
          },
        ),
      );
}
