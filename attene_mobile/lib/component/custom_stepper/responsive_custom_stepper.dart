

import '../../general_index.dart';
import 'stepper_step.dart';

class ResponsiveCustomStepper extends StatefulWidget {
  final List<StepperStep> steps;
  final int currentStep;
  final ValueChanged<int>? onStepTapped;
  final Widget Function(BuildContext, int) builder;
  final bool showLabels;
  final bool isLinear;

  const ResponsiveCustomStepper({
    Key? key,
    required this.steps,
    required this.currentStep,
    this.onStepTapped,
    required this.builder,
    this.showLabels = true,
    this.isLinear = false,
  }) : super(key: key);

  @override
  _ResponsiveCustomStepperState createState() =>
      _ResponsiveCustomStepperState();
}

class _ResponsiveCustomStepperState extends State<ResponsiveCustomStepper>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  int _previousStep = 0;
  bool _isForward = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(ResponsiveCustomStepper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentStep != widget.currentStep) {
      _isForward = widget.currentStep > oldWidget.currentStep;
      _previousStep = oldWidget.currentStep;
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1024;
    final isKeyboardVisible = MediaQuery
        .of(context)
        .viewInsets
        .bottom > 100;

    return Column(
      children: [
        _buildResponsiveStepperHeader(isMobile, isTablet),

        Expanded(child: widget.builder(context, widget.currentStep)),
      ],
    );
  }

  Widget _buildResponsiveStepperHeader(bool isMobile, bool isTablet) {
    final maxVisibleSteps = isMobile
        ? 3
        : isTablet
        ? 4
        : 6;
    final shouldScroll = widget.steps.length > maxVisibleSteps;

    Widget stepperContent = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(widget.steps.length, (index) {
        return _buildStepWithConnector(
          index: index,
          isMobile: isMobile,
          isTablet: isTablet,
        );
      }),
    );

    if (shouldScroll) {
      stepperContent = SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(widget.steps.length, (index) {
            return _buildStepWithConnector(
              index: index,
              isMobile: isMobile,
              isTablet: isTablet,
            );
          }),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.only(
        top: 25,
        left: isMobile ? 8 : 16,
        right: isMobile ? 8 : 16,
      ),
      child: stepperContent,
    );
  }

  Widget _buildStepWithConnector({
    required int index,
    required bool isMobile,
    required bool isTablet,
  }) {
    final step = widget.steps[index];
    final isActive = index == widget.currentStep;
    final isCompleted = index < widget.currentStep;
    final isPrevious = index == _previousStep;
    final isNext = index == widget.currentStep + 1;
    final isLast = index == widget.steps.length - 1;

    return Container(
      constraints: BoxConstraints(
        minWidth: isMobile ? 60 : 80,
        maxWidth: isMobile ? 80 : 100,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _AnimatedStepCircle(
            step: step,
            stepNumber: index + 1,
            isActive: isActive,
            isCompleted: isCompleted,
            isPrevious: isPrevious,
            isNext: isNext,
            animation: _animationController,
            onTap: () {
              if (!widget.isLinear || index <= widget.currentStep) {
                widget.onStepTapped?.call(index);
              }
            },
            isMobile: isMobile,
          ),

          if (!isLast)
            Container(
              width: isMobile ? 15 : 20,
              height: 2,
              margin: EdgeInsets.symmetric(horizontal: isMobile ? 1 : 2),
              child: _AnimatedStepConnector(
                isActive: isCompleted || isActive,
                isPrevious: isPrevious,
                isNext: isNext,
                currentStep: widget.currentStep,
                stepIndex: index,
                animation: _animationController,
              ),
            ),
        ],
      ),
    );
  }
}

class _AnimatedStepCircle extends StatelessWidget {
  final StepperStep step;
  final int stepNumber;
  final bool isActive;
  final bool isCompleted;
  final bool isPrevious;
  final bool isNext;
  final Animation<double> animation;
  final VoidCallback? onTap;
  final bool isMobile;

