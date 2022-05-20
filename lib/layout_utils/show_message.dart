import 'package:dice/models/message_type-enum.dart';
import 'package:flutter/material.dart';

void showMessage(String text, MessageTypeEnum type, BuildContext context) {
  final Color messageColor;
  switch (type) {
    case MessageTypeEnum.info:
      messageColor = Theme.of(context).hintColor;
      break;
    case MessageTypeEnum.success:
      messageColor = Theme.of(context).primaryColor;
      break;
    case MessageTypeEnum.error:
      messageColor = Theme.of(context).errorColor;
      break;
    default:
      messageColor = Theme.of(context).hintColor;
      break;
  }

  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
      duration: const Duration(seconds: 3),
      backgroundColor: messageColor));
}
