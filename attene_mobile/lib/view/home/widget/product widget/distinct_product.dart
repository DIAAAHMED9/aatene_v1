import 'package:attene_mobile/general_index.dart';

class DistinctProduct extends StatelessWidget {
  final String storeName;
  final String productName;
  final String description;
  final double price;
  final double oldPrice;
  final double rating;
  final String imageUrl;

  const DistinctProduct({
    super.key,
    required this.storeName,
    required this.productName,
    required this.description,
    required this.price,
    required this.oldPrice,
    required this.rating,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: AssetImage("assets/images/png/background_product.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // Image.asset(
          //   "assets/images/png/background_product.png",
          //   width: double.infinity,
          //   height: 200,
          // ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Store Name Badge
                      Row(
                        children: [
                          Text(
                            storeName,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.seventeen_mp,
                            color: Colors.amber,
                            size: 14,
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Product Name
                      Text(
                        productName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      // Description
                      Text(
                        description,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 8),

                      // Rating Stars
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            rating.toString(),
                            style: const TextStyle(
                              color: Colors.amber,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 4),
                          ...List.generate(5, (index) {
                            return Icon(
                              index < rating.floor()
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.amber,
                              size: 14,
                            );
                          }),
                        ],
                      ),
                      // Price
                      Row(
                        spacing: 5,
                        children: [
                          Text(
                            "₪${price.toInt()}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "₪$oldPrice",
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ),
                      // Button
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary400,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 0,
                          ),
                          minimumSize: const Size(0, 32),
                        ),
                        child: const Text(
                          "اطلبه الان",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
