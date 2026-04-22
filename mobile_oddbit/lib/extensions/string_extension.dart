extension StringExtension on String {}

extension OptionalStringExt on String? {
  bool get isNotNullAndNotEmpty => this != null && this!.isNotEmpty;
}
