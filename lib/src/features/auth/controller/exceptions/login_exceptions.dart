class LoginWithEmailAndPasswordExceptions {
  final String message;

  const LoginWithEmailAndPasswordExceptions(
      [this.message = "An Unknown error occured."]);

  factory LoginWithEmailAndPasswordExceptions.code(String code) {
    switch (code) {
      case 'user-not-found':
        return const LoginWithEmailAndPasswordExceptions(
            'There is no user record registered with this email.');
      case 'wrong-password':
        return const LoginWithEmailAndPasswordExceptions(
            'The password is wrong.');
      default:
        return const LoginWithEmailAndPasswordExceptions();
    }
  }
}
