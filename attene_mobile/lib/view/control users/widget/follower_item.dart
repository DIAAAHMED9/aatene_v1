import '../../../general_index.dart';


class FollowerItem extends StatelessWidget {
  FollowerItem({super.key});

  final RxBool isFollowing = false.obs;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 26,
            backgroundImage: NetworkImage('https://via.placeholder.com/150'),
          ),

          const SizedBox(width: 10),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('SideLimited', style: getBold(fontSize: 15)),
              const SizedBox(height: 4),
              Text(
                '249K متابعين',
                style: getRegular(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),

          const Spacer(),

          Obx(() {
            return GestureDetector(
              onTap: () {
                isFollowing.value = !isFollowing.value;
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                height: 36,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: isFollowing.value
                      ?  AppColors.customColor10
                      : AppColors.primary400,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(
                      isFollowing.value
                          ? Icons.done
                          : Icons.person_add_alt,
                      color: isFollowing.value
                          ? AppColors.primary400
                          : Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isFollowing.value ? 'تمت المتابعة' : 'رد المتابعة',
                      style: getMedium(
                        color: isFollowing.value
                            ? AppColors.primary400
                            : Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}