import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:royaltouch/bloc/payment_bloc/payment_bloc.dart';
import 'package:royaltouch/config/colors.dart';
import 'package:royaltouch/config/routes.dart';
import 'package:royaltouch/firebase/app_cloud_firestore.dart';
import 'package:royaltouch/firebase/app_firebase_auth.dart';
import 'package:royaltouch/firebase/models.dart';
import 'package:royaltouch/pages/payment/widget.dart';
import 'package:royaltouch/utils/appointments.dart';
import 'package:royaltouch/utils/validators.dart';
import 'package:royaltouch/widgets/buttons.dart';
import 'package:royaltouch/widgets/new_button.dart';
import 'package:royaltouch/widgets/scaffold.dart';
import 'package:royaltouch/widgets/styles.dart';
import 'package:square_in_app_payments/in_app_payments.dart';
import 'package:square_in_app_payments/models.dart';

class PaymentsWidget extends StatefulWidget {
  @override
  _PaymentsWidgetState createState() => _PaymentsWidgetState();
}

class _PaymentsWidgetState extends State<PaymentsWidget> {
  // final _formKey = GlobalKey<FormState>();

  TextEditingController address, contact;
  bool addressReadOnly = true, contactReadOnly = true, saveCard = true;
  UserDetails userDetails;
  // bool saveCard = false;
  ScrollController controller = ScrollController();

  @override
  void initState() {
    address = TextEditingController();
    contact = TextEditingController();
    AppCloudFirestore.getUserDetails(AppFirebaseAuth.auth.currentUser.email)
        .then((UserDetails value) {
      setState(() {
        userDetails = value;
        address.text = value.address;
        contact.text = value.contact;
      });
    });
    super.initState();
  }

  Widget tiles({String heading, String location, IconData icon}) {
    return ListTile(
      title: Text(
        heading,
        style: GoogleFonts.publicSans(
          fontWeight: FontWeight.w400,
          fontSize: 12,
          color: hintText,
        ),
      ),
      subtitle: Text(
        location,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.publicSans(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          color: statusBarColor,
        ),
      ),
      trailing: IconButton(
        onPressed: () {},
        icon: Icon(icon),
        color: bg,
      ),
    );
  }

