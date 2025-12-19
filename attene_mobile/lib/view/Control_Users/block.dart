import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            // Cover Image
            Container(
              height: 180,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/cover.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Edit Cover Button
            Positioned(
              top: 12,
              right: 12,
              child: _editButton(
                onTap: () {
                  // TODO: edit cover
                },
              ),
            ),

            // Profile Image + Edit Button
            Positioned(
              bottom: -50,
              left: 0,
              right: 0,
              child: Center(
                child: Stack(
                  children: [
                    // Profile Image
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: const CircleAvatar(
                        radius: 48,
                        backgroundImage:
                        AssetImage('assets/profile.jpg'),
                      ),
                    ),

                    // Edit Profile Button
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: _editButton(
                        size: 18,
                        padding: 6,
                        onTap: () {
                          // TODO: edit profile image
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 60),

        // Username
        const Text(
          'jerusalemIII',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 4),

        // Location
        const Text(
          'فلسطين، الخليل',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );

  }

  // Reusable Edit Button
  Widget _editButton({
    double size = 20,
    double padding = 8,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.camera_alt,
          color: Colors.white,
          size: size,
        ),
      ),
    );
  }
}
