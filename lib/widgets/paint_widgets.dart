import 'package:flutter/material.dart';
import '../data/model/space.dart';

enum DrawingOrTrade { drawing, trade }


class LocatingShape extends StatelessWidget {

  final double height;
  final double width;
  final VoidCallback? onBackgroundTap;
  final void Function(int)? onSpaceTap;
  final List<Space> spaces;
  final int? selectedNum;
  final DrawingOrTrade? drawingOrTrade;
  final void Function(int,DragUpdateDetails)? onPanUpdate;
  final void Function(int)? onPanEnd;
  final void Function(int)? onDoubleTap;
  final void Function(int,BuildContext)? onLongPress;

  const LocatingShape({
    super.key,
    required this.height,
    required this.width,
    required this.spaces,
    required this.drawingOrTrade,
    this.selectedNum,
    this.onBackgroundTap,
    this.onSpaceTap,
    this.onPanUpdate,
    this.onPanEnd,
    this.onDoubleTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      color: Colors.transparent,
      child: Stack(
        children: [
          GestureDetector(
            onTap: onBackgroundTap,
            child: Container(
              height: height,
              width: width,
              color: Colors.transparent,
            ),
          ),
          ...spaces.map((space) =>
              BuildShape(
                space: space,
                selectedNum: selectedNum,
                onSpaceTap: () => onSpaceTap?.call(space.num),
                drawingOrTrade: drawingOrTrade,
                onPanUpdate: onPanUpdate,
                onPanEnd: onPanEnd,
                onDoubleTap: onDoubleTap,
                onLongPress: onLongPress,
              )
          )
        ],
      )
    );
  }
}

class BuildShape extends StatelessWidget {
  final Space space;
  final int? selectedNum;
  final VoidCallback? onSpaceTap;
  final DrawingOrTrade? drawingOrTrade;
  final void Function(int,DragUpdateDetails)? onPanUpdate;
  final void Function(int)? onPanEnd;
  final void Function(int)? onDoubleTap;
  final void Function(int,BuildContext)? onLongPress;

  const BuildShape({
    super.key,
    required this.space,
    required this.drawingOrTrade,
    this.selectedNum,
    this.onSpaceTap,
    this.onPanUpdate,
    this.onPanEnd,
    this.onDoubleTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          width: space.width,
          height: space.height,
          color: drawingOrTrade == DrawingOrTrade.drawing
              ? Colors.green
              : (space.user != null
              ? Colors.grey
              : (selectedNum == space.num ? Colors.blue : Colors.green)),
        ),
        Positioned(
          bottom: -4, // 살짝 바깥으로 (테두리 보정)
          child: Container(
            width: 20,
            height: 5,
            color: Colors.black,
          ),
        ),
      ],
    );
    return Positioned(
      left: space.x,
      top: space.y,
      child: GestureDetector(
        onTap: onSpaceTap,
        onPanUpdate: (details) => onPanUpdate?.call(space.num, details),
        onPanEnd: (details) => onPanEnd?.call(space.num),
        onDoubleTap: () => onDoubleTap?.call(space.num),
        onLongPress: () => onLongPress?.call(space.num, context),
        child: Stack(
            alignment: Alignment.center,
            children: [
              Transform.rotate(
                angle: space.angle,
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    content,
                    if (space.num == selectedNum && drawingOrTrade == DrawingOrTrade.drawing)
                      Positioned(
                        top: -4,
                        left: -4,
                        child: Container(
                          width: space.width + 8,
                          height: space.height + 8,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.redAccent, width: 2),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Text(
                'ID ${space.num}',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ]
        ),
      ),
    );;
  }
}
