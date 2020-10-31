import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../base/shadow_card.dart';

class DecoratedReactiveTextField extends StatelessWidget {
  /// [ReactiveTextField] Expecific props;
  final String formControlName;
  final Function onSubmitted;
  final ValidationMessagesFunction validationMessages;
  final bool mandatory; //For showing an Asterisk

  /// [TextField] custom props;
  final String hint;
  final String label;
  final IconData icon;
  final TextInputType textType;
  final TextInputAction textInputAction;
  final List<TextInputFormatter> inputFormatters;
  final Color backgroundColor;
  final bool obscureText;

  DecoratedReactiveTextField({
    this.onSubmitted,
    @required this.formControlName,
    this.validationMessages,
    this.hint,
    this.label,
    this.icon,
    this.backgroundColor,
    this.textType = TextInputType.text,
    this.textInputAction,
    this.inputFormatters,
    this.obscureText,
    this.mandatory = false,
  });

  @override
  Widget build(BuildContext context) {
    return ShadowCard(
      backGroundColor: backgroundColor ?? Theme.of(context).cardColor,
      child: Padding(
        padding: icon != null
            ? const EdgeInsets.all(2.0)
            : const EdgeInsets.fromLTRB(8, 2, 2, 2),
        child: ReactiveTextField(
          formControlName: formControlName,
          onSubmitted: onSubmitted,
          validationMessages: validationMessages,
          inputFormatters: inputFormatters,
          style: TextStyle(height: 1),
          keyboardType: textType,
          textInputAction: textInputAction,
          cursorColor: Theme.of(context).primaryColor,
          obscureText: obscureText ?? false,
          decoration: InputDecoration(
            isDense: true,
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
            labelText: mandatory ? label + ' *' : label,
            hintText: hint,
            errorStyle: TextStyle(
                height: 0.3,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class DecoratedReactiveObscureTextField extends StatefulWidget {
  /// [ReactiveTextField] Expecific props;
  final String formControlName;
  final Function onSubmitted;
  final ValidationMessagesFunction validationMessages;

  /// [TextField] custom props;
  final String hint;
  final String label;
  final IconData icon;
  final TextInputType textType;
  final TextInputAction textInputAction;
  final List<TextInputFormatter> inputFormatters;
  final Color backgroundColor;

  DecoratedReactiveObscureTextField({
    this.onSubmitted,
    @required this.formControlName,
    this.validationMessages,
    this.hint,
    this.label,
    this.icon,
    this.backgroundColor,
    this.textType = TextInputType.text,
    this.textInputAction,
    this.inputFormatters,
  });

  @override
  _DecoratedReactiveObscureTextFieldState createState() =>
      _DecoratedReactiveObscureTextFieldState();
}

class _DecoratedReactiveObscureTextFieldState
    extends State<DecoratedReactiveObscureTextField> {
  bool passwordVisible;

  @override
  void initState() {
    super.initState();
    passwordVisible = false;
  }

  getToogleButton() {
    return IconButton(
        icon: Icon(
          // Based on passwordVisible state choose the icon
          passwordVisible ? Icons.visibility : Icons.visibility_off,
          color: Theme.of(context).primaryColorDark,
        ),
        onPressed: () {
          // Update the state i.e. toogle the state of passwordVisible variable
          setState(() {
            passwordVisible = !passwordVisible;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return ShadowCard(
      backGroundColor: widget.backgroundColor ?? Theme.of(context).cardColor,
      child: Padding(
        padding: widget.icon != null
            ? const EdgeInsets.all(2.0)
            : const EdgeInsets.fromLTRB(8, 2, 2, 2),
        child: ReactiveTextField(
          formControlName: widget.formControlName,
          onSubmitted: widget.onSubmitted,
          validationMessages: widget.validationMessages,
          inputFormatters: widget.inputFormatters,
          style: TextStyle(height: 1),
          keyboardType: widget.textType,
          textInputAction: widget.textInputAction,
          cursorColor: Theme.of(context).primaryColor,
          obscureText: !passwordVisible,
          decoration: InputDecoration(
            isDense: true,
            suffixIcon: getToogleButton(),
            prefixIcon: widget.icon != null
                ? Container(
                    margin: const EdgeInsets.fromLTRB(2.0, 2.0, 6.0, 2.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withAlpha(130),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    child: Icon(
                      widget.icon,
                      size: 22,
                      color: Colors.white,
                    ))
                : null,
            border: InputBorder.none,
            labelText: widget.label,
            hintText: widget.hint,
            errorStyle: TextStyle(
                height: 0.3,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
