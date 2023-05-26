class SocialExceptions {
  final String message;

  const SocialExceptions([this.message = "An Unknown error occurred."]);

  factory SocialExceptions.code(String code) {
    switch (code) {
      case 'account-exists-with-different-credential':
        return const SocialExceptions(
            "There is another account existing on our platform using this social auth provider. Contact support@dropsride.com if you feel this is an error for rectification.");
      case 'provider-already-linked':
        return const SocialExceptions(
            'The provider has already been linked to the user.');
      case 'operation-not-allowed':
        return const SocialExceptions(
            'Operation is not allowed. Please contact support for assistance: support@dropsride.com');
      case 'user-disabled':
        return const SocialExceptions(
            'This user has been disabled. Please contact support for assistance: support@dropsride.com');
      case 'invalid-credential':
        return const SocialExceptions(
            'The provider\'s credential is not valid.');
      case 'user-not-found':
        return const SocialExceptions(
            'There is no user record registered with this email.');
      case 'wrong-password':
        return const SocialExceptions('The password is wrong.');
      case 'credential-already-in-use':
        return const SocialExceptions(
            '"The account corresponding to the credential already exists, or is already linked to a Firebase User.');
      default:
        return const SocialExceptions();
    }
  }
}
