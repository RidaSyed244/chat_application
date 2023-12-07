// import 'package:flutter/material.dart';
// import 'package:multiple_images_picker/multiple_images_picker.dart';

// class YourChatApp extends StatefulWidget {
//   @override
//   _YourChatAppState createState() => _YourChatAppState();
// }

// class _YourChatAppState extends State<YourChatApp> {

//   Widget buildGridView() {
//     return GridView.count(
//       crossAxisCount: 3,
//       children: List.generate(images.length, (index) {
//         Asset asset = images[index];
//         return AssetThumb(
//           asset: asset,
//           width: 300,
//           height: 300,
//         );
//       }),
//     );
//   }

  


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Your Chat App"),
//       ),
//       body: Column(
//         children: [
//           buildGridView(),
//           ElevatedButton(
//             onPressed: loadAssets,
//             child: Text("Open Gallery"),
//           ),
//           if (images.isNotEmpty)
//             ElevatedButton(
//               onPressed: () {
//                 // Implement the logic to send images to the database
//                 // You can use the 'images' list for sending the selected images
//                 // For example, you can use a service class to handle the database communication
//                 // sendImagesToDatabase(images);
//               },
//               child: Text("Send Images to Database"),
//             ),
//         ],
//       ),
//     );
//   }
// }
