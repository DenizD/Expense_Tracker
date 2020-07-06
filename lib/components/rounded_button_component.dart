import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final IconData iconData;
  final Function onPressed;

  RoundedButton({this.iconData, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      height: 50,
      minWidth: 50,
      child: FlatButton(
        color: Colors.green,
        onPressed: onPressed,
        child: Icon(
          iconData,
          color: Colors.white,
        ),
        shape: CircleBorder(
          side: BorderSide(
            color: Colors.green,
            width: 1,
            style: BorderStyle.solid,
          ),
        ),
      ),
    );
  }
}
