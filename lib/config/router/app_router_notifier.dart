import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_app/features/auth/presentation/providers/auth_provider.dart';

//* provider de riverpod que maneja los cambios de estado de authNotifier
final goRouterNotifierProvider = Provider((ref) {
  final authNotifier = ref.read(authProvider.notifier);
  return GoRouterNotifier(authNotifier);
});

//* ChangeNotifier no viene de riverpod viene con flutter y se puede utilizar para manejar estados
class GoRouterNotifier extends ChangeNotifier {
  final AuthNotifier _authNotifier;

  AuthStatus _authStatus = AuthStatus.checking;
  Acount _acount = Acount.nonExist;

  GoRouterNotifier(this._authNotifier) {
    //* esto me sirve para estar pendiente de los cambios que haga el _authNotifier
    //* cuando _authNotifier emita un nuevo estado que viene de riverpod cambio el stado del authStatus del ChangeNotifier
    //* aqui estoy utilizando la propiedad get
    _authNotifier.addListener((state) {
      authStatus = state.authStatus;
      acount = state.acount;
    });
  }

  //* regresando el valor actual del _authStatus
  AuthStatus get authStatus => _authStatus;

  set authStatus(AuthStatus value) {
    _authStatus = value;

    //*esto se utiliza para cambiar el estado del ChangeNotifier
    notifyListeners();
  }

  Acount get acount => _acount;

  set acount(Acount value) {
    _acount = value;
    notifyListeners();
  }
}
