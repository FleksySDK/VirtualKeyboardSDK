import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterintegration/home/widgets/status_text.dart';

class StatusRow extends StatelessWidget {

  const StatusRow(this.text, this.onTap, this.enabled);

  final String text;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
      return InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Text(text),
              StatusText(enabled: enabled)
            ],
          ),
        ),
      );
  }
}

