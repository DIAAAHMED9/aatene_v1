import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import '../../general_index.dart';
import 'responsive_custom_stepper.dart';
import 'stepper_step.dart';
// import 'responsive_custom_stepper.dart';

abstract class StepperScreenBase extends StatefulWidget {
  final String appBarTitle;
  final Color primaryColor;
  final bool showAppBar;
  final bool showBackButton;
  final bool isLinear;
  final Widget? customAppBar;
  final Widget? bottomNavigation;

  const StepperScreenBase({
    Key? key,
    required this.appBarTitle,
    this.primaryColor = AppColors.primary400,
    this.showAppBar = true,
    this.showBackButton = true,
    this.isLinear = false,
    this.customAppBar,
    this.bottomNavigation,
  }) : super(key: key);
}

abstract class StepperScreenBaseState<T extends StepperScreenBase>
    extends State<T> {
  late int currentStep;
  late List<StepperStep> steps;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    currentStep = getInitialStep();
    steps = getSteps();
    initializeControllers();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<StepperStep> getSteps();

  Widget buildStepContent(int stepIndex);

  /// Initialize any controllers used by the stepper screen.
  ///
  /// Note: This is `Future<void>` to be flexible across screens that need async
  /// setup. It is called from `initState()` without awaiting.
  Future<void> initializeControllers();

  int getInitialStep() => 0;

  Future<bool> onWillPop() async => true;

  void onStepChanged(int oldStep, int newStep) {}

  bool validateStep(int stepIndex) => true;

  Future<void> onFinish() async {}

  Future<void> onCancel() async {}

  Widget buildNextButton() => _buildDefaultNextButton();

  Widget buildBackButton() => _buildDefaultBackButton();

  Widget buildStepNavigation() => _buildDefaultStepNavigation();

  String _getCurrentStepTitle() {
    if (steps.isEmpty || currentStep >= steps.length) {
      return widget.appBarTitle;
    }

    final step = steps[currentStep];
    if (step.title is Text) {
      return (step.title as Text).data ?? widget.appBarTitle;
    } else if (step.title is String) {
      return step.title as String;
    } else {
      return widget.appBarTitle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          final shouldPop = await onWillPop();
          if (shouldPop) {
            Get.back();
          }
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: _buildAppBar(context),
        body: ResponsiveCustomStepper(
          steps: steps,
          currentStep: currentStep,
          onStepTapped: (step) => _onStepTapped(step),
          isLinear: widget.isLinear,
          builder: (context, stepIndex) {
            return Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 16,
                    ),
                    child: buildStepContent(stepIndex),
                  ),
                ),
                KeyboardVisibilityBuilder(
                  builder: (BuildContext context, bool isVisible) {
                    return isVisible
                        ? const SizedBox()
                        : widget.bottomNavigation ?? buildStepNavigation();
                  },
                ),
                SizedBox(height: 56),
              ],
            );
          },
        ),
      ),
    );
  }

  PreferredSizeWidget? _buildAppBar(BuildContext context) {
    if (!widget.showAppBar) return null;

    if (widget.customAppBar != null) {
      return widget.customAppBar as PreferredSizeWidget;
    }

    return AppBar(
      title: Text(_getCurrentStepTitle(), style: getBold(fontSize: 18)),
      backgroundColor: Colors.white,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leading: widget.showBackButton
          ? IconButton(
              onPressed: () async {
                if (currentStep > 0) {
                  previousStep();
                } else {
                  await onCancel();
                }
              },
              icon: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.grey[100],
                ),
                child: Icon(Icons.arrow_back, color: AppColors.neutral100),
              ),
            )
          : null,
      actions: _buildAppBarActions(),
    );
  }

  List<Widget>? _buildAppBarActions() {
    return null;
  }

  void _onStepTapped(int step) {
    if (step <= currentStep && !widget.isLinear) {
      if (validateStep(currentStep)) {
        _animateToStep(step);
      }
    } else if (step == currentStep + 1 && widget.isLinear) {
      if (validateStep(currentStep)) {
        nextStep();
      }
    }
  }

  void _animateToStep(int step) {
    final oldStep = currentStep;
    setState(() {
      currentStep = step;
    });

    // PageController might temporarily have no clients (e.g., when returning from another route
    // like MediaLibrary). Guard against 'PageController is not attached to a PageView.'
    void go() {
      if (!mounted) return;
      if (!_pageController.hasClients) return;
      _pageController.animateToPage(
        step,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      onStepChanged(oldStep, step);
    }

    if (_pageController.hasClients) {
      go();
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) => go());
    }
  }

  void nextStep() {
    print('press next');
    if (!validateStep(currentStep)) return;

    if (currentStep < steps.length - 1) {
      _animateToStep(currentStep + 1);
    } else {
      onFinish();
    }
  }

  void previousStep() {
    if (currentStep > 0) {
      _animateToStep(currentStep - 1);
    }
  }

  void jumpToStep(int step) {
    if (step >= 0 && step < steps.length) {
      _animateToStep(step);
    }
  }

  Widget _buildDefaultStepNavigation() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[300]!, width: 1.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (currentStep > 0) buildBackButton(),
          if (currentStep > 0) const SizedBox(width: 16),
          Expanded(child: buildNextButton()),
        ],
      ),
    );
  }

  Widget _buildDefaultBackButton() {
    return Expanded(
      child: AateneButton(
        onTap: previousStep,
        buttonText: "رجوع",
        borderColor: AppColors.primary400,
        color: AppColors.light1000,
        textColor: AppColors.primary400,
      ),
      // OutlinedButton(
      //   style: OutlinedButton.styleFrom(
      //     padding: const EdgeInsets.symmetric(vertical: 16),
      //     side: BorderSide(color: AppColors.primary400, width: 2),
      //     shape: RoundedRectangleBorder(
      //       borderRadius: BorderRadius.circular(12),
      //     ),
      //   ),
      //   child: Text('رجوع', style: getMedium(color: AppColors.primary400)),
      // ),
    );
  }

  Widget _buildDefaultNextButton() {
    return AateneButton(
      onTap: nextStep,
      buttonText: currentStep == steps.length - 1 ? 'إنهاء' : 'التالي',
      color: AppColors.primary400,
      borderColor: AppColors.primary400,
      textColor: AppColors.light1000,
    );
    // ElevatedButton(
    //   onPressed: nextStep,
    //   style: ElevatedButton.styleFrom(
    //     padding: const EdgeInsets.symmetric(vertical: 16),
    //     backgroundColor: widget.primaryColor,
    //     foregroundColor: AppColors.primary400,
    //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
    //     elevation: 3,
    //   ),
    //   child: Padding(
    //     padding: const EdgeInsets.symmetric(horizontal: 24),
    //     child: Text(
    //       currentStep == steps.length - 1 ? 'إنهاء' : 'التالي',
    //       style: getMedium(),
    //     ),
    //   ),
    // );
  }
}
