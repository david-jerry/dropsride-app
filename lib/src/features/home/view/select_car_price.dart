// import 'package:dropsride/src/constants/assets.dart';
// import 'package:dropsride/src/constants/placeholder.dart';
// import 'package:dropsride/src/constants/size.dart';
// import 'package:dropsride/src/features/auth/controller/auth_controller.dart';
// import 'package:dropsride/src/features/home/controller/map_controller.dart';
// import 'package:dropsride/src/features/home/widget/sidebar.dart';
// import 'package:dropsride/src/utils/size_config.dart';
// import 'package:dropsride/src/utils/theme/colors.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_credit_card/extension.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';

// class SelectCarScreenScreen extends StatelessWidget {
//   const SelectCarScreenScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // size config initialization
//     SizeConfig.init(context);

//     final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

//     MapController map = Get.find<MapController>();

//     void openDrawer() {
//       scaffoldKey.currentState?.openDrawer();
//     }

//     WidgetsBinding.instance.addPostFrameCallback(
//       (_) async {
//         await map.getUserData();
//         await map.onBuildCompleted();
//       },
//     );

//     final isSubscribed = AuthController.find.isSubscribed.value;

//     return Scaffold(
//       key: scaffoldKey,
//       drawer: const SideBar(),
//       body: Obx(
//         () => SizedBox(
//           width: double.infinity,
//           height: double.infinity,
//           child: SingleChildScrollView(
//             child: map.hasLoadedMarker.value
//                 ? Stack(
//                     children: [
//                       SizedBox(
//                         width: SizeConfig.screenWidth,
//                         height: SizeConfig.screenHeight,
//                         child: map.googleMap.value!,
//                       ),

