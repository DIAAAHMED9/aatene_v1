import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../custom_stepper/responsive_custom_stepper.dart';

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
    this.primaryColor = Colors.blue,
    this.showAppBar = true,
    this.showBackButton = true,
    this.isLinear = false,
    this.customAppBar,
    this.bottomNavigation,
  }) : super(key: key);
}

abstract class StepperScreenBaseState<T extends StepperScreenBase> extends State<T> {
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
  void initializeControllers();
  
  int getInitialStep() => 0;
  Future<bool> onWillPop() async => true;
  void onStepChanged(int oldStep, int newStep) {}
  bool validateStep(int stepIndex) => true;
  Future<void> onFinish() async {}
  Future<void> onCancel() async {}
  Widget buildNextButton() => _buildDefaultNextButton();
  Widget buildBackButton() => _buildDefaultBackButton();
  Widget buildStepNavigation() => _buildDefaultStepNavigation();

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
                    padding: const EdgeInsets.all(16.0),
                    child: buildStepContent(stepIndex),
                  ),
                ),
                widget.bottomNavigation ?? buildStepNavigation(),
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
      title: Text(
        widget.appBarTitle,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: widget.primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leading: widget.showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () async {
                if (currentStep > 0) {
                  previousStep();
                } else {
                  await onCancel();
                }
              },
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
    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    onStepChanged(oldStep, step);
  }

  void nextStep() {
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
        border: Border(
          top: BorderSide(color: Colors.grey[300]!, width: 1.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 100),
        child: Row(
          children: [
            if (currentStep > 0) buildBackButton(),
            if (currentStep > 0) const SizedBox(width: 16),
            Expanded(child: buildNextButton()),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultBackButton() {
    return Expanded(
      child: OutlinedButton(
        onPressed: previousStep,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          side: BorderSide(color: widget.primaryColor, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          'رجوع',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: widget.primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultNextButton() {
    return ElevatedButton(
      onPressed: nextStep,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: widget.primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 3,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Text(
          currentStep == steps.length - 1 ? 'إنهاء' : 'التالي',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}