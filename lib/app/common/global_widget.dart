import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';

class TextInitial extends StatelessWidget {
  final String text;
  final Color? color;
  final double? size;
  const TextInitial({required this.text, this.color, this.size, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text[0].toUpperCase(),
        style: GoogleFonts.roboto(
            color: color ?? Colors.grey,
            fontSize: size ?? 25,
            fontWeight: FontWeight.w600),
      ),
    );
  }
}

class CustomButton extends StatefulWidget {
  final Function? onTap;

  final Widget? leading;
  final Widget? onHoverLeading;

  final Widget? title;
  final Widget? onHoverTitle;
  final bool centerTitle;

  final Widget? trailing;
  final Widget? onHoverTrailing;

  final double height;
  final double width;

  final double buttonRadius;

  final Color backgroundColor;
  final BoxShadow boxShadow;

  final EdgeInsets? margin;
  final EdgeInsets? padding;

  const CustomButton({
    this.onTap,
    this.leading,
    this.onHoverLeading,
    this.title,
    this.onHoverTitle,
    this.centerTitle = false,
    this.trailing,
    this.onHoverTrailing,
    this.height = 60,
    this.width = 100,
    this.buttonRadius = 10,
    this.backgroundColor = Colors.grey,
    this.margin = const EdgeInsets.all(0),
    this.padding = const EdgeInsets.all(10),
    this.boxShadow = const BoxShadow(
      color: Colors.transparent,
    ),
    Key? key,
  }) : super(key: key);

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  Widget? leading;
  Widget? title;
  Widget? trailing;

  @override
  void initState() {
    leading = widget.leading;
    title = widget.title;
    trailing = widget.trailing;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap != null ? widget.onTap!() : null;
      },
      child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onHover: (event) => _hoverEffect(),
          onExit: (event) => _exitEffect(),
          child: Container(
              height: widget.height,
              width: widget.width,
              margin: widget.margin,
              padding: widget.padding,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.all(Radius.circular(widget.buttonRadius)),
                color: widget.backgroundColor,
                boxShadow: [widget.boxShadow],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  leading ?? Container(),
                  Expanded(
                    child: Align(
                        alignment: widget.centerTitle
                            ? Alignment.center
                            : Alignment.centerLeft,
                        child: title ?? Container()),
                  ),
                  trailing ?? Container()
                ],
              ))),
    );
  }

  void _hoverEffect() {
    setState(() {
      widget.leading != null
          ? leading = widget.onHoverLeading ?? widget.leading
          : null;
      widget.title != null ? title = widget.onHoverTitle ?? widget.title : null;
      widget.trailing != null
          ? trailing = widget.onHoverTrailing ?? widget.trailing
          : null;
    });
  }

  void _exitEffect() {
    setState(() {
      widget.leading != null ? leading = widget.leading : null;
      widget.title != null ? title = widget.title : null;
      widget.trailing != null ? trailing = widget.trailing : null;
    });
  }
}

