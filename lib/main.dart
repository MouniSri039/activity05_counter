import 'package:flutter/material.dart';

void main() => runApp(const CounterApp());

class CounterApp extends StatelessWidget {
  const CounterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CounterPage(),
    );
  }
}

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int _counter = 40;
  int _increment = 7;
  final List<int> _history = [];

  final TextEditingController _incrementController =
      TextEditingController(text: '7');

  @override
  void dispose() {
    _incrementController.dispose();
    super.dispose();
  }

  bool _isValidValue(int value) {
    return value >= 10 && value <= 150;
  }

  Color _counterColor() {
    if (_counter == 10) return Colors.red;
    if (_counter > 90) return Colors.green;
    return Colors.black;
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _moveTo(int nextValue) {
    if (!_isValidValue(nextValue)) {
      _showMessage(
        'Counter must stay between 10 and 150.',
      );
      return;
    }

    // Only record history when the counter actually changes.
    if (nextValue == _counter) {
      return;
    }

    setState(() {
      _history.add(_counter);
      _counter = nextValue;
    });
  }

  void _readIncrement(String input) {
    final value = int.tryParse(input);

    if (value == null || value <= 0) {
      _showMessage(
        'Enter a positive whole number, such as 1, 5, or 10.',
      );
      return;
    }

    setState(() {
      _increment = value;
    });
  }

  void _undo() {
    if (_history.isEmpty) {
      _showMessage(
        'There is no earlier value to restore.',
      );
      return;
    }

    setState(() {
      _counter = _history.removeLast();
    });
  }

  void _reset() {
    if (_counter == 10) {
      _showMessage('Counter is already at 10.');
      return;
    }

    _moveTo(10);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity 05 Counter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '$_counter',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: _counterColor(),
                    fontWeight: FontWeight.bold,
                  ),
            ),

            Slider(
              value: _counter.toDouble(),
              min: 10,
              max: 150,
              divisions: 140,
              onChanged: (value) {
                _moveTo(value.round());
              },
            ),

            TextField(
              controller: _incrementController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
                signed: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Increment amount',
                helperText: 'Enter a positive whole number',
              ),
              onChanged: _readIncrement,
            ),

            const SizedBox(height: 16),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _moveTo(_counter - _increment);
                  },
                  child: const Text('Decrease'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _moveTo(_counter + _increment);
                  },
                  child: const Text('Increase'),
                ),
                OutlinedButton(
                  onPressed: _reset,
                  child: const Text('Reset to 10'),
                ),
                OutlinedButton(
                  onPressed: _undo,
                  child: const Text('Undo'),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Text(
              _history.isEmpty
                  ? 'History: none'
                  : 'History: ${_history.join(', ')}',
            ),
          ],
        ),
      ),
    );
  }
}