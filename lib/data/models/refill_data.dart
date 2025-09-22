import 'package:freezed_annotation/freezed_annotation.dart';

part 'refill_data.freezed.dart';
part 'refill_data.g.dart';

@freezed
abstract class RefillData with _$RefillData {
  factory RefillData({
    required String menuId,
    required int quantity,
  }) = _RefillData;

  factory RefillData.fromJson(Map<String, dynamic> json) =>
      _$RefillDataFromJson(json);
}
