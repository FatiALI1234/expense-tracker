import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';

Future<Either<Failure, String>> signup({
  required String email,
  required String password,
}) async {
  try {
    final user = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    return right("Account created successfuly");
  } on FirebaseAuthException catch (e, stacktrace) {
    if (e.code == 'weak-password') {
      return Either.left(Failure(message: 'strong password is require'));
    } else if (e.code == "email-already-in-use") {
      return Either.left(Failure(
        message: ' This account is already exist',
      ));
    } else {
      print("Error $e $stacktrace");
      return Either.left(Failure(message: "Something went wrong"));
    }
  }
}
//future function for Signin

Future<Either<Failure, String>> signin({
  required String email,
  required String password,
}) async {
  try {
    final user = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return right("Login successfuly");
  } on FirebaseAuthException catch (e, stacktrace) {
    if (e.code == 'weak-password') {
      return Either.left(Failure(message: 'require strong password'));
    } else if (e.code == "email-already-in-use") {
      return Either.left(Failure(
        message: ' This account is already exist',
      ));
    } else {
      print("Error $e $stacktrace");
      return Either.left(Failure(message: "Something went wrong"));
    }
  }
}

Future<Either<Failure,String>>resetpassword(String email)async{
  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    return right("reset password successfuly");
  }on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      return left(Failure(message: "No user found for that email."));
    } else if (e.code == 'invalid-email') {
      return left(Failure(message:"The email address is not valid."));
    } else {
      return left(Failure(message: "An error occurred: ${e.message}"));
    }
  }
  }

class Failure {
final String message;
Failure({required this.message});
}
