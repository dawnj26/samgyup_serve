import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimePicker extends StatefulWidget {
  const DateTimePicker({
    super.key,
    this.initialValue,
    this.onChanged,
    this.labelText,
    this.hintText,
    this.helperText,
    this.errorText,
    this.enabled = true,
    this.readOnly = false,
    this.mode = DateTimePickerMode.dateTime,
    this.firstDate,
    this.lastDate,
    this.dateFormat,
    this.decoration,
    this.textStyle,
    this.prefixIcon,
    this.suffixIcon,
  });

  final DateTime? initialValue;
  final ValueChanged<DateTime?>? onChanged;
  final String? labelText;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final bool enabled;
  final bool readOnly;
  final DateTimePickerMode mode;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final DateFormat? dateFormat;
  final InputDecoration? decoration;
  final TextStyle? textStyle;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  @override
  State<DateTimePicker> createState() => _DateTimePickerState();
}

enum DateTimePickerMode {
  date,
  time,
  dateTime,
}

class _DateTimePickerState extends State<DateTimePicker> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode(canRequestFocus: false);
  late final DateFormat _formatter;
  late DateTime? _value;

  @override
  void initState() {
    super.initState();
    _formatter = widget.dateFormat ?? _getDefaultFormatter();
    _value = widget.initialValue;
    _updateControllerText();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  DateFormat _getDefaultFormatter() {
    switch (widget.mode) {
      case DateTimePickerMode.date:
        return DateFormat.yMd();
      case DateTimePickerMode.time:
        return DateFormat.jm();
      case DateTimePickerMode.dateTime:
        return DateFormat.yMd().add_jm();
    }
  }

  void _updateControllerText() {
    if (_value == null) {
      _controller.text = '';
      return;
    }

    _controller.text = _formatter.format(_value!);
  }

  Future<void> _showPicker() async {
    if (!widget.enabled || widget.readOnly) return;

    DateTime? selectedDateTime = _value ?? DateTime.now();

    switch (widget.mode) {
      case DateTimePickerMode.date:
        selectedDateTime = await _showDatePicker(selectedDateTime);
      case DateTimePickerMode.time:
        selectedDateTime = await _showTimePicker(selectedDateTime);
      case DateTimePickerMode.dateTime:
        selectedDateTime = await _showDateTimePicker(selectedDateTime);
    }

    if (selectedDateTime == null) return;

    setState(() {
      _value = selectedDateTime;
      _updateControllerText();
    });

    widget.onChanged?.call(selectedDateTime);
  }

  Future<DateTime?> _showDatePicker(DateTime initialDate) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: widget.firstDate ?? DateTime(1900),
      lastDate: widget.lastDate ?? DateTime(2100),
    );
    return picked;
  }

  Future<DateTime?> _showTimePicker(DateTime initialDate) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate),
    );
    if (picked != null) {
      return DateTime(
        initialDate.year,
        initialDate.month,
        initialDate.day,
        picked.hour,
        picked.minute,
      );
    }
    return null;
  }

  Future<DateTime?> _showDateTimePicker(DateTime initialDate) async {
    final selectedDate = await _showDatePicker(initialDate);
    if (selectedDate != null && mounted) {
      final selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );
      if (selectedTime != null) {
        return DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );
      }
    }
    return null;
  }

  Widget _getDefaultIcon() {
    switch (widget.mode) {
      case DateTimePickerMode.date:
        return const Icon(Icons.calendar_today);
      case DateTimePickerMode.time:
        return const Icon(Icons.access_time);
      case DateTimePickerMode.dateTime:
        return const Icon(Icons.event);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      readOnly: true,
      enabled: widget.enabled,
      style: widget.textStyle ?? theme.textTheme.bodyLarge,
      decoration:
          widget.decoration ??
          InputDecoration(
            labelText: widget.labelText,
            hintText: widget.hintText,
            helperText: widget.helperText,
            errorText: widget.errorText,
            prefixIcon: widget.prefixIcon ?? _getDefaultIcon(),
            suffixIcon: widget.suffixIcon,
            filled: true,
            fillColor: widget.enabled
                ? colorScheme.surface.withValues(alpha: 0.12)
                : colorScheme.onSurface.withValues(alpha: 0.04),
            border: const OutlineInputBorder(),
          ),
      onTap: _showPicker,
    );
  }
}
