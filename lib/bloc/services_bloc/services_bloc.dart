import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:royaltouch/firebase/app_cloud_firestore.dart';
import 'package:royaltouch/firebase/models.dart';

part 'services_event.dart';
part 'services_state.dart';

class ServicesBloc extends Bloc<ServicesEvent, ServicesState> {
  ServicesBloc() : super(ServicesLoading()) {
    loadServices();
  }
  // final VehicleCategories vehicleCategories;
  void loadServices() {
    AppCloudFirestore.getAllServices().then((List l) {
      if (l != null) {
        add(OnServicesLoaded(services: l));
      } else {
        add(OnServicesLoadingFailed());
      }
    });
  }

  @override
  Stream<ServicesState> mapEventToState(
    ServicesEvent event,
  ) async* {
    if (event is OnServicesLoaded) {
      yield ServicesLoaded(services: event.services);
    } else if (event is OnServicesLoadingFailed) {
      yield ServicesLoadingFailed();
    } else if (event is OnServicesLoadingSuccess) {
      yield ServicesLoadingSuccess();
    } else if (event is OnServiceSelected) {
      yield ServicesLoaded(services: event.services);
    } else if (event is OnSort) {
      if (event.sort == Sort.ByPrice) {
        event.services.sort((a, b) => a.price.compareTo(b.price));
      } else if (event.sort == Sort.ByTime) {
        event.services.sort((a, b) => a.time.compareTo(b.time));
      }

      yield ServicesLoaded(services: event.services);
    } else {
      yield ServicesLoading();
    }
  }
}
