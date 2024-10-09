import 'package:flutter/material.dart';

class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.expand(
      child: Center(
        //*los widgets que tiene adaptative se adaptan al sistema operativo
        child: CircularProgressIndicator.adaptive(
          strokeWidth: 2,
        ),
      ),
    );
  }
}
