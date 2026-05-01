import '../errors/products_errors.dart';
import '../mappers/product_mapper.dart';
import 'package:dio/dio.dart';
import 'package:teslo_shop/config/constants/environment.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';

class ProductsDatasourceImpl extends ProductsDatasource {
  late final Dio dio;
  final String accessToken;

  ProductsDatasourceImpl({required this.accessToken})
      : dio = Dio(
          BaseOptions(
            baseUrl: Environment.apiUrl,
            headers: {'Authorization': 'Bearer $accessToken'},
          ),
        );

  @override
  Future<Product> createUpdateProduct(Map<String, dynamic> productLike) {
    // TODO: implement creareUpdateProduct
    throw UnimplementedError();
  }

  @override
  Future<Product> getProductById(String id) async {
    try {
      final response = await dio.get('/products/$id');
      final Product product = ProductMapper.jsonToEntity(response.data);
      return product;
    } on DioException catch (e) {
      if (e.response!.statusCode == 404) throw ProductNotFound();
      throw NotControllerException();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<List<Product>> getProductsByPage(
      {int limit = 10, int offset = 0}) async {
    try {
      final response =
          await dio.get<List>('/products?limit=$limit&offset=$offset');
      final List<Product> products = [];

      for (var product in response.data ?? []) {
        products.add(ProductMapper.jsonToEntity(product));
      }
      return products;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError('Token no válido');
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError('Se excedio el límite de tiempo');
      }
      throw CustomError('Something wrong happend');
    } catch (e) {
      throw CustomError('Unexpected: Something wrong happend');
    }
  }

  @override
  Future<List<Product>> searchProductByTerm(String term) {
    // TODO: implement searchProductByTerm
    throw UnimplementedError();
  }
}
