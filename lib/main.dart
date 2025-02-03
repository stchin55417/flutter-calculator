import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart'; // External package for expression evaluation
import 'dart:math'; // Import for sqrt function

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _expression = '';
  String _result = '';

  void _addToExpression(String value) {
    setState(() {
      _expression += value;
    });
  }

  void _calculateResult() {
    try {
      final expression = Expression.parse(_expression);
      final evaluator = const ExpressionEvaluator();
      final result = evaluator.eval(expression, {
        'sqrt': (num x) => sqrt(x),
      });
      setState(() {
        _result = result.toString();
      });
    } catch (e) {
      setState(() {
        _result = 'Error';
      });
    }
  }

  void _applySqrt() {
    try {
      if (_expression.isEmpty)
        return; // Prevent applying sqrt to an empty expression

      final expression = Expression.parse(_expression);
      final evaluator = const ExpressionEvaluator();
      final result = evaluator.eval(expression, {});

      if (result is num && result >= 0) {
        // Ensure it's a valid number for sqrt
        final sqrtResult = sqrt(result);
        setState(() {
          _expression = sqrtResult.toString();
          _result = ''; // Clear the result until next evaluation
        });
      } else {
        setState(() {
          _result = 'Error'; // Handle negative numbers or invalid inputs
        });
      }
    } catch (e) {
      setState(() {
        _result = 'Error';
      });
    }
  }

  void _clear() {
    setState(() {
      _expression = '';
      _result = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              alignment: Alignment.bottomRight,
              child: Text(
                '$_expression = $_result',
                style: const TextStyle(fontSize: 24),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildButton('7'),
                _buildButton('8'),
                _buildButton('9'),
                _buildButton('/'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildButton('4'),
                _buildButton('5'),
                _buildButton('6'),
                _buildButton('*'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildButton('1'),
                _buildButton('2'),
                _buildButton('3'),
                _buildButton('-'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildButton('0'),
                _buildButton('.'),
                _buildButton('='),
                _buildButton('+'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildButton('sqrt'), // Add open parenthesis for sqrt
                SizedBox(
                  width: 320,
                  child: TextButton(
                    onPressed: _clear,
                    child: const Text('C', style: TextStyle(fontSize: 24)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String value) {
    return Expanded(
      child: TextButton(
        onPressed: () {
          if (value == '=') {
            _calculateResult();
          } else if (value == 'sqrt') {
            _applySqrt();
          } else {
            _addToExpression(value);
          }
        },
        child: Text(
          value,
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
