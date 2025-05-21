import '../../../views.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(cellNoControllerProvider);
    final errorText = ref.watch(phoneValidationProvider);
    final loginController = ref.read(loginControllerProvider);

    return ScalingFactor(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: CustomScaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: ReusableColumn(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                LoginTopIcon(),
                LoginTopText(),
                GrowkPhoneField(controller: controller, errorText: errorText),
                const ReusableSizedBox(height: 250),
                GrowkButton(
                  onTap: () => loginController.validatePhone(context),
                  title: 'Continue',
                ),
                LoginBottomText(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
