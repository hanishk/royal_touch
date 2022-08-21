// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:royaltouch/bloc/categories_bloc/categories_bloc.dart';
// import 'package:royaltouch/config/routes.dart';
// import 'package:royaltouch/firebase/models.dart';
// import 'package:royaltouch/pages/categories/main_drawer.dart';
// import 'package:royaltouch/widgets/appbar.dart';
// import 'package:royaltouch/widgets/scaffold.dart';

// class CategoriesPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) => MainScaffold(
//         appBar: mainAppBar(
//           title: 'Categories Screen',
//         ),
//         drawer: MainDrawer(),
//         body: BlocConsumer<CategoriesBloc, CategoriesState>(
//           listener: (context, state) {},
//           builder: (context, state) {
//             if (state is CategoriesLoading) {
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             } else if (state is CategoriesLoaded) {
//               return Column(
//                 children: [
//                   ...state.categories
//                       .map((c) => RadioListTile<VehicleCategories>(
//                             value: c,
//                             groupValue: state.selectedCategory,
//                             onChanged: (VehicleCategories category) =>
//                                 BlocProvider.of<CategoriesBloc>(context).add(
//                               OnCategorySelected(
//                                 selectedCategory: c,
//                                 categories: state.categories,
//                               ),
//                             ),
//                             title: Text(c.name),
//                           ))
//                       .toList(),
//                   OutlineButton(
//                     onPressed: state.selectedCategory != null
//                         ? () => AppRouter.fluroRouter.navigateTo(
//                               context,
//                               AppRouter.services,
//                               routeSettings: RouteSettings(
//                                 arguments: state.selectedCategory,
//                               ),
//                             )
//                         : null,
//                     child: const Text('Continue'),
//                   ),
//                 ],
//               );
//             } else {
//               return const Center(
//                 child: Text('Sorry We couldnt find any categories.'),
//               );
//             }
//           },
//         ),
//       );
// }
