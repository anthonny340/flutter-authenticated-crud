import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/presentation/providers/products_repository_provider.dart';

// State Notifier PROVIDER
final productsProvider = NotifierProvider<ProductsNotifier, ProductsState>(
  ProductsNotifier.new,
);

// State NOTIFIER Provider
class ProductsNotifier extends Notifier<ProductsState> {
  ProductsRepository get productsRepository =>
      ref.read(productsRepositoryProvider);

  @override
  ProductsState build() {
    Future.microtask(loadNextPage);
    return ProductsState();
  }

  Future<bool> createUpdateProduct(Map<String, dynamic> productLike) async {
    try {
      final Product product =
          await productsRepository.createUpdateProduct(productLike);

      //Si es un producto nuevo (el usuario crea uno) no puede estar en la lista por ende regresa false
      final isProductInList = state.products.any(
        (element) => (element.id == product.id),
      );

      if (!isProductInList) {
        state = state.copyWith(products: [
          ...state.products,
          product
        ]); //Agregamos el producto nuevo y eso redibuja el products_screen
      }

      state = state.copyWith(
          products: state.products
              .map((element) => (element.id == product.id) ? product : element)
              .toList());

      return true;
    } catch (e) {
      return false;
    }
  }

  Future loadNextPage() async {
    if (state.isLoading || state.isLastPage) return;

    state = state.copyWith(isLoading: true);

    final products = await productsRepository.getProductsByPage(
        limit: state.limit, offset: state.offset);

    if (products.isEmpty) {
      state = state.copyWith(
        isLoading: false,
        isLastPage: true,
      );
      return;
    }

    state = state.copyWith(
      isLoading: false,
      isLastPage: false,
      offset: state.offset + state.limit,
      products: [...state.products, ...products],
    );
  }
}

//STATE Notifier Provider
class ProductsState {
  final bool isLastPage;
  final int limit;
  final int offset;
  final bool isLoading;
  final List<Product> products;

  ProductsState({
    this.isLastPage = false,
    this.limit = 10,
    this.offset = 0,
    this.isLoading = false,
    this.products = const [],
  });

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
