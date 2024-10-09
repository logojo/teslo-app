import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_app/features/products/domain/domain.dart';
import 'package:teslo_app/features/shared/infraestructure/inputs/inpust.dart';

class ProductFormNotifier extends StateNotifier<ProductFormState> {
  final void Function(Map<String, dynamic> productLike)? onSubmitCallback;

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
