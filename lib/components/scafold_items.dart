import 'package:flutter/material.dart';
import 'package:invoicing/screens/client_preview.dart';
import 'package:invoicing/utils/app_icons_icons.dart';
import 'package:invoicing/utils/constant.dart';

AppBar getAppBarGrey(String title) {
  return AppBar(
    iconTheme: IconThemeData(color: kORANGE_COLOR),
    title: Text(
      title,
      style: TextStyle(color: kORANGE_COLOR),
    ),
    backgroundColor: Color(0xfff3f3f8),
  );
}

AppBar getAppBarWhite(String title) {
  return AppBar(
    iconTheme: IconThemeData(color: kORANGE_COLOR),
    title: Text(
      title,
      style: TextStyle(color: kORANGE_COLOR),
    ),
    backgroundColor: Colors.white,
  );
}

AppBar getAppBarWhiteWithAction(
    {String title, Function filter, Function search}) {
  return AppBar(
    actions: <Widget>[
      IconButton(
        onPressed: search,
        icon: Icon(AppIcons.i_search),
      ),
      IconButton(
        onPressed: filter,
        icon: Icon(AppIcons.i_filter),
      )
    ],
    iconTheme: IconThemeData(color: kORANGE_COLOR),
    title: Text(
      title,
      style: TextStyle(color: kORANGE_COLOR),
    ),
    backgroundColor: Colors.white,
  );
}

FloatingActionButton getFloatingActionButton(Function action) {
  return FloatingActionButton(
    backgroundColor: kORANGE_COLOR,
    child: Icon(
      Icons.add,
      size: 25,
    ),
    onPressed: action,
  );
}
