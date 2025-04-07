// import 'package:flutter/material.dart';
// import 'package:glam1/constants/AppColors.dart';

// class ManageLeadsBookingDetailsButton extends StatelessWidget {
//   const ManageLeadsBookingDetailsButton({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       padding: EdgeInsets.all(16.0),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.07),
//             blurRadius: 6,
//             spreadRadius: 1,
//             offset: Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [

//           Text(
//                       "Booking Details",
//                       style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black87,
//                             fontSize: 18
//                           ),
//                     ),
//                     SizedBox(height: MediaQuery.of(context).size.height*0.02),


//           // Calendar Icon + Date
//           Row(
//             children: [
//               Icon(Icons.calendar_today, color: AppColors.primary, size: 20),
//               SizedBox(width: 8),
//               Text(
//                 "15 February, 2025",
//                 style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                       fontWeight: FontWeight.w300,
//                       color: Colors.black87,
//                     ),
//               ),
//             ],
//           ),

//           SizedBox(height: MediaQuery.of(context).size.height * 0.015),

//           // Clock Icon + Time
//           Row(
//             children: [
//               Icon(Icons.access_time, color: AppColors.primary, size: 20),
//               SizedBox(width: 8),
//               Text(
//                 "10:00 AM - 12:00 PM",
//                 style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                       fontWeight: FontWeight.w300,
//                       color: Colors.black87,
//                     ),
//               ),
//             ],
//           ),

//           SizedBox(height: MediaQuery.of(context).size.height * 0.02),

//           // Edit Booking & View Conversation Buttons
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               GestureDetector(
//                 onTap: () {},
//                 child: Row(
//                   children: [
//                     Icon(Icons.edit, color: AppColors.primary, size: 20),
//                     SizedBox(width: 4),
//                     Text(
//                       'Edit Booking',
//                       style: TextStyle(color: AppColors.primary, fontSize: 16),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(width: MediaQuery.of(context).size.width * 0.04),
//               GestureDetector(
//                 onTap: () {},
//                 child: Row(
//                   children: [
//                     Icon(Icons.chat, color: Color(0xFF656565), size: 20),
//                     SizedBox(width: 4),
//                     Text(
//                       'View Conversation',
//                       style: TextStyle(color: Color(0xFF656565), fontSize: 16),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:glam1/constants/AppColors.dart';

class ManageLeadsBookingDetailsButton extends StatelessWidget {
  final String bookingDate;
  final String bookingTime;

    const ManageLeadsBookingDetailsButton({
    super.key,
    this.bookingDate = "15 February, 2025",
    this.bookingTime = "10: AM - 12:00 PM",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 6,
            spreadRadius: 1,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Booking Details",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontSize: 18,
                ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),

          // Calendar Icon + Dynamic Date
          Row(
            children: [
              Icon(Icons.calendar_today, color: AppColors.primary, size: 20),
              SizedBox(width: 8),
              Text(
                bookingDate, // ✅ Dynamic date from API
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w300,
                      color: Colors.black87,
                    ),
              ),
            ],
          ),

          SizedBox(height: MediaQuery.of(context).size.height * 0.015),

          // Clock Icon + Dynamic Time
          Row(
            children: [
              Icon(Icons.access_time, color: AppColors.primary, size: 20),
              SizedBox(width: 8),
              Text(
                bookingTime, // ✅ Dynamic time from API
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w300,
                      color: Colors.black87,
                    ),
              ),
            ],
          ),

          SizedBox(height: MediaQuery.of(context).size.height * 0.02),

          // Edit Booking & View Conversation Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    Icon(Icons.edit, color: AppColors.primary, size: 20),
                    SizedBox(width: 4),
                    Text(
                      'Edit Booking',
                      style: TextStyle(color: AppColors.primary, fontSize: 16),
                    ),
                  ],
                ),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.04),
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    Icon(Icons.chat, color: Color(0xFF656565), size: 20),
                    SizedBox(width: 4),
                    Text(
                      'View Conversation',
                      style: TextStyle(color: Color(0xFF656565), fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
