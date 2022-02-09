import 'package:flutter/material.dart';

class EmptyCard extends StatelessWidget {
  final String message;

  const EmptyCard({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(
        vertical: 32.0,
        horizontal: 24.0,
      ),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: theme.dividerColor,
        ),
      ),
      elevation: 0.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              Icons.sentiment_dissatisfied,
              color: theme.disabledColor,
              size: 60.0,
            ),
            const SizedBox(height: 16.0),
            Text(
              'Product not found',
              style: theme.textTheme.headline5,
              textAlign: TextAlign.center,
            ),
            Text(
              message,
              style: theme.textTheme.caption,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
