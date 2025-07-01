import '../../views.dart';

class CommonBottomSheet extends ConsumerStatefulWidget {
  final String title;
  final List<String> options;
  final void Function(String) onSelected;
  final bool showSearch;

  const CommonBottomSheet({
    super.key,
    required this.title,
    required this.options,
    required this.onSelected,
    this.showSearch=true,
  });

  @override
  ConsumerState<CommonBottomSheet> createState() => _CommonBottomSheetState();
}

class _CommonBottomSheetState extends ConsumerState<CommonBottomSheet> {
  late List<String> filteredOptions;
  final TextEditingController _searchController = TextEditingController();


  @override
  void initState() {
    super.initState();
    filteredOptions = widget.options;
    _searchController.addListener(() {
      final query = _searchController.text.toLowerCase();
      setState(() {
        filteredOptions = widget.options
            .where((item) => item.toLowerCase().contains(query))
            .toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(isDarkProvider);
    final textStyles = AppTextStyle.current(isDark);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: isDark?Colors.grey[900]:AppColors.current(isDark).background,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Center(
              child: ReusableText(
                text: widget.title,
                style: textStyles.titleMedium,
              ),
            ),
            const SizedBox(height: 12),
            showSearch == true ?Container(
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[800] : Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextField(
                controller: _searchController,
                style: textStyles.bodyRegular,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: textStyles.labelSmall,
                  icon: Icon(Icons.search, size: 20, color: textStyles.labelSmall.color),
                  border: InputBorder.none,
                ),
              ),
            ):ReusableSizedBox(),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: filteredOptions.length,
                itemBuilder: (context, index) {
                  final item = filteredOptions[index];
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        widget.onSelected(item);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 14),
                        child: ReusableText(
                          text: item,
                          style: textStyles.bodyMedium,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
