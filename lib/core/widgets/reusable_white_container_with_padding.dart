import '../../views.dart';

class ReusableWhiteContainerWithPadding extends StatelessWidget {
  final Widget widget;
  const ReusableWhiteContainerWithPadding({super.key, required this.widget});

  @override
  Widget build(BuildContext context) {
    return ScalingFactor(
      child: ReusablePadding(
        padding: const EdgeInsets.only(bottom: 8),
        child: ReusableContainer(
          width: double.infinity,
          color: Colors.white,
          child: ReusablePadding(
            padding:
                const EdgeInsets.only(left: 22, right: 22, top: 24, bottom: 24),
            child: widget,
          ),
        ),
      ),
    );
  }
}
