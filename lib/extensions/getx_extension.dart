part of 'extensions.dart';

extension GetXExtension on Rx {
  bool get isRxNull => this == Rx(null);

  bool isEqualTo(dynamic value) => this.value == value;
}
