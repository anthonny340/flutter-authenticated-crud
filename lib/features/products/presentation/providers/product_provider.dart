import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/presentation/providers/products_repository_provider.dart';

//Provider
final productProvider = NotifierProvider.autoDispose
    .family<ProductNotifier, ProductState, String>(
        (String productId) => ProductNotifier(productId: productId));

//Notifier
class ProductNotifier extends Notifier<ProductState> {
  final String productId;

  ProductsRepository get productsRepository =>
      ref.watch(productsRepositoryProvider);

  ProductNotifier({required this.productId});

  @override
  ProductState build() {
    Future.microtask(loadProduct);
    return ProductState(id: productId);
  }

  Product newEmptyProduct() {
    final product = Product(
      id: 'new',
      title: '',
      price: 0,
      description: '',
      slug: '',
      stock: 0,
      sizes: [],
      gender: '',
      tags: [],
      images: [],
    );
    return product;
  }

  Future<void> loadProduct() async {
    try {
      //Evaluar si es un producto nuevo que va a crear
      if (productId == 'new') {
        state = state.copyWith(
          isLoading: false,
          product: newEmptyProduct(),
        );
        return;
      }
      final product = await productsRepository.getProductById(state.id);

      state = state.copyWith(
        isLoading: false,
        product: product,
      );
    } catch (e) {
      print(e);
    }
  }
}

//State
class ProductState {
  final String id;
  final Product? product;
  final bool isLoading;
  final bool isSaving;

  ProductState({
    required this.id,
    this.product,
    this.isLoading = true,
    this.isSaving = false,
  });

  ProductState copyWith({
    String? id,
    Product? product,
    bool? isLoading,
    bool? isSaving,
  }) =>
      ProductState(
        id: id ?? this.id,
        product: product ?? this.product,
        isLoading: isLoading ?? this.isLoading,
        isSaving: isSaving ?? this.isSaving,
      );
}
