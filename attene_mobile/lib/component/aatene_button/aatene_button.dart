
import '../../general_index.dart';
import '../../utils/responsive/responsive_dimensions.dart';


class AateneButton extends StatelessWidget {
  const AateneButton({
    super.key,
    required this.buttonText,
    this.borderColor,
    this.color,
    this.textColor,
    this.onTap,
    this.isLoading = false,
    this.raduis = 99,
  });

  final Function()? onTap;
  final String buttonText;
  final Color? borderColor;
  final Color? color;
  final Color? textColor;
  final bool isLoading;
  final double raduis;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: ResponsiveDimensions.w(6)),
        height: ResponsiveDimensions.h(48),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(raduis),
          border: Border.all(color: borderColor ?? AppColors.neutral100, width: 1),
        ),
        child: isLoading
            ? SizedBox(
                width: ResponsiveDimensions.w(20),
                height: ResponsiveDimensions.h(20),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                buttonText,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w700,
                  fontFamily: "PingAR",
                ),
              ),
      ),
    );
  }
}