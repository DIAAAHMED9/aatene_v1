import 'package:attene_mobile/general_index.dart';
import 'package:flutter/material.dart';
import '../model/story_model.dart';

class PromoVideoCard extends StatelessWidget {
  final PromoVideoModel model;
  final Function(PromoVideoModel) onTap;

  const PromoVideoCard({super.key, required this.model, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: model.id,
      child: GestureDetector(
        onTap: () => onTap(model),
        child: Container(
          width: 110,
          height: 160,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          child: Stack(
            children: [
              /// Image
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  model.image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),

              /// Overlay
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.2),
                      Colors.black.withOpacity(0.6),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),

              /// Play Icon
              Center(
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.primary300.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.play_arrow,
                    color: AppColors.primary100,
                    size: 25,
                  ),
                ),
              ),

              /// Avatar
              Positioned(
                bottom: 12,
                right: 12,
                child: CircleAvatar(
                  radius: 13,
                  backgroundImage: NetworkImage(model.avatar),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
