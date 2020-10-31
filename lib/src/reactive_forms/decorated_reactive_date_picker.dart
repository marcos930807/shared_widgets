import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../utils/date_utils.dart';
import '../base/shadow_card.dart';

class DecoratedReactiveDatePicker extends StatelessWidget {
  const DecoratedReactiveDatePicker({
    Key key,
    @required this.formControlName,
    this.label,
    this.mandatory = false,
  }) : super(key: key);

  final String formControlName;
  final bool mandatory;
  final String label;

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
      labelText: mandatory ? (label + ' *') : label,
      errorStyle: TextStyle(
          height: 0.3,
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold),
    );
    final InputDecoration effectiveDecoration = decoration.applyDefaults(
      Theme.of(context).inputDecorationTheme,
    );
    return ReactiveDatePicker(
      formControlName: formControlName,
      builder: (context, picker, child) {
        return ShadowCard(
          child: InkWell(
            onTap: () async {
              picker.showPicker();
            },
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: InputDecorator(
                isEmpty: picker.value == null,
                decoration: effectiveDecoration,
                child: Container(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: <Widget>[
                        if (picker.value != null)
                          Text(
                            picker.value?.toPipeFormatedDate,
                            style: TextStyle(fontSize: 16),
                          ),
                        SizedBox(
                          width: 5,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      firstDate: DateTime(2019),
      lastDate: DateTime(2022),
    );
  }
}
