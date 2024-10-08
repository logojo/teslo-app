import 'package:dio/dio.dart';
import 'package:teslo_app/config/config.dart';
import 'package:teslo_app/features/auth/domain/domain.dart';
import 'package:teslo_app/features/auth/infraestructure/infraestructure.dart';

class AuthDatasourceImpl extends AuthDatasource {
  final dio = Dio(BaseOptions(baseUrl: Environment.apiUrl));

  @override
  Future<User> checkAuthStatus(String token) async {
    try {
      final res = await dio.get('/auth/check-status',
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      final user = UserMapper.userJsonToEntity(res.data);
      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError(e.response?.data['message'] ?? 'Token no valido');
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError(
            e.response?.data['message'] ?? 'Revise su conexion a internet');
      }
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<User> login(String email, String password) async {
    try {
      final res = await dio
          .post('/auth/login', data: {'email': email, 'password': password});

      final user = UserMapper.userJsonToEntity(res.data);

      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        //throw Wrongcredentials();
        throw CustomError(
            e.response?.data['message'] ?? 'Credenciales no validas');
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError(
            e.response?.data['message'] ?? 'Revise su conexion a internet');
      }
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<User> register(String email, String password, String fullname) async {
    try {
      final res = await dio.post('/auth/register',
          data: {'email': email, 'fullName': fullname, 'password': password});

      final user = UserMapper.userJsonToEntity(res.data);

      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        //throw Wrongcredentials();
        throw CustomError(e.response?.data['message'] ?? 'El correo ya existe');
      }
      if (e.response?.statusCode == 401) {
        //throw Wrongcredentials();
        throw CustomError(
            e.response?.data['message'] ?? 'Credenciales no validas');
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError(
            e.response?.data['message'] ?? 'Revise su conexion a internet');
      }
      throw Exception(e);
    } catch (e) {
      throw Exception(e);
    }
  }
}
