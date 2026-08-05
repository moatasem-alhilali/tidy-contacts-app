part of 'text.dart';

class DefaultTextColor extends StatelessWidget {
  const DefaultTextColor({required this.color, required this.child, super.key});
  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: DefaultTextStyle.of(context).style.copyWith(color: color),
      child: child,
    );
  }
}
