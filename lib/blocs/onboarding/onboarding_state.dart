part of 'onboarding_bloc.dart';

abstract class OnboardingState extends Equatable {
  const OnboardingState();

  @override
  List<Object> get props => [];
}

class OnboardingLoading extends OnboardingState {}

class OnboardingLoaded extends OnboardingState {
  final User user;
  final TabController tabController;

  const OnboardingLoaded({required this.user, required this.tabController});

  @override
  List<Object> get props => [user, tabController];
}
