import 'package:attene_mobile/view/profile/user_profile/widget/stat_item.dart';

import '../../../../general_index.dart';
import 'followers_avatars.dart';

class ProfileStatsRow extends StatelessWidget {
  const ProfileStatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: const [
        ProfileStatItem(
          title: 'متابع',
          value: '350K',
          icon: SizedBox(
            width: 32,
            child: FollowersAvatars(
              images: [
                'https://i.pravatar.cc/150?img=1',
                'https://i.pravatar.cc/150?img=2',
                'https://i.pravatar.cc/150?img=3',
              ],
            ),
          ),
        ),

        VerticalDivider(width: 1),
        ProfileStatItem(
          title: 'المفضلة',
          value: '30K',
          icon: Icon(Icons.favorite_border, color: Colors.grey,size: 4,),
        ),
        VerticalDivider(width: 1),
        ProfileStatItem(
          title: 'تقييم',
          value: '4.5 (2,372) ',
          icon: Icon(Icons.star_border, color: Colors.grey,size: 14,),
        ),

      ],
    );
  }
}
