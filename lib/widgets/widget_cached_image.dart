import 'package:cached_network_image/cached_network_image.dart'; // ignore: import_of_legacy_library_into_null_safe
import 'package:flutter/material.dart';
import 'package:gen_crm/src/src_index.dart';
import 'package:gen_crm/widgets/widgets.dart';
import 'package:http/http.dart' as http; // ignore: import_of_legacy_library_into_null_safe

class WidgetCachedImage extends StatelessWidget {
  WidgetCachedImage({this.url, this.color, this.fit, this.icon, this.height, this.width});
  final String? url, icon;
  final Color? color;
  final BoxFit? fit;
  final double? height, width;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: CachedNetworkImage(
        imageUrl: url ?? IMAGES.LOGO_APP,
        placeholder: (context, url) => Center(
          child: WidgetContainerImage(
            boxDecoration: BoxDecoration(
                shape: BoxShape.circle
            ),
            borderRadius: BorderRadius.circular(100),
            image: 'assets/lottie/loading.gif',
            height: 100,
            width: 100,
          )
        ),
        errorWidget: (context, url, error) => Icon(Icons.error),
        color: color,
        fit: fit ?? AppValue.IMAGE_FIT_MODE,
        filterQuality: FilterQuality.low,
      ),
    );
  }
}

class WidgetAvatar extends StatelessWidget {
  final String? url;
  final double? height, width;
  WidgetAvatar({this.url, this.height = 70, this.width = 70});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Center(
          child: CachedNetworkImage(
            imageUrl: url ?? IMAGES.LOGO_APP,
            height: height,
            width: width,
            fit: BoxFit.fill,
            useOldImageOnUrlChange: false,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => WidgetContainerImage(image: IMAGES.LOGO_APP, height: 60, width: 60,),
          ),
        ),
      ),
    );
  }
}

class WidgetImageCircle extends StatelessWidget {
  final String? url;
  final double height, width;
  WidgetImageCircle({this.url, this.height = 70, this.width = 70});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Center(
          child: CachedNetworkImage(
            imageUrl: url ?? IMAGES.LOGO_APP,
            fit: BoxFit.fill,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => WidgetContainerImage(image: IMAGES.LOGO_APP),
          ),
        ),
      ),
    );
  }
}