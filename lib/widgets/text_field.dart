import 'package:look_app/services/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldWidget extends StatelessWidget {
  TextFieldWidget({
    this.hint,
    this.icon,
    this.type,
    this.controller,
    this.onTap,
    this.formatter,
    this.maxLength,
    this.maxLines,
  });

  final String? hint;
  final IconData? icon;
  final TextInputType? type;
  final TextEditingController? controller;
  final Function()? onTap;
  final List<TextInputFormatter>? formatter;
  final int? maxLength;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      padding: EdgeInsets.only(left: icon != null ? 0 : 15, right: 15),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: Constants.radius,
      ),
      child: TextField(
        onTap: onTap,
        maxLength: maxLength,
        maxLines: maxLines,
        controller: controller,
        inputFormatters: formatter,
        textCapitalization: TextCapitalization.sentences,
        keyboardAppearance: Brightness.light,
        keyboardType: type,
        maxLengthEnforcement: MaxLengthEnforcement.none,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.only(top: 14.0),
          counterStyle: TextStyle(
            height: double.minPositive,
          ),
          counterText: "",
          prefixIcon: icon != null
              ? Icon(
                  icon!,
                  color: Colors.blueGrey[800],
                )
              : null,
        ),
      ),
    );
  }
}
