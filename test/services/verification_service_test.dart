import 'package:flutter_test/flutter_test.dart';
import 'package:sportifylife/services/verification_service.dart';

void main() {
  late VerificationService verificationService;

  setUp(() {
    verificationService = VerificationService();
  });

  group('VerificationService', () {
    group('verifyEmail', () {
      test('should return validation error when token is empty', () async {
        // Act
        final result = await verificationService.verifyEmail('');

        // Assert
        expect(result.isFailure, true);
        expect(result.errorOrNull?.isValidationError, true);
      });
    });

    group('resendVerification', () {
      test('should return validation error when email is empty', () async {
        // Act
        final result = await verificationService.resendVerification('');

        // Assert
        expect(result.isFailure, true);
        expect(result.errorOrNull?.isValidationError, true);
      });
    });

    group('expiry calculations', () {
      test('calculateExpiry should return future datetime', () {
        // Act
        final expiry = verificationService.calculateExpiry();

        // Assert
        expect(expiry.isAfter(DateTime.now()), true);
      });

      test('isExpired should return true for past datetime', () {
        // Arrange
        final pastTime = DateTime.now().subtract(const Duration(minutes: 5));

        // Act
        final result = verificationService.isExpired(pastTime);

        // Assert
        expect(result, true);
      });

      test('isExpired should return false for future datetime', () {
        // Arrange
        final futureTime = DateTime.now().add(const Duration(minutes: 5));

        // Act
        final result = verificationService.isExpired(futureTime);

        // Assert
        expect(result, false);
      });
    });
  });
}
