import 'package:flutter/material.dart';

class TextButtonStyleExtension extends StatefulWidget {
  final String buttonText;
  final double buttonRadius;

  final Color buttonColor;
  final Color? buttonHoverColor;
  final double height;
  final double? width;

  final EdgeInsets margin;
  final EdgeInsets padding;

  final TextStyle textStyle;
  final TextStyle? hoverTextStyle;

  final BoxShadow? boxShadow;

  const TextButtonStyleExtension({
    this.buttonText = "Button",
    this.buttonRadius = 0,
    required this.buttonColor,
    this.buttonHoverColor,
    this.height = 40,
    this.width,
    this.margin = const EdgeInsets.all(10),
    this.padding = const EdgeInsets.all(10),
    Key? key,
    this.textStyle = const TextStyle(),
    this.hoverTextStyle,
    this.boxShadow,
  }) : super(key: key);

  @override
  _TextButtonStyleExtensionState createState() =>
      _TextButtonStyleExtensionState();
}

class _TextButtonStyleExtensionState extends State<TextButtonStyleExtension> {
  Color? _buttonColor;
  TextStyle? _buttonTextStyle;

  _TextButtonStyleExtensionState();
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onHover: (event) => _hoverEffect(),
      onExit: (event) => _exitEffect(),
      child: Container(
        height: widget.height,
        width: widget.width,
        margin: widget.margin,
        padding: widget.padding,
        decoration: BoxDecoration(
          boxShadow: widget.boxShadow != null ? [widget.boxShadow!] : null,
          color: _buttonColor ?? widget.buttonColor, //Button Color

          borderRadius: BorderRadius.all(Radius.circular(widget.buttonRadius)),
        ),
        child: Text(widget.buttonText,
            style: _buttonTextStyle ?? widget.textStyle,
            textAlign: TextAlign.center),
        alignment: Alignment.center,
      ),
    );
  }

  void _hoverEffect() {
    setState(() {
      _buttonColor = widget.buttonHoverColor ?? widget.buttonColor;
      _buttonTextStyle = widget.hoverTextStyle ?? widget.textStyle;
    });
  }

  void _exitEffect() {
    setState(() {
      _buttonColor = widget.buttonColor;
      _buttonTextStyle = widget.textStyle;
    });
  }
}

////////////////////////////////////////////////
////////////////////////////////////////////////

class IconButtonStyleExtension extends StatefulWidget {
  final Color? iconColor;
  final Color? iconHoverColor;

  final IconData? icon;
  final IconData? hoverIcon;
  final double buttonSize;
  final double buttonRadius;
  final double iconSize;

  final double sizeIncreased;

  final Color backgroundColor;
  final BoxShadow boxShadow;
  const IconButtonStyleExtension({
    required this.iconColor,
    this.iconHoverColor,
    required this.icon,
    this.hoverIcon,
    this.iconSize = 20,
    this.sizeIncreased = 0,
    this.buttonRadius = 0,
    this.buttonSize = 30,
    this.backgroundColor = Colors.transparent,
    Key? key,
    this.boxShadow = const BoxShadow(
      color: Colors.transparent,
    ),
  }) : super(key: key);

  @override
  _IconButtonStyleExtensionState createState() =>
      _IconButtonStyleExtensionState(iconColor!, icon!);
}

class _IconButtonStyleExtensionState extends State<IconButtonStyleExtension> {
  Color _iconColor;
  IconData _iconData;

  _IconButtonStyleExtensionState(this._iconColor, this._iconData);
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
        cursor: SystemMouseCursors.click,
        onHover: (event) => _hoverEffect(),
        onExit: (event) => _exitEffect(),
        child: Container(
          height: widget.buttonSize,
          width: widget.buttonSize,
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.all(Radius.circular(widget.buttonRadius)),
            color: widget.backgroundColor,
            boxShadow: [widget.boxShadow],
          ),
          child: Icon(
            _iconData,
            color: _iconColor,
            size: widget.iconSize,
          ),
        ));
  }

  void _hoverEffect() {
    setState(() {
      _iconColor = widget.iconHoverColor != null
          ? widget.iconHoverColor!
          : widget.iconColor!;
      _iconData = widget.hoverIcon != null ? widget.hoverIcon! : widget.icon!;
    });
  }

  void _exitEffect() {
    setState(() {
      _iconColor = widget.iconColor!;
      _iconData = widget.icon!;
    });
  }
}
