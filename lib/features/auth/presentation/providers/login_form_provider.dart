import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:teslo_app/features/shared/shared.dart';

//* autoDispose limpia el provider cuando ya no se esta utilizando
final loginFormProvider =
    StateNotifierProvider.autoDispose<LoginFormNotifier, LoginFormState>((ref) {
  //*conectando con el metodo login del provider AuthProcider
  final loginUserCallback = ref.watch(authProvider.notifier).login;
  return LoginFormNotifier(loginUserCallback: loginUserCallback);
});

//*State del provider
class LoginFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Email email;
  final Password password;

  LoginFormState(
      {this.isPosting = false,
      this.isFormPosted = false,
      this.isValid = false,
      this.email = const Email.pure(),
      this.password = const Password.pure()});

  LoginFormState copyWith(
          {bool? isPosting,
          bool? isFormPosted,
          bool? isValid,
          Email? email,
          Password? password}) =>
      LoginFormState(
        isPosting: isPosting ?? this.isPosting,
        isFormPosted: isFormPosted ?? this.isFormPosted,
        isValid: isValid ?? this.isValid,
        email: email ?? this.email,
        password: password ?? this.password,
      );

  @override
  String toString() {
    return '''
    LoginFormState:
      isPosting: $isPosting 
      isFormPosted: $isFormPosted
      isValid: $isValid
      email: $email
      password: $password
    ''';
  }
}

class LoginFormNotifier extends StateNotifier<LoginFormState> {
  final Function(String, String) loginUserCallback;
  LoginFormNotifier({required this.loginUserCallback})
      : super(LoginFormState());

  void onSubmit() async {
    _touchEveryField();

    if (!state.isValid) return;

    state = state.copyWith(isPosting: true);

    //*llamando la función login del authProvider
    await loginUserCallback(state.email.value, state.password.value);

    state = state.copyWith(isPosting: false);
  }

  void _touchEveryField() {
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);

    state = state.copyWith(
        isFormPosted: true,
        email: email,
        password: password,
        isValid: Formz.validate([state.email, state.password]));
  }

  void emailChange(String value) {
    final email = Email.dirty(value);

    state = state.copyWith(
        email: email, isValid: Formz.validate([email, state.password]));
  }

  void passwordChange(String value) {
    final password = Password.dirty(value);

    state = state.copyWith(
        password: password, isValid: Formz.validate([password, state.email]));
  }
}
