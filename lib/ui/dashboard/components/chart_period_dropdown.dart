import 'package:flutter/material.dart';
import 'package:samgyup_serve/ui/components/components.dart';

class ChartPeriodDropdown extends StatefulWidget {
  const ChartPeriodDropdown({super.key, this.onChanged});

  final void Function(ChartPeriod period)? onChanged;

  @override
  State<ChartPeriodDropdown> createState() => _ChartPeriodDropdownState();
}

class _ChartPeriodDropdownState extends State<ChartPeriodDropdown> {
  ChartPeriod value = ChartPeriod.weekly;
  final List<ChartPeriod> list = ChartPeriod.values;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return DropdownButton<ChartPeriod>(
      value: value,
      style: textTheme.bodyMedium,
      onChanged: (ChartPeriod? value) {
        setState(() {
          this.value = value!;
        });

        widget.onChanged?.call(this.value);
      },
      items: list.map<DropdownMenuItem<ChartPeriod>>((ChartPeriod value) {
        return DropdownMenuItem<ChartPeriod>(
          value: value,
          child: Text(value.label),
        );
      }).toList(),
    );
  }
}
