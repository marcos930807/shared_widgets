import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;

/// A builder that builds a widget responsible to decide when to show
/// the picker dialog.
///
/// The builder passes a delegate [picker] as argument that has a method
/// to show the dialog, it also has a property to access the [FormControl]
/// that is bound to [ReactiveTimePicker].
///
/// See also [ReactiveDatePickerDelegate].
typedef ReactiveCustomDateRangePickerBuilder = Widget Function(
    BuildContext context,
    ReactiveCustomDateRangePickerDelegate picker,
    Widget child);

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
/// ReactiveCustomDateRangePicker(
///   formControlName: 'birthday',
///   builder: (context, picker, child) {
///     return IconButton(
///       onPressed: picker.showPicker,
///       icon: Icon(Icons.date_range),
///     );
///   },
/// )
/// ```
class ReactiveCustomDateRangePicker extends ReactiveFormField<DateTimeRange> {
  /// Creates a [ReactiveCustomDateRangePicker] that wraps the function [showDateRangePicker].
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
  ReactiveCustomDateRangePicker({
    Key key,
    String formControlName,
    FormControl formControl,
    @required ReactiveCustomDateRangePickerBuilder builder,
    @required DateTime initiaFirstDate,
    @required DateTime firstDate,
    @required DateTime lastDate,
    @required DateTime initialLastDate,
    SelectableDayPredicate selectableDayPredicate,
    String helpText,
    String cancelText,
    String confirmText,
    Locale locale,
    bool useRootNavigator = true,
    RouteSettings routeSettings,
    TextDirection textDirection,
    TransitionBuilder transitionBuilder,
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
              ReactiveCustomDateRangePickerDelegate._(
                  field,
                  () => DateRagePicker.showDatePicker(
                              context: field.context,
                              initialFirstDate: initiaFirstDate,
                              initialLastDate: initialLastDate,
                              firstDate: firstDate,
                              lastDate: lastDate)
                          .then((value) {
                        if (value != null) {
                          if (value.length == 1) {
                            //Si viene un solo elemto el rango es ese propio dia duplico
                            value.add(value.first);
                          }
                          field.didChange(
                              DateTimeRange(start: value[0], end: value[1]));
                        }
                      }) /* showDateRangePicker(
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
                }), */
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
/// See also [ReactiveCustomDateRangePicker].
class ReactiveCustomDateRangePickerDelegate {
  final ReactiveFormFieldState<DateTimeRange> _field;
  final VoidCallback _showPickerCallback;

  ReactiveCustomDateRangePickerDelegate._(
      this._field, this._showPickerCallback);

  /// Gets the control bound to the [ReactiveCustomDateRangePicker] widget
  AbstractControl<DateTimeRange> get control =>
      _field.control as AbstractControl<DateTimeRange>;

  /// Gets the value selected in the date picker.
  DateTimeRange get value => this.control.value;

  /// Shows the time picker dialog.
  void showPicker() {
    this._showPickerCallback();
  }
}
