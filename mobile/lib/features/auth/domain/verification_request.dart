enum VerificationType {
  email,
  phone,
}

class VerificationRequest {
  final String identifier;
  final VerificationType type;

  VerificationRequest({
    required this.identifier,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      'identifier': identifier,
      'type': type == VerificationType.email ? 'Email' : 'Phone',
    };
  }
}
