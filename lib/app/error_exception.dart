class ErrorException{
  static String showError(String errorCode){
    switch(errorCode){

      case 'email-already-in-use':
        return "The email address is already in use by another account.";

      case 'invalid-credential':
        return "The supplied auth credential is incorrect, malformed or has expired.";

      default:
        return 'An Error Occurred';

    }

  }

}