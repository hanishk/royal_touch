import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:royaltouch/api/square_api.dart';
import 'package:royaltouch/bloc/make_appointments_bloc/appointments_bloc.dart';
import 'package:royaltouch/firebase/app_cloud_firestore.dart';
import 'package:royaltouch/firebase/app_firebase_auth.dart';
import 'package:royaltouch/firebase/models.dart';
import 'package:royaltouch/pages/makeAppointments/appointments_widgets.dart';
import 'package:royaltouch/widgets/appbar.dart';
import 'package:royaltouch/widgets/buttons.dart';
import 'package:royaltouch/widgets/scaffold.dart';
import 'package:royaltouch/widgets/styles.dart';
import 'package:royaltouch/config/colors.dart';
import 'package:royaltouch/widgets/new_button.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController name, email, address, contact;
  bool nameReadOnly = true, addressReadOnly = true, contactReadOnly = true;
  @override
  void initState() {
    super.initState();
    name = TextEditingController();
    email = TextEditingController();
    address = TextEditingController();
    contact = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final User user = AppFirebaseAuth.auth.currentUser;
    final makeAppointmentsBloc = BlocProvider.of<MakeAppointmentsBloc>(context);
    const SizedBox sizedBox = SizedBox(height: 20.0);
    return MainScaffold(
      appBar: mainAppBar(
        context,
        title: 'Profile',
      ),
      body: FutureBuilder<UserDetails>(
        future: AppCloudFirestore.getUserDetails(user.email),
        builder: (BuildContext _, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          }
          final UserDetails userDetails = snapshot.data;
          name.text = userDetails.name;
          contact.text = userDetails.contact;
          address.text = userDetails.address;
          email.text = userDetails.email;

          return ListView(
            children: [
              // TextFormField(
              //   controller: email,
              //   readOnly: true,
              //   decoration: const InputDecoration(
              //     contentPadding: bothHorAndVertical,
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.all(Radius.circular(10.0)),
              //     ),
              //     isDense: true,
              //     labelText: 'Email',
              //     hintText: 'Email',
              //   ),
              // ),
              const SizedBox(height: 24),
              Padding(
                padding: onlyHorizontal,
                child: TextFormField(
                  // validator: (str) {
                  //   return Validators.emailValidator(str);
                  // },
                  controller: email,
                  readOnly: true,
                  style: TfDecoration.textInputStyle(),

                  keyboardType: TextInputType.emailAddress,
                  decoration:
                      TfDecoration.inputDecoration(textHint: 'Email Address'),
                ),
              ),
              const SizedBox(
                height: 22,
              ),
              Padding(
                padding: onlyHorizontal,
                child: Row(
                  children: const [
                    Padding(
                      padding: onlyHorizontal,
                      // child: Checkbox(value: null, onChanged: null),
                    ),
                    // const SizedBox(width: 8),
                    // Text(
                    //   'Send me Best Detailing Deals',
                    //   style: GoogleFonts.publicSans(
                    //     fontWeight: FontWeight.w400,
                    //     fontSize: 14,
                    //     color: statusBarColor,
                    //   ),
                    // ),
                  ],
                ),
              ),
              const SizedBox(
                height: 22,
              ),
              Padding(
                padding: onlyHorizontal,
                child: TextFormField(
                  // validator: (str) {
                  //   return Validators.emailValidator(str);
                  // },
                  controller: name,
                  style: TfDecoration.textInputStyle(),
                  decoration: TfDecoration.inputDecoration(textHint: 'Name'),
                ),
              ),
              // TextFormField(
              //   controller: name,
              //   readOnly: nameReadOnly,
              //   decoration: InputDecoration(
              //     contentPadding: bothHorAndVertical,
              //     border: const OutlineInputBorder(
              //       borderRadius: BorderRadius.all(Radius.circular(10.0)),
              //     ),
              //     isDense: true,
              //     labelText: 'Name',
              //     hintText: 'Name',
              //     suffix: IconButton(
              //       icon: Icon(nameReadOnly ? Icons.edit : Icons.check),
              //       visualDensity: VisualDensity.compact,
              //       onPressed: () {
              //         // update user name here
              //         setState(() {
              //           nameReadOnly = !nameReadOnly;
              //           if (nameReadOnly) {
              //             userDetails..name = name.text;
              //             AppCloudFirestore.saveUserDetails(userDetails);
              //           }
              //         });
              //       },
              //     ),
              //   ),
              // ),

              const SizedBox(height: 8),

              Padding(
                padding: onlyHorizontal,
                child: TextFormField(
                  // validator: (str) {
                  //   return Validators.emailValidator(str);
                  // },
                  controller: contact,
                  style: TfDecoration.textInputStyle(),
                  decoration: TfDecoration.inputDecoration(textHint: 'Phone'),
                ),
              ),

              // TextFormField(
              //   controller: contact,
              //   readOnly: contactReadOnly,
              //   decoration: InputDecoration(
              //     contentPadding: bothHorAndVertical,
              //     border: const OutlineInputBorder(
              //       borderRadius: BorderRadius.all(Radius.circular(10.0)),
              //     ),
              //     isDense: true,
              //     labelText: 'Phone',
              //     hintText: 'Phone',
              //     suffix: IconButton(
              //       icon: Icon(contactReadOnly ? Icons.edit : Icons.check),
              //       visualDensity: VisualDensity.compact,
              //       onPressed: () {
              //         // update user name here
              //         setState(() {
              //           contactReadOnly = !contactReadOnly;
              //           if (contactReadOnly) {
              //             userDetails..contact = contact.text;
              //             AppCloudFirestore.saveUserDetails(userDetails);
              //           }
              //         });
              //       },
              //     ),
              //   ),
              // ),
              const SizedBox(height: 8),
              Padding(
                padding: onlyHorizontal,
                child: TextFormField(
                  controller: address,
                  maxLines: 3,
                  style: TfDecoration.textInputStyle(),
                  decoration: TfDecoration.inputDecoration(textHint: 'Address'),
                ),
              ),

              const SizedBox(height: 24),
              Padding(
                padding: onlyHorizontal,
                child: Text('Preffered Service Location',
                    style: GoogleFonts.publicSans(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: hintText,
                    )),
              ),
              const SizedBox(height: 3),
              BlocBuilder<MakeAppointmentsBloc, MakeAppointmentsState>(
                builder: (_, state) {
                  return Padding(
                    padding: onlyHorizontal,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: white,
                      ),
                      padding: onlyHorizontal,
                      child: technicianDropdown(
                          state: state,
                          bloc: makeAppointmentsBloc,
                          onChanged: (Technician technician) {
                            userDetails.location =
                                AppCloudFirestore.allTechnicians +
                                    '/${technician.docId}';
                            makeAppointmentsBloc
                                .add(OnChangeCalendar(technician));
                            AppCloudFirestore.saveUserDetails(userDetails);
                          }),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              Button(
                showIcon: true,
                style: GoogleFonts.poppins(),
                position: P.Right,
                text: 'Update',
                color: bluePrimary,
                onPressed: () {
                  userDetails..name = name.text;
                  userDetails..contact = contact.text;
                  userDetails..address = address.text;

                  AppCloudFirestore.saveUserDetails(userDetails);
                  //show snackbar or loader that data is successfullly updated.
                },
              ),
              sizedBox,
              userDetails != null &&
                      userDetails.sqCardOnFile != null &&
                      userDetails.sqCardOnFile.card != null
                  ? Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10.0)),
                        border: Border.all(width: 0.3),
                      ),
                      padding: bothHorAndVertical,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Saved Card:',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ListTile(
                            onTap: () {
                              showDialog<bool>(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title:
                                      const Text('Confirm delete saved card'),
                                  content: const Text(
                                      'Are you sure you want to delete the saved card ?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text('CANCEL'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: const Text('CONFIRM'),
                                    ),
                                  ],
                                ),
                              ).then((value) async {
                                if (value != null && value) {
                                  showDialog<bool>(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (_) {
                                      AppCloudFirestore.updateDoc(
                                        AppCloudFirestore.allUsers +
                                            '/' +
                                            userDetails.email,
                                        <String, dynamic>{
                                          'sq_card_on_file': null,
                                        },
                                      ).then(
                                        (value) => SquareApi()
                                            .deleteCustomerCard(
                                              userDetails: userDetails,
                                            )
                                            .then(
                                              (value) =>
                                                  Navigator.pop(context, true),
                                            ),
                                      );

                                      return const SimpleDialog(
                                        title: Text(
                                          'Removing card',
                                        ),
                                        children: [
                                          Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        ],
                                      );
                                    },
                                  ).then<void>((value) {
                                    if (value != null && value) {
                                      setState(() {
                                        Flushbar<void>(
                                          messageText: const Text(
                                            'Card successfully removed',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          flushbarStyle: FlushbarStyle.GROUNDED,
                                          duration: const Duration(seconds: 2),
                                          backgroundColor: Colors.green,
                                        ).show(context);
                                      });
                                    }
                                  });
                                }
                              });
                            },
                            trailing: const Icon(Icons.delete),
                            leading: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey.shade600,
                                      width: 1.5,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5.0)),
                                  ),
                                  child: Text(
                                    userDetails.sqCardOnFile.card.cardBrand,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            title: Text('Ends in ' +
                                userDetails.sqCardOnFile.card.last4),
                            subtitle: Text(userDetails
                                    .sqCardOnFile.card.expMonth
                                    .toString() +
                                '/' +
                                userDetails.sqCardOnFile.card.expYear
                                    .toString()),
                          )
                        ],
                      ),
                    )
                  : Container(),
              sizedBox,
              sizedBox,
            ],
          );
        },
      ),
    );
  }
}
