import 'package:flutter/material.dart';

class ActionCard extends StatelessWidget {
  const ActionCard({
    required this.title,
    super.key,
    this.subtitle,
    this.leading,
    this.onTap,
    this.elevation,
    this.borderRadius,
    this.padding,
    this.color,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final VoidCallback? onTap;
  final double? elevation;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final radius = borderRadius ?? BorderRadius.circular(16);

    return Card(
      color: color ?? theme.colorScheme.surfaceContainerLow,
      elevation: elevation ?? 2,
      shape: RoundedRectangleBorder(borderRadius: radius),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        splashFactory: InkRipple.splashFactory,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isCompact =
                constraints.maxWidth < 180 || constraints.maxHeight < 120;
            final spacing = isCompact ? 8.0 : 12.0;
            final iconSize = isCompact ? 28.0 : 36.0;
            final resolvedPadding =
                padding ?? EdgeInsets.all(isCompact ? 12 : 16);

            return Padding(
              padding: resolvedPadding,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (leading != null)
                      IconTheme(
                        data: IconThemeData(
                          size: iconSize,
                          color: theme.colorScheme.primary,
                        ),
                        child: leading!,
                      ),
                    if (leading != null) SizedBox(height: spacing),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: isCompact
                          ? textTheme.titleMedium
                          : textTheme.titleLarge,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitle != null) ...[
                      SizedBox(height: spacing / 2),
                      Text(
                        subtitle!,
                        textAlign: TextAlign.center,
                        style: textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
