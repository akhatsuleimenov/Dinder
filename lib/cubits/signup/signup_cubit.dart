import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';

import '/repositories/repositories.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final AuthRepository _authRepository;

  SignupCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(SignupState.initial());

  void emailChanged(String value) {
    final email = Email.dirty(value);

    emit(state.copyWith(
      email: email,
      status: Formz.validate([email, state.password]),
    ));
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);

    emit(state.copyWith(
      password: password,
      status: Formz.validate([state.email, password]),
    ));
  }

  Future<void> signUpWithCredentials() async {
    if (!state.status.isValidated) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      var user = await _authRepository.signUp(
        email: state.email.value,
        password: state.password.value,
      );
      emit(state.copyWith(status: FormzStatus.submissionSuccess, user: user));
    } catch (e) {
      print(e);
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }
}

//   Future<User?> signInWithGoogle() async {
//     User? user;
//     emit(state.copyWith(status: FormzStatus.submissionInProgress));
//     try {
//       final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

//       if (gUser != null) {
//         final GoogleSignInAuthentication gAuth = await gUser.authentication;

//         final credential = GoogleAuthProvider.credential(
//           accessToken: gAuth.accessToken,
//           idToken: gAuth.idToken,
//         );

//         try {
//           final userCredential =
//               await FirebaseAuth.instance.signInWithCredential(credential);
//           user = userCredential.user;

//           emit(state.copyWith(
//               email: Email.dirty(user!.email!),
//               password: const Password.dirty(' '),
//               status: FormzStatus.submissionSuccess,
//               user: user));
//         } on FirebaseAuthException catch (e) {
//           // if (e.code == 'account-exists-with-different-credential') {
//           //   Get.showSnackbar(const GetSnackBar(
//           //     message:
//           //         "You already have an account with this email. Use other login method.",
//           //     duration: Duration(seconds: 3),
//           //   ));
//           // }
//           if (e.code == 'invalid-credential') {
//             const SnackBar(
//               content: Text("Invalid Credential!"),
//               duration: Duration(seconds: 3),
//             );
//           } else if (e.code == 'wrong-password') {
//             const SnackBar(
//               content: Text("Wrong password!"),
//               duration: Duration(seconds: 3),
//             );
//           }
//         } catch (e) {
//           print(e);
//           const SnackBar(
//             content: Text("Unknown Error. Try again later"),
//             duration: Duration(seconds: 3),
//           );
//         }
//       }
//       return user;
//     } catch (e) {
//       print(e);
//       emit(state.copyWith(status: FormzStatus.submissionFailure));
//     }
//     return user;
//   }
// }
