part of 'home_cubit.dart';

@immutable
class HomeState extends Equatable {

  const HomeState({
    this.count = 0,
  });

  final int count;

  HomeState copyWith({
    int? count,
  }) {
    return HomeState(
      count: count ?? this.count,
    );
  }

  @override
  List<Object?> get props => [count];
}
