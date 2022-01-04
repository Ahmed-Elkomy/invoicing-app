import 'package:flutter/material.dart';
import 'package:invoicing/utils/constant.dart';

import 'dashboard_side_row.dart';

class DashboardRow extends StatelessWidget {
  final double topMargin;
  final double sideMargin;
  final bool lastRow;
  final IconData rightIcon;
  final String rightText;
  final String rightPageId;
  final IconData leftIcon;
  final String leftText;
  final String leftPageId;
  static final double paddingAll = kDASHBOARD_ITEMS_INTERNAL_PADDING;
  static final double borderWidth = kDASHBOARD_ITEMS_BORDER_WIDTH;
  static final Color borderColor = kDASHBOARD_ITEMS_BORDER_COLOR;
  static final double iconSize = kDASHBOARD_ITEMS_ICON_SIZE;
  static final double fontSize = kDASHBOARD_ITEMS_FONT_SIZE;
  const DashboardRow(
      {this.topMargin,
      this.sideMargin,
      this.leftIcon,
      this.leftText,
      this.leftPageId,
      this.rightIcon,
      this.rightText,
      this.rightPageId,
      this.lastRow});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        DashboardSideRow(
            paddingAll: paddingAll,
            topMargin: topMargin,
            sideMargin: sideMargin,
            borderWidth: borderWidth,
            borderColor: borderColor,
            lastRow: lastRow,
            isLeft: true,
            icon: leftIcon,
            iconSize: iconSize,
            text: leftText,
            pageId: leftPageId,
            fontSize: fontSize),
        DashboardSideRow(
            paddingAll: paddingAll,
            topMargin: topMargin,
            sideMargin: sideMargin,
            borderWidth: borderWidth,
            borderColor: borderColor,
            lastRow: lastRow,
            isLeft: false,
            icon: rightIcon,
            iconSize: iconSize,
            text: rightText,
            pageId: rightPageId,
            fontSize: fontSize),
      ],
    );
  }
}