class CustomInputField extends StatefulWidget {
  final TextEditingController? controller;
  final String hintText;
  final Widget? leading;
  final Widget? trailing;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final double? width;
  final double? height;
  final TextStyle? textStyle;
  final bool isPassword;
  final Color color;
  final Color? backgroundColor;
  final Color borderColor;
  final BorderRadius? borderRadius;
  final double borderStoke;
  final TextAlign textAlign;
  final BoxShadow? shadow;
  final TextInputType? textInputType;
  final int? maxLines;
  final Function(String value)? onChanged;
  const CustomInputField({
    Key? key,
    this.hintText = "",
    this.textStyle,
    this.isPassword = false,
    this.controller,
    this.color = Colors.blue,
    this.backgroundColor,
    this.borderColor = Colors.blue,
    this.borderRadius,
    this.borderStoke = 2,
    this.textAlign = TextAlign.left,
    this.padding = const EdgeInsets.symmetric(horizontal: 10),
    this.shadow,
    this.width,
    this.height,
    this.margin = const EdgeInsets.all(10),
    this.leading,
    this.trailing,
    this.textInputType,
    this.maxLines,
    this.onChanged,
  }) : super(key: key);

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height ?? 60,
      width: widget.width,
      padding: widget.padding,
      margin: widget.margin,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: widget.backgroundColor ?? Colors.white,
          borderRadius: widget.borderRadius ?? BorderRadius.circular(10),
          boxShadow: widget.shadow != null
              ? [
                  widget.shadow!
                  // ??
                  //     BoxShadow(
                  //       color: SiteColors.foregroundColor,
                  //       offset: const Offset(-6, 5),
                  //       blurRadius: 13, // soften the shadow
                  //       spreadRadius: 0, //extend the shadow
                  //     ),
                ]
              : []),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                if (widget.leading != null) widget.leading!,
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextField(
                    keyboardType: widget.textInputType,
                    maxLines: widget.isPassword ? 1 : widget.maxLines,
                    controller: widget.controller,
                    obscureText: widget.isPassword,
                    cursorColor: widget.color,
                    style: widget.textStyle ??
                        GoogleFonts.roboto(color: widget.color),
                    textAlign: widget.textAlign,
                    onChanged: (String value) {
                      widget.onChanged != null
                          ? widget.onChanged!(value)
                          : null;
                    },
                    decoration: InputDecoration(
                      filled: false,
                      border: InputBorder.none,
                      // border: OutlineInputBorder(
                      //   borderSide: BorderSide(color: borderColor, width: borderStoke),
                      //   borderRadius: borderRadius,
                      // ),
                      // enabledBorder: OutlineInputBorder(
                      //     borderSide: BorderSide(color: borderColor, width: borderStoke),
                      //     borderRadius: borderRadius),
                      // focusedBorder: OutlineInputBorder(
                      //     borderSide: BorderSide(color: borderColor, width: borderStoke),
                      //     borderRadius: borderRadius),
                      hintText: widget.hintText,
                      hintStyle: widget.textStyle ??
                          GoogleFonts.roboto(color: widget.color),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (widget.trailing != null) widget.trailing!,
        ],
      ),
    );
  }
}

class CustomDropDown extends StatefulWidget {
  final String text;
  final TextStyle textStyle;
  final IconData icon;
  final Color iconColor;
  final double height;
  final double containerHeight;
  //final double containerItemsHeight;
  final double containerPositionControl;
  final Color dropdownButtonColor;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;

  final Color dropdownContainerColor;
  final BorderRadius? containerBorderRadius;

  final List<CustomListItem> listItems;
  final Function(int index)? onChanged;
  const CustomDropDown({
    Key? key,
    this.height = 60,
    this.containerHeight = 200,
    //this.containerItemsHeight = 200,
    this.containerPositionControl = 0,
    this.dropdownButtonColor = Colors.grey,
    this.borderRadius,
    required this.text,
    this.icon = Icons.arrow_drop_down_circle,
    this.iconColor = Colors.white,
    this.margin = const EdgeInsets.all(10),
    this.padding = const EdgeInsets.all(10),
    this.textStyle = const TextStyle(),
    this.dropdownContainerColor = Colors.grey,
    this.containerBorderRadius,
    required this.listItems,
    this.onChanged,
  }) : super(key: key);

  @override
  _CustomDropDownState createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  String value = 'Institute ID';
  GlobalKey? actionKey;
  RenderBox? renderBox;
  double? height, width, xPosition, yPosition;
  bool isDropdownOpened = false;

  OverlayEntry? floatingDropdown;

  @override
  void initState() {
    value = widget.listItems[0].itemValue;
    actionKey = LabeledGlobalKey(value);
    super.initState();
  }

  void findDropdownData() {
    renderBox = context.findRenderObject() as RenderBox;
    height = renderBox!.size.height;
    width = renderBox!.size.width;
    Offset offset = renderBox!.localToGlobal(Offset.zero);
    xPosition = offset.dx;
    yPosition = offset.dy;
  }

