import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../base/shadow_card.dart';

typedef SyncLoadFuntion<T> = List<T> Function();
typedef ItemBuilder<T> = Widget Function(T item);

class DecoratedReactiveBasePicker<T> extends StatelessWidget {
  const DecoratedReactiveBasePicker({
    Key key,
    @required this.formControlName,
    @required this.loadFuntion,
    @required this.itemBuilder,
    this.icon,
    this.label,
    this.backgoroundColor,
    this.validationMessages,
  }) : super(key: key);

  final String formControlName;
  final SyncLoadFuntion<T> loadFuntion;
  final ItemBuilder<T> itemBuilder;
  final IconData icon;
  final String label;
  final Color backgoroundColor;
  final ValidationMessagesFunction validationMessages;
  @override
  Widget build(BuildContext context) {
    return Container(
      //  height: 52,
      child: ShadowCard(
        backGroundColor: backgoroundColor,
        child: Padding(
            padding: icon != null
                ? const EdgeInsets.all(2.0)
                : const EdgeInsets.fromLTRB(8, 2, 2, 2),
            child: ReactiveDropdownField<T>(
                elevation: 1,
                isExpanded: true,
                isDense: false,
                onChanged: (value) {
                  print(value.toString());
                },
                validationMessages: validationMessages,
                decoration: InputDecoration(
                  isDense: true,
                  isCollapsed: true, //The magic
                  contentPadding:
                      EdgeInsets.only(right: 8.0, top: 0.0, bottom: 0.0),
                  prefixIcon: icon != null
                      ? Container(
                          margin: const EdgeInsets.fromLTRB(2.0, 2.0, 6.0, 2.0),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).primaryColor.withAlpha(130),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                          child: Icon(
                            icon,
                            size: 22,
                            color: Colors.white,
                          ))
                      : null,
                  border: InputBorder.none,
                  labelText: label,
                  labelStyle: TextStyle(height: 1.5),

                  errorStyle: TextStyle(
                      height: 0.3,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                icon: Padding(
                  padding: const EdgeInsets.only(
                    left: 4,
                  ),
                  child: Icon(
                    EvaIcons.arrowCircleDownOutline,
                    size: 17,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
                formControlName: formControlName,
                onTap: () {
                  print('LALALALALA');
                },
                items: loadFuntion()
                    .map((e) => DropdownMenuItem<T>(
                          value: e,
                          child: Container(
                              height: 45,
                              padding: EdgeInsets.only(top: 10),
                              alignment: Alignment.centerLeft,
                              child: itemBuilder(e)),
                        ))
                    .toList())),
      ),
    );
  }
}
