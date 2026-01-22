
import '../../../general_index.dart';

class CurvedBackground extends StatelessWidget {
  const CurvedBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _CurveClipper(),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.52,
        width: double.infinity,
        color: AppColors.primary400,
      ),
    );
  }
}

class _CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..lineTo(0, size.height - 90)
      ..quadraticBezierTo(
        size.width / 2,
        size.height,
        size.width,
        size.height - 90,
      )
      ..lineTo(size.width, 0)
      ..close();
  }

  @override
  bool shouldReclip(_) => false;
}
