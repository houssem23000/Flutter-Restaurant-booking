import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///
/// Created by Sunil Kumar on 29-04-2020 10:10 AM.
///
class Loader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}

class ErrorText extends StatelessWidget {
  final String message;
  const ErrorText(this.message);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(message ?? 'Error',
          style: Theme.of(context).textTheme.headline6),
    );
  }
}
