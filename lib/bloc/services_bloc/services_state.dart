part of 'services_bloc.dart';

@immutable
abstract class ServicesState {}

class ServicesLoading extends ServicesState {}

class ServicesLoaded extends ServicesState {
  ServicesLoaded({@required this.services});
  final List<AllServices> services;
}

class ServicesLoadingFailed extends ServicesState {}

class ServicesLoadingSuccess extends ServicesState {}
