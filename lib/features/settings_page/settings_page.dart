import 'package:growk_v2/features/settings_page/widgets/settings_content_data.dart';
import 'package:growk_v2/views.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);
    return ScalingFactor(
        child: Scaffold(
            backgroundColor: AppColors.current(isDark).scaffoldBackground,
            body: SettingsContent()));
  }
}
