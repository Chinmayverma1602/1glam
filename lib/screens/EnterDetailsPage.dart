import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:glam1/screens/VerifyEmailPage.dart';
import 'package:glam1/widgets/CustomButton.dart';
import 'package:glam1/widgets/CustomHeader.dart';

class EnterDetailsPage extends StatefulWidget {
  const EnterDetailsPage({super.key});

  @override
  State<EnterDetailsPage> createState() => _EnterDetailsPageState();
}

class _EnterDetailsPageState extends State<EnterDetailsPage> {
  final List<Map<String, dynamic>> users = [
    {"business" : "Nail Salon", "color" : Colors.transparent},
    {"business" : "Hairstylist", "color" : Colors.transparent},
    {"business" : "MAkeup Artist", "color" : Colors.transparent},
    {"business" : "Other", "color" : Colors.transparent},

  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          CustomHeader(),
          SizedBox(height: 20,),
            Text("What's your business ?" , style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.title),),
            Expanded(
              child: GridView.count(crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: List.generate(users.length, (index){
                return Column(
  children: [
    Container(
      width: 150, 
      height: 150,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.primary.withOpacity(0.4), 
          width: 1,                       
        ),
      ),
      child: CircleAvatar(
        radius: 72,                      
        backgroundColor: users[index]["color"],
        child: SvgPicture.asset('assets/images/svg.svg')
      ),),
    
    SizedBox(height: 10),
    Text(users[index]["business"]),
  ],
);

              }),
              ),
              
            ),
            
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 300),
                child: CustomButton(
                  text: "Proceed to enter my details", 
                  color: AppColors.subtitle,
                  icon: null,
                  onPressed:() => Navigator.push(context, (MaterialPageRoute(builder: (context)=> VerifyEmailPage()))),),
            ))
        
        ],),
      ),
    );
  }
}