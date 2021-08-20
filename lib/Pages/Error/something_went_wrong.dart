import 'package:flutter/widgets.dart';

class SomethingWentWrong extends StatelessWidget {
  const SomethingWentWrong({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Something went wrong, please restart the app or update.'),
    );
  }
}
