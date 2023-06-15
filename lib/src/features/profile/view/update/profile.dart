import 'package:dropsride/src/common_widgets/appbar_title.dart';
import 'package:dropsride/src/constants/gaps.dart';
import 'package:dropsride/src/constants/size.dart';
import 'package:dropsride/src/features/profile/controller/profile_controller.dart';
import 'package:dropsride/src/features/profile/model/user_model.dart';
import 'package:dropsride/src/utils/theme/colors.dart';
import 'package:dropsride/src/utils/validators.dart';

import 'package:date_field/date_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class ProfileUpdateScreen extends StatelessWidget {
  ProfileUpdateScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final List<Gender> genderItems = [
    Gender.gender,
    Gender.male,
    Gender.female,
  ];

  final List<String> countriesItem = [
    'Nigeria',
    'Ghana',
    'United States',
  ];

  @override
  Widget build(BuildContext context) {
    // ! initialize the profile controller here
    Get.put(ProfileController());

    bool isLoading = false;
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
        title: const AppBarTitle(pageTitle: "Edit Profile"),
        actions: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: AppSizes.padding * 1.4),
            child: InkWell(
              onTap: () {},
              child: const Row(
                children: [
                  Text(
                    'Delete Account',
                    style: TextStyle(
                        color: AppColors.red, fontWeight: FontWeight.w900),
                  ),
                  Icon(
                    Icons.delete,
                    color: AppColors.red,
                  ),
                ],
              ),
            ),
          )
        ],
      ),

      // ! body section
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(AppSizes.padding * 2),
          child: FutureBuilder(
            // wrap with <List<UserModel>>( to get no error rendering the list of users
            future: ProfileController.instance
                .getUserData(FirebaseAuth.instance.currentUser!.email!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  // ! initialize the data here
                  // todo: use the information here to initialize each form field initial value
                  UserModel userData = snapshot.data as UserModel;
                  return Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            hSizedBox2,
                            TextFormField(
                              onTapOutside: (event) {
                                ProfileController.instance
                                    .validateFields(_formKey);
                              },
                              onChanged: (value) {
                                ProfileController.instance.displayName.value =
                                    value;
                              },
                              onSaved: (newValue) {
                                ProfileController.instance.displayName.value =
                                    newValue!;
                              },
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1.4,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondaryContainer),
                              enableSuggestions: true,
                              keyboardType: TextInputType.text,
                              autocorrect: false,
                              textCapitalization: TextCapitalization.words,
                              validator: (value) {
                                if (!validateRequired(value!)) {
                                  return "This field is required";
                                }

                                if (!validateAlphabetsOnly(value)) {
                                  return "This field must be alphabets only";
                                }

                                return null;
                              },
                              enableIMEPersonalizedLearning: true,
                              initialValue: userData.displayName,
                              decoration: InputDecoration(
                                label: const Text(
                                    'Full Name (First and Last Name)'),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.auto,
                                floatingLabelAlignment:
                                    FloatingLabelAlignment.start,
                                filled: true,
                                fillColor:
                                    Theme.of(context).colorScheme.onSecondary,
                                isDense: true,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppSizes.margin,
                                  ),
                                  borderSide: const BorderSide(
                                      width: AppSizes.p2,
                                      color: AppColors.primaryColor),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppSizes.margin,
                                  ),
                                  borderSide: const BorderSide(
                                      width: AppSizes.p2, color: AppColors.red),
                                ),
                              ),
                            ),
                            hSizedBox4,
                            TextFormField(
                              readOnly: true,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1.4,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondaryContainer),
                              enableSuggestions: true,
                              keyboardType: TextInputType.text,
                              autocorrect: false,
                              textCapitalization: TextCapitalization.words,
                              validator: (value) {
                                if (!validateRequired(value!)) {
                                  return "This field is required";
                                }

                                if (!validateEmail(value)) {
                                  return "This must be a valid email field";
                                }

                                return null;
                              },
                              enableIMEPersonalizedLearning: true,
                              initialValue: userData.email,
                              decoration: InputDecoration(
                                label: const Text('Email'),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.auto,
                                floatingLabelAlignment:
                                    FloatingLabelAlignment.start,
                                filled: true,
                                fillColor:
                                    Theme.of(context).colorScheme.onSecondary,
                                isDense: true,
                                suffixIcon: const Icon(
                                    Icons.mail_outline_rounded,
                                    size: AppSizes.iconSize * 1.4),
                                suffixIconColor:
                                    Theme.of(context).colorScheme.onBackground,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppSizes.margin,
                                  ),
                                  borderSide: const BorderSide(
                                      width: AppSizes.p2,
                                      color: AppColors.primaryColor),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppSizes.margin,
                                  ),
                                  borderSide: const BorderSide(
                                      width: AppSizes.p2, color: AppColors.red),
                                ),
                              ),
                            ),
                            hSizedBox4,
                            DateTimeFormField(
                              initialValue: userData.dateOfBirth,
                              mode: DateTimeFieldPickerMode.date,
                              initialDate: userData.dateOfBirth,
                              onSaved: (newValue) {
                                ProfileController.instance.dateOfBirth.value =
                                    newValue!;
                              },
                              lastDate: userData.dateOfBirth,
                              onDateSelected: (value) {
                                ProfileController.instance.dateOfBirth.value =
                                    value;
                                ProfileController.instance
                                    .validateFields(_formKey);
                              },
                              validator: (value) {
                                if (value != null) {
                                  if (value.year > DateTime.now().year - 18) {
                                    return 'You must be above 18 years of age to use this application';
                                  }
                                  return null;
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                label: const Text('Date of Birth'),
                                labelStyle: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1.4,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondaryContainer),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.auto,
                                floatingLabelAlignment:
                                    FloatingLabelAlignment.start,
                                filled: true,
                                fillColor:
                                    Theme.of(context).colorScheme.onSecondary,
                                isDense: false,
                                suffixIcon: const Icon(Icons.calendar_month),
                                suffixIconColor:
                                    Theme.of(context).colorScheme.onBackground,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppSizes.margin,
                                  ),
                                  borderSide: const BorderSide(
                                      width: AppSizes.p2,
                                      color: AppColors.primaryColor),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppSizes.margin,
                                  ),
                                  borderSide: const BorderSide(
                                      width: AppSizes.p2, color: AppColors.red),
                                ),
                              ),
                            ),
                            hSizedBox4,
                            DropdownButtonFormField(
                              decoration: InputDecoration(
                                label: const Text('Country'),
                                labelStyle: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1.4,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondaryContainer),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.auto,
                                floatingLabelAlignment:
                                    FloatingLabelAlignment.start,
                                filled: true,
                                fillColor:
                                    Theme.of(context).colorScheme.onSecondary,
                                isDense: true,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppSizes.margin,
                                  ),
                                  borderSide: const BorderSide(
                                      width: AppSizes.p2,
                                      color: AppColors.primaryColor),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppSizes.margin,
                                  ),
                                  borderSide: const BorderSide(
                                      width: AppSizes.p2, color: AppColors.red),
                                ),
                              ),
                              items: countriesItem.map((item) {
                                return DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(item),
                                );
                              }).toList(),
                              value: userData.country,
                              onChanged: (value) {
                                ProfileController.instance.country.value =
                                    value ?? 'Select Country';
                              },
                              onSaved: (newValue) {
                                ProfileController.instance.country.value =
                                    userData.country ?? 'Nigeria';
                              },
                              hint: Text(
                                userData.country ?? 'Country',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1.4,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondaryContainer),
                              ),
                            ),
                            hSizedBox4,
                            IntlPhoneField(
                              disableLengthCheck: true,
                              initialValue: userData.phoneNumber?.number,
                              // onChanged: (value) {
                              //   aController.phoneInput.value = value;
                              // },
                              flagsButtonMargin: const EdgeInsets.all(12),
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      signed: true, decimal: false),
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1.4,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondaryContainer),
                              initialCountryCode:
                                  userData.phoneNumber?.countryISOCode,
                              countries: const [
                                'NG',
                                'GH',
                                'US',
                              ],
                              onChanged: (value) {
                                ProfileController.instance.phoneNumber.value =
                                    PhoneNumberMap(
                                  countryCode: value.countryCode,
                                  countryISOCode: value.countryISOCode,
                                  number: value.number,
                                );
                              },
                              onSaved: (newValue) {
                                ProfileController.instance.phoneNumber.value =
                                    PhoneNumberMap(
                                  countryCode: newValue!.countryCode,
                                  countryISOCode: newValue.countryISOCode,
                                  number: newValue.number,
                                );
                              },
                              inputFormatters: [
                                MaskedInputFormatter('000 000 0000')
                              ],
                              decoration: InputDecoration(
                                labelText: 'Phone Number',
                                floatingLabelAlignment:
                                    FloatingLabelAlignment.start,
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.auto,
                                filled: true,
                                fillColor:
                                    Theme.of(context).colorScheme.onSecondary,
                                isDense: true,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppSizes.margin,
                                  ),
                                  borderSide: const BorderSide(
                                      width: AppSizes.p2,
                                      color: AppColors.primaryColor),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppSizes.margin,
                                  ),
                                  borderSide: const BorderSide(
                                      width: AppSizes.p2, color: AppColors.red),
                                ),
                              ),
                            ),
                            hSizedBox4,
                            DropdownButtonFormField(
                              decoration: InputDecoration(
                                label: const Text('Gender'),
                                labelStyle: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1.4,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondaryContainer),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.auto,
                                floatingLabelAlignment:
                                    FloatingLabelAlignment.start,
                                filled: true,
                                fillColor:
                                    Theme.of(context).colorScheme.onSecondary,
                                isDense: true,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppSizes.margin,
                                  ),
                                  borderSide: const BorderSide(
                                      width: AppSizes.p2,
                                      color: AppColors.primaryColor),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppSizes.margin,
                                  ),
                                  borderSide: const BorderSide(
                                      width: AppSizes.p2, color: AppColors.red),
                                ),
                              ),
                              items: genderItems.map(
                                (item) {
                                  return DropdownMenuItem<Gender>(
                                    value: item,
                                    child: Text(item.name),
                                  );
                                },
                              ).toList(),
                              onChanged: (value) {
                                ProfileController.instance.gender.value =
                                    value ?? Gender.gender;
                              },
                              value: userData.gender ?? Gender.gender,
                              onSaved: (newValue) {
                                ProfileController.instance.gender.value =
                                    newValue ?? userData.gender;
                              },
                              hint: Text(
                                userData.gender?.name ?? 'Gender',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1.4,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondaryContainer),
                              ),
                            ),
                            hSizedBox6,
                            Obx(
                              () => SizedBox(
                                width: double.maxFinite,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    await ProfileController.instance
                                        .updateUser(_formKey);
                                  },
                                  child: Text(
                                    ProfileController.instance.isLoading.value
                                        ? 'Updating...'
                                        : 'Update Details',
                                    style: const TextStyle(
                                      fontSize: AppSizes.iconSize,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            hSizedBox4,
                            SizedBox(
                              width: double.maxFinite,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Joined ${userData.joinedOn.day} ${userData.joinedOn.year}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.w900,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                }
              } else {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }
              return Center(
                child: Text(snapshot.error.toString()),
              );
            },
          ),
        ),
      ),
    );
  }
}
