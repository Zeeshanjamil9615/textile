class ApiResponse<T> {
  final int status;
  final String message;
  final T? data;
  final String? redirect;

  ApiResponse({
    required this.status,
    required this.message,
    this.data,
    this.redirect,
  });

  // Parse from API response
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    return ApiResponse<T>(
      status: json['status'] as int? ?? 0,
      message: json['message'] as String? ?? '',
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : null,
      redirect: json['redirect'] as String?,
    );
  }

  // Check if response is successful
  bool get isSuccess => status == 200;

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data,
      'redirect': redirect,
    };
  }
}
