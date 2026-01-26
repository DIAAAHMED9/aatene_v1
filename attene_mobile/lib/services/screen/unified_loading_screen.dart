

import 'dart:async';

import '../../general_index.dart';

class UnifiedLoadingScreen {
  static final RxDouble _currentProgress = 0.0.obs;
  static final RxString _currentMessage = ''.obs;
  static String? _currentDialogId;

  static void show({
    String? message,
    bool isDismissible = false,
    bool showProgress = false,
    double? progressValue,
    Color? backgroundColor,
    Color? progressColor,
    String? dialogId,
  }) {
    if (!Get.isRegistered<AppLifecycleManager>()) {
      print('⚠️ [LOADING] AppLifecycleManager غير مسجل، تخطي التحقق');
      _showDialogInternal(
        message: message,
        isDismissible: isDismissible,
        showProgress: showProgress,
        progressValue: progressValue,
        backgroundColor: backgroundColor,
        progressColor: progressColor,
        dialogId: dialogId,
      );
      return;
    }

    final lifecycleManager = Get.find<AppLifecycleManager>();
    if (!lifecycleManager.canShowDialogs) {
      print('⚠️ [LOADING] Cannot show dialog - app is not in active state');
      return;
    }

    _showDialogInternal(
      message: message,
      isDismissible: isDismissible,
      showProgress: showProgress,
      progressValue: progressValue,
      backgroundColor: backgroundColor,
      progressColor: progressColor,
      dialogId: dialogId,
    );
  }

  static void _showDialogInternal({
    String? message,
    bool isDismissible = false,
    bool showProgress = false,
    double? progressValue,
    Color? backgroundColor,
    Color? progressColor,
    String? dialogId,
  }) {
    if (Get.isDialogOpen ?? false) {
      if (dialogId != null && _currentDialogId == dialogId) {
        _currentMessage.value = message ?? 'جاري التحميل...';
        if (progressValue != null) {
          _currentProgress.value = progressValue;
        }
        return;
      } else {
        dismiss();
      }
    }

    _currentDialogId = dialogId;
    _currentMessage.value = message ?? 'جاري التحميل...';
    if (progressValue != null) {
      _currentProgress.value = progressValue;
    }

    try {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (Get.isDialogOpen ?? false) return;
        Get.dialog(
        Material(
          type: MaterialType.transparency,
          child: WillPopScope(
          onWillPop: () async => isDismissible,
          child: _LoadingDialog(
            message: message,
            isDismissible: isDismissible,
            showProgress: showProgress,
            progressValue: progressValue,
            backgroundColor: backgroundColor,
            progressColor: progressColor,
          ),
        ),
        ),
        barrierDismissible: isDismissible,
        barrierColor: Colors.black.withOpacity(0.5),
        );
      });
    } catch (e) {
      print('❌ [LOADING] Error showing dialog: $e');
    }
  }

  static void updateProgress(double progress, {String? message}) {
    _currentProgress.value = progress;
    if (message != null) {
      _currentMessage.value = message;
    }
  }

  static void updateMessage(String message) {
    _currentMessage.value = message;
  }

  static void dismiss() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
    _currentDialogId = null;
  }

  static Future<T?> showWithFuture<T>(
    Future<T> future, {
    String? message,
    String? dialogId,
    Function(dynamic error)? onError,
    bool showProgress = false,
  }) async {
    show(message: message, dialogId: dialogId, showProgress: showProgress);

    try {
      final result = await future;
      dismiss();
      return result;
    } catch (e) {
      dismiss();
      if (onError != null) {
        onError(e);
      } else {
        Get.snackbar(
          'خطأ',
          'حدث خطأ أثناء العملية',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
      rethrow;
    }
  }

  static void showProgressIndicator({
    required String message,
    required Stream<double> progressStream,
    Function()? onComplete,
    Function(dynamic error)? onError,
  }) {
    show(message: message, showProgress: true);

    final subscription = progressStream.listen(
      (progress) {
        updateProgress(progress);
      },
      onError: (error) {
        dismiss();
        if (onError != null) {
          onError(error);
        }
      },
      onDone: () {
        dismiss();
        if (onComplete != null) {
          onComplete();
        }
      },
    );

    Get.find<StreamSubscription<double>?>()?.cancel();
    Get.put(subscription, permanent: false);
  }
}

class _LoadingDialog extends StatelessWidget {
  final String? message;
  final bool isDismissible;
  final bool showProgress;
  final double? progressValue;
  final Color? backgroundColor;
  final Color? progressColor;

  const _LoadingDialog({
    Key? key,
    this.message,
    this.isDismissible = false,
    this.showProgress = false,
    this.progressValue,
    this.backgroundColor,
    this.progressColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: EdgeInsets.zero,
      child: Center(
        child: Obx(() {
          final currentMessage = UnifiedLoadingScreen._currentMessage.value;
          final currentProgress = UnifiedLoadingScreen._currentProgress.value;

          return Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: backgroundColor ?? Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            constraints: const BoxConstraints(maxWidth: 300, minWidth: 250),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        progressColor ?? Theme.of(context).primaryColor,
                        progressColor?.withOpacity(0.7) ??
                            Theme.of(context).primaryColor.withOpacity(0.7),
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(15),
                  child: CircularProgressIndicator(
                    strokeWidth: 4,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
                    backgroundColor: Colors.white.withOpacity(0.3),
                    value: showProgress ? currentProgress : null,
                  ),
                ),

                const SizedBox(height: 25),

                Text(
                  currentMessage,
                  style: getMedium(),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                if (showProgress) ...[
                  const SizedBox(height: 15),
                  Text(
                    '${(currentProgress * 100).toStringAsFixed(0)}%',
                    style: getRegular(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: currentProgress,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        progressColor ?? Theme.of(context).primaryColor,
                      ),
                      minHeight: 6,
                    ),
                  ),
                ],

                const SizedBox(height: 5),

                if (isDismissible)
                  Text(
                    'يمكنك النقر خارج الصندوق للإلغاء',
                    style: getRegular(fontSize: 12, color: Colors.grey),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}