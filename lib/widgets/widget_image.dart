// import 'dart:io';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
//
// class ImageWidget extends StatelessWidget {
//   final File image;
//   final ValueChanged<ImageSource> onClicked;
//
//
//   const ImageWidget({
//     Key? key,
//     required this.image,
//     required this.onClicked
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final color = Theme.of(context).colorScheme.primary;
//     return Center(
//       child: Stack(
//         children: [
//           buildImage(context),
//           Positioned(
//             bottom: 0,right: 4,
//               child: buildEditIcon(color))
//         ],
//       ),
//     );
//   }
//   buildImage(BuildContext context){
//     final imagePath = this.image.path;
//     final image = imagePath.contains('https://')
//           ? NetworkImage(imagePath)
//         : FileImage(File(imagePath));
//     return ClipOval(
//       child: Material(
//         color: Colors.transparent,
//         child: Ink.image(
//           image: image as ImageProvider,
//           fit: BoxFit.cover,
//           width: 150,height: 150,
//           child: InkWell(
//             onTap: () async{
//               final source = await showImageSource(context);
//               if (source == null) return;
//
//               onClicked(source);
//             },
//           ),
//         ),
//       ),
//     );
//   }
//   buildEditIcon(Color color){
//     return buildCircle();
//   }
//   Future<ImageSource?> showImageSource(BuildContext context) async{
//     if(Platform.isAndroid){}
//       return showCupertinoModalPopup<ImageSource>(
//           context: context,
//           builder: (context){
//             return CupertinoActionSheet(
//               actions: [
//                 CupertinoActionSheetAction(
//                     onPressed: (){Navigator.of(context).pop(ImageSource.camera);},
//                     child: Text('camera')),
//                 CupertinoActionSheetAction(
//                     onPressed: (){Navigator.of(context).pop(ImageSource.gallery);},
//                     child: Text('gallery'))
//               ],
//             );
//           }
//       );
//   } else {
//     return showModalBottomSheet(
//     context: context,
//     builder: (context){
//       return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         ListTile(
//   leading: Icon(Icons.camera_alt),
//   title: Text('camera'),
//   onTap: (){Navigator.of(context).pop(ImageSource.camera);},
//   ),
//   ListTile(
//   leading: Icon(Icons.camera_alt),
//   title: Text('camera'),
//   onTap: (){Navigator.of(context).pop(ImageSource.camera);},
//   ),
//         ],
//       );
//     });
//     }
// }
