import 'package:iic_app_template_flutter/COMPONENTS/button_view.dart';
import 'package:iic_app_template_flutter/COMPONENTS/text_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iic_app_template_flutter/COMPONENTS/button_view.dart';
import 'package:iic_app_template_flutter/COMPONENTS/text_view.dart';

class TextfieldView extends StatefulWidget {
  final bool isAutoCorrect;
  final bool isAutoFocus;
  final String placeholder;
  final Color placeholderColor;
  final double size;
  final Color color;
  final Color backgroundColor;
  final double paddingV;
  final double paddingH;
  final bool enabled;
  final double borderWidth;
  final Color borderColor;
  final double radius;
  final TextInputType keyboardType;
  final int max;
  final int maxLines;
  final int minLines;
  final bool multiline;
  final bool isPassword;
  final TextEditingController controller;

  const TextfieldView({
    super.key,
    this.isAutoCorrect = false,
    this.isAutoFocus = false,
    this.placeholder = "Enter text here...",
    this.placeholderColor = Colors.grey,
    this.size = 16,
    this.color = Colors.black,
    this.backgroundColor = Colors.black12,
    this.paddingV = 10,
    this.paddingH = 16,
    this.enabled = true,
    this.borderWidth = 0,
    this.borderColor = Colors.black,
    this.radius = 8,
    this.keyboardType = TextInputType.text,
    this.max = 0,
    this.maxLines = 1,
    this.minLines = 1,
    this.multiline = false,
    this.isPassword = false,
    required this.controller,
  });

  @override
  _TextfieldViewState createState() => _TextfieldViewState();
}

class _TextfieldViewState extends State<TextfieldView> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // Add listener to the FocusNode to trigger rebuild when focus changes
    _focusNode.addListener(() {
      setState(() {}); // Trigger a rebuild when focus changes
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    widget.controller.dispose();
    super.dispose();
  }

  void clearText() {
    setState(() {
      widget.controller.clear();
    });
  }

  void _dismissKeyboard() {
    _focusNode.unfocus(); // Dismisses the keyboard
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent, // Ensure Material background is transparent
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: BorderRadius.circular(widget.radius),
              border: widget.borderWidth > 0
                  ? Border.all(
                      color: widget.borderColor, width: widget.borderWidth)
                  : null,
            ),
            child: TextField(
              controller: widget.controller,
              focusNode: _focusNode,
              autocorrect: widget.isAutoCorrect,
              autofocus: widget.isAutoFocus,
              decoration: InputDecoration(
                hintText: widget.placeholder,
                hintStyle:
                    GoogleFonts.inconsolata(color: widget.placeholderColor),
                contentPadding: EdgeInsets.symmetric(
                  vertical: widget.paddingV,
                  horizontal: widget.paddingH,
                ),
                border: InputBorder.none,
              ),
              enabled: widget.enabled,
              keyboardType: widget.multiline
                  ? TextInputType.multiline
                  : widget.keyboardType,
              style: GoogleFonts.inconsolata(
                fontSize: widget.size,
                color: widget.color,
              ),
              textInputAction: widget.multiline
                  ? TextInputAction.newline
                  : TextInputAction.done,
              maxLength: widget.max > 0 ? widget.max : null,
              maxLines: widget.isPassword ? 1 : widget.maxLines,
              minLines: widget.minLines,
              obscureText: widget.isPassword,
            ),
          ),
          // Show "Done" button only if the TextField is focused
          if (_focusNode.hasFocus)
            SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ButtonView(
                    onPress: _dismissKeyboard,
                    child: TextView(
                      text: 'done',
                      color: widget.color,
                      size: 22,
                      font: 'inconsolata',
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
