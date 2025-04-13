// import 'package:flutter/material.dart';
// import 'package:glam1/constants/AppColors.dart';

// class CustomServiceButton extends StatelessWidget {
//   final String title;
//   final String subtitle;
//   final Color borderColor;
//   final Color titleColor;
//   final Color subtitleColor;
//   final Color leadingIconColor;
//   final Color numberColor;
//   final Color trailingIconColor;
//   final String value;
//   final dynamic serviceCategoryDropDown;

//   const CustomServiceButton({
//     Key? key,
//     required this.title,
//     required this.subtitle,
//     required this.serviceCategoryDropDown,
//     this.borderColor = AppColors.travelFeeIconColor,
//     this.titleColor = Colors.black,
//     this.subtitleColor = Colors.grey,
//     this.leadingIconColor = Colors.amber,
//     this.numberColor = AppColors.subtitle,
//     this.trailingIconColor = AppColors.subtitle,
//     this.value = "30.00",
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       // height: MediaQuery.of(context).size.width*0.2,
//       padding: const EdgeInsets.all(12),
//       margin: const EdgeInsets.symmetric(horizontal: 13),
//       decoration: BoxDecoration(
//         color: const Color.fromARGB(255, 255, 223, 246),
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: const Color.fromARGB(255, 105, 63, 108),
//             blurRadius: 20,
//             spreadRadius: 0.1,
//             offset: Offset(-4, 3),
//           ),
//         ],
//       ),

//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: titleColor,
//                 ),
//               ),
//               Text(
//                 subtitle,
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: subtitleColor,
//                 ),
//               ),
//               Text(
//                 serviceCategoryDropDown.toString(),
//                 style: TextStyle(

//                   // fontSize: 18,
//                   color: subtitleColor,
//                 ),
//               ),
//             ],
//           ),
//           Row(
//             children: [
//               Icon(Icons.currency_rupee, color: leadingIconColor, size: 18,),
//               SizedBox(width: MediaQuery.of(context).size.width*0.008),
//               Text(
//                 value,
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: numberColor,
//                 ),
//               ),
//               SizedBox(width: MediaQuery.of(context).size.width*0.025),
//               Icon(Icons.arrow_forward_ios, size: 16, color: trailingIconColor),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glam1/constants/AppColors.dart';

// Modified CustomServiceButton to accept title, subtitle, and price directly
class CustomServiceButton extends StatelessWidget {
  const CustomServiceButton({
    super.key,
    required this.title,
    required this.subtitle,
    required this.price,
  });

  final String title;
  final String subtitle;
  final String price;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
          ),
          Text(
            price,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.subtitle,
            ),
          ),
          const Icon(Icons.chevron_right, color: Color(0xFF4C1C97))
        ],
      ),
    );
  }
}