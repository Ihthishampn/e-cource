import 'package:e_cource/feature/settings/presentation/provider/settings_tab_provider.dart';
import 'package:e_cource/feature/settings/presentation/view/bunny_vdo_screen.dart';
import 'package:e_cource/feature/settings/presentation/view/help_and_support_screen.dart';
import 'package:e_cource/feature/settings/presentation/view/live_settings_screen.dart';
import 'package:e_cource/feature/settings/presentation/view/manage_user_screen.dart';
import 'package:e_cource/feature/settings/presentation/view/payement_option_screen.dart';
import 'package:e_cource/feature/settings/presentation/view/privacy_policy_screen.dart';
import 'package:e_cource/feature/settings/presentation/view/terms_contition__screen.dart';
import 'package:e_cource/feature/settings/presentation/view/time_slot_screen.dart';

import 'package:e_cource/feature/settings/presentation/widgets/selection_Item_settings.dart';
import 'package:e_cource/general/core/theme/app_colors.dart';
import 'package:e_cource/general/widgets/custom_main_header.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  ScrollController scrollController = ScrollController();
  final TextEditingController termsHeadercontroller = TextEditingController();
  final TextEditingController termsDescriptionHeadercontroller =
      TextEditingController();

  final TextEditingController helpWpNUmberController = TextEditingController();
  final TextEditingController helpEmailController = TextEditingController();
  final TextEditingController helpContactController = TextEditingController();
  final TextEditingController privacyHeaderController = TextEditingController();
  final TextEditingController privacyDescriptionController =
      TextEditingController();

  late final List<Widget> list = [
    PrivacyPolicyScreen(
      privacyHeaderController: privacyHeaderController,
      privacyDescriptionController: privacyDescriptionController,
    ),

    //2
    HelpAndSupportScreen(
      helpWpNUmberController: helpWpNUmberController,
      helpEmailController: helpEmailController,
      helpContactController: helpContactController,
    ),

    //3
    TermsAndContition(
      headerController: termsHeadercontroller,
      descriptionController: termsDescriptionHeadercontroller,
    ),

    //4
    ManageUserScreen(),

    //5
    BunnyVdoScreen(),

    //6
    PayementOptionScreen(),

    //7
    LiveSettingsScreen(),

    //8
    TimeSlotScreen(),
  ];

  @override
  void dispose() {
    scrollController.dispose();
    termsDescriptionHeadercontroller.dispose();
    termsHeadercontroller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          const CustomMainHeader(),

          // ------------------ // --------------------- //
          SliverFillRemaining(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  SizedBox(
                    width: 180,

                    child: Column(
                      children: [
                        Text(
                          'Settings',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        Gap(18),

                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 0.5,
                                color: Colors.transparent,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              color: const Color.fromARGB(255, 255, 255, 255),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 0.5,
                                  color: const Color.fromARGB(255, 61, 61, 61),
                                ),
                                borderRadius: BorderRadius.circular(12),
                                color: const Color.fromARGB(255, 233, 230, 230),
                              ),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: SingleChildScrollView(
                                      child: Consumer<SettingsTabProvider>(
                                        builder: (context, value, child) =>
                                            Column(
                                              children: [
                                                SelectionItemSettings(
                                                  text: "Privacy Policy",
                                                  ontap: () {
                                                    value.changeIndexSettings(
                                                      0,
                                                    );
                                                  },
                                                  color: value.selctedIndex == 0 ? Colors.black : Colors.grey,
                                                ),
                                                SelectionItemSettings(
                                                  text: "Help & Support",
                                                  ontap: () {
                                                    value.changeIndexSettings(
                                                      1,
                                                    );
                                                  },
                                                  color: value.selctedIndex == 1 ? Colors.black : Colors.grey,
                                                ),
                                                SelectionItemSettings(
                                                  text: "Terms And\nCondition",
                                                  ontap: () {
                                                    value.changeIndexSettings(
                                                      2,
                                                    );
                                                  },
                                                  color: value.selctedIndex == 2 ? Colors.black : Colors.grey,
                                                ),
                                                SelectionItemSettings(
                                                  text: "Manage Users",
                                                  ontap: () {
                                                    value.changeIndexSettings(
                                                      3,
                                                    );
                                                  },
                                                  color: value.selctedIndex == 3 ? Colors.black : Colors.grey,
                                                ),
                                                SelectionItemSettings(
                                                  text: "Bunny Video",
                                                  ontap: () {
                                                    value.changeIndexSettings(
                                                      4,
                                                    );
                                                  },
                                                  color: value.selctedIndex == 4 ? Colors.black : Colors.grey,
                                                ),
                                                SelectionItemSettings(
                                                  text: "Payment Options",
                                                  ontap: () {
                                                    value.changeIndexSettings(
                                                      5,
                                                    );
                                                  },
                                                  color: value.selctedIndex == 5 ? Colors.black : Colors.grey,
                                                ),
                                                SelectionItemSettings(
                                                  text: "Live Settings",
                                                  ontap: () {
                                                    value.changeIndexSettings(
                                                      6,
                                                    );
                                                  },
                                                  color: value.selctedIndex == 6 ? Colors.black : Colors.grey,
                                                ),
                                                SelectionItemSettings(
                                                  text: "Time Slot",
                                                  ontap: () {
                                                    value.changeIndexSettings(
                                                      7,
                                                    );
                                                  },
                                                  color: value.selctedIndex == 7 ? Colors.black : Colors.grey,
                                                ),
                                              ],
                                            ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 20),

                                  InkWell(
                                    onTap: () {},
                                    child: Container(
                                      height: 45,
                                      decoration: BoxDecoration(
                                        color: const Color(0xffEF5350),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Log Out',
                                            style: TextStyle(
                                              color: AppColors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Gap(10),
                                          Icon(
                                            Icons.logout_rounded,
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  //   2 nd screen
                  Expanded(
                    child: Consumer<SettingsTabProvider>(
                      builder: (context, provider, child) {
                        return IndexedStack(
                          index: provider.selctedIndex,
                          children: list,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
