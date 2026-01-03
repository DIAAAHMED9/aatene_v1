import '../../general_index.dart'hide DeviceType;
import 'index.dart';
import 'stepper_step.dart';


class ResponsiveStepper extends StatelessWidget {
  final List<StepperStep> steps;
  final int currentStep;
  final ValueChanged<int>? onStepTapped;
  final bool isLinear;
  final Axis direction;
  final bool showStepNumbers;
  final Color activeColor;
  final Color completedColor;
  final Color inactiveColor;
  final EdgeInsets padding;
  final double spacing;

  const ResponsiveStepper({
    Key? key,
    required this.steps,
    required this.currentStep,
    this.onStepTapped,
    this.isLinear = false,
    this.direction = Axis.horizontal,
    this.showStepNumbers = true,
    this.activeColor = StepperConstants.primaryColor,
    this.completedColor = StepperConstants.successColor,
    this.inactiveColor = StepperConstants.disabledColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    this.spacing = 8.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isVertical =
        direction == Axis.vertical || DeviceType.isMobile(context);

    return Container(
      padding: padding,
      child: isVertical
          ? _buildVerticalStepper(context)
          : _buildHorizontalStepper(context),
    );
  }

  Widget _buildHorizontalStepper(BuildContext context) {
    final isMobile = DeviceType.isMobile(context);
    final isTablet = DeviceType.isTablet(context);
    final maxVisibleSteps = DeviceType.getMaxVisibleSteps(context);
    final showScroll = steps.length > maxVisibleSteps;

    Widget stepperContent = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: _buildStepItems(context, false),
    );

    if (showScroll) {
      stepperContent = SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: _buildStepItems(context, false)),
      );
    }

    return Container(
      height: isMobile
          ? StepperConstants.mobileStepHeight
          : isTablet
          ? StepperConstants.tabletStepHeight
          : StepperConstants.desktopStepHeight,
      child: stepperContent,
    );
  }

  Widget _buildVerticalStepper(BuildContext context) {
    return Column(children: _buildStepItems(context, true));
  }

  List<Widget> _buildStepItems(BuildContext context, bool isVertical) {
    return List.generate(steps.length, (index) {
      final step = steps[index];
      final isActive = index == currentStep;
      final isCompleted = index < currentStep;
      final isEnabled = !isLinear || index <= currentStep;

      if (isVertical) {
        return _buildVerticalStepItem(
          context,
          index,
          step,
          isActive,
          isCompleted,
          isEnabled,
        );
      } else {
        return _buildHorizontalStepItem(
          context,
          index,
          step,
          isActive,
          isCompleted,
          isEnabled,
        );
      }
    });
  }

  Widget _buildHorizontalStepItem(
    BuildContext context,
    int index,
    StepperStep step,
    bool isActive,
    bool isCompleted,
    bool isEnabled,
  ) {
    final isMobile = DeviceType.isMobile(context);
    final circleSize = isMobile
        ? StepperConstants.stepCircleSizeMobile
        : DeviceType.isTablet(context)
        ? StepperConstants.stepCircleSizeTablet
        : StepperConstants.stepCircleSizeDesktop;

    return GestureDetector(
      onTap: isEnabled ? () => onStepTapped?.call(index) : null,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: spacing / 2),
        padding: isMobile
            ? StepperConstants.stepPaddingMobile
            : DeviceType.isTablet(context)
            ? StepperConstants.stepPaddingTablet
            : StepperConstants.stepPaddingDesktop,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _getStepBorderColor(isActive, isCompleted),
            width: isActive ? 2 : 1,
          ),
          boxShadow: _getStepShadow(isActive),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: circleSize,
              height: circleSize,
              decoration: BoxDecoration(
                color: _getStepCircleColor(isActive, isCompleted),
                shape: BoxShape.circle,
                border: Border.all(
                  color: _getStepCircleBorderColor(isActive, isCompleted),
                  width: 2,
                ),
              ),
              child: Center(
                child: _buildStepIcon(index, isActive, isCompleted, circleSize),
              ),
            ),
            SizedBox(width: spacing),

            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.title,
                  style: TextStyle(
                    fontFamily: "PingAR",
                    fontSize: isMobile ? 14 : 12,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    color: _getStepTextColor(isActive, isCompleted),
                  ),
                ),
                if (step.subtitle.isNotEmpty)
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 120),
                    child: Text(
                      step.subtitle,
                      style: TextStyle(
                        fontFamily: "PingAR",
                        fontSize: isMobile ? 12 : 10,
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerticalStepItem(
    BuildContext context,
    int index,
    StepperStep step,
    bool isActive,
    bool isCompleted,
    bool isEnabled,
  ) {
    return GestureDetector(
      onTap: isEnabled ? () => onStepTapped?.call(index) : null,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: spacing / 2),
        padding: StepperConstants.stepPaddingMobile,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _getStepBorderColor(isActive, isCompleted),
            width: isActive ? 2 : 1,
          ),
          boxShadow: _getStepShadow(isActive),
        ),
        child: Row(
          children: [
            Column(
              children: [
                if (index > 0)
                  Container(
                    width: 2,
                    height: 16,
                    color: isCompleted ? completedColor : Colors.grey[300],
                  ),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: _getStepCircleColor(isActive, isCompleted),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _getStepCircleBorderColor(isActive, isCompleted),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: _buildStepIcon(index, isActive, isCompleted, 32),
                  ),
                ),
                if (index < steps.length - 1)
                  Container(
                    width: 2,
                    height: 16,
                    color: isCompleted ? completedColor : Colors.grey[300],
                  ),
              ],
            ),

            SizedBox(width: spacing * 2),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.title,
                    style: TextStyle(
                      fontFamily: "PingAR",
                      fontSize: 16,
                      fontWeight: isActive
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: _getStepTextColor(isActive, isCompleted),
                    ),
                  ),
                  if (step.subtitle.isNotEmpty)
                    Text(
                      step.subtitle,
                      style:getRegular(fontSize: 14, color: Colors.grey),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStepBorderColor(bool isActive, bool isCompleted) {
    if (isActive) return activeColor;
    if (isCompleted) return completedColor;
    return Colors.grey[300]!;
  }

  Color _getStepCircleColor(bool isActive, bool isCompleted) {
    if (isCompleted) return completedColor;
    if (isActive) return activeColor.withOpacity(0.1);
    return Colors.transparent;
  }

  Color _getStepCircleBorderColor(bool isActive, bool isCompleted) {
    if (isActive) return activeColor;
    if (isCompleted) return completedColor;
    return Colors.grey[300]!;
  }

  Color _getStepTextColor(bool isActive, bool isCompleted) {
    if (isActive) return activeColor;
    if (isCompleted) return completedColor;
    return Colors.grey[800]!;
  }

  List<BoxShadow>? _getStepShadow(bool isActive) {
    return isActive
        ? [
            BoxShadow(
              color: activeColor.withOpacity(0.1),
              blurRadius: 8,
              spreadRadius: 1,
              offset: Offset(0, 2),
            ),
          ]
        : null;
  }

  Widget _buildStepIcon(
    int index,
    bool isActive,
    bool isCompleted,
    double size,
  ) {
    if (isCompleted) {
      return Icon(Icons.check, size: size * 0.5, color: Colors.white);
    }

    if (showStepNumbers) {
      return Text(
        '${index + 1}',
        style: TextStyle(
          fontFamily: "PingAR",
          fontSize: size * 0.4,
          fontWeight: FontWeight.bold,
          color: isActive ? activeColor : Colors.grey[600],
        ),
      );
    }

    return Icon(
      isActive ? Icons.circle : Icons.radio_button_unchecked,
      size: size * 0.4,
      color: isActive ? activeColor : Colors.grey[400],
    );
  }
}