  const _AnimatedStepCircle({
    Key? key,
    required this.step,
    required this.stepNumber,
    required this.isActive,
    required this.isCompleted,
    required this.isPrevious,
    required this.isNext,
    required this.animation,
    this.onTap,
    required this.isMobile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final circleSize = isMobile ? 36.0 : 40.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: circleSize,
        height: circleSize,
        margin: EdgeInsets.symmetric(horizontal: isMobile ? 3 : 4),
        child: AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            final scale = isActive || isNext
                ? Tween<double>(begin: 0.8, end: 1.0)
                .animate(
              CurvedAnimation(
                parent: animation,
                curve: isActive
                    ? Curves.elasticOut
                    : Curves.easeInOut,
              ),
            )
                .value
                : 1.0;

            return Transform.scale(
              scale: scale,
              child: Stack(
                  alignment: Alignment.center,
                  children: [
              AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              width: circleSize,
              height: circleSize,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isCompleted || isActive
                      ? AppColors.primary400
                      : Colors.grey[300]!,
                  width: isMobile ? 2.0 : 2.5,
                ),
                boxShadow: (isActive || isNext)
                    ? [
                  BoxShadow(
                    color: AppColors.primary400.withOpacity(
                      0.3 * animation.value,
                    ),
                    blurRadius: isMobile ? 6 : 8,
                    spreadRadius: isMobile ? 1 : 2,
                    offset: const Offset(0, 2),
                  ),
                ]
                    : [],
              ),
            ),

            if (isCompleted || isActive)
            AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            width: isActive
            ? (isMobile ? 28 : 32)
                : (isMobile ? 30 : 34),
            height: isActive
            ? (isMobile ? 28 : 32)
                : (isMobile ? 30 : 34),
            curve: Curves.fastOutSlowIn,
            decoration: BoxDecoration(
            color: isCompleted
            ? AppColors.primary400.withOpacity(0.9)
                : Colors.transparent,
            shape: BoxShape.circle,
            ),
            ),

            AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            switchInCurve: Curves.elasticOut,
            switchOutCurve: Curves.easeInBack,
            child: isCompleted
            ? Icon(
            Icons.check_rounded,
            color: Colors.white,
            size: isMobile ? 16 : 18,
            key: ValueKey('check_$stepNumber'),
            )
                : (isActive
            ? Container(
            width: isMobile ? 10 : 12,
            height: isMobile ? 10 : 12,
            decoration: BoxDecoration(
            color: AppColors.primary400,
            shape: BoxShape.circle,
            boxShadow: [
            BoxShadow(
            color: AppColors.primary400.withOpacity(
            0.5,
            ),
            blurRadius: isMobile ? 3 : 4,
            spreadRadius: isMobile ? 0.5 : 1,
            ),
            ],
            ),
            key: ValueKey('dot_$stepNumber'),
            )
                : Text(
            stepNumber.toString(),
            style: getBold(
            color: Colors.grey,
            fontSize: isMobile ? 13 : 14,
            ),
            key: ValueKey('number_$stepNumber'),
            )),
            ),

            if (!isMobile)
            Positioned(
            bottom: -25,
            child: Column(
            children: [
            Text(
            step.title,
            style: TextStyle(
            fontFamily: "PingAR",
            fontSize: 12,
            fontWeight: isActive
            ? FontWeight.bold
                : FontWeight.normal,
            color: isActive || isCompleted
            ? AppColors.primary400
                : Colors.grey[600],
            ),
            ),
            if (step.subtitle.isNotEmpty)
            Text(
            step.subtitle,
            style: getRegular( fontSize: 10,
            color: Colors.grey,)
            ),
            ],
            ),
            )
            ,
            ]
            ,
            )
            ,
            );
          },
        ),
      ),
    );
  }
}

class _AnimatedStepConnector extends StatelessWidget {
  final bool isActive;
  final bool isPrevious;
  final bool isNext;
  final int currentStep;
  final int stepIndex;
  final Animation<double> animation;

  const _AnimatedStepConnector({
    Key? key,
    required this.isActive,
    required this.isPrevious,
    required this.isNext,
    required this.currentStep,
    required this.stepIndex,
    required this.animation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool shouldAnimate =
        (isPrevious && stepIndex == currentStep - 1) ||
            (isNext && stepIndex == currentStep);

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        double progress = 0.0;

        if (shouldAnimate) {
          progress = animation.value;
        } else if (isActive) {
          progress = 1.0;
        }

        return CustomPaint(
          painter: _StepConnectorPainter(
            progress: progress,
            isActive: isActive || shouldAnimate,
          ),
        );
      },
    );
  }
}

class _StepConnectorPainter extends CustomPainter {
  final double progress;
  final bool isActive;

  _StepConnectorPainter({required this.progress, required this.isActive});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint backgroundPaint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final Paint progressPaint = Paint()
      ..shader = LinearGradient(
        colors: [AppColors.primary400, AppColors.primary500],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      backgroundPaint,
    );

    if (isActive) {
      final double animatedWidth = size.width * progress;
      canvas.drawLine(
        Offset(0, size.height / 2),
        Offset(animatedWidth, size.height / 2),
        progressPaint,
      );

      if (progress > 0 && progress < 1) {
        final pulsePaint = Paint()
          ..color = AppColors.primary400.withOpacity(0.5 * (1 - progress))
          ..strokeWidth = 6
          ..strokeCap = StrokeCap.round;

        canvas.drawLine(
          Offset(animatedWidth - 2, size.height / 2),
          Offset(animatedWidth + 2, size.height / 2),
          pulsePaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _StepConnectorPainter oldDelegate) {
    return progress != oldDelegate.progress || isActive != oldDelegate.isActive;
  }
}
