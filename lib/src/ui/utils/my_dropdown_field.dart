library dropdownfield;

import 'package:capstone_mobile/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DropDownField extends FormField<String> {
  final dynamic value;
  final Widget icon;
  final String hintText;
  final TextStyle hintStyle;
  final String labelText;
  final TextStyle labelStyle;
  final TextStyle textStyle;
  final bool required;
  final bool enabled;
  final List<dynamic> items;
  final List<TextInputFormatter> inputFormatters;
  final FormFieldSetter<dynamic> setter;
  final ValueChanged<dynamic> onValueChanged;
  final bool strict;
  final int itemsVisibleInDropdown;
  final String errorText;

  final TextEditingController controller;

  DropDownField(
      {Key key,
      this.controller,
      this.value,
      this.required: false,
      this.icon,
      this.hintText,
      this.hintStyle: const TextStyle(
          fontWeight: FontWeight.normal, color: Colors.grey, fontSize: 16.0),
      this.labelText,
      this.labelStyle: const TextStyle(
          fontWeight: FontWeight.normal, color: Colors.grey, fontSize: 16.0),
      this.inputFormatters,
      this.items,
      this.textStyle: const TextStyle(
          fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16.0),
      this.setter,
      this.onValueChanged,
      this.itemsVisibleInDropdown: 3,
      this.enabled: true,
      this.strict: true,
      this.errorText: 'This field can not be empty!'})
      : super(
          key: key,
          autovalidate: false,
          initialValue: controller != null ? controller.text : (value ?? ''),
          onSaved: setter,
          builder: (FormFieldState<String> field) {
            final DropDownFieldState state = field;
            final ScrollController _scrollController = ScrollController();
            final InputDecoration effectiveDecoration = InputDecoration(
                border: InputBorder.none,
                filled: true,
                icon: icon,
                suffixIcon: IconButton(
                    icon: Icon(Icons.arrow_drop_down,
                        size: 24.0, color: Colors.black),
                    onPressed: () {
                      SystemChannels.textInput.invokeMethod('TextInput.hide');
                      state.setState(() {
                        state._showdropdown = !state._showdropdown;
                      });
                    }),
                hintStyle: hintStyle,
                labelStyle: labelStyle,
                hintText: hintText,
                labelText: labelText);

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        // width: 50,
                        child: TextFormField(
                          autovalidate: true,
                          controller: state._effectiveController,
                          decoration: effectiveDecoration.copyWith(
                            errorText: field.errorText,
                            contentPadding:
                                const EdgeInsets.only(top: 14, left: 8),
                            // border: OutlineInputBorder(
                            //   borderSide: const BorderSide(
                            //       color: Colors.white, width: 2.0),
                            //   borderRadius: BorderRadius.circular(5.0),
                            // ),
                          ),
                          style: textStyle,
                          textAlign: TextAlign.start,
                          autofocus: false,
                          obscureText: false,
                          maxLengthEnforced: true,
                          maxLines: 1,
                          validator: (String newValue) {
                            if (required) {
                              if (newValue == null || newValue.isEmpty)
                                return errorText;
                            }

                            //Items null check added since there could be an initial brief period of time
                            //when the dropdown items will not have been loaded
                            if (items != null) {
                              if (strict &&
                                  newValue.isNotEmpty &&
                                  !items.contains(newValue))
                                return 'Invalid value in this field!';
                            }
                          },
                          onSaved: setter,
                          enabled: enabled,
                          inputFormatters: inputFormatters,
                        ),
                      ),
                    ),
                    // IconButton(
                    //   icon: Icon(Icons.close),
                    //   onPressed: () {
                    //     if (!enabled) return;
                    //     state.clearValue();
                    //   },
                    // )
                  ],
                ),
                !state._showdropdown
                    ? Container()
                    : Container(
                        alignment: Alignment.topCenter,
                        height: itemsVisibleInDropdown *
                            32.0, //limit to default 3 items in dropdownlist view and then remaining scrolls
                        width: MediaQuery.of(field.context).size.width,
                        child: ListView(
                          cacheExtent: 0.0,
                          scrollDirection: Axis.vertical,
                          controller: _scrollController,
                          padding: EdgeInsets.only(left: 8.0),
                          children: items.isNotEmpty
                              ? ListTile.divideTiles(
                                      context: field.context,
                                      tiles: state._getChildren(state._items))
                                  .toList()
                              : List(),
                        ),
                        color: Colors.grey[200],
                      ),
              ],
            );
          },
        );

  @override
  DropDownFieldState createState() => DropDownFieldState();
}

class DropDownFieldState extends FormFieldState<String> {
  TextEditingController _controller;
  bool _showdropdown = false;
  bool _isSearching = true;
  String _searchText = "";

  @override
  DropDownField get widget => super.widget;
  TextEditingController get _effectiveController =>
      widget.controller ?? _controller;

  List<String> get _items => widget.items;

  void toggleDropDownVisibility() {}

  void clearValue() {
    setState(() {
      _effectiveController.text = '';
    });
  }

  @override
  void didUpdateWidget(DropDownField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      widget.controller?.addListener(_handleControllerChanged);

      if (oldWidget.controller != null && widget.controller == null)
        _controller =
            TextEditingController.fromValue(oldWidget.controller.value);
      if (widget.controller != null) {
        setValue(widget.controller.text);
        if (oldWidget.controller == null) _controller = null;
      }
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleControllerChanged);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _isSearching = false;
    if (widget.controller == null) {
      _controller = TextEditingController(text: widget.initialValue);
    }

    _effectiveController.addListener(_handleControllerChanged);

    _searchText = _effectiveController.text;
  }

  @override
  void reset() {
    super.reset();
    setState(() {
      _effectiveController.text = widget.initialValue;
    });
  }

  List<ListTile> _getChildren(List<String> items) {
    List<ListTile> childItems = List();
    for (var item in items) {
      if (_searchText.isNotEmpty) {
        if (item.toUpperCase().contains(_searchText.toUpperCase()))
          childItems.add(_getListTile(item));
      } else {
        childItems.add(_getListTile(item));
      }
    }
    _isSearching ? childItems : List();
    return childItems;
  }

  ListTile _getListTile(String text) {
    return ListTile(
      dense: true,
      title: Text(
        text,
      ),
      onTap: () {
        setState(() {
          _effectiveController.text = text;
          _handleControllerChanged();
          _showdropdown = false;
          _isSearching = false;
          if (widget.onValueChanged != null) widget.onValueChanged(text);
        });
      },
    );
  }

  void _handleControllerChanged() {
    if (_effectiveController.text != value)
      didChange(_effectiveController.text);

    if (_effectiveController.text.isEmpty) {
      setState(() {
        _isSearching = false;
        _searchText = "";
      });
    } else {
      setState(() {
        _isSearching = true;
        _searchText = _effectiveController.text;
        _showdropdown = true;
      });
    }
  }
}
