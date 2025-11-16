class VerificationResponse {
  final bool success;
  final String message;
  final DateTime? expiresAt;

  VerificationResponse({
    required this.success,
    required this.message,
    this.expiresAt,
  });

  factory VerificationResponse.fromJson(Map<String, dynamic> json) {
    return VerificationResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      expiresAt: json['expiresAt'] != null 
          ? DateTime.parse(json['expiresAt'] as String)
          : null,
    );
  }
}
