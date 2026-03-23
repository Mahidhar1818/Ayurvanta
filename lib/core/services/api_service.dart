import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiResponse {
  final Map<String, dynamic> data;
  ApiResponse(this.data);
}

class ApiService {
  final String baseUrl = 'https://ayurvanta.example.com/api';

  Future<ApiResponse> get(String path) async {
    // For now, implementing mock responses to allow UI to be built
    if (path.contains('/exercises/\$')) {
      return ApiResponse({'success': true, 'data': {}});
    }
    return ApiResponse({'success': true, 'data': []});
  }

  Future<ApiResponse> post(String path, {required Map<String, dynamic> data}) async {
    // Simulated successful POST response with mock object
    return ApiResponse({'success': true, 'data': data});
  }

  Future<ApiResponse> put(String path, {required Map<String, dynamic> data}) async {
    // Simulated successful PUT response with mock object
    return ApiResponse({'success': true, 'data': data});
  }
}