  Widget modelHeader = Center(
    child: Container(
      padding: const EdgeInsets.only(top: 8),
      margin: const EdgeInsets.only(bottom: 16),
      height: 4,
      width: 60,
      decoration: const BoxDecoration(
        color: grey,
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
    ),
  );

  void changePhone(BuildContext context) {
    showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      barrierColor: modelBg,
      isScrollControlled:
          true, // Important: Makes content maxHeight = full device height
      context: context,
      builder: (context) {
        return AnimatedPadding(
          padding: MediaQuery.of(context).viewInsets,
          duration: const Duration(milliseconds: 100),
          curve: Curves.decelerate,
          child: Container(
            decoration: const BoxDecoration(
              color: white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            height: 274,
            // height: MediaQuery.of(context).size.height / 2.5,
            // height: SizeConfig.blockSizeVertical * 40,

            child: Column(
              children: [
                const SizedBox(height: 8),
                modelHeader,
                Text(
                  'Change phone number',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: bluePrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                // SizedBox(height: SizeConfig.blockSizeVertical * 3),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.number,
                    controller: contact,
                    validator: Validators.phoneValidator,
                    style: TfDecoration.textInputStyle(),
                    decoration: TfDecoration.modifyTextFieldDec('Phone'),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Button(
                      showIcon: true,
                      iconData: Icons.close,
                      iconPosition: P.Left,
                      position: P.Left,
                      cut: Cut.TR,
                      text: 'Cancel',
                      color: bg,
                      fontSize: 14,
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Button(
                        position: P.Right,
                        showIcon: true,
                        fontSize: 14,
                        // fontSize: MediaQuery.of(context).size.width * 0.05,
                        cut: Cut.BL,
                        text: 'Proceed',
                        color: bluePrimary,
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void changeAddress(BuildContext context) {
    showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      barrierColor: modelBg,
      isScrollControlled:
          true, // Important: Makes content maxHeight = full device height
      context: context,
      builder: (context) {
        return AnimatedPadding(
          padding: MediaQuery.of(context).viewInsets,
          duration: const Duration(milliseconds: 100),
          curve: Curves.decelerate,
          child: Container(
            decoration: const BoxDecoration(
              color: white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            height: 274,
            // height: SizeConfig.blockSizeVertical * 42,
            child: Column(
              children: [
                const SizedBox(height: 8),
                modelHeader,
                Text(
                  'Change pickup address',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: bluePrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                      maxLines: 3,
                      textInputAction: TextInputAction.done,
                      // keyboardType: TextInputType.number,
                      controller: address,
                      validator: Validators.addressValidator,
                      style: TfDecoration.textInputStyle(),
                      decoration: TfDecoration.modifyTextFieldDec('Address')),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Button(
                      showIcon: true,
                      iconData: Icons.close,
                      iconPosition: P.Left,
                      position: P.Left,
                      cut: Cut.TR,
                      text: 'Cancel',
                      color: bg,
                      fontSize: 14,
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Button(
                        position: P.Right,
                        showIcon: true,
                        fontSize: 14,
                        cut: Cut.BL,
                        text: 'Proceed',
                        color: bluePrimary,
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showConfirmPetHairDialog(BuildContext context, Function f) {
    showModalBottomSheet<bool>(
      barrierColor: modelBg,
      backgroundColor: Colors.transparent,
      isScrollControlled:
          true, // Important: Makes content maxHeight = full device height
      context: context,
      builder: (context) {
        return AnimatedPadding(
          padding: MediaQuery.of(context).viewInsets,
          duration: const Duration(milliseconds: 100),
          curve: Curves.decelerate,
          child: Container(
            decoration: const BoxDecoration(
              color: white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            height: 274,
            child: Column(
              children: [
                const SizedBox(height: 8),
                modelHeader,
                Text(
                  'Keep in mind',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: bluePrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: RichText(
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    text: TextSpan(
                      text: 'You may be charged between\n ',
                      style: GoogleFonts.publicSans(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: statusBarColor,
                          height: 1.5),
                      children: [
                        TextSpan(
                          text: '\$35.00- \$75.00 ',
                          style: GoogleFonts.publicSans(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: statusBarColor,
                              height: 1.5),
                        ),
                        TextSpan(
                          text: 'extra for pet hair\n removal when applicable.',
                          style: GoogleFonts.publicSans(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: statusBarColor,
                              height: 1.5),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.08),
                Row(
                  children: [
                    Button(
                      showIcon: true,
                      iconData: Icons.close,
                      iconPosition: P.Left,
                      position: P.Left,
                      cut: Cut.TR,
                      text: 'Cancel',
                      color: bg,
                      fontSize: 14,
                      onPressed: () => Navigator.pop(context, false),
                    ),
                    Expanded(
                      child: Button(
                        showIcon: true,
                        fontSize: 14,
                        cut: Cut.BL,
                        text: 'Proceed',
                        color: bluePrimary,
                        onPressed: () => Navigator.pop(context, true),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ).then((value) {
      if (value != null && value) {
        f();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final PaymentConfirmationModel model =
        ModalRoute.of(context).settings.arguments as PaymentConfirmationModel;
    final PaymentBloc bloc = BlocProvider.of<PaymentBloc>(context);
    final double size = MediaQuery.of(context).size.height;
    const Divider divider = Divider(color: statusBarColor);
    const SizedBox box16 = SizedBox(height: 16);
    return MainScaffold(
      color: white,
      body: BlocConsumer<PaymentBloc, PaymentState>(
        listener: (context, state) {
          if (state is StartCardEntryFlow) {
            InAppPayments.startCardEntryFlow(
              collectPostalCode: true,
              onCardEntryCancel: () {
                // TODO(Aman-Malhote): Ask Graham
                // what happens if the card entry flow was cancelled
                bloc.add(OnCancelCardEntryFlow());
              },
              onCardNonceRequestSuccess: (CardDetails cardDetails) => bloc.add(
                OnSuccessCardEntryFlow(
                  model: model,
                  cardDetails: cardDetails,
                  toPay: bloc.downPayment,
                  address: address.text,
                  contact: contact.text,
                  userDetails: userDetails,
                  saveCard: saveCard,
                ),
              ),
            );
          } else if (state is CancelCardEntryFlow) {
            // card entry cancelled
            // InAppPayments.showCardNonceProcessingError();
          } else if (state is CompleteCardEntryFlow) {
            if (userDetails != null &&
                userDetails.sqCardOnFile != null &&
                userDetails.sqCardOnFile.card != null) {
              AppRouter.fluroRouter.pop<void>(context);
              AppRouter.fluroRouter.pop<Map>(context, <String, dynamic>{
                'appointment_success': true,
              });
            } else {
              InAppPayments.completeCardEntry(
                onCardEntryComplete: () {
                  // complete card entry flow
                  AppRouter.fluroRouter.pop<void>(context);
                  AppRouter.fluroRouter.pop<Map>(context, <String, dynamic>{
                    'appointment_success': true,
                  });
                },
              );
            }
          } else if (state is FailureCardEntryFlow) {
            InAppPayments.showCardNonceProcessingError(
              state.errorMsg,
            );
          }
        },
        builder: (context, state) {
          if (state is Processing) {
            return const Center(child: CircularProgressIndicator());
          }

          return SafeArea(
            child: Stack(
              children: [
                CustomScrollView(
                  controller: controller,
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverAppBar(
                      centerTitle: true,
                      pinned: true,
                      backgroundColor: bluePrimary,
                      expandedHeight: size * 0.3,
                      // leading: IconButton(
                      //   icon: const Icon(Icons.arrow_back),
                      //   onPressed: () {},
                      // ),
                      flexibleSpace: MyFlexibleSpace(
                        text: 'Confirm Appointment',
                        imageUrl: '${model.services.imageUrl}',
                        // imageUrl:
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate(
                        <Widget>[
                          box16,
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Text(
                              model.services.name,
                              // getServiceName(model.services, asTitle: true),
                              // 'Disinfectant Interior Plus Detailing',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                color: bluePrimary,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          // SizedBox(height: size * 0.025),
                          box16,
                          divider,
                          // SizedBox(height: size * 0.025),
                          box16,
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Text(
                              'Booking Details',
                              style: GoogleFonts.poppins(
                                color: bluePrimary,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          // SizedBox(height: size * 0.019),
                          box16,
                          ListTile(
                            title: Text(
                              'Your Phone Number',
                              style: GoogleFonts.publicSans(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: hintText,
                              ),
                            ),
                            subtitle: Text(
                              contact.text, //
                              style: GoogleFonts.publicSans(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: statusBarColor,
                              ),
                            ),
                            trailing: IconButton(
                              onPressed: () => changePhone(context),
                              icon: const Icon(
                                Icons.edit,
                                color: statusBarColor,
                              ),
                            ),
                          ),
                          ListTile(
                            title: Text(
                              'Your pickup address',
                              style: GoogleFonts.publicSans(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: hintText,
                              ),
                            ),
                            subtitle: Text(
                              address.text,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.publicSans(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: statusBarColor,
                              ),
                            ),
                            trailing: IconButton(
                              onPressed: () => changeAddress(context),
                              icon: const Icon(
                                Icons.edit,
                                color: statusBarColor,
                              ),
                            ),
                          ),
                          // SizedBox(height: size * 0.024),
                          box16,
                          divider,
                          // SizedBox(height: size * 0.024),
                          box16,
                          tiles(
                            heading: 'Nearest Location',
                            location: model.state.technician.name,
                            icon: Icons.location_on_rounded,
                          ),
                          tiles(
                            heading: 'Selected Time Slot',
                            location: onlyTime.format(
                                    model.state.timeSlot.startTime.toDate()) +
                                ' - ' +
                                onlyTime.format(
                                    model.state.timeSlot.endTime.toDate()),
                            icon: Icons.watch_later_rounded,
                          ),
                          tiles(
                            heading: 'Selected Date',
                            location: DateFormat(
                                    DateFormat.YEAR_ABBR_MONTH_WEEKDAY_DAY)
                                .format(model.state.selectedDate),
                            icon: Icons.calendar_today,
                          ),
                          box16,
                          divider,
                          // SizedBox(height: size * 0.024),
                          box16,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Text(
                                  'Duration: ${model.services.time} hours',
                                  style: GoogleFonts.publicSans(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: statusBarColor,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 15),
                                child: Text(
                                  'Booking fee: \$${bloc.downPayment}',
                                  style: GoogleFonts.publicSans(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    color: statusBarColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          //use text span
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 61, right: 28, top: 11),
                            child: RichText(
                              maxLines: 2,
                              // textDirection: TextDirection.RTL,
                              text: TextSpan(
                                text: 'Full payment of ',
                                style: GoogleFonts.publicSans(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  color: bluePrimary,
                                ),
                                children: [
                                  TextSpan(
                                    text:
                                        '\$${model.services.price - bloc.downPayment} ',
                                    style: GoogleFonts.publicSans(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                      color: bluePrimary,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        'will be paid after service tech shows up and service is complete later',
                                    style: GoogleFonts.publicSans(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      color: bluePrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(
                              height: kBottomNavigationBarHeight * 3),
                        ],
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Material(
                    color: white,
                    elevation: 20.0,
                    child: userDetails == null
                        ? const Center(child: CircularProgressIndicator())
                        : userDetails != null &&
                                userDetails.sqCardOnFile != null &&
                                userDetails.sqCardOnFile.card != null
                            ? Padding(
                                padding: onlyHorizontal.copyWith(top: 10.0),
                                child: payUsingSavedCard(context,
                                    userDetails: userDetails, onPay: () {
                                  // if (_formKey.currentState.validate()) {
                                  showConfirmPetHairDialog(
                                      context,
                                      () => bloc.add(
                                            OnChargeCardOnFile(
                                              model: model,
                                              toPay: bloc.downPayment,
                                              address: address.text,
                                              contact: contact.text,
                                              userDetails: userDetails,
                                            ),
                                          ));
                                }
                                    // },
                                    ),
                              )
                            : Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CheckboxListTile(
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    activeColor: statusBarColor,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20.0,
                                    ),
                                    // dense: true,
                                    value: saveCard,
                                    onChanged: (b) =>
                                        setState(() => saveCard = b),
                                    title:
                                        Text('Save card for future payments ?',
                                            style: GoogleFonts.publicSans(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                            )),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    child: Button(
                                        showIcon: true,
                                        text:
                                            'CONFIRM AND PAY \$${bloc.downPayment}',
                                        style: GoogleFonts.poppins(),
                                        color: bluePrimary,
                                        onPressed: () {
                                          // if (_formKey.currentState
                                          //     .validate()) {
                                          showConfirmPetHairDialog(
                                            context,
                                            () => bloc.add(
                                              OnStartCardEntryPaymentFlow(
                                                address: address.text,
                                                model: null,
                                              ),
                                            ),
                                          );
                                        }
                                        // },
                                        ),
                                  ),
                                ],
                              ),
                  ),
                ),
              ],
            ),
          );

          // return Form(
          //   // key: _formKey,
          //   child: Stack(
          //     children: [
          //       AppointmentsScaffold(
          //         model.services,
          //         <Widget>[
          //           const SizedBox(height: 10.0),
          //           Padding(
          //             padding: onlyHorizontal,
          //             child: Column(
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               children: [
          //                 getServiceName(model.services, asTitle: true),
          //                 const SizedBox(height: 10.0),
          //                 Text.rich(
          //                   TextSpan(children: [
          //                     const TextSpan(text: 'Down Payment: '),
          //                     TextSpan(
          //                       text: '\$${bloc.downPayment}',
          //                       // style: textStyle.copyWith(
          //                       //   // color: Colors.red,
          //                       //   fontWeight: FontWeight.bold,
          //                       //   fontSize: 18.0,
          //                       // ),
          //                     ),
          //                   ]),
          //                   maxLines: 1,
          //                   overflow: TextOverflow.ellipsis,
          //                 ),
          //                 const Divider(),
          //               ],
          //             ),
          //           ),
          //           // serviceDetails(bloc.model.services, asTitle: true),
          //           // const SizedBox(height: 10.0),
          //           Padding(
          //             padding: onlyHorizontal,
          //             child: TextFormField(
          //               controller: address,
          //               validator: (String str) {
          //                 if (str.length < 8) {
          //                   return 'Address is too short';
          //                 }
          //                 return null;
          //               },
          //               readOnly: addressReadOnly,
          //               decoration: InputDecoration(
          //                 isDense: true,
          //                 labelText: 'Address',
          //                 hintText: 'Address',
          //                 suffix: IconButton(
          //                   iconSize: 20.0,
          //                   icon: Icon(
          //                     addressReadOnly ? Icons.edit : Icons.check,
          //                   ),
          //                   visualDensity: VisualDensity.compact,
          //                   tooltip: 'Edit',
          //                   onPressed: () {
          //                     setState(
          //                         () => addressReadOnly = !addressReadOnly);
          //                   },
          //                 ),
          //               ),
          //             ),
          //           ),
          //           const SizedBox(height: 10.0),
          //           Padding(
          //             padding: onlyHorizontal,
          //             child: TextFormField(
          //               controller: contact,
          //               readOnly: contactReadOnly,
          //               validator: (String value) {
          //                 // Indian Mobile number are of 10 digit only
          //                 if (value.length != 10)
          //                   return 'Mobile Number must be of 10 digit';
          //                 else
          //                   return null;
          //               },
          //               decoration: InputDecoration(
          //                 isDense: true,
          //                 labelText: 'Phone',
          //                 hintText: 'Phone',
          //                 suffix: IconButton(
          //                   icon: Icon(
          //                       contactReadOnly ? Icons.edit : Icons.check),
          //                   visualDensity: VisualDensity.compact,
          //                   onPressed: () {
          //                     // update user name here
          //                     setState(
          //                         () => contactReadOnly = !contactReadOnly);
          //                   },
          //                 ),
          //               ),
          //             ),
          //           ),
          //           const SizedBox(height: 10.0),
          //           ListTile(
          //             title: const Text(
          //               'Nearest Location:',
          //             ),
          //             subtitle: Text(
          //               model.state.technician.name,
          //             ),
          //           ),
          //           ListTile(
          //             title: const Text(
          //               'Selected date:',
          //             ),
          //             subtitle: Text(
          //               DateFormat(DateFormat.YEAR_ABBR_MONTH_WEEKDAY_DAY)
          //                   .format(model.state.selectedDate),
          //             ),
          //           ),
          //           ListTile(
          //             title: const Text(
          //               'Selected time slot:',
          //             ),
          //             subtitle: Text(
          //               onlyTime.format(
          //                       model.state.timeSlot.startTime.toDate()) +
          //                   ' - ' +
          //                   onlyTime
          //                       .format(model.state.timeSlot.endTime.toDate()),
          //             ),
          //           ),
          //           const SizedBox(height: kBottomNavigationBarHeight * 4),
          //         ],
          //         showBackButton: false,
          //       ),
          //       Align(
          //         alignment: Alignment.bottomCenter,
          //         child: Material(
          //           elevation: 20.0,
          //           child: userDetails == null
          //               ? const Center(child: CircularProgressIndicator())
          //               : userDetails != null &&
          //                       userDetails.sqCardOnFile != null &&
          //                       userDetails.sqCardOnFile.card != null
          //                   ? Padding(
          //                       padding: onlyHorizontal.copyWith(top: 10.0),
          //                       child: payUsingSavedCard(
          //                         context,
          //                         userDetails: userDetails,
          //                         onPay: () {
          //                           // if (_formKey.currentState.validate()) {
          //                           //   showConfirmPetHairDialog(() => bloc.add(
          //                           //         OnChargeCardOnFile(
          //                           //           model: model,
          //                           //           toPay: bloc.downPayment,
          //                           //           address: address.text,
          //                           //           contact: contact.text,
          //                           //           userDetails: userDetails,
          //                           //         ),
          //                           //       ));
          //                           // }
          //                         },
          //                       ),
          //                     )
          //                   : Column(
          //                       mainAxisSize: MainAxisSize.min,
          //                       mainAxisAlignment: MainAxisAlignment.start,
          //                       crossAxisAlignment: CrossAxisAlignment.start,
          //                       children: [
          //                         CheckboxListTile(
          //                           contentPadding: const EdgeInsets.symmetric(
          //                             horizontal: 20.0,
          //                           ),
          //                           // dense: true,
          //                           value: saveCard,
          //                           onChanged: (b) =>
          //                               setState(() => saveCard = b),
          //                           title: const Text(
          //                               'Save card for future payments ?'),
          //                         ),
          //                         Container(
          //                           height: kBottomNavigationBarHeight * 1.5,
          //                           width: double.infinity,
          //                           child: Padding(
          //                             padding: const EdgeInsets.symmetric(
          //                                 horizontal: 20.0,
          //                                 vertical: kBottomNavigationBarHeight *
          //                                     0.35),
          //                             child: FlatButton(
          //                               color: Theme.of(context).primaryColor,
          //                               shape: RoundedRectangleBorder(
          //                                 borderRadius: borderRadius,
          //                               ),
          //                               onPressed: () {
          //                                 // if (_formKey.currentState
          //                                 //     .validate()) {
          //                                 //   showConfirmPetHairDialog(
          //                                 //       () => bloc.add(
          //                                 //             OnStartCardEntryPaymentFlow(
          //                                 //               address: address.text,
          //                                 //               model: null,
          //                                 //             ),
          //                                 //           ));
          //                                 // }
          //                               },
          //                               child: Text.rich(
          //                                 TextSpan(
          //                                   text: 'Confirm and Pay '
          //                                       .toUpperCase(),
          //                                   children: [
          //                                     TextSpan(
          //                                       text: '\$' +
          //                                           bloc.downPayment.toString(),
          //                                     ),
          //                                   ],
          //                                   style: const TextStyle(
          //                                     // color: Colors.green,
          //                                     fontWeight: FontWeight.bold,
          //                                   ),
          //                                 ),
          //                                 style: const TextStyle(
          //                                     color: Colors.white),
          //                               ),
          //                             ),
          //                           ),
          //                         ),
          //                       ],
          //                     ),
          //         ),
          //       ),
          //     ],
          //   ),
          // );
        },
      ),
    );
  }
}

class MyFlexibleSpace extends StatefulWidget {
  const MyFlexibleSpace({
    @required this.text,
    @required this.imageUrl,
  });

  final String text;
  final String imageUrl;

  @override
  _MyFlexibleSpaceState createState() => _MyFlexibleSpaceState();
}

class _MyFlexibleSpaceState extends State<MyFlexibleSpace> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final settings = context
            .dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
        final deltaExtent = settings.maxExtent - settings.minExtent;
        final t =
            (1.0 - (settings.currentExtent - settings.minExtent) / deltaExtent)
                .clamp(0.0, 1.0) as double;
        final fadeStart = math.max(0.0, 1.0 - kToolbarHeight / deltaExtent);
        const fadeEnd = 1.0;
        final opacity = 1.0 - Interval(fadeStart, fadeEnd).transform(t);

        return Stack(
          children: [
            Center(
              child: Opacity(
                opacity: 1 - opacity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.text,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: white),
                  ),
                ),
              ),
            ),
            Opacity(
              opacity: opacity,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Hero(
                    tag: widget.imageUrl,
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      //change to image network
                      child: Image.network(
                        widget.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
