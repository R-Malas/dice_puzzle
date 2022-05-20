import 'dart:math';

import 'package:dice/widgets/dice.dart';
import 'package:flutter/material.dart';

class DiceScreen extends StatefulWidget {
  const DiceScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DiceScreenState();
}

class _DiceScreenState extends State<DiceScreen> {
  // dice properties
  int _firstDice = 1;
  int _secondDice = 1;

  // input field properties
  bool _hasInputValue = false;
  final _focusNode = FocusNode();
  final TextEditingController _txtCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: const Text('Dice'),
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).backgroundColor,
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Dice
            Row(
              children: [
                Dice(imageIndex: _firstDice),
                const SizedBox(width: 16),
                Dice(imageIndex: _secondDice)
              ],
            ),
            const SizedBox(height: 30.0),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: _buildInputField(),
            )
          ],
        ),
      ),
    ));
  }

  Widget _buildInputField() {
    return Container(
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
          color: Colors.grey[200],
          border: Border.all(color: Theme.of(context).primaryColor)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: TextField(
              controller: _txtCtrl,
              focusNode: _focusNode,
              decoration: InputDecoration(
                  labelText: 'Enter a number',
                  labelStyle: const TextStyle(color: Colors.black),
                  hintText: 'Enter your guess',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  border: InputBorder.none),
              keyboardType: TextInputType.number,
              onSubmitted: _hasInputValue ? _submitUserGuess : null,
              onChanged: (text) {
                setState(() {
                  _hasInputValue = text.isNotEmpty;
                });
              },
            ),
          ),
          IconButton(
            onPressed:
                _hasInputValue ? () => _submitUserGuess(_txtCtrl.text) : null,
            icon: const Icon(Icons.send),
            color: Theme.of(context).primaryColor,
          )
        ],
      ),
    );
  }

  void _onDiceTab() {
    setState(() {
      _firstDice = Random().nextInt(5) + 1;
      _secondDice = Random().nextInt(5) + 1;
    });
  }

  void _submitUserGuess(String guess) {
    _txtCtrl.clear();
    final parsedGuess = int.tryParse(guess);
    if (parsedGuess == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('You can only enter numbers'),
        backgroundColor: Theme.of(context).hintColor,
      ));
    } else if (parsedGuess < 2 || parsedGuess > 12) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              const Text('Your guess must be less than 12 and bigger than 2'),
          backgroundColor: Theme.of(context).errorColor));
    } else {
      _onDiceTab();
      if (parsedGuess == _firstDice + _secondDice) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text('Good guess!'),
            duration: const Duration(seconds: 1000),
            backgroundColor: Theme.of(context).primaryColor));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Wrong guess, Try again!'),
          duration: const Duration(seconds: 1000),
          backgroundColor: Theme.of(context).errorColor,
        ));
      }
    }

    setState(() {
      _hasInputValue = false;
    });

    _focusNode.requestFocus();
  }
}
