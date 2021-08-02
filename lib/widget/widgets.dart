import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  const InputField({
    @required this.controller,
    @required this.labelText,
    this.isPasswordField = false,
    this.width = 100.0,
  });

  final TextEditingController controller;
  final String labelText;
  final bool isPasswordField;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        child: TextField(
          obscureText: isPasswordField,
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: labelText,
          ),
        )
    );
  }
}

class CustomButton extends StatelessWidget {
  const CustomButton ({
    @required this.text,
    @required this.onPressed,
    this.width = 100.0,
    this.backgroundColor = Colors.black,
    this.textColor = Colors.white,
    this.textSize = 30.0,
  });

  final String text;
  final Function onPressed;
  final double width;
  final Color backgroundColor;
  final Color textColor;
  final double textSize;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      width: width,
      child: OutlinedButton(
        onPressed: onPressed,
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: textSize,
            ),
          ),
        ),
      ),
    );
  }
}

class IconText extends StatelessWidget {
  const IconText({this.icon, this.text, this.color = Colors.white60});
  final IconData icon;
  final String text;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(icon, color: color,),
        SizedBox(width: 5.0,),
        Text(text, style: TextStyle(color: color)),
      ],
    );
  }
}
