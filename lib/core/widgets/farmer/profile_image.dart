import 'package:farmdirect/core/provider/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ProfileImage extends StatelessWidget {
  final double size;
  final bool showCamera;

  const ProfileImage({
    super.key,
    this.size = 50,
    this.showCamera = false,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, profile, child) {
        Widget imageWidget;

        if (profile.profileImage != null) {
          imageWidget = Image.file(
            profile.profileImage!,
            width: size,
            height: size,
            fit: BoxFit.cover,
          );
        } else {
          imageWidget = Image.asset(
            profile.defaultImage,
            width: size,
            height: size,
            fit: BoxFit.cover,
          );
        }

        final profileWidget = SizedBox(
          width: size,
          height: size,
          child: ClipOval(
            child: imageWidget,
          ),
        );

        // Only make it clickable when camera is shown
        if (showCamera) {
          return GestureDetector(
            onTap: () async {
              await profile.pickProfileImage();
            },
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                profileWidget,

                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: size * 0.28,
                    height: size * 0.28,
                    decoration: BoxDecoration(
                      color: const Color(0xFF075B47),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: size * 0.15,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return profileWidget;
      },
    );
  }
}