import 'package:teslo_app/features/products/domain/domain.dart';

class ProductsRepositoryImpl extends ProductsRepository {
  final ProductsDatasource datasource;

  ProductsRepositoryImpl({required this.datasource});

  @override
  Future<Product> createUpdateProduct(Map<String, dynamic> productLike) {
    return datasource.createUpdateProduct(productLike);
  }

  @override
  Future<Product> getProductById(String id) {
    return datasource.getProductById(id);
  }

  @override
  Future<List<Product>> getProducts({int limit = 10, offset = 0}) {
    return datasource.getProducts(limit: limit, offset: offset);
  }

  @override
  Future<List<Product>> searchProducByTerm(String term) {
    return datasource.searchProducByTerm(term);
  }
}
