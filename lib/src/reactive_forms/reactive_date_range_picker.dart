import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// A builder that builds a widget responsible to decide when to show
/// the picker dialog.
///
/// The builder passes a delegate [picker] as argument that has a method
/// to show the dialog, it also has a property to access the [FormControl]
/// that is bound to [ReactiveTimePicker].
///
/// See also [ReactiveDatePickerDelegate].
typedef ReactiveDateRangePickerBuilder = Widget Function(
    BuildContext context, ReactiveDateRangePickerDelegate picker, Widget child);

/// This is a convenience widget that wraps the function
/// [showDatePicker] in a [ReactiveDatePicker].
///
/// The [formControlName] is required to bind this [ReactiveDatePicker]
/// to a [FormControl].
///
/// For documentation about the various parameters, see the [showDatePicker]
/// function parameters.
///
/// ## Example:
///
/// ```dart
/// ReactiveDateRangePicker(
///   formControlName: 'birthday',
///   builder: (context, picker, child) {
///     return IconButton(
///       onPressed: picker.showPicker,
///       icon: Icon(Icons.date_range),
///     );
///   },
/// )
/// ```
class ReactiveDateRangePicker extends ReactiveFormField<DateTimeRange> {
  /// Creates a [ReactiveDateRangePicker] that wraps the function [showDateRangePicker].
  ///
  /// Can optionally provide a [formControl] to bind this widget to a control.
  ///
  /// Can optionally provide a [formControlName] to bind this ReactiveFormField
  /// to a [FormControl].
  ///
  /// Must provide one of the arguments [formControl] or a [formControlName],
  /// but not both at the same time.
  ///
  /// The parameter [transitionBuilder] is the equivalent of [builder]
  /// parameter in the [showTimePicker].
  ///
  /// For documentation about the various parameters, see the [showDateRangePicker]
  /// function parameters.
  ReactiveDateRangePicker({
    Key key,
    String formControlName,
    FormControl formControl,
    @required ReactiveDateRangePickerBuilder builder,
    @required DateTime firstDate,
    @required DateTime lastDate,
    DatePickerEntryMode initialEntryMode = DatePickerEntryMode.calendar,
    SelectableDayPredicate selectableDayPredicate,
    String helpText,
    String cancelText,
    String confirmText,
    Locale locale,
    bool useRootNavigator = true,
    RouteSettings routeSettings,
    TextDirection textDirection,
    TransitionBuilder transitionBuilder,
    DatePickerEntryMode initialDatePickerMode = DatePickerEntryMode.calendar,
    String errorFormatText,
    String errorInvalidText,
    String fieldHintText,
    String fieldLabelText,
    Widget child,
  })  : assert(builder != null),
        super(
          key: key,
          formControl: formControl,
          formControlName: formControlName,
          builder: (ReactiveFormFieldState<DateTimeRange> field) {
            return builder(
              field.context,
              ReactiveDateRangePickerDelegate._(
                field,
                () => showDateRangePicker(
                  context: field.context,
                  firstDate: firstDate,
                  lastDate: lastDate,
                  initialDateRange: field.value ??
                      DateTimeRange(start: DateTime.now(), end: DateTime.now()),
                  initialEntryMode: initialEntryMode,
                  helpText: helpText,
                  cancelText: cancelText,
                  confirmText: confirmText,
                  locale: locale,
                  useRootNavigator: useRootNavigator,
                  routeSettings: routeSettings,
                  textDirection: textDirection,
                  builder: transitionBuilder,
                  errorFormatText: errorFormatText,
                  errorInvalidText: errorInvalidText,
                ).then((value) {
                  if (value != null) {
                    field.didChange(value);
                  }
                }),
              ),
              child,
            );
          },
        );

  @override
  ReactiveFormFieldState<DateTimeRange> createState() =>
      ReactiveFormFieldState<DateTimeRange>();
}

/// This class is responsible of showing the picker dialog.
///
/// See also [ReactiveDateRangePicker].
class ReactiveDateRangePickerDelegate {
  final ReactiveFormFieldState<DateTimeRange> _field;
  final VoidCallback _showPickerCallback;

  ReactiveDateRangePickerDelegate._(this._field, this._showPickerCallback);

  /// Gets the control bound to the [ReactiveDateRangePicker] widget
  AbstractControl<DateTimeRange> get control =>
      _field.control as AbstractControl<DateTimeRange>;

  /// Gets the value selected in the date picker.
  DateTimeRange get value => this.control.value;

  /// Shows the time picker dialog.
  void showPicker() {
    this._showPickerCallback();
  }
}
