# SMS/Email Verification API Documentation

## Overview
This document describes the SMS/Email verification API endpoints implemented for the Shongkot Emergency Responder application.

## Base URL
```
Development: http://localhost:5000/api
Production: https://your-api-url.com/api
```

## Endpoints

### 1. Send Verification Code

Sends a verification code to the specified email or phone number.

**Endpoint:** `POST /auth/send-code`

**Request Body:**
```json
{
  "identifier": "user@example.com",
  "type": "Email"
}
```

**Request Parameters:**
- `identifier` (string, required): The email address or phone number to send the verification code to
- `type` (string, required): Either "Email" or "Phone"

**Success Response (200 OK):**
```json
{
  "success": true,
  "message": "Verification code sent to user@example.com",
  "expiresAt": "2025-11-16T04:33:00Z"
}
```

**Error Response (429 Too Many Requests):**
```json
{
  "message": "Please wait before requesting a new code"
}
```

**Rate Limiting:**
- Maximum 1 request per 60 seconds per identifier
- Code expires after 5 minutes

---

### 2. Verify Code

Verifies a code for the given email or phone number.

**Endpoint:** `POST /auth/verify`

**Request Body:**
```json
{
  "identifier": "user@example.com",
  "code": "123456"
}
```

**Request Parameters:**
- `identifier` (string, required): The email address or phone number that received the code
- `code` (string, required): The 6-digit verification code

**Success Response (200 OK):**
```json
{
  "success": true,
  "message": "Verification successful"
}
```

**Error Response (400 Bad Request):**
```json
{
  "success": false,
  "message": "Invalid or expired verification code"
}
```

**Validation:**
- Code must be exactly 6 digits
- Code must not be expired (5 minutes from generation)
- Code must not have been used previously

---

### 3. Resend Verification Code

Resends a verification code to the specified email or phone number.

**Endpoint:** `POST /auth/resend-code`

**Request Body:**
```json
{
  "identifier": "user@example.com",
  "type": "Email"
}
```

**Request Parameters:**
- `identifier` (string, required): The email address or phone number to resend the verification code to
- `type` (string, required): Either "Email" or "Phone"

**Success Response (200 OK):**
```json
{
  "success": true,
  "message": "Verification code sent to user@example.com",
  "expiresAt": "2025-11-16T04:38:00Z"
}
```

**Error Response (429 Too Many Requests):**
```json
{
  "message": "Please wait before requesting a new code"
}
```

**Rate Limiting:**
- Same as Send Verification Code
- Previous codes become invalid when a new code is generated

---

## Security Considerations

1. **Rate Limiting**: Implemented at 60-second intervals to prevent abuse
2. **Code Expiration**: Codes expire after 5 minutes
3. **Single Use**: Codes can only be used once
4. **Mock Implementation**: Current implementation uses mock service for development
   - In production, integrate with actual SMS gateway (Twilio, AWS SNS) or email service (SendGrid, AWS SES)

## Error Codes

| Status Code | Description |
|-------------|-------------|
| 200 | Success |
| 400 | Bad Request (invalid code, missing parameters) |
| 429 | Too Many Requests (rate limit exceeded) |
| 500 | Internal Server Error |

## Example Usage

### JavaScript/TypeScript
```typescript
// Send verification code
const sendCodeResponse = await fetch('http://localhost:5000/api/auth/send-code', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
  },
  body: JSON.stringify({
    identifier: 'user@example.com',
    type: 'Email',
  }),
});

const sendCodeData = await sendCodeResponse.json();
console.log(sendCodeData);

// Verify code
const verifyResponse = await fetch('http://localhost:5000/api/auth/verify', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
  },
  body: JSON.stringify({
    identifier: 'user@example.com',
    code: '123456',
  }),
});

const verifyData = await verifyResponse.json();
console.log(verifyData);
```

### Flutter/Dart
```dart
import 'package:http/http.dart' as http;
import 'dart:convert';

// Send verification code
final sendCodeResponse = await http.post(
  Uri.parse('http://localhost:5000/api/auth/send-code'),
  headers: {'Content-Type': 'application/json'},
  body: jsonEncode({
    'identifier': 'user@example.com',
    'type': 'Email',
  }),
);

final sendCodeData = jsonDecode(sendCodeResponse.body);
print(sendCodeData);

// Verify code
final verifyResponse = await http.post(
  Uri.parse('http://localhost:5000/api/auth/verify'),
  headers: {'Content-Type': 'application/json'},
  body: jsonEncode({
    'identifier': 'user@example.com',
    'code': '123456',
  }),
);

final verifyData = jsonDecode(verifyResponse.body);
print(verifyData);
```

## Testing

### Mock Service
The current implementation uses a mock verification service that:
- Generates random 6-digit codes
- Logs codes to console for testing
- Implements in-memory storage
- Enforces rate limiting and expiration

### Example Test Code
In development, verification codes are printed to the console:
```
[MOCK] Verification code for user@example.com: 123456
```

## Future Enhancements

1. **SMS Gateway Integration**
   - Twilio
   - AWS SNS
   - Other SMS providers

2. **Email Service Integration**
   - SendGrid
   - AWS SES
   - SMTP

3. **Database Persistence**
   - Store verification attempts
   - Track usage patterns
   - Audit logs

4. **Advanced Security**
   - IP-based rate limiting
   - Suspicious activity detection
   - Multi-factor authentication

## Support
For issues or questions, please contact the development team.
