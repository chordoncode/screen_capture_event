///
/// list_expandable_widget.dart
/// Purpose: Supply boilerplate for expandable list
/// Description:
/// Created: Aug 11th 2020
/// Copyright (C) 2020 Liem Vo.
///
import 'package:flutter/material.dart';

class ListExpandableWidget extends StatefulWidget {
  // optional property and default value is false
  final bool isExpanded;

  // required widget and display the header of each group
  final Widget header;

  // required list `ListTile` widget for group items
  final List<ListTile> items;

  // optional widget for expanded Icon. Default value is `Icon(Icons.keyboard_arrow_down)`
  final Widget expandedIcon;

  // optional widget for collapse Icon. Default value is `Icon(Icons.keyboard_arrow_right)`
  final Widget collapsedIcon;

  ListExpandableWidget(
      { this.isExpanded = false,
        required this.header,
        required this.items,
        this.expandedIcon = const Icon(Icons.keyboard_arrow_down),
        this.collapsedIcon = const Icon(Icons.keyboard_arrow_right)});

  @override
  _ListExpandableWidgetState createState() => _ListExpandableWidgetState();
}

class _ListExpandableWidgetState extends State<ListExpandableWidget> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _updateExpandState(widget.isExpanded);
  }

  void _updateExpandState(bool isExpanded) =>
      setState(() => _isExpanded = isExpanded);

  @override
  Widget build(BuildContext context) {
    return _isExpanded ? _buildListItems(context) : _wrapHeader();
  }

  Widget _wrapHeader() {
    List<Widget> children = [];
    if (!widget.isExpanded) {
      //children.add(Divider());
    }
    children.add(ListTile(
      title: widget.header,
      trailing: _isExpanded
          ? widget.expandedIcon ?? Icon(Icons.keyboard_arrow_down)
          : widget.collapsedIcon ?? Icon(Icons.keyboard_arrow_right),
      onTap: () => _updateExpandState(!_isExpanded),
    ));
    return Ink(
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildListItems(BuildContext context) {
    List<Widget> titles = [];
    titles.add(_wrapHeader());
    titles.addAll(widget.items);
    return Column(
      children: ListTile.divideTiles(tiles: titles, context: context).toList(),
    );
  }
}
