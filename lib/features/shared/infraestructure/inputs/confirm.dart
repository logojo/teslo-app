import 'package:formz/formz.dart';

enum ConfirmError { empty, mismatch }

class Confirm extends FormzInput<String, ConfirmError> {
  final String password;

  const Confirm.pure(this.password) : super.pure('');

  const Confirm.dirty(this.password, [String value = '']) : super.dirty(value);

  String? get errorMesage {
    if (isValid || isPure) return null;

    if (displayError == ConfirmError.empty) return 'El campo es requerido';
    if (displayError == ConfirmError.mismatch) {
      return 'las contraseñas no coinciden';
    }

    return null;
  }

  @override
  ConfirmError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return ConfirmError.empty;
    if (value != password) return ConfirmError.mismatch;
    return null;
  }
}
