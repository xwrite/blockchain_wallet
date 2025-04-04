part of 'authentication_cubit.dart';

class AuthenticationState extends Equatable {
  final bool isPasswordVisible;
  final bool isPasswordAgainVisible;
  final String password;
  final String passwordAgain;

  const AuthenticationState({
    this.isPasswordVisible = false,
    this.isPasswordAgainVisible = false,
    this.password = '',
    this.passwordAgain = '',
  });

  AuthenticationState copyWith({
    bool? isPasswordVisible,
    bool? isPasswordAgainVisible,
    String? password,
    String? passwordAgain,
  }) {
    return AuthenticationState(
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isPasswordAgainVisible:
          isPasswordAgainVisible ?? this.isPasswordAgainVisible,
      password: password ?? this.password,
      passwordAgain: passwordAgain ?? this.passwordAgain,
    );
  }

  @override
  List<Object?> get props => [
        isPasswordVisible,
        isPasswordAgainVisible,
        password,
        passwordAgain,
      ];
}
