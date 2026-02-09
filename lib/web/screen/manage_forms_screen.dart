import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sappiire/constants/app_colors.dart';
import 'package:sappiire/web/widget/side_menu.dart';
// YOUR IMPORTS
import 'package:sappiire/resources/static_form_input.dart'; 

class ManageFormsScreen extends StatefulWidget {
  const ManageFormsScreen({super.key});

  @override
  State<ManageFormsScreen> createState() => _ManageFormsScreenState();
}

class _ManageFormsScreenState extends State<ManageFormsScreen> {
  String selectedForm = "General Intake Sheet";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FE), // Light background
      body: Row(
        children: [
          const SideMenu(activePath: "Forms"),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(35.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- HEADER ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Forms Management",
                        style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primaryBlue),
                      ),
                      _buildHeaderButton("Create New Forms", Icons.add),
                    ],
                  ),
                  const SizedBox(height: 25),

                  // --- DROPDOWN ---
                  _buildDropdown(),
                  const SizedBox(height: 25),

                  // --- MAIN BENTO CONTENT ---
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.accentBlue, // Using Accent Blue for the form card
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20)],
                      ),
                      child: Row(
                        children: [
                          // LEFT SIDE: QR CODE
                          _buildQrSidebar(),

                          // RIGHT SIDE: SCROLLABLE FORM (Imported from mobile)
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.all(20),
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                color: AppColors.primaryBlue.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: SingleChildScrollView(
                                padding: const EdgeInsets.symmetric(vertical: 30),
                                child: Column(
                                  children: const [
                                    ClientInfoSection(selectAll: false),
                                    SizedBox(height: 40),
                                    FamilyTable(selectAll: false),
                                    SizedBox(height: 40),
                                    SocioEconomicSection(selectAll: false),
                                    SizedBox(height: 40),
                                    SignatureSection(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // --- BOTTOM SAVE ACTION ---
                  const SizedBox(height: 25),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.buttonPurple, // Using your Purple
                        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      child: const Text("SAVE FORM ENTRY", 
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
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

  Widget _buildDropdown() {
    return Container(
      width: 400,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.buttonOutlineBlue.withOpacity(0.5)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedForm,
          items: ["General Intake Sheet", "Medical Assistance", "Emergency Burial"]
              .map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontWeight: FontWeight.w600)))).toList(),
          onChanged: (val) => setState(() => selectedForm = val!),
        ),
      ),
    );
  }

  Widget _buildQrSidebar() {
    return Container(
      width: 320,
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          const Text("Live Form QR", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: QrImageView(
              data: "GIS-2026-TEMP-001",
              version: QrVersions.auto,
              size: 220.0,
            ),
          ),
          const SizedBox(height: 15),
          const Text("ID: GIS-2026-001", style: TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildHeaderButton(String label, IconData icon) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: Icon(icon, color: AppColors.primaryBlue),
      label: Text(label, style: const TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold)),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: AppColors.buttonOutlineBlue),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}