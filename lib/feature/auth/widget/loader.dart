import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';

showLoaderWrapper(BuildContext context) {
  return Loader.show(
    context,
    overlayColor: Colors.black.withOpacity(0.4),
    progressIndicator: const CupertinoActivityIndicator(),
  );
}
