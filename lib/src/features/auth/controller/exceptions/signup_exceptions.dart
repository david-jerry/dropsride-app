class SignupWithEmailAndPasswordExceptions {
  final String message;

  const SignupWithEmailAndPasswordExceptions(
      [this.message = "An Unknown error occured."]);

  factory SignupWithEmailAndPasswordExceptions.code(String code) {
    switch (code) {
      case 'weak-password':
        return const SignupWithEmailAndPasswordExceptions(
            'Please enter a strong password.');
      case 'invalid-email':
        return const SignupWithEmailAndPasswordExceptions(
            'Email is not valid or badly formatted.');
      case 'email-already-in-use':
        return const SignupWithEmailAndPasswordExceptions(
            'An account already exists for that email');
      case 'operation-not-allowed':
        return const SignupWithEmailAndPasswordExceptions(
            'Operation is not allowed. Please contact support for assistance: support@dropsride.com');
      case 'user-disabled':
        return const SignupWithEmailAndPasswordExceptions(
            'This user has been disabled. Please contact support for assistance: support@dropsride.com');
      default:
        return const SignupWithEmailAndPasswordExceptions();
    }
  }
}
