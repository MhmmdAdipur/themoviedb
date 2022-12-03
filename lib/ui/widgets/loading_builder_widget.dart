part of 'widgets.dart';

class LoadingBuilderWidget extends StatelessWidget {
  const LoadingBuilderWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SpinKitFadingCircle(color: SharedValue.primaryColor, size: 40),
          const SizedBox(height: 10),
          const AutoSizeText(
            'Mohon Tunggu',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 5),
          const AutoSizeText('Sedang memuat data...'),
        ],
      ),
    );
  }
}
