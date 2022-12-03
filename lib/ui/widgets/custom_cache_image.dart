part of 'widgets.dart';

class CustomCacheImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final double width, height;
  final ProgressIndicatorBuilder? progressIndicatorBuilder;

  const CustomCacheImage(
      {super.key,
      required this.imageUrl,
      required this.width,
      required this.height,
      this.fit = BoxFit.cover,
      this.progressIndicatorBuilder});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      width: width,
      height: height,
      progressIndicatorBuilder: progressIndicatorBuilder ??
          (context, url, downloadProgress) => Center(
                child: SpinKitFoldingCube(
                  color: SharedValue.primaryColor,
                  size: 20,
                ),
              ),
    );
  }
}
