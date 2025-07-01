import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gimmiker/features/warehouse_register/warehouse_register_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../widgets/blueprint_widgets.dart';
import '../../widgets/paint_widgets.dart';
import '../../widgets/register.dart';

class WarehouseRegisterScreen extends StatefulWidget {
  const WarehouseRegisterScreen({super.key});

  @override
  State<WarehouseRegisterScreen> createState() => _WarehouseRegisterScreenState();
}

class _WarehouseRegisterScreenState extends State<WarehouseRegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: _Body(),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WarehouseRegisterProvider>();

    if (provider.isDraw) {
      return BlueprintEditorScreen();
    }
    else {
      return const WarehouseRegisterBody();
    }
  }
}

class WarehouseRegisterBody extends StatelessWidget {
  const WarehouseRegisterBody({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WarehouseRegisterProvider>();
    final NumberFormat priceFormat = NumberFormat("#,##0", "ko_KR");

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                physics: provider.scroll ? null : const NeverScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        PhotoButton(
                          onTap: provider.pickImage,
                          pickedCount: provider.images.length,
                        ),
                        PhotoList(
                          delete: provider.deletePhoto,
                          pickedImages: provider.images,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () => provider.selectLocation(context),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          provider.address ?? '주소',
                          style: TextStyle(
                            fontSize: 20,
                            color: provider.address == null ? Colors.grey : Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const _BuildTextField(hint: '상세 주소'),
                    const SizedBox(height: 12),
                    _BuildNumberField(hint: '창고 갯수', unit: '개', controller: provider.countController),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: FloatingActionButton.extended(
                        onPressed: () {
                          provider.drawChange(true);
                        },
                        label: const Text("건물 도면 그리기", style: TextStyle(fontSize: 16)),
                        icon: const Icon(Icons.check),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SingleChildScrollView(
                      physics: provider.scroll ? null : const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        width: provider.transformedData?.width ?? 0,
                        height: provider.transformedData?.height ?? 0,
                        child: Stack(
                          children: [
                            CustomPaint(
                              painter: GridPainter(
                                gridSize: 30,
                                width: provider.transformedData?.width ?? 0,
                                height: provider.transformedData?.height ?? 0,
                                lines: provider.transformedData?.shiftedLines ?? [],
                                doors: provider.transformedData?.shiftedDoors ?? {},
                              ),
                            ),
                            LocatingShape(
                              height: provider.transformedData?.height ?? 0,
                              width: provider.transformedData?.width ?? 0,
                              spaces: provider.spaces,
                              drawingOrTrade: DrawingOrTrade.drawing,
                              selectedNum: provider.selectedSpaceId,
                              onSpaceTap: provider.selectSpace,
                              onBackgroundTap: provider.onBackgroundTap,
                              onPanUpdate: provider.updateSpacePosition,
                              onPanEnd: provider.snapSpaceToGrid,
                              onDoubleTap: provider.rotateSpace,
                              onLongPress: provider.deleteSpace,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: ElevatedButton(
                        onPressed: () => provider.showSpaceSizeDialog(context),
                        child: const Text('창고 추가'),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: FloatingActionButton.extended(
                        onPressed: () => provider.upload(context),
                        label: const Text("등록", style: TextStyle(fontSize: 16)),
                        icon: const Icon(Icons.check),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (provider.isLoading)
            Container(
              color: Colors.black.withAlpha(128),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 16),
                    Text("업로드 중입니다...", style: TextStyle(color: Colors.white, fontSize: 16)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _BuildTextField extends StatelessWidget {
  final String hint;

  const _BuildTextField({required this.hint});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WarehouseRegisterProvider>();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: provider.detailAddressController,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          border: InputBorder.none,
        ),
        style: const TextStyle(fontSize: 20),
        onChanged: (detailAddress) {
          provider.detailAddress = detailAddress;
        },
      ),
    );
  }
}

class _BuildNumberField extends StatelessWidget {
  final String hint;
  final String unit;
  final NumberFormat? formatter;
  final TextEditingController controller;

  const _BuildNumberField({required this.hint, required this.unit, this.formatter, required this.controller});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<WarehouseRegisterProvider>();

    return Container(
      width: 200,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                TextInputFormatter.withFunction((oldValue, newValue) {
                  final text = newValue.text.replaceAll(',', '');
                  int? value = int.tryParse(text);
                  _changeNumber(viewModel, hint, value);
                  if (text.isEmpty) return newValue;
                  final formatted = formatter?.format(value) ?? value.toString();
                  return TextEditingValue(text: formatted);
                }),
              ],
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.end,
            ),
          ),
          const SizedBox(width: 8),
          Text(unit, style: const TextStyle(fontSize: 20, color: Colors.black)),
        ],
      ),
    );
  }

  void _changeNumber(WarehouseRegisterProvider viewModel, String hint, int? num) {
    switch (hint) {
      case '창고 갯수':
        viewModel.countChange(num);
        break;
      default:
    }
  }
}
