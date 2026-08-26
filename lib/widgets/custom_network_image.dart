import 'package:flutter/material.dart';

class CustomNetworkImage extends StatelessWidget {
  final String image;
  final String? localImage;
  final double? borderRadius;
  final double? height;
  final double? width;

  const CustomNetworkImage(
      {this.height,
      this.width,
      required this.image,
      this.localImage,
      this.borderRadius,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return image.isNotEmpty
        ? Container(
            height: height,
            width: width,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(borderRadius ?? 0),
              ),
            ),
            child: Image.network(
              image,
              fit: BoxFit.cover,
              frameBuilder: (_, image, loadingBuilder, __) {
                if (loadingBuilder == null) {
                  return Image.asset(
                    localImage ?? "assets/images/no-image_card.jpg",
                    fit: BoxFit.cover,
                  );
                }
                return image;
              },
              loadingBuilder: (context, image, loading) {
                if (loading == null) {
                  return image;
                } else {
                  return Image.asset(
                      localImage ?? "assets/images/no-image_card.jpg",
                      fit: BoxFit.cover);
                }
              },
              errorBuilder: (_, __, ___) {
                return Image.asset(
                    localImage ?? "assets/images/no-image_card.jpg",
                    fit: BoxFit.cover);
              },
            ),
          )
        : Container(
            height: height,
            width: width,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(borderRadius ?? 0),
              ),
            ),
            child: Image.asset(localImage ?? "assets/images/no-image_card.jpg",fit: BoxFit.cover,),
          );
  }
}
