import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pace Converter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.transparent),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Pace Converter'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _minuteController3 = TextEditingController();
  final TextEditingController _secondController3 = TextEditingController();
  final TextEditingController _minuteController4 = TextEditingController();
  final TextEditingController _secondController4 = TextEditingController();

  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();
  final FocusNode _focusNode4 = FocusNode();
  final FocusNode _focusNode5 = FocusNode();
  final FocusNode _focusNode6 = FocusNode();

  @override
  void initState() {
    super.initState();

    _focusNode1.addListener(() {
      if (!_focusNode1.hasFocus) {
        _calculateValues('milePerHour');
      }
    });

    _focusNode2.addListener(() {
      if (!_focusNode2.hasFocus) {
        _calculateValues('kmPerHour');
      }
    });

    _focusNode3.addListener(() {
      if (!_focusNode3.hasFocus) {
        _calculateValues('minutePerKm');
      }
    });

    _focusNode4.addListener(() {
      if (!_focusNode4.hasFocus) {
        _calculateValues('minutePerKm');
      }
    });

    _focusNode5.addListener(() {
      if (!_focusNode5.hasFocus) {
        _calculateValues('minutePerMile');
      }
    });

    _focusNode6.addListener(() {
      if (!_focusNode6.hasFocus) {
        _calculateValues('minutePerMile');
      }
    });
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _minuteController3.dispose();
    _secondController3.dispose();
    _minuteController4.dispose();
    _secondController4.dispose();

    _focusNode1.dispose();
    _focusNode2.dispose();
    _focusNode3.dispose();
    _focusNode4.dispose();
    _focusNode5.dispose();
    _focusNode6.dispose();

    super.dispose();
  }

  void _calculateValues(String changedField) {
    setState(() {
      double milePerHour = double.tryParse(_controller1.text.isEmpty ? '0' : _controller1.text) ?? 0.0;
      double kmPerHour = double.tryParse(_controller2.text.isEmpty ? '0' : _controller2.text) ?? 0.0;
      double minutePerKm = (double.tryParse(_minuteController3.text.isEmpty ? '0' : _minuteController3.text) ?? 0.0) +
          (double.tryParse(_secondController3.text.isEmpty ? '0' : _secondController3.text) ?? 0.0) / 60;
      double minutePerMile = (double.tryParse(_minuteController4.text.isEmpty ? '0' : _minuteController4.text) ?? 0.0) +
          (double.tryParse(_secondController4.text.isEmpty ? '0' : _secondController4.text) ?? 0.0) / 60;

      switch (changedField) {
        case 'milePerHour':
          if (milePerHour > 0) {
            kmPerHour = milePerHour * 1.60934;
            minutePerKm = 60 / kmPerHour;
            minutePerMile = 60 / milePerHour;
          }
          break;
        case 'kmPerHour':
          if (kmPerHour > 0) {
            milePerHour = kmPerHour / 1.60934;
            minutePerKm = 60 / kmPerHour;
            minutePerMile = 60 / milePerHour;
          }
          break;
        case 'minutePerKm':
          if (minutePerKm > 0) {
            kmPerHour = 60 / minutePerKm;
            milePerHour = kmPerHour / 1.60934;
            minutePerMile = 60 / milePerHour;
          }
          break;
        case 'minutePerMile':
          if (minutePerMile > 0) {
            milePerHour = 60 / minutePerMile;
            kmPerHour = milePerHour * 1.60934;
            minutePerKm = 60 / kmPerHour;
          }
          break;
      }

      // Update the text fields with the calculated values
      if (changedField != 'milePerHour') {
        _controller1.text = milePerHour.toStringAsFixed(2);
      }
      if (changedField != 'kmPerHour') {
        _controller2.text = kmPerHour.toStringAsFixed(2);
      }
      if (changedField != 'minutePerKm') {
        int minutesKm = minutePerKm.floor();
        int secondsKm = ((minutePerKm - minutesKm) * 60).round();
        _minuteController3.text = minutesKm.toString();
        _secondController3.text = secondsKm.toString();
      }
      if (changedField != 'minutePerMile') {
        int minutesMile = minutePerMile.floor();
        int secondsMile = ((minutePerMile - minutesMile) * 60).round();
        _minuteController4.text = minutesMile.toString();
        _secondController4.text = secondsMile.toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Text(widget.title),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque, // Ensures the GestureDetector covers the entire area
        onTap: () {
          FocusScope.of(context).unfocus(); // Dismiss the keyboard
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller1,
                        focusNode: _focusNode1,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Mile / Hour',
                        ),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller2,
                        focusNode: _focusNode2,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Km / Hour',
                        ),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _minuteController3,
                        focusNode: _focusNode3,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Minutes / Km',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _secondController3,
                        focusNode: _focusNode4,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Seconds / Km',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _minuteController4,
                        focusNode: _focusNode5,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Minutes / Mile',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _secondController4,
                        focusNode: _focusNode6,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Seconds / Mile',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
