import 'package:growk_v2/views.dart';

class OtpInputField extends ConsumerStatefulWidget {
  final Function(String) onCompleted;

  const OtpInputField({super.key, required this.onCompleted});

  @override
  ConsumerState<OtpInputField> createState() => _OtpInputFieldState();
}

class _OtpInputFieldState extends ConsumerState<OtpInputField> {
  late TextEditingController _otpController;

  @override
  void initState() {
    super.initState();
    _otpController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(isDarkProvider);
    final otpInput = ref.watch(otpInputProvider);

    if (otpInput.isEmpty && _otpController.text.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _otpController.clear();
      });
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: PinCodeTextField(
        controller: _otpController,
        appContext: context,
        length: 4,
        obscureText: false,
        animationType: AnimationType.fade,
        autoFocus: true,
        cursorColor: AppColors.current(isDark).text,
        textStyle: TextStyle(
          fontSize: 20,
          color: AppColors.current(isDark).text,
          fontWeight: FontWeight.w600,
        ),
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(10),
          fieldHeight: 50,
          fieldWidth: 50,
          activeFillColor: const Color.fromRGBO(83, 83, 83, 1),
          inactiveFillColor: Colors.transparent,
          selectedFillColor: Colors.transparent,
          activeColor: AppColors.current(isDark).text,
          inactiveColor:AppColors.current(isDark).text,
          selectedColor: AppColors.current(isDark).text,
          borderWidth: 0.8,
        ),
        animationDuration: const Duration(milliseconds: 300),
        enableActiveFill: true,
        keyboardType: TextInputType.number,
        onCompleted: widget.onCompleted,
        onChanged: (value) {
          ref.read(otpInputProvider.notifier).state = value;
        },
      ),
    );
  }
}