//                       // ? Menu Drawer Button
//                       Positioned(
//                         top: AppSizes.padding * 3,
//                         left: AppSizes.padding * 1.4,
//                         child: GestureDetector(
//                           onTap: () => openDrawer(),
//                           child: Material(
//                             elevation: 4,
//                             borderRadius:
//                                 BorderRadius.circular(AppSizes.iconSize * 2.5),
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(
//                                     AppSizes.iconSize * 2.5),
//                                 color: Theme.of(context).colorScheme.background,
//                               ),
//                               padding: const EdgeInsets.all(AppSizes.padding),
//                               child: SvgPicture.asset(
//                                 Assets.assetsImagesIconsMenuIcon,
//                                 color:
//                                     Theme.of(context).colorScheme.onBackground,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),

//                       // ? Get Current Location Position FLoating Button
//                       Positioned(
//                         bottom: map.bottomSheetHeight.value +
//                             AppSizes.margin +
//                             (AppSizes.padding * 3),
//                         right: AppSizes.padding * 1.4,
//                         child: GestureDetector(
//                           onTap: () => map.goToMyLocation(),
//                           child: Material(
//                             elevation: 4,
//                             borderRadius:
//                                 BorderRadius.circular(AppSizes.iconSize * 2.5),
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(
//                                     AppSizes.iconSize * 2.5),
//                                 color: Theme.of(context).colorScheme.background,
//                               ),
//                               padding: const EdgeInsets.all(AppSizes.padding),
//                               child: SvgPicture.asset(
//                                 Assets.assetsImagesIconsCurrentLocation,
//                                 color:
//                                     Theme.of(context).colorScheme.onBackground,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),

//                       // ? Bottom Sheet with text field to add a dropoff location
//                       Positioned(
//                         top: SizeConfig.screenHeight -
//                             map.bottomSheetHeight.value +
//                             20,
//                         bottom: 0,
//                         left: 0,
//                         right: 0,
//                         child: SearchLocationBottomSheet(
//                           map: map,
//                         ), //map.dropOffSelected.value
//                       ),
//                     ],
//                   )
//                 : Column(
//                     children: [
//                       // current user marker
//                       if (!map.openedSelectCar.value)
//                         Transform.translate(
//                           offset: Offset(-SizeConfig.screenHeight * 2,
//                               -SizeConfig.screenWidth * 2),
//                           child: RepaintBoundary(
//                             key: map.currentUserMarkerKey,
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 color: AppColors.white100,
//                                 border: Border.all(
//                                   color: AppColors.primaryColor,
//                                   width: 4,
//                                 ),
//                                 borderRadius: BorderRadius.circular(70),
//                               ),
//                               padding: const EdgeInsets.all(4),
//                               child: ClipRRect(
//                                 borderRadius: BorderRadius.circular(70),
//                                 child: Image.network(
//                                   map.userPhoto.value.isNotNullAndNotEmpty
//                                       ? map.userPhoto.value
//                                       : kPlaceholder,
//                                   fit: BoxFit.contain,
//                                   height: 28,
//                                   width: 28,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),

//                       // pickup marker
//                       Transform.translate(
//                         offset: Offset(-SizeConfig.screenHeight * 2,
//                             -SizeConfig.screenWidth * 2),
//                         child: RepaintBoundary(
//                           key: map.pickupKey,
//                           child: SvgPicture.asset(
//                             Assets.assetsImagesIconsUserMarker,
//                             height: 65,
//                             width: 65,
//                           ),
//                         ),
//                       ),

//                       Transform.translate(
//                         offset: Offset(-SizeConfig.screenHeight * 2,
//                             -SizeConfig.screenWidth * 2),
//                         child: RepaintBoundary(
//                           key: map.dropoffKey,
//                           child: SvgPicture.asset(
//                             Assets.assetsImagesIconsDestinationMarker,
//                             height: 65,
//                             width: 65,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class SearchLocationBottomSheet extends StatelessWidget {
//   const SearchLocationBottomSheet({super.key, required this.map});

//   final MapController map;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//         onVerticalDragUpdate: (DragUpdateDetails details) {
//           if (map.bottomSheetDragOffset.value < 0 &&
//               map.bottomSheetHeight.value < 221) {
//             map.bottomSheetDragOffset.value = 0.0;
//             map.bottomSheetHeight.value = 220.0;
//           } else if (map.bottomSheetDragOffset.value > 0 &&
//               map.bottomSheetHeight.value > SizeConfig.screenHeight) {
//             map.bottomSheetDragOffset.value = 0.0;
//             map.bottomSheetHeight.value = SizeConfig.screenHeight;
//           } else if (map.bottomSheetDragOffset.value > 0 &&
//               map.bottomSheetHeight.value > 220 &&
//               !MapController.find.openedSelectCar.value) {
//             //(SizeConfig.screenHeight
//             map.bottomSheetDragOffset.value = 0.0;
//             map.bottomSheetHeight.value = SizeConfig.screenHeight;
//           } else if (map.bottomSheetDragOffset.value > 0 &&
//               map.bottomSheetHeight.value < SizeConfig.screenHeight &&
//               MapController.find.openedSelectCar.value) {
//             //(SizeConfig.screenHeight
//             map.bottomSheetDragOffset.value = 0.0;
//             map.bottomSheetHeight.value -= details.delta.dy;
//           } else {
//             map.bottomSheetDragOffset.value -= details.delta.dy;
//             map.bottomSheetHeight.value -= details.delta.dy;
//           }
//         },
//         onVerticalDragEnd: (details) {
//           map.bottomSheetDragOffset.value = 0.0;
//         },
//         child: Container(
//           width: double.maxFinite,
//           height: map.bottomSheetHeight.value,
//           padding: const EdgeInsets.all(AppSizes.padding * 1.4),
//           decoration: BoxDecoration(
//             boxShadow: [
//               BoxShadow(
//                 color: AppColors.secondaryColor.withOpacity(0.2),
//                 spreadRadius: 1,
//                 blurRadius: 5,
//                 offset: const Offset(0, -3),
//               )
//             ],
//             borderRadius: const BorderRadius.vertical(
//               top: Radius.circular(
//                 AppSizes.padding * 2,
//               ),
//             ),
//             color: Theme.of(context).colorScheme.background,
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.max,
//             children: [
//               Divider(
//                 color: AppColors.grey300,
//                 thickness: 3,
//                 endIndent: SizeConfig.screenWidth * 0.3,
//                 indent: SizeConfig.screenWidth * 0.3,
//               ),
//               const SizedBox(height: AppSizes.padding),
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       SizedBox(
//                         width: double.maxFinite,
//                         child: Column(
//                           children: [
//                             Row(
//                               children: [
//                                 Column(
//                                   mainAxisSize: MainAxisSize.max,
//                                   children: [
//                                     SvgPicture.asset(
//                                       Assets.assetsImagesIconsCurrentLocation,
//                                       color: AppColors.primaryColor,
//                                     ),
//                                     const SizedBox(
//                                       height: 37,
//                                       child: VerticalDivider(
//                                         width: AppSizes.p12,
//                                         thickness: 2,
//                                         indent: 8,
//                                         endIndent: 8,
//                                       ),
//                                     ),
//                                     SvgPicture.asset(
//                                       Assets.assetsImagesIconsLocationFilled,
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onBackground,
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(width: 6),
//                                 Expanded(
//                                   child: Column(
//                                     children: [
//                                       SizedBox(
//                                         width: double.maxFinite,
//                                         child: Text(
//                                           map.userPickupLocation.value!
//                                               .locationName!,
//                                           softWrap: true,
//                                         ),
//                                       ),
//                                       Divider(
//                                         thickness: 1.3,
//                                         height: AppSizes.padding * 2.4,
//                                         color: Theme.of(context)
//                                             .colorScheme
//                                             .onBackground,
//                                       ),
//                                       SizedBox(
//                                         width: double.maxFinite,
//                                         child: Text(
//                                           map.userDropOffLocation.value!
//                                               .locationName!,
//                                           softWrap: true,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ));
//   }
// }