  OverlayEntry _createFloatingDropdown(
      EdgeInsetsGeometry margin,
      double containerHeight,
      BoxDecoration boxDecoration,
      List<CustomListItem> items) {
    return OverlayEntry(builder: (context) {
      return Positioned(
        left: xPosition!,
        width: width!,
        top: yPosition! + height! - widget.containerPositionControl,
        height: containerHeight,
        child: Container(
            margin: margin,
            decoration: boxDecoration,
            height: containerHeight,
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: ListView(
                children: [
                  for (var i = 0; i < items.length; i++)
                    GestureDetector(
                        child: items[i],
                        onTap: () {
                          setState(() {
                            value = items[i].itemValue;
                            widget.onChanged!(i);
                            floatingDropdown?.remove();
                            isDropdownOpened = !isDropdownOpened;
                          });
                        })
                ],
              ),
            )
            // ListView(
            //   children: [
            //     Text("test"),
            //     for (var i = 0; i < items.length; i++)
            //       GestureDetector(
            //           child: items[i],
            //           onTap: () {
            //             setState(() {
            //               value = items[i].itemValue;
            //               floatingDropdown?.remove();
            //               isDropdownOpened = !isDropdownOpened;
            //             });
            //           })
            //   ],
            // ),
            ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isDropdownOpened) {
            //floatingDropdown!.remove();
            if (floatingDropdown?.mounted ?? false) {
              floatingDropdown?.remove();
            }
          } else {
            findDropdownData();
            floatingDropdown = _createFloatingDropdown(
              widget.margin,
              widget.containerHeight,
              BoxDecoration(
                  color: widget.dropdownContainerColor,
                  borderRadius: widget.containerBorderRadius ??
                      BorderRadius.circular(10)),
              widget.listItems,
            );
            Overlay.of(context)!.insert(floatingDropdown!);
          }
          isDropdownOpened = !isDropdownOpened;
        });
      },
      child: Container(
        height: widget.height,
        margin: widget.margin,
        padding: widget.padding,
        decoration: BoxDecoration(
          borderRadius: widget.borderRadius ?? BorderRadius.circular(10),
          color: widget.dropdownButtonColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              value,
              style: widget.textStyle,
            ),
            Icon(widget.icon, color: widget.iconColor)
          ],
        ),
      ),
    );
  }
}

class CustomListItem extends StatelessWidget {
  final String itemValue;
  final TextStyle? itemTextStyle;
  final BorderRadius? itemBorderRadius;
  final Color? itemContainerColor;
  final double height;
  final double margin;
  const CustomListItem(
      {Key? key,
      required this.itemValue,
      this.itemTextStyle,
      this.itemBorderRadius,
      this.itemContainerColor,
      this.height = 40,
      this.margin = 5})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: EdgeInsets.only(top: margin, left: margin, right: margin),
      decoration: BoxDecoration(
          color: itemContainerColor ?? Colors.lightBlue,
          borderRadius: itemBorderRadius ?? BorderRadius.circular(10)),
      child: Center(
          child: Text(
        itemValue,
        style: itemTextStyle ?? const TextStyle(),
      )),
    );
  }
}

/// Create a grid.
class CustomGrid extends StatelessWidget {
  const CustomGrid({
    Key? key,
    this.columnCount = 2,
    this.gap,
    this.padding,
    required this.children,
  }) : super(key: key);

  /// Number of column.
  final int columnCount;

  /// Gap to separate each cell.
  final double? gap;

  /// An empty space.
  final EdgeInsets? padding;

  /// The widgets below this widget in the tree.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      child: Column(children: _createRows()),
    );
  }

  List<Widget> _createRows() {
    final List<Widget> rows = [];
    final childrenLength = children.length;
    final rowCount = (childrenLength / columnCount).ceil();

    for (int rowIndex = 0; rowIndex < rowCount; rowIndex++) {
      final List<Widget> columns = _createRowCells(rowIndex);
      rows.add(Row(children: columns));
      if (rowIndex != rowCount - 1) rows.add(SizedBox(height: gap));
    }

    return rows;
  }

  List<Widget> _createRowCells(int rowIndex) {
    final List<Widget> columns = [];
    final childrenLength = children.length;

    for (int columnIndex = 0; columnIndex < columnCount; columnIndex++) {
      final cellIndex = rowIndex * columnCount + columnIndex;
      if (cellIndex <= childrenLength - 1) {
        columns.add(Expanded(child: children[cellIndex]));
      } else {
        columns.add(Expanded(child: Container()));
      }

      if (columnIndex != columnCount - 1) columns.add(SizedBox(width: gap));
    }

    return columns;
  }
}
