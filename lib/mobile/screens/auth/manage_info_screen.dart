import 'dart:async'; // 🔹 Required for Timer
import 'package:flutter/material.dart';
import 'package:sappiire/mobile/widgets/bottom_navbar.dart';
import 'package:sappiire/mobile/widgets/selectall_button.dart';
import 'package:sappiire/mobile/widgets/dropdown.dart';
import 'package:sappiire/resources/static_form_input.dart';
import 'package:sappiire/mobile/screens/auth/qr_scanner_screen.dart';
import 'package:sappiire/mobile/screens/auth/login_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ManageInfoScreen extends StatefulWidget {
  final String? userId; // 🔹 Optional userId from signup

  const ManageInfoScreen({super.key, this.userId});

  @override
  State<ManageInfoScreen> createState() => _ManageInfoScreenState();
}

class _ManageInfoScreenState extends State<ManageInfoScreen> {
  int _currentIndex = 0;
  bool _selectAll = false;
  String _selectedForm = "General Intake Sheet";
  String? _activeSessionId;
  Timer? _debounce; // 🔹 Prevents spamming Supabase on every keystroke

  // ===============================
  // CENTRAL CONTROLLER HUB
  // ===============================
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();

    final List<String> allLabels = [
      "Last Name",
      "First Name",
      "Middle Name",
      "House number, street name, phase/purok",
      "Subdivision",
      "Barangay",
      "Kasarian",
      "Estadong Sibil",
      "Relihiyon",
      "CP Number",
      "Email Address",
      "Natapos o naabot sa pag-aaral",
      "Lugar ng Kapanganakan",
      "Trabaho/Pinagkakakitaan",
      "Kumpanyang Pinagtratrabuhan",
      "Buwanang Kita (A)",
      "Total Gross Family Income (A+B+C)=(D)",
      "Household Size (E)",
      "Monthly Per Capita Income (D/E)",
      "Total Monthly Expense (F)",
      "Net Monthly Income (D-F)",
      "Bayad sa bahay",
      "Food items",
      "Non-food items",
      "Utility bills",
      "Baby's needs",
      "School needs",
      "Medical needs",
      "Transpo expense",
      "Loans",
      "Gasul",
    ];

    for (final label in allLabels) {
      _controllers[label] = TextEditingController();

      // 🔹 Attach listener with debounce logic
      _controllers[label]!.addListener(_onFieldChanged);
    }

    // 🔹 Load user profile if userId is provided (from signup)
    if (widget.userId != null) {
      _loadUserProfile(widget.userId!);
    }
  }

  // 🔹 Load user profile data from Supabase
  Future<void> _loadUserProfile(String userId) async {
    try {
      final response = await Supabase.instance.client
          .from('user_profiles')
          .select()
          .eq('user_id', userId)
          .single();

      if (mounted) {
        setState(() {
          // Map Supabase data to form fields
          _controllers["First Name"]?.text = response['firstname'] ?? '';
          _controllers["Middle Name"]?.text = response['middle_name'] ?? '';
          _controllers["Last Name"]?.text = response['lastname'] ?? '';
          _controllers["Email Address"]?.text = response['email'] ?? '';
          _controllers["CP Number"]?.text = response['cellphone_number'] ?? '';
        });
      }
    } catch (e) {
      debugPrint('Error loading profile: $e');
    }
  }

  // 🔹 Debounce Logic: Waits 500ms after typing stops before syncing
  void _onFieldChanged() {
    if (_activeSessionId == null) return;

    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (_activeSessionId != null) {
        syncDataToWeb(_activeSessionId!);
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel(); // 🔹 Clean up timer
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  // ===============================
  // SYNC METHOD → SUPABASE
  // ===============================
  Future<void> syncDataToWeb(String sessionId) async {
    final Map<String, String> formData = {};

    _controllers.forEach((key, controller) {
      formData[key] = controller.text;
    });

    try {
      await Supabase.instance.client
          .from('form_sessions')
          .update({'form_data': formData})
          .eq('id', sessionId);

      // Note: Removed the SnackBar from here because it would pop up
      // every time the user stops typing, which is distracting.
    } catch (e) {
      debugPrint("Sync Error: $e");
    }
  }

  // 🔹 LOGOUT - Clear session and return to login
  Future<void> _logout() async {
    // Clear any session data
    setState(() {
      _activeSessionId = null;
    });

    // Navigate back to login screen
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D3299),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: _logout,
        ),
        title: const Text(
          "Manage Information",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 15),
                child: FormDropdown(
                  selectedForm: _selectedForm,
                  items: const ["General Intake Sheet", "Senior Citizen ID"],
                  onChanged: (val) => setState(() => _selectedForm = val!),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClientInfoSection(
                        selectAll: _selectAll,
                        controllers: _controllers,
                      ),
                      const SizedBox(height: 30),
                      FamilyTable(
                        selectAll: _selectAll,
                        controllers: _controllers,
                      ),
                      const SizedBox(height: 30),
                      SocioEconomicSection(
                        selectAll: _selectAll,
                        controllers: _controllers,
                      ),
                      const SizedBox(height: 30),
                      const SignatureSection(),
                      const SizedBox(height: 150),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
        onTap: (index) async {
          if (index == 1) {
            // 🔹 QR Scanner Tab
            final String? sessionId = await Navigator.push<String>(
              context,
              MaterialPageRoute(builder: (context) => const QrScannerScreen()),
            );

            if (sessionId != null) {
              // 🔹 CRITICAL FIX: Save the session ID to the state
              setState(() {
                _activeSessionId = sessionId;
              });

              // Initial sync to confirm connection
              await syncDataToWeb(sessionId);

              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Connected to Web Session!")),
                );
              }
            }
          } else {
            setState(() => _currentIndex = index);
          }
        },
      ),
    );
  }
}
