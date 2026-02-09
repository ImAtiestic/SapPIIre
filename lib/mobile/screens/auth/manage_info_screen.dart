import 'package:flutter/material.dart';
import 'package:sappiire/mobile/widgets/bottom_navbar.dart';
import 'package:sappiire/mobile/widgets/selectall_button.dart';
import 'package:sappiire/mobile/widgets/dropdown.dart';
import 'package:sappiire/resources/static_form_input.dart'; 
import 'package:sappiire/mobile/screens/auth/qr_scanner_screen.dart';

class ManageInfoScreen extends StatefulWidget {
  const ManageInfoScreen({super.key});

  @override
  State<ManageInfoScreen> createState() => _ManageInfoScreenState();
}

class _ManageInfoScreenState extends State<ManageInfoScreen> {
  int _currentIndex = 0;
  bool _selectAll = false;
  String _selectedForm = "General Intake Sheet";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D3299),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Manage Information", 
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
        ),
      ),
      body: Stack(
        children: [
          // Main layout Column
          Column(
            children: [
              // FIXED TOP SECTION: Dropdown stays here
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 15),
                child: FormDropdown(
                  selectedForm: _selectedForm,
                  items: const ["General Intake Sheet", "Senior Citizen ID"],
                  onChanged: (val) => setState(() => _selectedForm = val!),
                ),
              ),

              // SCROLLABLE SECTION: The Form
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section A
                      ClientInfoSection(selectAll: _selectAll), 

                      const SizedBox(height: 30),

                      // Section B
                      FamilyTable(selectAll: _selectAll), 

                      const SizedBox(height: 30),

                      // Section C
                      SocioEconomicSection(selectAll: _selectAll),

                      const SizedBox(height: 30),

                      // Signature
                      const SignatureSection(),

                      const SizedBox(height: 150), 
                    ],
                  ),
                ),
              ),
            ],
          ),

          // THE FLOATING SELECT ALL BUTTON
          Positioned(
            bottom: 25, 
            right: 16,
            child: SelectAllButton(
              isSelected: _selectAll,
              onChanged: (v) => setState(() => _selectAll = v ?? false),
            ),
          ),
        ],
      ),

      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => const QrScannerScreen())
            );
          } else {
            setState(() => _currentIndex = index);
          }
        },
      ),
    );
  }
}