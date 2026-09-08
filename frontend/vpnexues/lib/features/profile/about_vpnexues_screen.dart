import 'package:flutter/material.dart';

class AboutVpnexuesScreen extends StatelessWidget {
  const AboutVpnexuesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF0),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeroSection(context),
                    _buildFeaturesSection(),
                    _buildJourneySection(context),
                    _buildContactSection(),
                    _buildFooter(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(Icons.arrow_back, size: 22, color: Color(0xFF1A1A1A)),
          ),
          const SizedBox(width: 12),
          const Text(
            'About',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF1A1A1A)),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: Stack(
        children: [
          // Green dots decoration top-right
          Positioned(
            right: 0,
            top: 0,
            child: Column(
              children: List.generate(4, (i) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: List.generate(4, (j) => Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(left: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50).withValues(alpha: 0.3 - (i * 0.05)),
                      shape: BoxShape.circle,
                    ),
                  )),
                ),
              )),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Rooted in Tamil Nadu.\nConnected to the world.',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF1A1A1A), height: 1.3),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(width: 24, height: 2, color: const Color(0xFF4CAF50)),
                        const SizedBox(width: 6),
                        const Icon(Icons.eco, size: 12, color: Color(0xFF4CAF50)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'We connect TamilNadu\'s finest\norganic farmers with businesses\nand consumers worldwide.',
                      style: TextStyle(fontSize: 12, color: Color(0xFF6B7280), height: 1.5),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.calendar_today_outlined, size: 12, color: Color(0xFF2E7D32)),
                          SizedBox(width: 6),
                          Text('Since 2022', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF2E7D32))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 4,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(80),
                  ),
                  child: Image.asset(
                    'assets/images/about/farmer_hero.jpg',
                    height: 160,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      height: 160,
                      color: const Color(0xFFE8F5E9),
                      child: const Icon(Icons.agriculture, size: 50, color: Color(0xFF4CAF50)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF0E3B1F),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(36),
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          Expanded(child: _featureItem(Icons.check_circle, '100% Organic\nProducts', 'Serving both\nbusinesses and\nconsumers with\nreliable organic.')),
          Container(width: 1, height: 110, color: Colors.white.withValues(alpha: 0.15)),
          Expanded(child: _featureItem(Icons.public, 'Import &\nExport', 'Full-scale import and\nexport operations for\norganic vegetables,\nfruits, spices, grains.')),
          Container(width: 1, height: 110, color: Colors.white.withValues(alpha: 0.15)),
          Expanded(child: _featureItem(Icons.local_shipping, 'B2B & B2C\nSupply', 'Serving both\nbusinesses and\nconsumers with\nreliable organic.')),
        ],
      ),
    );
  }

  Widget _featureItem(IconData icon, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: ClipOval(
              child: Padding(
                padding: const EdgeInsets.all(3),
                child: Image.asset('assets/images/company_logo.png', fit: BoxFit.contain),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white, height: 1.3),
          ),
          const SizedBox(height: 8),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 9, color: Colors.white.withValues(alpha: 0.7), height: 1.4),
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildJourneySection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, 4))],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('OUR JOURNEY', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF9CA3AF), letterSpacing: 1.2)),
                  const SizedBox(width: 6),
                  Container(width: 24, height: 1, color: const Color(0xFF4CAF50)),
                  const SizedBox(width: 4),
                  const Icon(Icons.eco, size: 10, color: Color(0xFF4CAF50)),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/images/about/tea_journey.jpg',
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(
                        width: 120,
                        height: 120,
                        color: const Color(0xFFE8F5E9),
                        child: const Icon(Icons.landscape, color: Color(0xFF4CAF50), size: 40),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'From Our Farms to\nYour Table.',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF1A1A1A), height: 1.3),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'We follow sustainable farming\npractices to grow nutritious,\nchemical-free produce. Our\nproduce is carefully harvested.',
                          style: TextStyle(fontSize: 11, color: Color(0xFF6B7280), height: 1.4),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(color: const Color(0xFFF1F8E9), borderRadius: BorderRadius.circular(20)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.eco, size: 12, color: Color(0xFF4CAF50)),
                              SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  'freshness you can trust,\nquality you can rely on.',
                                  style: TextStyle(fontSize: 9, color: Color(0xFF4CAF50), height: 1.3),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('LET\'S CONNECT', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF9CA3AF), letterSpacing: 1.2)),
              const SizedBox(width: 6),
              Container(width: 24, height: 1, color: const Color(0xFF4CAF50)),
              const SizedBox(width: 4),
              const Icon(Icons.eco, size: 10, color: Color(0xFF4CAF50)),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: _contactItem(Icons.phone, 'Phone', '+919943994603')),
              const SizedBox(width: 12),
              Expanded(child: _contactItem(Icons.mail_outline, 'website', 'www.vpnexues.com')),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _contactItem(Icons.location_on_outlined, 'location', 'Salem,TamilNadu')),
              const SizedBox(width: 12),
              Expanded(child: _contactItem(Icons.mail_outline, 'Mail', 'support@vpnexues')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _contactItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(color: Color(0xFFE8F5E9), shape: BoxShape.circle),
          child: Icon(icon, size: 16, color: const Color(0xFF2E7D32)),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFF9CA3AF))),
              const SizedBox(height: 1),
              Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF1A1A1A)), maxLines: 1, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF0E3B1F),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: ClipOval(child: Image.asset('assets/images/company_logo.png', fit: BoxFit.cover)),
          ),
          const SizedBox(height: 10),
          const Text('VP NEXUES', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 2)),
          const SizedBox(height: 2),
          Text('IMPORT & EXPORT', style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: 0.6), letterSpacing: 1.5)),
        ],
      ),
    );
  }
}
