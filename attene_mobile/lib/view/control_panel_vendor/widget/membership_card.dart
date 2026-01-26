import 'package:attene_mobile/general_index.dart';

class MembershipCard extends StatelessWidget {
  final RxInt points;

  const MembershipCard({super.key, required this.points});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/png/backbround1.png'),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Colors.black87, Colors.black54],
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Image.asset(
            'assets/images/png/coin.png',
            height: 55,
            width: 55,
            fit: BoxFit.cover,
          ),
          const Spacer(),
          Column(
            spacing: 4,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('عضو Basic', style: getRegular(color: Colors.white)),
              Obx(
                () => Text(
                  '${points.value} نقطة',
                  style: getRegular(color: Colors.white70),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
