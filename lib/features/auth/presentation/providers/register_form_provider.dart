import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:teslo_app/features/shared/shared.dart';

//* autoDispose limpia el provider cuando ya no se esta utilizando
final registerFormProvider =
    StateNotifierProvider.autoDispose<RegisterFormNotifier, RegisterFormState>(
        (ref) {
  final registerUserCallback = ref.watch(authProvider.notifier).register;
  return RegisterFormNotifier(registerUserCallback: registerUserCallback);
});

//*State del provider
class RegisterFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Email email;
  final Username fullname;
  final Password password;
  final Confirm confirm;

  RegisterFormState(
      {this.isPosting = false,
      this.isFormPosted = false,
      this.isValid = false,
      this.email = const Email.pure(),
      this.fullname = const Username.pure(),
      this.password = const Password.pure(),
      this.confirm = const Confirm.pure('')});

  RegisterFormState copyWith(
          {bool? isPosting,
          bool? isFormPosted,
          bool? isValid,
          Email? email,
          Username? fullname,
          Password? password,
          Confirm? confirm}) =>
      RegisterFormState(
        isPosting: isPosting ?? this.isPosting,
        isFormPosted: isFormPosted ?? this.isFormPosted,
        isValid: isValid ?? this.isValid,
        email: email ?? this.email,
        fullname: fullname ?? this.fullname,
        password: password ?? this.password,
        confirm: confirm ?? this.confirm,
      );

  @override
  String toString() {
    return '''
    RegisterFormState:
      isPosting: $isPosting 
      isFormPosted: $isFormPosted
      isValid: $isValid
      email: $email
      fullname: $fullname
      password: $password
    ''';
  }
}

class RegisterFormNotifier extends StateNotifier<RegisterFormState> {
  final Function(String, String, String) registerUserCallback;
  RegisterFormNotifier({required this.registerUserCallback})
      : super(RegisterFormState());

  void onSubmit() async {
    _touchEveryField();

    if (!state.isValid) return;

    state = state.copyWith(isPosting: true);

    //*llamando la función register del authProvider
    await registerUserCallback(
        state.email.value, state.fullname.value, state.password.value);

    state = state.copyWith(isPosting: false);
  }

  void _touchEveryField() {
    final email = Email.dirty(state.email.value);
    final fullname = Username.dirty(state.fullname.value);
    final password = Password.dirty(state.password.value);
    final confirm = Confirm.dirty(state.password.value, state.confirm.value);

    state = state.copyWith(
        isFormPosted: true,
        email: email,
        fullname: fullname,
        password: password,
        confirm: confirm,
        isValid: Formz.validate(
            [state.email, state.fullname, state.password, state.confirm]));
  }

  void emailChange(String value) {
    final email = Email.dirty(value);

    state = state.copyWith(
        email: email,
        isValid: Formz.validate(
            [email, state.fullname, state.password, state.confirm]));
  }

  void fullNameChange(String value) {
    final fullname = Username.dirty(value);

    state = state.copyWith(
        fullname: fullname,
        isValid: Formz.validate(
            [fullname, state.email, state.password, state.confirm]));
  }

  void passwordChange(String value) {
    final password = Password.dirty(value);

    state = state.copyWith(
        password: password,
        isValid: Formz.validate(
            [password, state.email, state.fullname, state.confirm]));
  }

  void confirmChange(String value) {
    final confirm = Confirm.dirty(state.password.value, value);

    state = state.copyWith(
        confirm: confirm,
        isValid: Formz.validate(
            [confirm, state.password, state.email, state.fullname]));
  }
}
