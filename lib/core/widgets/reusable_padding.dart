import 'package:growk_v2/views.dart';

class ReusablePadding extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final Widget child;

  const ReusablePadding({
    super.key,
    required this.padding,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ScalingFactor(
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}
