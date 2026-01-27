//
// import 'package:flutter/material.dart';
//
// /// بديل خفيف لـ package:readmore حتى لا تعتمد على أي باكج خارجي.
// /// يدعم فقط TrimMode.line + trimLines + نص (عرض المزيد/أقل)
// enum TrimMode { Line }
//
// class ReadMoreText extends StatefulWidget {
//   final String data;
//   final TrimMode trimMode;
//   final int trimLines;
//   final String trimCollapsedText;
//   final String trimExpandedText;
//   final TextStyle? style;
//   final TextStyle? moreStyle;
//   final Color? colorClickableText;
//
//   const ReadMoreText(
//     this.data, {
//     super.key,
//     this.trimMode = TrimMode.Line,
//     this.trimLines = 3,
//     this.trimCollapsedText = 'عرض المزيد',
//     this.trimExpandedText = 'عرض أقل',
//     this.style,
//     this.moreStyle,
//     this.colorClickableText,
//   });
//
//   @override
//   State<ReadMoreText> createState() => _ReadMoreTextState();
// }
//
// class _ReadMoreTextState extends State<ReadMoreText> {
//   bool _expanded = false;
//
//   @override
//   Widget build(BuildContext context) {
//     final baseStyle = widget.style ?? DefaultTextStyle.of(context).style;
//     final linkStyle = widget.moreStyle ??
//         baseStyle.copyWith(
//           fontWeight: FontWeight.w600,
//           color: widget.colorClickableText ?? Theme.of(context).colorScheme.primary,
//         );
//
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         // Determine if text overflows with trimLines
//         final tp = TextPainter(
//           text: TextSpan(text: widget.data, style: baseStyle),
//           maxLines: widget.trimLines,
//           textDirection: Directionality.of(context),
//         )..layout(maxWidth: constraints.maxWidth);
//
//         final overflow = tp.didExceedMaxLines;
//
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               widget.data,
//               style: baseStyle,
//               maxLines: _expanded ? null : widget.trimLines,
//               overflow: _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
//             ),
//             if (overflow)
//               GestureDetector(
//                 onTap: () => setState(() => _expanded = !_expanded),
//                 child: Padding(
//                   padding: const EdgeInsets.only(top: 6),
//                   child: Text(
//                     _expanded ? widget.trimExpandedText : widget.trimCollapsedText,
//                     style: linkStyle,
//                   ),
//                 ),
//               ),
//           ],
//         );
//       },
//     );
//   }
// }
