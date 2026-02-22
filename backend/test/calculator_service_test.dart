import 'package:my_app_backend/calculator_service.dart';
import 'package:test/test.dart';

void main() {
  group('CalculatorService', () {
    final service = CalculatorService();

    test('adds numbers', () {
      final result = service.calculate(num1: 2, num2: 3, operation: '+');
      expect(result, 5);
    });

    test('subtracts numbers', () {
      final result = service.calculate(num1: 7, num2: 4, operation: '-');
      expect(result, 3);
    });

    test('multiplies numbers', () {
      final result = service.calculate(num1: 5, num2: 2, operation: '*');
      expect(result, 10);
    });

    test('divides numbers', () {
      final result = service.calculate(num1: 10, num2: 2, operation: '/');
      expect(result, 5);
    });

    test('throws for divide by zero', () {
      expect(
        () => service.calculate(num1: 10, num2: 0, operation: '/'),
        throwsArgumentError,
      );
    });

    test('throws for unsupported operation', () {
      expect(
        () => service.calculate(num1: 1, num2: 1, operation: '%'),
        throwsArgumentError,
      );
    });
  });
}
