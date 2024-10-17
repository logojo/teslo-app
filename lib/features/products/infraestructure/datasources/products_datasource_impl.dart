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
  Future<Product> createUpdateProduct(Map<String, dynamic> productLike) async {
    try {
      final String? productId = productLike['id'];

      final String method = (productId == null) ? 'POST' : 'PATCH';
      final String url =
          (productId == null) ? '/products' : '/products/$productId';

      productLike.remove('id');

      final res = await dio.request(url,
          data: productLike, options: Options(method: method));

      final Product product = ProductMapper.productJsonEntity(res.data);

      return product;
    } on DioException catch (e) {
      if (e.response!.statusCode == 404) throw ProductNotFound();
      throw Exception(e);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<Product> getProductById(String id) async {
    try {
      final res = await dio.get('/products/$id');
      final Product product = ProductMapper.productJsonEntity(res.data);

      return product;
    } on DioException catch (e) {
      if (e.response!.statusCode == 404) throw ProductNotFound();
      throw Exception(e);
    } catch (e) {
      throw Exception(e);
    }
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
