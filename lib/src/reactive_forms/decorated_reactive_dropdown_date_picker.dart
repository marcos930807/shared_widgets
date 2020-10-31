import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:reactive_forms/reactive_forms.dart';
import '../utils/date_utils.dart';
import '../base/shadow_card.dart';
// this is the packages of the example where the Counter widget resides

class DecoratedReactiveDropDownDatePicker extends ReactiveFormField<DateTime> {
  DecoratedReactiveDropDownDatePicker({
    @required String formControlName,
    String label,
  }) : super(
            formControlName: formControlName,
            builder: (ReactiveFormFieldState<DateTime> field) {
              return DateTimeDropDown(
                label: label,
                initalValue: field.value,
                onChanged: (value) => field.didChange(value),
              );
            });

  @override
  ReactiveFormFieldState<DateTime> createState() =>
      ReactiveFormFieldState<DateTime>();
}

class DateTimeDropDown extends StatefulWidget {
  const DateTimeDropDown({
    Key key,
    this.onChanged,
    this.initalValue,
    this.label,
  }) : super(key: key);
  final String label;
  final ValueChanged<DateTime> onChanged;
  final DateTime initalValue;

  @override
  DateTimeDropDownState createState() => DateTimeDropDownState();
}

class DateTimeDropDownState extends State<DateTimeDropDown> {
  DateTime current = DateTime.now();
  int state = 3;

  @override
  void initState() {
    super.initState();
    if (widget.initalValue != null) {
      current = widget.initalValue;
    }
  }

  @override
  void didUpdateWidget(DateTimeDropDown oldWidget) {
    if (widget.initalValue != current) {
      current = widget.initalValue;
      state = 3;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final icon = EvaIcons.calendarOutline;
    final decoration = InputDecoration(
      isDense: true,
      // filled: true,
      contentPadding: EdgeInsets.only(right: 8.0, top: 6.0, bottom: 2.0),
      prefixIcon: icon != null
          ? Container(
              margin: const EdgeInsets.fromLTRB(2.0, 2.0, 6.0, 2.0),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withAlpha(130),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              child: Icon(
                icon,
                size: 22,
                color: Colors.white,
              ))
          : null,
      border: InputBorder.none,
      labelText: widget.label ?? 'Date',
      errorStyle: TextStyle(
          height: 0.3,
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold),
    );
    final InputDecoration effectiveDecoration = decoration.applyDefaults(
      Theme.of(context).inputDecorationTheme,
    );
    //Sino lo cargo desde cual es la compa;ia activa
    return ShadowCard(
        child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: InputDecorator(
                isEmpty: current == null,
                decoration: effectiveDecoration,
                child: _dropDownDateTimeType())));
  }

  Widget _dropDownDateTimeType() => DropdownButton<int>(
        elevation: 1,
        isDense: true,
        icon: Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Icon(
            EvaIcons.arrowCircleDownOutline,
            size: 17,
            color: Theme.of(context).iconTheme.color,
          ),
        ),

        items: [
          DropdownMenuItem(value: 0, child: Text('+ 7 dias')),
          DropdownMenuItem(value: 1, child: Text('+ 30 dias')),
          DropdownMenuItem(value: 2, child: Text('+ 90 dias')),
          DropdownMenuItem(value: 3, child: Text('+ 1 año')),
          DropdownMenuItem(value: 4, child: Text('Perzonalizado')),
        ],
        selectedItemBuilder: (BuildContext context) {
          return <Widget>[
            getBuilderItem,
            getBuilderItem,
            getBuilderItem,
            getBuilderItem,
            getBuilderItem,
          ];
        },
        onChanged: (value) async {
          await _setDateBaseOnValue(value);
          setState(() {
            state = value;
            if (widget.onChanged != null) widget.onChanged(current);
          });
        },
        value: state,
        isExpanded: true,
        underline: Container(),
        // ),
      );

  Widget get getBuilderItem {
    return Text(
      current?.toPipeFormatedDate ?? '',
      maxLines: 1,
    );
  }

  _setDateBaseOnValue(int value) async {
    switch (value) {
      case 0:
        current = DateTime.now().add(Duration(days: 7));
        break;
      case 1:
        current = DateTime.now().add(Duration(days: 30));
        break;
      case 2:
        current = DateTime.now().add(Duration(days: 90));
        break;
      case 3:
        current = DateTime.now().add(Duration(days: 365));
        break;
      case 4:
        var date = await selectDate(context);
        if (date != null) {
          current = date;
        }
        break;
    }
  }
}
