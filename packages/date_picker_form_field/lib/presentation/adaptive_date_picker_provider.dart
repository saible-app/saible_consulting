import 'package:date_picker_form_field/presentation/adaptive_cupertino_date_picker.dart';
import 'package:date_picker_form_field/presentation/adaptive_date_picker.dart';
import 'package:date_picker_form_field/presentation/adaptive_material_date_picker.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

/// Provides an adaptive date picker depending on the widget platform
class const AdaptiveDatePickerProvider({
  super.key,
  required this.child,
  this.datePicker,
}) extends StatelessWidget {
  /// Creates an [AdaptiveDatePickerProvider]
  this;

  /// The widget below this provider in the tree.
  final Widget child;

  /// An optional custom [AdaptiveDatePicker] to override the platform default.
  /// 
  /// If you want to use your own concrete adaptive date picker implementation, you can do so here.
  final AdaptiveDatePicker? datePicker;

  @override
  Widget build(BuildContext context) {
    final platform = Theme.of(context).platform;
    return Provider<AdaptiveDatePicker>.value(
      value: datePicker ?? switch (platform) {
        TargetPlatform.iOS || TargetPlatform.macOS => AdaptiveCupertinoDatePicker(),
        _ => AdaptiveMaterialDatePicker(),
      },
      child: child,
    );
  }
}
