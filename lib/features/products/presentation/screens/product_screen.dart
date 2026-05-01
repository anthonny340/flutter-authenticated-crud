import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/products/presentation/providers/product_provider.dart';

class ProductScreen extends ConsumerStatefulWidget {
  final String productId;
  const ProductScreen({super.key, required this.productId});

  @override
  ConsumerState<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends ConsumerState<ProductScreen> {
  @override
  void initState() {
    super.initState();

    ref.read(productProvider(widget.productId).notifier).loadProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar producto'),
      ),
      body: Center(child: Text(widget.productId)),
    );
  }
}
