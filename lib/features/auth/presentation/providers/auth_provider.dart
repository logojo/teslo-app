import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_app/features/auth/domain/domain.dart';
import 'package:teslo_app/features/auth/infraestructure/infraestructure.dart';
import 'package:teslo_app/features/shared/infraestructure/services/key_value_storage.dart';

import 'package:teslo_app/features/shared/infraestructure/services/key_value_storage_impl.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = AuthRepositoryImpl();
  final storageService = KeyValueStorageImpl();

  return AuthNotifier(
      authRepository: authRepository, storageService: storageService);
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository authRepository;
  final KeyValueStorage storageService;

  AuthNotifier({required this.authRepository, required this.storageService})
      : super(AuthState()) {
    //*Ejecutando checkAuthStatus justo cuando se crea la primera instancias de la app
    checkAuthStatus();
  }

  Future<void> login(String email, String password) async {
    try {
      final user = await authRepository.login(email, password);
      _setLoggedUser(user);
    } on CustomError catch (e) {
      //*error que viene del backend
      logout(e.message);
    } catch (e) {
      logout('Upsss, Something went wrong!!!!');
    }
  }

  void register(String email, String fullname, String password) async {
    try {
      final user = await authRepository.register(email, password, fullname);

      await storageService.setKetValue('usuario', user.fullName);
      await storageService.setKetValue('email', user.email);
      await storageService.setKetValue('acount', Acount.exist.name);

      _setLoggedUser(user);
    } on CustomError catch (e) {
      logout(e.message);
    } catch (e) {
      logout('Upsss, Something went wrong!!!!');
    }
  }

  void checkAuthStatus() async {
    final token = await storageService.getValue<String>('token');
    final acount = await storageService.getValue<String>('acount');
    final username = await storageService.getValue<String>('usuario');

    state = state.copyWith(
        username: username,
        acount: acount != null ? Acount.exist : Acount.nonExist);

    if (token == null) return logout();

    try {
      //*verificando con la api si el token es valido
      final user = await authRepository.checkAuthStatus(token);
      _setLoggedUser(user);
    } catch (e) {
      logout();
    }
  }

  void _setLoggedUser(User user) async {
    //*Almacenando el token en el almacenamiento local
    await storageService.setKetValue('token', user.token);

    state = state.copyWith(
        authStatus: AuthStatus.authenticated,
        acount: Acount.exist,
        user: user,
        errorMessage: '');
  }

  Future<void> logout([String? errorMessage]) async {
    //* limpiando token
    await storageService.removeKey('token');

    state = state.copyWith(
        authStatus: AuthStatus.notAuthenticated,
        user: null,
        errorMessage: errorMessage);
  }
}

enum AuthStatus { checking, authenticated, notAuthenticated }

enum Acount { exist, nonExist }

class AuthState {
  final AuthStatus authStatus;
  final Acount acount;
  final User? user;
  final String errorMessage;
  final String? username;

  AuthState(
      {this.authStatus = AuthStatus.checking,
      this.acount = Acount.nonExist,
      this.user,
      this.errorMessage = '',
      this.username = ''});

  AuthState copyWith({
    AuthStatus? authStatus,
    Acount? acount,
    User? user,
    String? errorMessage,
    String? username,
  }) =>
      AuthState(
          authStatus: authStatus ?? this.authStatus,
          acount: acount ?? this.acount,
          user: user ?? this.user,
          errorMessage: errorMessage ?? this.errorMessage,
          username: username ?? this.username);
}
