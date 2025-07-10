import 'package:flutter/services.dart';
import 'package:growk_v2/features/goals/add_goal_page/controller/saving_slider_controller.dart';
import 'package:growk_v2/views.dart';

Widget amntDispRow(
    bool isDark, SavingAmountSliderController controller, WidgetRef ref) {
  final texts = ref.watch(appTextsProvider);
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        texts.targtAmnt,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          fontFamily: GoogleFonts.poppins().fontFamily,
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
      Image.asset(
        AppImages.sarSymbol,
        height: 13,
        color: AppColors.current(isDark).primary,
      ),
      const SizedBox(width: 5),
      SizedBox(
        width: 80,
        child: Transform.translate(
          offset: const Offset(0, -8),
          child: TextField(
            controller: controller.controller,
            focusNode: controller.focusNode,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.start,
            onChanged: controller.onTextChanged,
            onSubmitted: (_) => controller.onEditingComplete(),
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              fontFamily: GoogleFonts.poppins().fontFamily,
              color: isDark ? Colors.white : Colors.black,
            ),
            cursorColor: isDark ? Colors.white : Colors.black,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
              LengthLimitingTextInputFormatter(15),
            ],
            decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: isDark ? Colors.grey[600]! : Colors.grey[400]!,
                ),
              ),
              contentPadding: const EdgeInsets.fromLTRB(3, 10, 0, -10),
              hintText: '10K - 1M',
              hintStyle: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.grey[500] : Colors.grey[400],
              ),
            ),
          ),
        ),
      ),
    ],
  );
}
