import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_app/features/products/domain/domain.dart';
import 'products_respository_providers.dart';

final productsProvider =
    StateNotifierProvider<ProductsNotifier, ProductsState>((ref) {
  //*leyendo el provider productsRepositoryProvider que ya contiene el repositorio y a su vez el datasource que require el ProductsNotifier
  final productsRepository = ref.watch(productsRepositoryProvider);

  return ProductsNotifier(productsRepository: productsRepository);
});

class ProductsNotifier extends StateNotifier<ProductsState> {
  final ProductsRepository productsRepository;

  ProductsNotifier({required this.productsRepository})
      : super(ProductsState()) {
    loadNextPage();
  }

  Future loadNextPage() async {
    //* evitar que se haga otra peticion antes de terminar la anterior
    if (state.isLoading || state.isLastPage) return;

    state = state.copyWith(isLoading: true);

    final products = await productsRepository.getProducts(
        limit: state.limit, offset: state.offset);

    //* cuando ya se han cargado todos las paginas de los productos
    if (products.isEmpty) {
      state.copyWith(isLoading: false, isLastPage: true);
      return;
    }

    //* cuando aun faltan paginas por cargar
    state = state.copyWith(
        isLastPage: false,
        isLoading: false,
        offset: state.offset + 10,
        products: [...state.products, ...products]);
  }
}

class ProductsState {
  final bool isLastPage;
  final int limit;
  final int offset;
  final bool isLoading;
  final List<Product> products;

  ProductsState(
      {this.isLastPage = false,
      this.limit = 10,
      this.offset = 0,
      this.isLoading = false,
      this.products = const []});

  ProductsState copyWith({
    bool? isLastPage,
    int? limit,
    int? offset,
    bool? isLoading,
    List<Product>? products,
  }) =>
      ProductsState(
        isLastPage: isLastPage ?? this.isLastPage,
        limit: limit ?? this.limit,
        offset: offset ?? this.offset,
        isLoading: isLoading ?? this.isLoading,
        products: products ?? this.products,
      );
}
