import 'dart:math';

import 'package:dice/layout_utils/show_message.dart';
import 'package:dice/models/message_type-enum.dart';
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
  bool _isCheatModelEnabled = false;
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
        actions: [
          Switch(value: _isCheatModelEnabled, onChanged: _enableCheatMode)
        ],
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
      showMessage(
          'You can only enter numbers', MessageTypeEnum.success, context);
    } else if (parsedGuess < 2 || parsedGuess > 12) {
      showMessage('Your guess must be less than 12 and bigger than 2',
          MessageTypeEnum.error, context);
    } else {
      _isCheatModelEnabled
          ? _roleWithCheatMode(parsedGuess)
          : _roleDice(parsedGuess);
    }

    setState(() {
      _hasInputValue = false;
    });

    _focusNode.requestFocus();
  }

  void _roleDice(int userGuess) {
    _onDiceTab();
    if (userGuess == _firstDice + _secondDice) {
      showMessage('Good Guess!', MessageTypeEnum.success, context);
    } else {
      showMessage('Wrong guess, Try again!', MessageTypeEnum.error, context);
    }
  }

  void _roleWithCheatMode(int userGuess) {
    var randomSeed = 0;
    if (userGuess == 2) {
      randomSeed = 1;
    } else if (userGuess <= 6) {
      randomSeed = userGuess;
    } else {
      randomSeed = userGuess ~/ 2;
    }

    var firstValue = Random().nextInt(randomSeed) + 1;
    var secondValue = userGuess - firstValue;
    bool isPairFound = firstValue <= 6 && secondValue <= 6;

    while (!isPairFound) {
      if (secondValue > 6) {
        firstValue = Random().nextInt(randomSeed) + 1;
        secondValue = userGuess - firstValue;
      }
      var newPairSum = secondValue + firstValue;
      isPairFound =
          firstValue <= 6 && secondValue <= 6 && newPairSum == userGuess;
    }

    setState(() {
      _firstDice = firstValue;
      _secondDice = secondValue;
    });
  }

  void _enableCheatMode(value) {
    setState(() {
      _isCheatModelEnabled = value;
    });
  }
}
