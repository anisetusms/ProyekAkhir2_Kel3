import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:front/features/property/data/models/property_model.dart';

abstract class PropertyRemoteDataSource {
  Future<List<PropertyModel>> getProperties({bool? isDeleted});
  Future<PropertyModel> createProperty(FormData formData);
  Future<PropertyModel> updateProperty(int id, FormData formData);
  Future<void> deleteProperty(int id);
}

@LazySingleton(as: PropertyRemoteDataSource)
class PropertyRemoteDataSourceImpl implements PropertyRemoteDataSource {
  final Dio dio;

  PropertyRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<PropertyModel>> getProperties({bool? isDeleted}) async {
    final response = await dio.get('/properties', queryParameters: {
      'isDeleted': isDeleted,
    });
    
    return (response.data['data'] as List)
        .map((json) => PropertyModel.fromJson(json))
        .toList();
  }

  @override
  Future<PropertyModel> createProperty(FormData formData) async {
    final response = await dio.post(
      '/properties',
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );
    return PropertyModel.fromJson(response.data['data']);
  }

  @override
  Future<PropertyModel> updateProperty(int id, FormData formData) async {
    final response = await dio.put(
      '/properties/$id',
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );
    return PropertyModel.fromJson(response.data['data']);
  }

  @override
  Future<void> deleteProperty(int id) async {
    await dio.delete('/properties/$id');
  }
}