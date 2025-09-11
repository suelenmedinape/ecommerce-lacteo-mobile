// /lib/services/api_response.dart (exemplo de caminho)

class ApiResponse<T> {
  T? data; // Os dados em caso de sucesso (ex: uma lista de produtos)
  String? successMessage; // A mensagem de sucesso do backend
  String? errorMessage; // A mensagem de erro do backend

  ApiResponse({this.data, this.successMessage, this.errorMessage});

  bool get hasError => errorMessage != null;
}