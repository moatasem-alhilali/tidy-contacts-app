part of 'text.dart';

class StaticTextScale extends StatelessWidget {
  const StaticTextScale({required this.child, super.key, this.scale = 1});

  final Widget child;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.linear(scale),
      ),
      child: child,
    );
  }
}
