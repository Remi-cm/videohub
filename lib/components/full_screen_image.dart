import 'package:flutter/material.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';

import '../core/models/full_screen_image_model.dart';
import '../core/utils/size_config.dart';

class ImageFullScreen extends StatelessWidget {
  final FullScreenImageModel img;
  const ImageFullScreen({ Key? key, required this.img }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.grey[900],
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, size: 25, color: Colors.white,), onPressed: ()=>Navigator.pop(context)),
        title: Text(img.title, style: const TextStyle(fontSize: 17, color: Colors.white)),
      ),
      body: DoubleTappableInteractiveViewer(
          scaleDuration: const Duration(milliseconds: 600),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                child: FastCachedImage(url:  img.url), 
                tag: img.hero,
              ),
              SizedBox(height: hv*5,)
            ],
          ),
        ),
    );
  }
}

class DoubleTappableInteractiveViewer extends StatefulWidget {
  final double scale;
  final Duration scaleDuration;
  final Curve curve;
  final Widget child;
  
  const DoubleTappableInteractiveViewer({Key? key,
    this.scale = 2,
    this.curve = Curves.fastLinearToSlowEaseIn,
    required this.scaleDuration,
    required this.child,
  }) : super(key: key);
  
  @override
  State<DoubleTappableInteractiveViewer> createState() => _DoubleTappableInteractiveViewerState();
}

class _DoubleTappableInteractiveViewerState extends State<DoubleTappableInteractiveViewer>
  with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  Animation<Matrix4>? _zoomAnimation;
  late TransformationController _transformationController;
  TapDownDetails? _doubleTapDetails;
  
  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.scaleDuration,
    )..addListener(() {
      _transformationController.value = _zoomAnimation!.value;
    });
  }
  
  @override
  void dispose() {
    _transformationController.dispose();
    _animationController.dispose();
    super.dispose();
  }
  
  void _handleDoubleTapDown(TapDownDetails details) {
  _doubleTapDetails = details;
}

  void _handleDoubleTap() {
    final newValue = 
      _transformationController.value.isIdentity() ?
        _applyZoom() : _revertZoom();
      
    _zoomAnimation = Matrix4Tween(
      begin: _transformationController.value,
      end: newValue,
    ).animate(
      CurveTween(curve: widget.curve)
        .animate(_animationController)
    );
    _animationController.forward(from: 0);
  }
  
  Matrix4 _applyZoom() {
    final tapPosition = _doubleTapDetails!.localPosition;
    final translationCorrection = widget.scale - 1;
    final zoomed = Matrix4.identity()
      ..translate(
        -tapPosition.dx * translationCorrection,
        -tapPosition.dy * translationCorrection,
      )
      ..scale(widget.scale);
    return zoomed;
  }
  
  Matrix4 _revertZoom() => Matrix4.identity();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTapDown: _handleDoubleTapDown,
      onDoubleTap: _handleDoubleTap,
      child: InteractiveViewer(
        transformationController: _transformationController,
        child: widget.child,
      ),
    );
  }
}