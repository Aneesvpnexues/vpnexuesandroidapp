import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vpnexues_pvt/shared/localization/language_provider.dart';
import 'package:vpnexues_pvt/shared/providers/auth_provider.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, String>> _allLanguages = const [
    {'code': 'en', 'name': 'English', 'native': 'English', 'char': '🌐'},
    {'code': 'hi', 'name': 'Hindi', 'native': 'हिंदी', 'char': 'अ'},
    {'code': 'ta', 'name': 'Tamil', 'native': 'தமிழ்', 'char': 'அ'},
    {'code': 'si', 'name': 'Sinhala', 'native': 'සිංහල', 'char': 'සි'},
    {'code': 'ar', 'name': 'Arabic', 'native': 'العربية', 'char': 'ع'},
    {'code': 'zh', 'name': 'Chinese (Simplified)', 'native': '简体中文', 'char': '简'},
    {'code': 'ur', 'name': 'Urdu', 'native': 'اردو', 'char': 'ا'},
    {'code': 'ml', 'name': 'Malayalam', 'native': 'മലയാളം', 'char': 'മ'},
  ];

  List<Map<String, String>> get _filtered {
    if (_searchQuery.isEmpty) return _allLanguages;
    final q = _searchQuery.toLowerCase();
    return _allLanguages.where((l) => l['name']!.toLowerCase().contains(q) || l['native']!.toLowerCase().contains(q)).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final langProvider = context.watch<LanguageProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF0),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE8EEE8), width: 1),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 12),
                    const Icon(Icons.search, color: Color(0xFF9CA3AF), size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (v) => setState(() => _searchQuery = v),
                        style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A1A)),
                        decoration: const InputDecoration(
                          hintText: 'Search language...',
                          hintStyle: TextStyle(fontSize: 14, color: Color(0xFF9CA3AF)),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    if (_searchQuery.isNotEmpty)
                      GestureDetector(
                        onTap: () => setState(() { _searchController.clear(); _searchQuery = ''; }),
                        child: const Padding(
                          padding: EdgeInsets.only(right: 12),
                          child: Icon(Icons.close, size: 18, color: Color(0xFF9CA3AF)),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                itemCount: _filtered.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final lang = _filtered[index];
                  return _buildLanguageOption(context, langProvider, lang);
                },
              ),
            ),
            _buildContinueButton(context, langProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(Icons.arrow_back, size: 22, color: Color(0xFF1A1A1A)),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'Change Language',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF1A1A1A)),
              ),
            ),
          ),
          const SizedBox(width: 22),
        ],
      ),
    );
  }

  Widget _buildContinueButton(BuildContext context, LanguageProvider langProvider) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0E3B1F),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            elevation: 0,
          ),
          child: const Text('Continue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        ),
      ),
    );
  }

  Widget _buildLanguageOption(BuildContext context, LanguageProvider langProvider, Map<String, String> lang) {
    final isSelected = langProvider.currentLanguage == lang['code'];
    final char = lang['char']!;

    return GestureDetector(
      onTap: () async {
        langProvider.setLanguage(lang['code']!);
        final authProvider = context.read<AuthProvider>();
        await authProvider.updateProfile(language: lang['code']);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF0F5F0) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF0E3B1F) : const Color(0xFFE8EEE8),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: char.length == 1
                    ? Text(char, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF2E7D32)))
                    : Text(char, style: const TextStyle(fontSize: 14)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lang['name']!,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A)),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    lang['native']!,
                    style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
                  ),
                ],
              ),
            ),
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? const Color(0xFF0E3B1F) : Colors.white,
                border: Border.all(color: isSelected ? const Color(0xFF0E3B1F) : const Color(0xFFD1D5DB), width: 1.5),
              ),
              child: isSelected ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
            ),
          ],
        ),
      ),
    );
  }
}
