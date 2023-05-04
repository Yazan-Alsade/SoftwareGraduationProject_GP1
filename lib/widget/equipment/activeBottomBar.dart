import 'package:flutter/material.dart';

class ActiveBottomBar extends StatelessWidget {
  final void Function()? onPressed;
  final String textbutton;
  final IconData icon;
  final bool active;
  ActiveBottomBar(
      {super.key,
      required this.textbutton,
      required this.icon,
      required this.onPressed,
      required this.active});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: active == true ? Colors.teal : Colors.grey[800],
          ),
          Text(
            textbutton,
            style: TextStyle(
                color: active == true ? Colors.teal : Colors.grey[800]),
          ),
        ],
      ),
    );
  }
}
