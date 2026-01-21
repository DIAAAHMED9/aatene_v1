//
// import 'package:dartz/dartz.dart';
//
// import '../../../api/api_request.dart';
//
// class  controlerTest extends GetxController{
//   Map<String, dynamic> storeData=	{
//     "type": "products",
//     "name": "My Store",
//     "logo": "images/QzuU8cxzP0pgRFit46Dh5LifmCrxSCm8eg49f10v.png",
//     "status": "active",
//     "cover": ["images/QzuU8cxzP0pgRFit46Dh5LifmCrxSCm8eg49f10v.png", "images/QzuU8cxzP0pgRFit46Dh5LifmCrxSCm8eg49f10v.png"],
//     "description": "A great place for awesome products.",
//     "email": "contact@mystore.com",
//     "city_id": 1,
//     "district_id": 3,
//     "address": "123 Main St, Example City",
//     "lng": "46.675293",
//     "lat": "24.713552",
//     "owner_id": 5,
//     "currency_id": 2,
//     "phone": "+12345678901",
//     "whats_app": "+12345678901",
//     "tiktok": "my_store_tiktok",
//     "facebook": "my_store_fb",
//     "instagram": "my_store_insta",
//     "twitter": "my_store_tw",
//     "youtube": "my_store_yt",
//     "linkedin": "my_store_ln",
//     "pinterest": "my_store_pin",
//
//     "delivery_type": "shipping",
//     "shippingCompanies": [
//       {
//         "name": "sec ship",
//         "phone": "0999988888",
//         "prices": [
//           {
//             "city_id": 3,
//             "days": 5,
//             "price": 40
//           }
//         ]
//       }
//     ],
//     "locationCities":[3],
//     "serviceCities":[3]
//   }
// ;
//   Future<void> createStore()async{
//     ApiHelper apiRequest=ApiHelper();
//     var response =await ApiHelper.post(
//       path: "/merchants/mobile/stores",
//           body:storeData
//     );
//     if () {
//
//     }
//
//   }
// }
