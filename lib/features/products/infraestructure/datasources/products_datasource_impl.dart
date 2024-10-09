import 'package:dio/dio.dart';
import 'package:teslo_app/config/config.dart';
import 'package:teslo_app/features/products/domain/domain.dart';
import 'package:teslo_app/features/products/infraestructure/infraestructure.dart';

class ProductsDatasourceImpl extends ProductsDatasource {
  //*late se usa para decir que esta variable sera configurada despues
  late final Dio dio;
  final String accessToken;

  ProductsDatasourceImpl({required this.accessToken})
      : dio = Dio(BaseOptions(
          baseUrl: Environment.apiUrl,
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ));

  @override
  Future<Product> createUpdateProduct(Map<String, dynamic> productLike) {
    // TODO: implement createUpdateProduct
    throw UnimplementedError();
  }

  @override
  Future<Product> getProductById(String id) {
    // TODO: implement getProductById
    throw UnimplementedError();
  }

  @override
  Future<List<Product>> getProducts({int limit = 10, offset = 0}) async {
    final res = await dio.get<List>('/products',
        queryParameters: {'limit': limit, 'offset': offset});

    final List<Product> products = [];

    for (final product in res.data ?? []) {
      products.add(ProductMapper.productJsonEntity(product));
    }

    return products;
  }

  @override
  Future<List<Product>> searchProducByTerm(String term) {
    // TODO: implement searchProducByTerm
    throw UnimplementedError();
  }
}
