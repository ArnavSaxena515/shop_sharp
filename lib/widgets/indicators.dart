import 'package:flutter/material.dart';

class ErrorIndicator extends StatelessWidget {
  const ErrorIndicator({
    Key? key,
    this.errorMessage = "Items could not be loaded",
  }) : super(key: key);
  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error,
            size: 50,
            color: Theme.of(context).colorScheme.error,
          ),
          Container(
            margin: const EdgeInsets.all(20),
            child: Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    Key? key,
    this.loadingMessage = "Fetching items, please wait",
  }) : super(key: key);
  final String loadingMessage;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            loadingMessage,
            style: const TextStyle(color: Colors.grey),
          ),
        )
      ],
    ));
  }
}
