import 'package:flutter/material.dart';

import 'add_item_popup_menu.dart';

class DashboardSideRow extends StatelessWidget {
  const DashboardSideRow({
    Key key,
    @required this.paddingAll,
    @required this.topMargin,
    @required this.sideMargin,
    @required this.borderWidth,
    @required this.borderColor,
    @required this.lastRow,
    @required this.isLeft,
    @required this.icon,
    @required this.iconSize,
    @required this.text,
    @required this.pageId,
    @required this.fontSize,
  }) : super(key: key);

  final double paddingAll;
  final double topMargin;
  final double sideMargin;
  final double borderWidth;
  final Color borderColor;
  final bool lastRow;
  final bool isLeft;
  final IconData icon;
  final double iconSize;
  final String text;
  final String pageId;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(top: paddingAll, bottom: paddingAll),
        margin: isLeft
            ? EdgeInsets.only(top: topMargin, left: sideMargin)
            : EdgeInsets.only(top: topMargin, right: sideMargin),
        decoration: BoxDecoration(
          border: isLeft
              ? Border(
                  right: BorderSide(width: borderWidth, color: borderColor),
                  bottom: lastRow
                      ? BorderSide(width: 0, color: Colors.white)
                      : BorderSide(width: borderWidth, color: borderColor),
                )
              : Border(
                  bottom: lastRow
                      ? BorderSide(width: 0, color: Colors.white)
                      : BorderSide(width: borderWidth, color: borderColor),
                ),
        ),
        child: GestureDetector(
//          onTap: () => Navigator.pushNamed(context, pageId),
          onTap: () => text == "Create Items"
              ? addItemPopupMenu(context)
              : Navigator.pushNamed(context, pageId),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                icon,
                color: Colors.black,
                size: iconSize,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                text,
                style:
                    TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}
