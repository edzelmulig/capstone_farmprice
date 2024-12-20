import 'package:flutter/material.dart';
import 'package:myapp/services/firebase_service.dart';
import 'package:myapp/ui/screens/admin_screen/crop_reports/add_crop_report.dart';
import 'package:myapp/ui/screens/admin_screen/crop_reports/update_crop_report.dart';
import 'package:myapp/ui/widgets/app_bar/custom_app_bar.dart';
import 'package:myapp/ui/widgets/cards/admin_cards/crop_report_card.dart';
import 'package:myapp/ui/widgets/custom_floating_action_button.dart';
import 'package:myapp/ui/widgets/custom_loading_indicator_v2.dart';
import 'package:myapp/ui/widgets/modals/custom_modals.dart';
import 'package:myapp/ui/widgets/navigation/custom_navigation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/ui/widgets/no_market_available.dart';

class CropReportsScreen extends StatefulWidget {
  const CropReportsScreen({super.key});

  @override
  State<CropReportsScreen> createState() => _CropReportsScreenState();
}

class _CropReportsScreenState extends State<CropReportsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(AppBar().preferredSize.height),
        child: CustomAppBar(
          backgroundColor: const Color(0xFF133c0b).withOpacity(0.3),
          titleText: "Crop Reports",
          fontColor: const Color(0xFF3C4D48),
          onLeadingPressed: () {
            Navigator.pop(context); // Safely pops to the previous screen
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('admin_accounts')
            .doc('crop_reports')
            .collection('reports')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // DISPLAY CUSTOM LOADING INDICATOR
            return const CustomLoadingIndicator();
          }
          // IF FETCHING DATA HAS ERROR EXECUTE THIS
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // CHECK IF THERE IS AVAILABLE SERVICES
          if (snapshot.data?.docs.isEmpty ?? true) {
            // DISPLAY THERE IS NO AVAILABLE SERVICES
            return const NoMarketAvailable(
              screenName: 'crop report',
            );
          } else {
            // DISPLAY AVAILABLE SERVICES: AS GRIDVIEW
            return GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // NUMBER OF COLUMNS
                crossAxisSpacing: 10, // HORIZONTAL SPACE BETWEEN CARDS
                mainAxisSpacing: 10, // VERTICAL SPACE BETWEEN CARDS
                childAspectRatio: 0.8, // ASPECT RATIO OF EACH CARD
              ),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var cropReports = snapshot.data!.docs[index];

                return CropReportCard(
                  cropReports: cropReports,
                  onUpdate: () {
                    String cropReportID = cropReports.id;
                    navigateWithSlideFromRight(
                      context,
                      UpdateCropReport(
                        cropReportID: cropReportID,
                      ),
                      0.0,
                      1.0,
                    );
                  },
                  onDelete: () async {
                    showDeleteWarning(
                      context,
                      'Are you sure you want to delete this market?',
                      'Delete',
                      (cropReportsID) => FirebaseService.deleteCropReport(
                          context,
                          marketID: cropReportsID),
                      cropReports.id,
                    );
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: CustomFloatingActionButton(
        textLabel: "Add Report",
        onPressed: () {
          navigateWithSlideFromRight(
            context,
            const AddCropReport(),
            1.0,
            0.0,
          );
        },
      ),
    );
  }
}
