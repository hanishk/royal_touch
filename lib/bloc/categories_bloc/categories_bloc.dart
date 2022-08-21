// import 'dart:async';

// import 'package:bloc/bloc.dart';
// import 'package:meta/meta.dart';
// import 'package:royaltouch/firebase/app_cloud_firestore.dart';
// import 'package:royaltouch/firebase/models.dart';

// part 'categories_event.dart';
// part 'categories_state.dart';

// class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
//   CategoriesBloc() : super(CategoriesLoading()) {
//     loadCategories();
//   }

//   void loadCategories() {
//     AppCloudFirestore.getCategories().then((List l) {
//       if (l != null) {
//         add(OnCategoriesLoaded(categories: l));
//       } else {
//         add(OnCategoriesLoadingFailed());
//       }
//     });
//   }

//   @override
//   Stream<CategoriesState> mapEventToState(
//     CategoriesEvent event,
//   ) async* {
//     if (event is OnCategoriesLoaded) {
//       yield CategoriesLoaded(
//           categories: event.categories, selectedCategory: null);
//     } else if (event is OnCategoriesLoadingFailed) {
//       yield CategoriesLoadingFailed();
//     } else if (event is OnCategoriesLoadingSuccess) {
//       yield CategoriesLoadingSuccess();
//     } else if (event is OnCategorySelected) {
//       yield CategoriesLoaded(
//           selectedCategory: event.selectedCategory,
//           categories: event.categories);
//     } else {
//       yield CategoriesLoading();
//     }
//   }
// }
