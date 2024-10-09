import '../entities/product.dart';

abstract class ProductsRepository {
  Future<List<Product>> getProducts({int limit = 10, offset = 0});

  Future<Product> getProductById(String id);

  Future<List<Product>> searchProducByTerm(String term);

  Future<Product> createUpdateProduct(Map<String, dynamic> productLike);
}
