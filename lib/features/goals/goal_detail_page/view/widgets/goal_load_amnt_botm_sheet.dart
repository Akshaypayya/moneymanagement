import 'package:growk_v2/features/goals/goal_detail_page/controller/goals_funds_controller.dart';
import 'package:growk_v2/features/goals/goal_detail_page/repo/amnt_ip_section.dart';
import 'package:growk_v2/features/goals/goal_detail_page/view/widgets/amnt_load_btn.dart';
import 'package:growk_v2/views.dart';

class LoadFundsBottomSheet extends ConsumerStatefulWidget {
  final String? goalName;
  final VoidCallback? onSuccess;

  const LoadFundsBottomSheet({
    Key? key,
    this.goalName,
    this.onSuccess,
  }) : super(key: key);

  @override
  ConsumerState<LoadFundsBottomSheet> createState() =>
      _LoadFundsBottomSheetState();
}

class _LoadFundsBottomSheetState extends ConsumerState<LoadFundsBottomSheet> {
  final TextEditingController _amountController = TextEditingController();
  final FocusNode _amountFocusNode = FocusNode();
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.listen(loadAmountProvider, (previous, current) {
        if (_amountController.text != current) {
          _amountController.text = current;
        }
      });
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _amountFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(isDarkProvider);
    final controller = ref.read(loadFundsControllerProvider);
    final loadAmount = ref.watch(loadAmountProvider);
    final isLoading = ref.watch(isLoadingFundsProvider);

    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[900] : Colors.white,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Load Funds Manually',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Move money from your main wallet and get one step closer to your dream.',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    color: isDark ? Colors.grey[300] : Colors.grey[600],
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),
                buildAmountInputSection(
                    isDark, controller, _amountController, _amountFocusNode),
                const SizedBox(height: 32),
                buildLoadAmountButton(
                    context,
                    isDark,
                    controller,
                    isLoading,
                    _amountController,
                    ref,
                    '${widget.goalName}',
                    widget.onSuccess),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
