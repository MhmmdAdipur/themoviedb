part of 'extensions.dart';

extension NumExtension on num? {
  String get toDisplay => this == null ? '-' : this!.toStringAsFixed(1);
}
