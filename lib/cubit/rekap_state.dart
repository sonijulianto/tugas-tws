part of 'rekap_cubit.dart';

abstract class RekapState extends Equatable {
  const RekapState();

  @override
  List<Object> get props => [];
}

class RekapInitial extends RekapState {}

class RekapLoading extends RekapState {}

class RekapSuccess extends RekapState {
  final rekaps;

  RekapSuccess(this.rekaps);
  @override
  List<Object> get props => [rekaps];
}

class RekapFailed extends RekapState {
  final String error;

  RekapFailed(this.error);

  @override
  List<Object> get props => [error];
}
