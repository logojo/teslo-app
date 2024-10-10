import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

import 'package:teslo_app/config/config.dart';
import 'package:teslo_app/features/products/domain/domain.dart';
import 'package:teslo_app/features/products/presentation/providers/products_respository_providers.dart';
import 'package:teslo_app/features/shared/infraestructure/inputs/inpust.dart';

final productFormProvider = StateNotifierProvider.autoDispose
    .family<ProductFormNotifier, ProductFormState, Product>((ref, product) {
  //* variable que recibe de otro provider la funcion del repositorio que a su vez llama la fnc del datasource
  final createUpdateCallback =
      ref.watch(productsRepositoryProvider).createUpdateProduct;

  return ProductFormNotifier(
      product: product, onSubmitCallback: createUpdateCallback);
});

class ProductFormNotifier extends StateNotifier<ProductFormState> {
  final Future<Product> Function(Map<String, dynamic> productLike)?
      onSubmitCallback;

  //* creado contructor con valores inicializados
  ProductFormNotifier({this.onSubmitCallback, required Product product})
      : super(ProductFormState(
          id: product.id,
          title: Title.dirty(product.title),
          price: Price.dirty(product.price),
          slug: Slug.dirty(product.slug),
          inStock: Stock.dirty(product.stock),
          sizes: product.sizes,
          gender: product.gender,
          description: product.description,
          tags: product.tags.join(''),
          images: product.images,
        ));

  Future<bool> onSubmit() async {
    _touchedEverything();

    if (state.isValid) return false;

    if (onSubmitCallback == null) return false;

    final productLike = {
      'id': state.id,
      'title': state.title.value,
      'price': state.price.value,
      'description': state.description,
      'slug': state.slug.value,
      'stock': state.inStock.value,
      'sizes': state.sizes,
      'gender': state.gender,
      'tags': state.tags.split(','),
      'images': state.images
          .map((image) =>
              image.replaceAll('${Environment.apiUrl}/files/product', ''))
          .toList()
    };

    try {
      await onSubmitCallback!(productLike);
      return true;
    } catch (e) {
      return false;
    }
  }

  void _touchedEverything() {
    state = state.copyWith(
      isValid: Formz.validate([
        Title.dirty(state.title.value),
        Price.dirty(state.price.value),
        Slug.dirty(state.slug.value),
        Stock.dirty(state.inStock.value),
      ]),
    );
  }

  onTitleChanged(String value) {
    state = state.copyWith(
        title: Title.dirty(value),
        isValid: Formz.validate([
          Title.dirty(value),
          Price.dirty(state.price.value),
          Slug.dirty(state.slug.value),
          Stock.dirty(state.inStock.value),
        ]));
  }

  onPriceChanged(double value) {
    state = state.copyWith(
        price: Price.dirty(value),
        isValid: Formz.validate([
          Title.dirty(state.title.value),
          Price.dirty(value),
          Slug.dirty(state.slug.value),
          Stock.dirty(state.inStock.value),
        ]));
  }

  onSlugChanged(String value) {
    state = state.copyWith(
        slug: Slug.dirty(value),
        isValid: Formz.validate([
          Title.dirty(state.title.value),
          Price.dirty(state.price.value),
          Slug.dirty(value),
          Stock.dirty(state.inStock.value),
        ]));
  }

  onStockChanged(int value) {
    state = state.copyWith(
        inStock: Stock.dirty(value),
        isValid: Formz.validate([
          Title.dirty(state.title.value),
          Price.dirty(state.price.value),
          Slug.dirty(state.slug.value),
          Stock.dirty(value),
        ]));
  }

  void onSizeChanged(List<String> sizes) {
    state = state.copyWith(sizes: sizes);
  }

  void onGenderChanged(String gender) {
    state = state.copyWith(gender: gender);
  }

  void onDescriptionChanged(String description) {
    state = state.copyWith(description: description);
  }

  void onTagsChanged(String tags) {
    state = state.copyWith(tags: tags);
  }
}

class ProductFormState {
  final bool isValid;
  final String? id;
  final Title title;
  final Price price;
  final Slug slug;
  final List<String> sizes;
  final String gender;
  final Stock inStock;
  final String description;
  final String tags;
  final List<String> images;

  ProductFormState(
      {this.isValid = false,
      this.id,
      this.title = const Title.dirty(''),
      this.price = const Price.dirty(0.0),
      this.slug = const Slug.dirty(''),
      this.sizes = const [],
      this.gender = 'men',
      this.inStock = const Stock.dirty(0),
      this.description = '',
      this.tags = '',
      this.images = const []});

  ProductFormState copyWith({
    bool? isValid,
    String? id,
    Title? title,
    Price? price,
    Slug? slug,
    List<String>? sizes,
    String? gender,
    Stock? inStock,
    String? description,
    String? tags,
    List<String>? images,
  }) =>
      ProductFormState(
          isValid: isValid ?? this.isValid,
          id: id ?? this.id,
          title: title ?? this.title,
          price: price ?? this.price,
          slug: slug ?? this.slug,
          sizes: sizes ?? this.sizes,
          gender: gender ?? this.gender,
          inStock: inStock ?? this.inStock,
          description: description ?? this.description,
          tags: tags ?? this.tags,
          images: images ?? this.images);
}
