import 'package:flutter/material.dart';

class FullScreenLoader extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: const <Widget>[
        Opacity(
          opacity: 0.3,
          child: ModalBarrier(dismissible: false, color: Colors.grey),
        ),
        Center(
          child: CircularProgressIndicator(),
        ),
      ],
    );
  }
}
