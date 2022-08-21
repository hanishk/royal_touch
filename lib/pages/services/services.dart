import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:royaltouch/bloc/services_bloc/services_bloc.dart';
import 'package:royaltouch/config/routes.dart';
import 'package:royaltouch/firebase/models.dart';
import 'package:royaltouch/pages/categories/main_drawer.dart';
import 'package:royaltouch/widgets/appbar.dart';
import 'package:royaltouch/widgets/buttons.dart';
import 'package:royaltouch/widgets/new_button.dart';
import 'package:royaltouch/widgets/scaffold.dart';
import 'package:royaltouch/widgets/service_details.dart';
import 'package:royaltouch/config/colors.dart';

class ServicesPage extends StatefulWidget {
  @override
  _ServicesPageState createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  bool useVertical = true;

  Widget sCardVertical(AllServices service, int i) {
    return Stack(
      overflow: Overflow.visible,
      children: [
        InkWell(
          onTap: () {
            AppRouter.fluroRouter
                .navigateTo(
              context,
              AppRouter.makeAppointment,
              routeSettings: RouteSettings(
                arguments: service,
              ),
            )
                .then(
              (dynamic val) {
                if (val is Map && val['appointment_success']) {
                  // coming back fromt he
                  Flushbar<void>(
                      messageText: const Text(
                        'Successfully made an appointment',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      flushbarStyle: FlushbarStyle.GROUNDED,
                      duration: const Duration(seconds: 4),
                      backgroundColor: Colors.green)
                    ..show(context);
                }
              },
            );
          },
          child: getSerivceImage(
            context: context,
            service: service,
            height: 190,
            // width: MediaQuery.of(context).size.width,
          ),
        ),
        Positioned(
          top: -10,
          left: 0,
          child: Button(
            fontSize: 12,
            position: P.Left,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
            ),
            color: white,
            onPressed: () {},
            text: service.name,
            cut: Cut.BR,
          ),
        ),
        Positioned(
          bottom: 6,
          left: 6,
          child: Container(
            width: 100,
            height: 36,
            decoration: const BoxDecoration(
              color: bluePrimary80,
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Icon(
                  Icons.watch_later_rounded,
                  color: white,
                ),
                Text(
                  service.time.toString() + ' hours',
                  style: GoogleFonts.publicSans(
                    color: white,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Button(
            color: bluePrimary.withOpacity(0.8),
            textColor: white,
            onPressed: () => print('hello'),
            cut: Cut.TL,
            text: '\$' + service.price.toString(),
            style: GoogleFonts.publicSans(),
          ),
        ),

        // serviceDetails(service),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<InnerDrawerState> innerDrawerKey =
        GlobalKey<InnerDrawerState>();
    return BlocBuilder<ServicesBloc, ServicesState>(
      builder: (context, state) {
        if (state is ServicesLoading) {
          return MainScaffold(
            appBar: mainAppBar(
              context,
              title: 'Royal Touch MD',
            ),
            body: Center(
              // TODO(Aman-Malhotra): To add the lottie file here
              child: Padding(
                padding: const EdgeInsets.only(left: 32.0),
                child: Lottie.asset(
                  'assets/lottie/flying_guy.json',
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          );
        }
        return InnerDrawer(
          key: innerDrawerKey,
          onTapClose: true,
          swipe: true,
          colorTransitionScaffold: Colors.black12,
          scale: const IDOffset.horizontal(1.0),
          proportionalChildArea: true,
          leftAnimationType: InnerDrawerAnimation.static,
          rightAnimationType: InnerDrawerAnimation.quadratic,
          backgroundDecoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
          ),
          leftChild: MainDrawer(),
          scaffold: MainScaffold(
            body: (state is ServicesLoaded)
                ? SafeArea(
                    child: CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: Column(
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                overflow: Overflow.visible,
                                children: [
                                  Container(
                                    height: 128,
                                    width: double.infinity,
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage(
                                            'assets/services_header.png'),
                                        colorFilter: ColorFilter.mode(
                                          bluePrimary,
                                          BlendMode.multiply,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 20,
                                    child: Container(
                                      width: 132,
                                      height: 48,
                                      child: Image.asset(
                                        'assets/royal_touch2.png',
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 0.0,
                                    bottom: -10.0,
                                    child: Button(
                                      cut: Cut.TL,
                                      text: 'What we do ',
                                      showIcon: true,
                                      iconData: Icons.play_circle_outline,
                                      fontSize: 14,
                                      style: GoogleFonts.poppins(),
                                      color: bluePrimary,
                                      onPressed: () => print(
                                          'open youtube video in full screen'),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 30),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 18),
                                    child: Text(
                                      'Services',
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20,
                                        color: statusBarColor,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 28),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.sort_sharp,
                                        color: statusBarColor,
                                      ),
                                      onPressed: () {
                                        showDialog<OnSort>(
                                          context: context,
                                          builder: (_) => SimpleDialog(
                                            title: const Text(
                                              'Sort By:',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18.0,
                                              ),
                                            ),
                                            titlePadding: bothHorAndVertical,
                                            contentPadding: onlyHorizontal,
                                            children: Sort.values
                                                .map<Widget>(
                                                  (e) => ListTile(
                                                      contentPadding: EdgeInsets
                                                          .zero,
                                                      trailing: e ==
                                                              Sort.ByPrice
                                                          ? const Icon(Icons
                                                              .attach_money)
                                                          : e == Sort.ByTime
                                                              ? const Icon(Icons
                                                                  .watch_later)
                                                              : Container(),
                                                      title: Text(
                                                        (e == Sort.ByPrice
                                                                ? 'Price'
                                                                : e == Sort.ByTime
                                                                    ? 'Time'
                                                                    : '')
                                                            .toUpperCase(),
                                                        style: const TextStyle(
                                                          fontSize: 14.0,
                                                        ),
                                                      ),
                                                      onTap: () =>
                                                          Navigator.pop(
                                                              context,
                                                              OnSort(
                                                                  state
                                                                      .services,
                                                                  e))),
                                                )
                                                .toList(),
                                          ),
                                        ).then((OnSort value) {
                                          if (value != null) {
                                            BlocProvider.of<ServicesBloc>(
                                                    context)
                                                .add(value);
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.03),
                            ],
                          ),
                        ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (_, i) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 19),
                              child: sCardVertical(
                                state.services[i],
                                state.services.indexOf(state.services[i]),
                              ),
                            ),
                            childCount: state.services.length,
                          ),
                        ),
                      ],
                    ),
                  )
                // child: SingleChildScrollView(
                //   physics: const ScrollPhysics(),
                //   child: Column(
                //     children: [
                //       Stack(
                //         alignment: Alignment.center,
                //         overflow: Overflow.visible,
                //         children: [
                //           Container(
                //             height: 128,
                //             width: double.infinity,
                //             decoration: const BoxDecoration(
                //               image: DecorationImage(
                //                 fit: BoxFit.cover,
                //                 image: AssetImage('assets/image 4.png'),
                //                 colorFilter: ColorFilter.mode(
                //                   bluePrimary,
                //                   BlendMode.multiply,
                //                 ),
                //               ),
                //             ),
                //           ),
                //           Positioned(
                //             top: 20,
                //             child: Container(
                //               width: 132,
                //               height: 48,
                //               child: Image.asset(
                //                 'assets/royal_touch2.png',
                //               ),
                //             ),
                //           ),
                //           Positioned(
                //             right: 0.0,
                //             bottom: -10.0,
                //             child: Button(
                //               cut: Cut.TL,
                //               text: 'What we do ',
                //               showIcon: true,
                //               iconData: Icons.play_circle_outline,
                //               fontSize: 14,
                //               style: GoogleFonts.poppins(),
                //               color: bluePrimary,
                //               onPressed: () => print(
                //                   'open youtube video in full screen'),
                //             ),
                //           ),
                //         ],
                //       ),
                //       const SizedBox(height: 30),
                //       Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //           Padding(
                //             padding: const EdgeInsets.only(left: 18),
                //             child: Text(
                //               'Services',
                //               style: GoogleFonts.poppins(
                //                 fontWeight: FontWeight.w500,
                //                 fontSize: 20,
                //                 color: statusBarColor,
                //               ),
                //             ),
                //           ),
                //           Padding(
                //             padding: const EdgeInsets.only(right: 28),
                //             child: IconButton(
                //               icon: const Icon(
                //                 Icons.sort_sharp,
                //                 color: statusBarColor,
                //               ),
                //               onPressed: () {
                //                 showDialog<OnSort>(
                //                   context: context,
                //                   builder: (_) => SimpleDialog(
                //                     title: const Text(
                //                       'Sort By:',
                //                       style: TextStyle(
                //                         fontWeight: FontWeight.bold,
                //                         fontSize: 18.0,
                //                       ),
                //                     ),
                //                     titlePadding: bothHorAndVertical,
                //                     contentPadding: onlyHorizontal,
                //                     children: Sort.values
                //                         .map<Widget>(
                //                           (e) => ListTile(
                //                               contentPadding:
                //                                   EdgeInsets.zero,
                //                               trailing: e == Sort.ByPrice
                //                                   ? const Icon(
                //                                       Icons.attach_money)
                //                                   : e == Sort.ByTime
                //                                       ? const Icon(
                //                                           Icons.watch_later)
                //                                       : Container(),
                //                               title: Text(
                //                                 (e == Sort.ByPrice
                //                                         ? 'Price'
                //                                         : e == Sort.ByTime
                //                                             ? 'Time'
                //                                             : '')
                //                                     .toUpperCase(),
                //                                 style: const TextStyle(
                //                                   fontSize: 14.0,
                //                                 ),
                //                               ),
                //                               onTap: () => Navigator.pop(
                //                                   context,
                //                                   OnSort(
                //                                       state.services, e))),
                //                         )
                //                         .toList(),
                //                   ),
                //                 ).then((OnSort value) {
                //                   if (value != null) {
                //                     BlocProvider.of<ServicesBloc>(context)
                //                         .add(value);
                //                   }
                //                 });
                //               },
                //             ),
                //           ),
                //         ],
                //       ),
                //       const SizedBox(height: 32),
                //       ListView.builder(
                //         physics: const ScrollPhysics(),
                //         shrinkWrap: true,
                //         itemCount: state.services.length,
                //         itemBuilder: (_, i) {
                //           return Padding(
                //             padding:
                //                 const EdgeInsets.symmetric(vertical: 19),
                //             child: sCardVertical(
                //               state.services[i],
                //               state.services.indexOf(state.services[i]),
                //             ),
                //           );
                //         },
                //       ),
                //     ],
                //   ),
                // ),

                //  CustomScrollView(
                //     slivers: [
                //       SliverToBoxAdapter(
                //         child: WelcomeVideo(),
                //       ),
                //       SliverList(
                //         delegate: SliverChildBuilderDelegate(
                //           (_, i) => Padding(
                //             padding:
                //                 const EdgeInsets.symmetric(horizontal: 16.0)
                //                     .copyWith(bottom: 16.0),
                //             child: sCardVertical(
                //               state.services[i],
                //               state.services.indexOf(state.services[i]),
                //             ),
                //           ),
                //           childCount: state.services.length,
                //         ),
                //       ),
                //     ],
                //   )
                : const Center(
                    child: Text('Sorry We couldnt find any services.'),
                  ),
          ),
        );
      },
    );
  }
}
