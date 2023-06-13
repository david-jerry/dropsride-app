import 'package:dropsride/src/common_widgets/appbar_title.dart';
import 'package:dropsride/src/constants/assets.dart';
import 'package:dropsride/src/constants/size.dart';
import 'package:dropsride/src/features/profile/controller/destination_controller.dart';
import 'package:dropsride/src/features/profile/controller/repository/destination_firebase.dart';
import 'package:dropsride/src/features/profile/model/favorite_destinations_model.dart';
import 'package:dropsride/src/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ! app bar section
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: IconButton(
          onPressed: () => Get.back(canPop: true, closeOverlays: false),
          icon: Icon(
            FontAwesomeIcons.angleLeft,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        titleSpacing: AppSizes.padding,
        primary: true,
        scrolledUnderElevation: AppSizes.p4,
        title: const AppBarTitle(pageTitle: "Favorite Destinations"),
        actions: [
          Obx(
            () => Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.padding * 1.4),
              child: InkWell(
                onTap: () async {
                  DestinationController.instance.openAddDestination();
                },
                child: Row(
                  children: [
                    DestinationController.instance.isGettingLocation.value
                        ? const CircularProgressIndicator.adaptive()
                        : const Icon(
                            Icons.add_location_alt_outlined,
                            color: AppColors.green,
                          ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),

      // body details using future builder to list all details of the items
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.padding),
        child: StreamBuilder<List<FavouriteDestination>>(
          stream: DestinationRepository.instance.getAllFavoriteDestination(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                final data = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final locationData = snapshot.data![index];
                    return Column(
                      children: [
                        Card(
                          child: ListTile(
                            leading: Image.asset(
                              Assets.assetsImagesDriverIconFavoriteDestinationLeadingIconSvg,
                              width: AppSizes.iconSize * 1.4,
                              // color: AppColors.primaryColor,
                            ),
                            title: Text(
                              locationData.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 22,
                                  ),
                            ),
                            subtitle: Text(locationData.address),
                          ),
                        ),
                      ],
                    );
                  },
                );
              } else {
                return const Center(
                  child: Text('There is no saved location to show'),
                );
              }
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('There is error'),
              );
            } else {
              if (snapshot.hasData) {
                final data = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final locationData = snapshot.data![index];
                    return Column(
                      children: [
                        Card(
                          child: ListTile(
                            leading: SvgPicture.asset(
                              Assets.assetsImagesDriverIconFavoriteDestinationLeadingIcon,
                              width: AppSizes.iconSize * 2,
                              // color: AppColors.primaryColor,
                            ),
                            title: Text(
                              locationData.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 22,
                                  ),
                            ),
                            subtitle: Text(locationData.address),
                          ),
                        ),
                      ],
                    );
                  },
                );
              } else {
                return const Center(
                  child: Text('There is no saved location to show'),
                );
              }
            }
          },
        ),
      ),
    );
  }
}
