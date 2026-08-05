part of 'avatar.dart';

class OverlappingAvatarsWidget extends StatelessWidget {
  const OverlappingAvatarsWidget({
    required this.avatars,
    this.circleDiameter,
    this.overlap,
    super.key,
  });

  final List<Widget> avatars;
  final double? circleDiameter;
  final double? overlap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ...List.generate(
          avatars.length,
          (index) => _buildAvatar(
            avatars.length - index - 1,
            index,
            context,
          ),
        ),
      ],
    );
  }

  Widget _buildAvatar(int reverseIndex, int index, BuildContext context) {
    return PositionedDirectional(
      start: reverseIndex == 0 ? null : reverseIndex * (overlap ?? 17).h,
      child: context.responsive(
        desktop: CircleAvatar(
          radius: 24.h,
          backgroundColor: context.colors.onSecondaryContainer,
          child: CircleAvatar(
            radius: 22.h,
            child: avatars[index],
          ),
        ),
        mobile: CircleAvatar(
          radius: (circleDiameter ?? 18).h,
          backgroundColor: context.colors.onSecondaryContainer,
          child: CircleAvatar(
            radius: (circleDiameter ?? 16).h,
            child: avatars[index],
          ),
        ),
      ),
    );
  }
}
