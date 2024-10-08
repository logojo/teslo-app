import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:teslo_app/features/products/domain/domain.dart';
import 'package:teslo_app/features/products/infraestructure/infraestructure.dart';

final productsRepositoryProvider = Provider<ProductsRepository>((ref) {
  //*Al acceder desde aqui al authProvider cualquier cambio que suceda en el tambien sera reflejado aquí
  //* cuando el usuario se authentica se actualiza y esparce el token y funciones a todos los providers que lo utilicen
  final accessToken = ref.watch(authProvider).user?.token ?? '';

  final productRepository = ProductsRepositoryImpl(
      datasource: ProductsDatasourceImpl(accessToken: accessToken));

  return productRepository;
});
