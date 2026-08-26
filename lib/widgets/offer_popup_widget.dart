import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/local_services.dart';

class OfferPopupWidget {
  static void show({
    required String imageUrl,
    required String deeplink,
    Function(String)? onDeepLink,
  }) {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (context) {
        return _OfferPopupContent(
          imageUrl: imageUrl,
          deeplink: deeplink,
          onDeepLink: onDeepLink,
        );
      },
    );
  }
}

class _OfferPopupContent extends StatelessWidget {
  final String imageUrl;
  final String deeplink;
  final Function(String)? onDeepLink;

  const _OfferPopupContent({
    required this.imageUrl,
    required this.deeplink,
    this.onDeepLink,
  });

  // ============================================================
  // HANDLE IMAGE TAP / DEEP LINK
  // ============================================================

  void _handleTap() {
    Get.back();

    if (onDeepLink != null) {
      onDeepLink!(deeplink);
      return;
    }

    // Default deep link handler
    if (deeplink.contains("product")) {
      final id = deeplink.split("/").last;

      Get.toNamed("/product/$id");
    } else if (deeplink.contains("offer")) {
      final id = deeplink.split("/").last;

      Get.toNamed("/offer/$id");
    }
  }

  // ============================================================
  // CLOSE POPUP
  // ============================================================

  Future<void> _closePopup() async {
    await LocalServices.storeOfferPopupShownStatus(true);

    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    // Maximum popup width
    final double maxWidth = screenSize.width * 0.90;

    // Maximum popup height
    final double maxHeight = screenSize.height * 0.75;

    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // ======================================================
          // BACKGROUND OVERLAY
          // ======================================================

          Positioned.fill(
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                color: Colors.black.withOpacity(0.70),
              ),
            ),
          ),

          // ======================================================
          // POPUP
          // ======================================================

          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: maxWidth,
                  maxHeight: maxHeight,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // ==========================================
                      // IMAGE
                      // ==========================================

                      GestureDetector(
                        onTap: _handleTap,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth: maxWidth,
                              maxHeight: maxHeight,
                            ),
                            color: Colors.transparent,
                            child: Image.network(
                              imageUrl,

                              // IMPORTANT:
                              // Don't crop the image
                              fit: BoxFit.contain,

                              // Loading
                              loadingBuilder: (
                                  context,
                                  child,
                                  loadingProgress,
                                  ) {
                                if (loadingProgress == null) {
                                  return child;
                                }

                                return SizedBox(
                                  width: maxWidth,
                                  height: 300,
                                  child: const Center(
                                    child:
                                    CircularProgressIndicator(),
                                  ),
                                );
                              },

                              // Error
                              errorBuilder: (
                                  context,
                                  error,
                                  stackTrace,
                                  ) {
                                return Container(
                                  width: maxWidth,
                                  height: 300,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius:
                                    BorderRadius.circular(16),
                                  ),
                                  alignment: Alignment.center,
                                  child: const Column(
                                    mainAxisSize:
                                    MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons
                                            .broken_image_outlined,
                                        size: 50,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        "Image not available",
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),

                      // ==========================================
                      // CLOSE BUTTON
                      // ==========================================

                      Positioned(
                        right: 6,
                        top: 6,
                        child: GestureDetector(
                          onTap: _closePopup,
                          child: Container(
                            width: 34,
                            height: 34,
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}