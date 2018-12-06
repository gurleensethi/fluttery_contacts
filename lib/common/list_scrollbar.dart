import 'package:flutter/material.dart';
import 'package:fluttery_contacts/common/spaces.dart';

typedef String LabelBuilder(int itemNumber);

class ListScrollbar extends StatefulWidget {
  final Widget child;
  final double scrollbarHeight;
  final ScrollController controller;
  final itemCount;
  final LabelBuilder labelBuilder;

  const ListScrollbar({
    Key key,
    this.child,
    this.scrollbarHeight = 60.0,
    this.controller,
    this.itemCount,
    this.labelBuilder,
  })  : assert(scrollbarHeight != null),
        assert(scrollbarHeight >= 40.0),
        assert(controller != null),
        super(key: key);

  @override
  ListScrollbarState createState() {
    return new ListScrollbarState();
  }
}

class ListScrollbarState extends State<ListScrollbar>
    with TickerProviderStateMixin {
  double _topOffset = 0.0;
  double _viewOffset = 0.0;
  String _labelText = '';
  AnimationController _animationController;
  Animation<double> _textSizeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _textSizeAnimation =
        Tween(begin: 20.0, end: 60.0).animate(_animationController);
    _animationController.addListener(() => setState(() {}));

    widget.controller.addListener(() {
      setState(() {
        _topOffset = _getBarScrollOffset();

        if (_topOffset < minScrollOffset) _topOffset = minScrollOffset;

        if (_topOffset > maxScrollOffset) _topOffset = maxScrollOffset;

        _updateLabel();
      });
    });


    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _updateLabel();
      });
    });
  }

  double get maxScrollOffset => context.size.height - widget.scrollbarHeight;

  double get minScrollOffset => 0.0;

  double get maxViewScrollOffset => widget.controller.position.maxScrollExtent;

  double get minViewScrollOffset => widget.controller.position.minScrollExtent;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        widget.child,
        GestureDetector(
          onVerticalDragUpdate: _onVerticalDragUpdate,
          onVerticalDragStart: _onVerticalDragStart,
          onVerticalDragEnd: _onVerticalDragEnd,
          onVerticalDragCancel: () {
            _animationController.reverse();
          },
          child: Container(
            alignment: Alignment.topRight,
            margin: EdgeInsets.only(top: _topOffset),
            child: _buildScrollbar(),
          ),
        ),
      ],
    );
  }

  double _getListScrollOffset() {
    return (maxViewScrollOffset / maxScrollOffset) * _topOffset;
  }

  double _getBarScrollOffset() {
    return widget.controller.position.pixels *
        (maxScrollOffset / maxViewScrollOffset);
  }

  _onVerticalDragStart(DragStartDetails details) {
    _animationController.forward();
  }

  _onVerticalDragEnd(DragEndDetails details) {
    _animationController.reverse();
  }

  _onVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      double topOffset = details.delta.dy;

      _topOffset += topOffset;

      if (_topOffset < minScrollOffset) _topOffset = minScrollOffset;

      if (_topOffset > maxScrollOffset) _topOffset = maxScrollOffset;

      _viewOffset = _getListScrollOffset();

      if (_viewOffset < minViewScrollOffset) {
        _viewOffset = minViewScrollOffset;
      }

      if (_viewOffset > maxViewScrollOffset) {
        _viewOffset = maxViewScrollOffset;
      }

      widget.controller.jumpTo(_viewOffset);

      _updateLabel();
    });
  }

  _updateLabel() {
    final itemSize = maxViewScrollOffset / widget.itemCount;
    var itemNumber = (widget.controller.position.pixels / itemSize).toInt();
    if (itemNumber < 0) itemNumber = 0;
    if (itemNumber > widget.itemCount) itemNumber = widget.itemCount - 1;

    if (widget.labelBuilder != null) {
      _labelText = widget.labelBuilder(itemNumber);
    }
  }

  _buildScrollbar() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          _labelText,
          style: TextStyle(
            fontSize: _textSizeAnimation.value,
            color: Colors.blue,
          ),
        ),
        SizedBox(
          width: _textSizeAnimation.value,
        ),
        Container(
          width: 20.0,
          height: widget.scrollbarHeight,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.0),
              bottomLeft: Radius.circular(16.0),
            ),
          ),
        ),
      ],
    );
  }
}
