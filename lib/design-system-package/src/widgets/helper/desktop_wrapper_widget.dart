part of 'helper_widgets.dart';

class DesktopWrapperWidget extends StatelessWidget {
  const DesktopWrapperWidget({
    required this.child,
    this.withBackButton = true,
    super.key,
  });

  final Widget child;
  final bool withBackButton;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 720,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            child,
            if(withBackButton)...[
              context.insets.mn.verticalSpace,
              const ButtonBackWidget(),
              context.spaces.xl.verticalSpace,
            ],
          ],
        ),
      ),
    );
  }
}
