import 'package:flutter/material.dart';
import 'package:pfa_flutter/utils/app_theme.dart';

class IconInfoRow extends StatelessWidget {
  final String text;
  final String? description;
  final IconData icon;
  final double? fontSize;
  final FontWeight? fontWeight;

  const IconInfoRow({
    required this.text,
    required this.icon,
    this.fontSize,
    this.description,
    this.fontWeight,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 20,
              color: AppTheme.primaryGreen,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      fontWeight: fontWeight ?? FontWeight.normal,
                      fontSize: fontSize ?? 14,
                      height: 1.5,
                    ),
                  ),
                  if (description != null)
                    Text(
                      description!,
                      style: const TextStyle(
                        fontSize: 12,
                        height: 1.5,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class InfoRow extends StatelessWidget {
  final String title;
  final TextStyle? style;
  final List<Widget>? children;

  const InfoRow({
    required this.title,
    this.style,
    this.children,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: style,
        ),
        if (children != null) ...[
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: children!,
          ),
        ],
      ],
    );
  }
}
