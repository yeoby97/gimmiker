import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gimmiker/widgets/paint_widgets.dart';
import '../data/model/space.dart';
import '../data/model/warehouse.dart';
import 'blueprint_widgets.dart';

class WarehouseContents extends StatelessWidget {

  final Warehouse warehouse;
  final VoidCallback? onPressed;
  final List<Space> spaces;

  const WarehouseContents({
    super.key,
    required this.warehouse,
    required this.onPressed,
    required this.spaces,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ImageSlide(images: warehouse.images),
          const SizedBox(height: 10),
          WarehouseInfoSection(warehouse: warehouse),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: onPressed,
                child: const Text('자세히 보기'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text('예약 가능한 공간', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          WarehouseLayoutView(
            warehouse: warehouse,
            spaces: spaces,
            drawingOrTrade: DrawingOrTrade.trade,
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}



class ImageSlide extends StatefulWidget {
  final List<String> images;

  const ImageSlide({super.key, required this.images});

  @override
  State<ImageSlide> createState() => _ImageSlideState();
}
class _ImageSlideState extends State<ImageSlide> {
  late final PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) {
      return const SizedBox(height: 150);
    }

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.images.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FullscreenImageSlide(
                          images: widget.images,
                          initialIndex: index,
                        ),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: widget.images[index],
                      fit: BoxFit.contain,
                      width: double.infinity,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[300],
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.error),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Positioned(
          bottom: 10,
          right: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${_currentIndex + 1} / ${widget.images.length}',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }
}







class FullscreenImageSlide extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  const FullscreenImageSlide({
    super.key,
    required this.images,
    this.initialIndex = 0,
  });

  @override
  State<FullscreenImageSlide> createState() => _FullscreenImageSlideState();
}

class _FullscreenImageSlideState extends State<FullscreenImageSlide> {
  late final PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.images.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Center(
                child: CachedNetworkImage(
                  imageUrl: widget.images[index],
                  fit: BoxFit.contain,
                  placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) =>
                  const Icon(Icons.error, color: Colors.white),
                ),
              );
            },
          ),
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 16,
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${_currentIndex + 1} / ${widget.images.length}',
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class WarehouseInfoSection extends StatelessWidget {
  final Warehouse warehouse;

  const WarehouseInfoSection({
    super.key,
    required this.warehouse,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          warehouse.address,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(warehouse.detailAddress),
        const SizedBox(height: 6),
        Text('보관 공간: ${warehouse.count}칸'),
        const SizedBox(height: 6),
        Text('등록일: ${warehouse.createdAt?.toLocal().toString().split(' ').first ?? ''}'),
        const SizedBox(height: 10),
      ],
    );
  }
}


class WarehouseLayoutView extends StatelessWidget {
  final Warehouse warehouse;
  final List<Space> spaces;
  final VoidCallback? onBackgroundPressed;
  final int? selectedNum;
  final void Function(int)? onSpaceTap;
  final DrawingOrTrade? drawingOrTrade;

  const WarehouseLayoutView({
    super.key,
    required this.warehouse,
    required this.spaces,
    required this.drawingOrTrade,
    this.onBackgroundPressed,
    this.selectedNum,
    this.onSpaceTap,
  });

  @override
  Widget build(BuildContext context) {
    final double containerHeight = warehouse.height;
    final double layoutWidth = warehouse.width;

    return Container(
      height: containerHeight,
      width: double.infinity, // 화면 너비에 고정
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 1.0,
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Stack(
          children: [
            // 실제 레이아웃 영역
            SizedBox(
              height: containerHeight,
              width: layoutWidth,
              child: CustomPaint(
                painter: GridPainter(
                  gridSize: 30,
                  width: layoutWidth,
                  height: containerHeight,
                  lines: warehouse.layout['lines'] ?? [],
                  doors: warehouse.layout['doors'] ?? {},
                  transparent: true,
                ),
              ),
            ),
            SizedBox(
              height: containerHeight,
              width: layoutWidth,
              child: LocatingShape(
                height: containerHeight,
                width: layoutWidth,
                onBackgroundTap:onBackgroundPressed,
                spaces: spaces,
                selectedNum: selectedNum,
                onSpaceTap: onSpaceTap,
                drawingOrTrade: drawingOrTrade,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

