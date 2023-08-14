import 'package:dropsride/src/common_widgets/appbar_title.dart';
import 'package:dropsride/src/constants/gaps.dart';
import 'package:dropsride/src/constants/size.dart';
import 'package:dropsride/src/features/auth/controller/auth_controller.dart';
import 'package:dropsride/src/features/profile/controller/profile_controller.dart';
import 'package:dropsride/src/features/profile/model/user_model.dart';
import 'package:dropsride/src/utils/theme/colors.dart';
import 'package:dropsride/src/utils/validators.dart';

import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class ProfileUpdateScreen extends StatelessWidget {
  ProfileUpdateScreen({super.key});

  final formKey = GlobalKey<FormState>();
  // final genderItems = [
  //   DropdownMenuItem(value: Gender.gender, child: Text(Gender.gender.name)),
  //   DropdownMenuItem(value: Gender.male, child: Text(Gender.male.name)),
  //   DropdownMenuItem(value: Gender.female, child: Text(Gender.female.name)),
  // ];

  // final countriesItem = [
  //   const DropdownMenuItem(value: 'Nigeria', child: Text('Nigeria')),
  //   const DropdownMenuItem(value: 'Ghana', child: Text('Ghana')),
  //   const DropdownMenuItem(
  //       value: 'United States', child: Text('United States')),
  // ];

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
          onPressed: () => Get.back(canPop: true, closeOverlays: true),
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
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Obx(
                () => Form(
                  key: formKey,
                  child: Column(
                    children: [
                      hSizedBox2,
                      TextFormField(
                        onTapOutside: (event) {
                          ProfileController.instance.validateFields(formKey);
                        },
                        onChanged: (value) {
                          ProfileController.instance.displayName.value = value;
                        },
                        onSaved: (newValue) {
                          ProfileController.instance.displayName.value =
                              newValue!;
                        },
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
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
                        initialValue:
                            AuthController.find.userModel.value!.displayName,
                        decoration: InputDecoration(
                          label: const Text('Full Name (First and Last Name)'),
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          floatingLabelAlignment: FloatingLabelAlignment.start,
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.onSecondary,
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
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
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
                        initialValue:
                            AuthController.find.userModel.value!.email,
                        decoration: InputDecoration(
                          label: const Text('Email'),
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          floatingLabelAlignment: FloatingLabelAlignment.start,
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.onSecondary,
                          isDense: true,
                          suffixIcon: const Icon(Icons.mail_outline_rounded,
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
                        initialValue:
                            AuthController.find.userModel.value!.dateOfBirth,
                        mode: DateTimeFieldPickerMode.date,
                        initialDate:
                            AuthController.find.userModel.value!.dateOfBirth,
                        onSaved: (newValue) {
                          ProfileController.instance.dateOfBirth.value =
                              newValue!;
                        },
                        lastDate:
                            AuthController.find.userModel.value!.dateOfBirth,
                        onDateSelected: (value) {
                          ProfileController.instance.dateOfBirth.value = value;
                          ProfileController.instance.validateFields(formKey);
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
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          floatingLabelAlignment: FloatingLabelAlignment.start,
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.onSecondary,
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
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          floatingLabelAlignment: FloatingLabelAlignment.start,
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.onSecondary,
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
                        value: AuthController.find.userModel.value!.country,
                        onChanged: (value) {
                          print(value);
                          ProfileController.instance.country.value =
                              value ?? 'Select Country';
                        },
                        onSaved: (newValue) {
                          print(newValue);
                          ProfileController.instance.country.value = newValue ??
                              AuthController.find.userModel.value!.country!;
                        },
                        items: const [
                          DropdownMenuItem<String>(
                              value: '', child: Text('Select Country')),
                          DropdownMenuItem<String>(
                              value: 'Nigeria', child: Text('Nigeria')),
                          DropdownMenuItem<String>(
                              value: 'Ghana', child: Text('Ghana')),
                          DropdownMenuItem<String>(
                              value: 'United States',
                              child: Text('United States')),
                        ],
                        hint: Text(
                          AuthController.find.userModel.value!.country ??
                              'Country',
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
                        initialValue: AuthController
                            .instance.userModel.value!.phoneNumber?.number,
                        // onChanged: (value) {
                        //   aController.phoneInput.value = value;
                        // },
                        flagsButtonMargin: const EdgeInsets.all(12),
                        keyboardType: const TextInputType.numberWithOptions(
                            signed: true, decimal: false),
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.4,
                            color: Theme.of(context)
                                .colorScheme
                                .onSecondaryContainer),
                        initialCountryCode: AuthController
                            .find.userModel.value!.phoneNumber?.countryISOCode,
                        // countries: const [
                        //   'NG',
                        //   'GH',
                        //   'US',
                        // ],
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
                        inputFormatters: [MaskedInputFormatter('000 000 0000')],
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          floatingLabelAlignment: FloatingLabelAlignment.start,
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.onSecondary,
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
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          floatingLabelAlignment: FloatingLabelAlignment.start,
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.onSecondary,
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
                        items: [
                          DropdownMenuItem(
                              value: Gender.gender,
                              child: Text(Gender.gender.name)),
                          DropdownMenuItem(
                              value: Gender.male,
                              child: Text(Gender.male.name)),
                          DropdownMenuItem(
                              value: Gender.female,
                              child: Text(Gender.female.name)),
                        ],
                        onChanged: (value) {
                          ProfileController.instance.gender.value =
                              value ?? Gender.gender;
                        },
                        value: AuthController.find.userModel.value!.gender ??
                            Gender.gender,
                        onSaved: (newValue) {
                          ProfileController.instance.gender.value = newValue ??
                              AuthController.find.userModel.value!.gender;
                        },
                        hint: Text(
                          AuthController.find.userModel.value!.gender?.name ??
                              'Gender',
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
                      SizedBox(
                        width: double.maxFinite,
                        child: ElevatedButton(
                          onPressed: () async {
                            await ProfileController.instance
                                .updateUser(formKey);
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
                      hSizedBox4,
                      SizedBox(
                        width: double.maxFinite,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Joined ${AuthController.find.userModel.value!.joinedOn.day} ${AuthController.find.userModel.value!.joinedOn.year}',
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
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
