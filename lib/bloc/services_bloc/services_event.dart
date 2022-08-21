part of 'services_bloc.dart';

@immutable
abstract class ServicesEvent {}

class OnServicesLoaded extends ServicesEvent {
  OnServicesLoaded({@required this.services});
  final List<AllServices> services;
}

class OnServicesLoadingFailed extends ServicesEvent {}

class OnServicesLoadingSuccess extends ServicesEvent {}

enum Sort { ByPrice, ByTime }

class OnSort extends ServicesEvent {
  OnSort(this.services, this.sort);
  final List<AllServices> services;
  final Sort sort;
}

class OnServiceSelected extends ServicesEvent {
  OnServiceSelected({@required this.selectedServices, @required this.services});
  final List<AllServices> services;
  final AllServices selectedServices;
}
