import 'package:flutter/cupertino.dart';

class StatusText extends StatelessWidget {
  StatusText({
    Key? key,
    this.enabled = false
  }) : super(key: key);

  bool enabled;
  Color green = const Color.fromARGB(255, 0, 255, 0);
  Color red = const Color.fromARGB(255, 255, 0, 0);

  @override
  Widget build(BuildContext context) {
    return Text(
      enabled ? "enabled" : "disabled",
      style: TextStyle(color: enabled ? green : red),
    );
  }
}
