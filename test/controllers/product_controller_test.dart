import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:Xkart/view/search_screens/search_controller/search_product_controller.dart';
import 'package:Xkart/services/api_services.dart';
import 'package:Xkart/models/product_models/product_model.dart';
import 'package:dio/dio.dart' as dio;

// Generate mock classes
@GenerateMocks([ApiServices])
import 'product_controller_test.mocks.dart';

void main() {
  late ProductController productController;
  late MockApiServices mockApiServices;

  // Sample product data for testing
  final sampleProductData = {
    'success': true,
    'count': 2,
    'products': [
      {
        '_id': '1',
        'name': 'iPhone 14',
        'shortDescription': 'Latest Apple smartphone',
        'longDescription':
            'The iPhone 14 features advanced camera system and A15 Bionic chip',
        'category': 'Electronics',
        'price': 999,
        'stock': 10,
        'tags': ['smartphone', 'apple'],
        'image': 'image1.jpg',
        'additionalImages': [],
        'isSafeFor': [],
        'certifications': [],
        'createdAt': '2023-01-01T00:00:00.000Z',
        'updatedAt': '2023-01-01T00:00:00.000Z',
        '__v': 0,
      },
      {
        '_id': '2',
        'name': 'Samsung Galaxy',
        'shortDescription': 'Android flagship phone',
        'longDescription':
            'Samsung Galaxy with high-resolution display and long battery life',
        'category': 'Electronics',
        'price': 799,
        'stock': 5,
        'tags': ['smartphone', 'samsung'],
        'image': 'image2.jpg',
        'additionalImages': [],
        'isSafeFor': [],
        'certifications': [],
        'createdAt': '2023-01-01T00:00:00.000Z',
        'updatedAt': '2023-01-01T00:00:00.000Z',
        '__v': 0,
      },
    ],
  };

  setUp(() {
    // Initialize GetX for testing
    Get.testMode = true;

    mockApiServices = MockApiServices();
    productController = ProductController();

    // Replace the ApiServices instance with our mock
    productController.apiServices = mockApiServices;
  });

  tearDown(() {
    Get.reset();
  });

  group('ProductController Search Tests', () {
    test('Valid search query returns products', () async {
      // Arrange
      final response = dio.Response(
        data: sampleProductData,
        statusCode: 200,
        requestOptions: dio.RequestOptions(path: ''),
      );

      when(
        mockApiServices.getRequest(
          authToken: false,
          url: 'https://moments-wrap-backend.vercel.app/product/getAllProducts',
          queryParameters: {'search': 'iPhone'},
        ),
      ).thenAnswer((_) async => response);

      // Act
      await productController.fetchProducts('iPhone', null, null, null, null);

      // Assert
      expect(productController.isLoading.value, false);
      expect(productController.products.value, isNotNull);
      expect(productController.products.value!.success, true);
      expect(productController.products.value!.count, 2);
      expect(productController.products.value!.products!.length, 2);
      expect(productController.categories.length, 1);
      expect(productController.categories.contains('Electronics'), true);
    });

    test('Category filter works correctly', () async {
      // Arrange
      final response = dio.Response(
        data: sampleProductData,
        statusCode: 200,
        requestOptions: dio.RequestOptions(path: ''),
      );

      when(
        mockApiServices.getRequest(
          authToken: false,
          url: 'https://moments-wrap-backend.vercel.app/product/getAllProducts',
          queryParameters: {'category': 'Electronics'},
        ),
      ).thenAnswer((_) async => response);

      // Act
      await productController.fetchProducts(
        null,
        'Electronics',
        null,
        null,
        null,
      );

      // Assert
      expect(productController.isLoading.value, false);
      expect(productController.products.value, isNotNull);
      expect(
        productController.products.value!.products!.every(
          (product) => product.category == 'Electronics',
        ),
        true,
      );

      verify(
        mockApiServices.getRequest(
          authToken: false,
          url: 'https://moments-wrap-backend.vercel.app/product/getAllProducts',
          queryParameters: {'category': 'Electronics'},
        ),
      ).called(1);
    });

    test('Price range filter works', () async {
      // Arrange
      final response = dio.Response(
        data: sampleProductData,
        statusCode: 200,
        requestOptions: dio.RequestOptions(path: ''),
      );

      when(
        mockApiServices.getRequest(
          authToken: false,
          url: 'https://moments-wrap-backend.vercel.app/product/getAllProducts',
          queryParameters: {
            'price': {'min': 500.0, 'max': 1000.0},
          },
        ),
      ).thenAnswer((_) async => response);

      // Act
      await productController.fetchProducts(null, null, 500.0, 1000.0, null);

      // Assert
      expect(productController.isLoading.value, false);
      expect(productController.products.value, isNotNull);

      verify(
        mockApiServices.getRequest(
          authToken: false,
          url: 'https://moments-wrap-backend.vercel.app/product/getAllProducts',
          queryParameters: {
            'price': {'min': 500.0, 'max': 1000.0},
          },
        ),
      ).called(1);
    });

    test('Empty search returns all products', () async {
      // Arrange
      final response = dio.Response(
        data: sampleProductData,
        statusCode: 200,
        requestOptions: dio.RequestOptions(path: ''),
      );

      when(
        mockApiServices.getRequest(
          authToken: false,
          url: 'https://moments-wrap-backend.vercel.app/product/getAllProducts',
          queryParameters: {},
        ),
      ).thenAnswer((_) async => response);

      // Act
      await productController.fetchProducts('', null, null, null, null);

      // Assert
      expect(productController.isLoading.value, false);
      expect(productController.products.value, isNotNull);
      expect(productController.products.value!.products!.length, 2);

      verify(
        mockApiServices.getRequest(
          authToken: false,
          url: 'https://moments-wrap-backend.vercel.app/product/getAllProducts',
          queryParameters: {},
        ),
      ).called(1);
    });

    test('Invalid price range handled', () async {
      // Arrange
      final response = dio.Response(
        data: sampleProductData,
        statusCode: 200,
        requestOptions: dio.RequestOptions(path: ''),
      );

      when(
        mockApiServices.getRequest(
          authToken: false,
          url: 'https://moments-wrap-backend.vercel.app/product/getAllProducts',
          queryParameters: {
            'price': {'min': 1000.0, 'max': 500.0},
          },
        ),
      ).thenAnswer((_) async => response);

      // Act - Test with min price higher than max price
      await productController.fetchProducts(null, null, 1000.0, 500.0, null);

      // Assert
      expect(productController.isLoading.value, false);
      expect(productController.products.value, isNotNull);

      verify(
        mockApiServices.getRequest(
          authToken: false,
          url: 'https://moments-wrap-backend.vercel.app/product/getAllProducts',
          queryParameters: {
            'price': {'min': 1000.0, 'max': 500.0},
          },
        ),
      ).called(1);
    });

    test('Network error during search', () async {
      // Arrange
      when(
        mockApiServices.getRequest(
          authToken: false,
          url: 'https://moments-wrap-backend.vercel.app/product/getAllProducts',
          queryParameters: {'search': 'iPhone'},
        ),
      ).thenThrow(
        dio.DioException(
          requestOptions: dio.RequestOptions(path: ''),
          error: 'Network Error',
        ),
      );

      // Act
      await productController.fetchProducts('iPhone', null, null, null, null);

      // Assert
      expect(productController.isLoading.value, false);
      expect(productController.products.value, isNull);

      verify(
        mockApiServices.getRequest(
          authToken: false,
          url: 'https://moments-wrap-backend.vercel.app/product/getAllProducts',
          queryParameters: {'search': 'iPhone'},
        ),
      ).called(1);
    });

    test('API returns 404 status', () async {
      // Arrange
      final response = dio.Response(
        data: null,
        statusCode: 404,
        requestOptions: dio.RequestOptions(path: ''),
      );

      when(
        mockApiServices.getRequest(
          authToken: false,
          url: 'https://moments-wrap-backend.vercel.app/product/getAllProducts',
          queryParameters: {'search': 'NonExistentProduct'},
        ),
      ).thenAnswer((_) async => response);

      // Act
      await productController.fetchProducts(
        'NonExistentProduct',
        null,
        null,
        null,
        null,
      );

      // Assert
      expect(productController.isLoading.value, false);
      expect(productController.products.value, isNull);

      verify(
        mockApiServices.getRequest(
          authToken: false,
          url: 'https://moments-wrap-backend.vercel.app/product/getAllProducts',
          queryParameters: {'search': 'NonExistentProduct'},
        ),
      ).called(1);
    });

    test('Combined filters work together', () async {
      // Arrange
      final response = dio.Response(
        data: sampleProductData,
        statusCode: 200,
        requestOptions: dio.RequestOptions(path: ''),
      );

      when(
        mockApiServices.getRequest(
          authToken: false,
          url: 'https://moments-wrap-backend.vercel.app/product/getAllProducts',
          queryParameters: {
            'search': 'iPhone',
            'category': 'Electronics',
            'price': {'min': 500.0, 'max': 1500.0},
            'tags': ['smartphone', 'premium'],
          },
        ),
      ).thenAnswer((_) async => response);

      // Act
      await productController.fetchProducts(
        'iPhone',
        'Electronics',
        500.0,
        1500.0,
        ['smartphone', 'premium'],
      );

      // Assert
      expect(productController.isLoading.value, false);
      expect(productController.products.value, isNotNull);
      expect(productController.products.value!.success, true);

      verify(
        mockApiServices.getRequest(
          authToken: false,
          url: 'https://moments-wrap-backend.vercel.app/product/getAllProducts',
          queryParameters: {
            'search': 'iPhone',
            'category': 'Electronics',
            'price': {'min': 500.0, 'max': 1500.0},
            'tags': ['smartphone', 'premium'],
          },
        ),
      ).called(1);
    });

    test('Loading state is managed correctly', () async {
      // Arrange
      final response = dio.Response(
        data: sampleProductData,
        statusCode: 200,
        requestOptions: dio.RequestOptions(path: ''),
      );

      when(
        mockApiServices.getRequest(
          authToken: false,
          url: 'https://moments-wrap-backend.vercel.app/product/getAllProducts',
          queryParameters: {'search': 'iPhone'},
        ),
      ).thenAnswer((_) async {
        // Simulate network delay
        await Future.delayed(Duration(milliseconds: 100));
        return response;
      });

      // Act
      expect(productController.isLoading.value, false);

      final future = productController.fetchProducts(
        'iPhone',
        null,
        null,
        null,
        null,
      );

      // Assert loading state during API call
      expect(productController.isLoading.value, true);

      await future;

      // Assert loading state after API call
      expect(productController.isLoading.value, false);
    });

    test('Product price getter returns correct value', () async {
      // Arrange
      final response = dio.Response(
        data: sampleProductData,
        statusCode: 200,
        requestOptions: dio.RequestOptions(path: ''),
      );

      when(
        mockApiServices.getRequest(
          authToken: false,
          url: 'https://moments-wrap-backend.vercel.app/product/getAllProducts',
          queryParameters: {},
        ),
      ).thenAnswer((_) async => response);

      // Act
      await productController.fetchProducts(null, null, null, null, null);

      // Assert
      expect(productController.productPrice, '999');
    });

    test('Product price getter returns default when no products', () {
      // Assert
      expect(productController.productPrice, '0');
    });
  });
}
