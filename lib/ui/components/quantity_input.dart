import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QuantityInput extends StatefulWidget {
  const QuantityInput({
    super.key,
    this.initialValue = 1,
    this.minValue = 0,
    this.maxValue = 999,
    this.step = 1,
    this.onChanged,
    this.width,
    this.height = 48.0,
    this.buttonColor,
    this.buttonDisabledColor,
    this.textColor,
    this.backgroundColor,
    this.borderRadius,
    this.incrementIcon = Icons.add,
    this.decrementIcon = Icons.remove,
    this.iconSize = 20.0,
    this.textStyle,
    this.enabled = true,
    this.padding,
    this.borderWidth = 1.0,
    this.borderColor,
  });

  final int initialValue;
  final int minValue;
  final int maxValue;
  final int step;
  final ValueChanged<int>? onChanged;
  final double? width;
  final double? height;
  final Color? buttonColor;
  final Color? buttonDisabledColor;
  final Color? textColor;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final IconData? incrementIcon;
  final IconData? decrementIcon;
  final double? iconSize;
  final TextStyle? textStyle;
  final bool enabled;
  final EdgeInsetsGeometry? padding;
  final double? borderWidth;
  final Color? borderColor;

  @override
  State<QuantityInput> createState() => _QuantityInputState();
}

class _QuantityInputState extends State<QuantityInput> {
  late TextEditingController _controller;
  late int _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue.clamp(widget.minValue, widget.maxValue);
    _controller = TextEditingController(text: _currentValue.toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _increment() {
    if (!widget.enabled) return;

    final newValue = (_currentValue + widget.step).clamp(
      widget.minValue,
      widget.maxValue,
    );
    _updateValue(newValue);
  }

  void _decrement() {
    if (!widget.enabled) return;

    final newValue = (_currentValue - widget.step).clamp(
      widget.minValue,
      widget.maxValue,
    );
    _updateValue(newValue);
  }

  void _updateValue(int newValue) {
    if (newValue != _currentValue) {
      setState(() {
        _currentValue = newValue;
        _controller.text = newValue.toString();
      });
      widget.onChanged?.call(newValue);
    }
  }

  void _onTextChanged(String value) {
    if (value.isEmpty) return;

    final intValue = int.tryParse(value);
    if (intValue != null) {
      final clampedValue = intValue.clamp(widget.minValue, widget.maxValue);
      if (clampedValue != _currentValue) {
        setState(() {
          _currentValue = clampedValue;
        });
        widget.onChanged?.call(clampedValue);
      }
    }
  }

  void _onEditingComplete() {
    setState(() {
      _controller.text = _currentValue.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final buttonColor = widget.buttonColor ?? colorScheme.primary;
    final buttonDisabledColor =
        widget.buttonDisabledColor ??
        colorScheme.onSurface.withValues(alpha: 0.12);
    final textColor = widget.textColor ?? colorScheme.onSurface;
    final backgroundColor = widget.backgroundColor ?? colorScheme.surface;
    final borderColor = widget.borderColor ?? colorScheme.outline;
    final borderRadius = widget.borderRadius ?? BorderRadius.circular(8);

    return Container(
      width: widget.width,
      height: widget.height,
      padding: widget.padding ?? const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
        border: Border.all(
          color: borderColor,
          width: widget.borderWidth!,
        ),
      ),
      child: Row(
        children: [
          // Decrement button
          _buildButton(
            icon: widget.decrementIcon!,
            onPressed: _currentValue > widget.minValue ? _decrement : null,
            color: buttonColor,
            disabledColor: buttonDisabledColor,
          ),

          // Quantity input field
          Expanded(
            child: TextFormField(
              controller: _controller,
              enabled: widget.enabled,
              textAlign: TextAlign.center,
              style:
                  widget.textStyle ??
                  theme.textTheme.bodyMedium?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w500,
                  ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(3),
              ],
              onChanged: _onTextChanged,
              onTap: () {
                setState(() {});
              },
              onEditingComplete: _onEditingComplete,
              onFieldSubmitted: (_) => _onEditingComplete(),
            ),
          ),

          // Increment button
          _buildButton(
            icon: widget.incrementIcon!,
            onPressed: _currentValue < widget.maxValue ? _increment : null,
            color: buttonColor,
            disabledColor: buttonDisabledColor,
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required IconData icon,
    required VoidCallback? onPressed,
    required Color color,
    required Color disabledColor,
  }) {
    return SizedBox(
      width: widget.height! - 4, // Square button based on height
      height: widget.height! - 4,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.enabled ? onPressed : null,
          borderRadius: BorderRadius.circular(6),
          child: Icon(
            icon,
            size: widget.iconSize,
            color: widget.enabled && onPressed != null ? color : disabledColor,
          ),
        ),
      ),
    );
  }
}
