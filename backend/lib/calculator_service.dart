class CalculatorService {
  double calculate({
    required double num1,
    required double num2,
    required String operation,
  }) {
    switch (operation) {
      case '+':
        return num1 + num2;
      case '-':
        return num1 - num2;
      case '*':
      case '×':
        return num1 * num2;
      case '/':
      case '÷':
        if (num2 == 0) {
          throw ArgumentError('Cannot divide by zero.');
        }
        return num1 / num2;
      default:
        throw ArgumentError('Unsupported operation: $operation');
    }
  }
}
