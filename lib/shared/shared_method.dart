part of 'shared.dart';

class SharedMethod {
  static void getSnackBar({
    required String title,
    required String message,
    bool isError = false,
    IconData? icon,
    Color? color,
    Duration? duration = const Duration(seconds: 3),
  }) =>
      Get.snackbar(
        title,
        message,
        titleText: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: SharedValue.whiteColor,
          ),
        ),
        colorText: SharedValue.whiteColor,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: SharedValue.primaryColor,
        margin: const EdgeInsets.all(8),
        duration: duration,
        borderRadius: 8,
        icon: Row(
          children: [
            Container(
              height: 70,
              width: 6,
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.horizontal(left: Radius.circular(8)),
                color: color ??
                    (isError
                        ? SharedValue.errorColor
                        : SharedValue.successColor),
              ),
            ),
            const SizedBox(width: 6),
            Icon(
              icon ??
                  (isError
                      ? EvaIcons.closeCircleOutline
                      : EvaIcons.checkmarkCircle),
              size: 28.0,
              color: color ??
                  (isError ? SharedValue.errorColor : SharedValue.successColor),
            ),
          ],
        ),
      );
}
