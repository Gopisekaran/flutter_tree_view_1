library flutter_tree_view;

import 'package:flutter/material.dart';

typedef ChildTree<T, R> = Widget Function(T parent, List<R>? childAccountList);
typedef ChildrenList<T> = List<T>? Function(int index);
typedef ChildNode<T> = Widget Function(T data);

class DataTreeGenerator<T, R> extends StatelessWidget {
  final List<T> dataList;
  final bool isSubTree;
  final ChildTree<T, R>? childTree;
  final ChildNode<T> child;
  final ChildrenList<R> getChildren;
  final double branchWidth;
  final bool enableDivider;
  final double childTileHeight;
  final double strokeWidth;
  final Color? branchColor;
  final int treeIndex;

  const DataTreeGenerator(
      {Key? key,
      required this.dataList,
      this.childTree,
      required this.isSubTree,
      required this.getChildren,
      required this.child,
      this.branchWidth = 20,
      this.enableDivider = true,
      this.childTileHeight = 50,
      this.strokeWidth = 2,
      this.branchColor,
      this.treeIndex = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScrollController controller = ScrollController();
    return CustomPaint(
      painter: isSubTree
          ? PaintVertical(branchColor ?? Theme.of(context).primaryColor,
              strokeWidth: strokeWidth)
          : null,
      child: ListView.builder(
        controller: controller,
        itemCount: dataList.length,
        shrinkWrap: true,
        // physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          T dataModel = dataList[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 5,
              ),
              CustomPaint(
                painter: isSubTree
                    ? dataList.length - 1 == index
                        ? PaintVerticalPatch(
                            Theme.of(context).canvasColor, 0.51,
                            strokeWidth: strokeWidth)
                        : null
                    : null,
                child: Row(
                  children: [
                    if (isSubTree)
                      CustomPaint(
                        painter: PaintHorizontal(
                            branchColor ?? Theme.of(context).primaryColor,
                            strokeWidth: strokeWidth),
                        child: SizedBox(width: branchWidth),
                      ),
                    Expanded(
                      child: child(dataModel),
                    ),
                  ],
                ),
              ),
              if (childTree != null)
                CustomPaint(
                  painter: isSubTree
                      ? dataList.length - 1 == index
                          ? PaintVerticalPatch(Theme.of(context).canvasColor, 0,
                              strokeWidth: strokeWidth)
                          : null
                      : null,
                  child: Padding(
                    padding:
                        EdgeInsets.only(left: (branchWidth * treeIndex) + (10)),
                    child: childTree!(dataModel, getChildren(index)),
                  ),
                )
            ],
          );
        },
      ),
    );
  }
}

class PaintVertical extends CustomPainter {
  Color color;
  double strokeWidth;
  PaintVertical(this.color, {this.strokeWidth = 2});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth;

    canvas.drawLine(
      const Offset(0, 0),
      Offset(0, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class PaintVerticalPatch extends CustomPainter {
  /// Patch color must not be changed
  Color color;

  double height = 0.50;

  double strokeWidth;

  PaintVerticalPatch(this.color, this.height, {this.strokeWidth = 2});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth;

    canvas.drawLine(
      Offset(0, size.height * height),
      Offset(0, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class PaintHorizontal extends CustomPainter {
  Color color;
  double strokeWidth;

  PaintHorizontal(this.color, {this.strokeWidth = 2});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2;

    canvas.drawLine(
      Offset(0, size.height * 0.5),
      Offset(size.width, size.height * 0.5),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
