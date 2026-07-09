import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'theme.dart';
import 'widgets/hover_card.dart';
import 'widgets/faq_accordion.dart';
import 'widgets/roadmap_timeline.dart';
import 'widgets/payment_dialog.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Rangmanch - Acting Guidance & Mentorship',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0;

  // GlobalKeys for sections to scroll to
  final GlobalKey _heroKey = GlobalKey();
  final GlobalKey _aboutFounderKey = GlobalKey();
  final GlobalKey _aboutPlatformKey = GlobalKey();
  final GlobalKey _programsKey = GlobalKey();
  final GlobalKey _roadmapKey = GlobalKey();
  final GlobalKey _impactKey = GlobalKey();
  final GlobalKey _galleryKey = GlobalKey();
  final GlobalKey _faqKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  int _currentTestimonialIndex = 0;

  final List<Map<String, String>> _testimonials = [
    {
      "name": "Amit Sharma",
      "location": "Mumbai, India",
      "quote": "The 3 Days Beginner Acting Workshop completely changed how I look at auditions. Sonam ma'am explained the roadmap so simply!",
      "role": "Student & Aspiring Actor"
    },
    {
      "name": "Sara Al-Mansoori",
      "location": "Dubai, UAE",
      "quote": "Even from Dubai, the live interactive sessions and personalized feedback felt incredibly professional. Highly recommended!",
      "role": "Advanced Program Student"
    },
    {
      "name": "Rohit Verma",
      "location": "Delhi, India",
      "quote": "Getting updates on web series auditions and personalized mentorship helped me record my first professional self-tape profile.",
      "role": "Community Member"
    }
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollTo(GlobalKey key) {
    if (key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint("Could not launch $urlString");
    }
  }

  void _showPaymentDialog() {
    showDialog(
      context: context,
      builder: (context) => const PaymentDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient base
          Positioned.fill(
            child: Container(
              color: AppColors.background,
            ),
          ),
          
          // Main Scrollable Content
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                _buildHeroSection(screenWidth, isMobile),
                _buildAboutFounderSection(isMobile),
                _buildAboutPlatformSection(isMobile),
                _buildProgramsSection(isMobile),
                _buildRoadmapSection(isMobile),
                _buildAuditionAndImpactSection(isMobile),
                _buildWhyChooseSection(isMobile),
                _buildGallerySection(isMobile),
                _buildTestimonialsSection(isMobile),
                _buildFaqSection(isMobile),
                _buildFooterSection(isMobile),
              ],
            ),
          ),

          // Sticky Glassmorphic Navigation Bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildNavBar(isMobile),
          ),
        ],
      ),
    );
  }

  // --- Sticky Navigation Bar ---
  Widget _buildNavBar(bool isMobile) {
    final isScrolled = _scrollOffset > 50;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: BoxDecoration(
        color: isScrolled ? AppColors.background.withOpacity(0.85) : Colors.transparent,
        border: Border(
          bottom: BorderSide(
            color: isScrolled ? Colors.white.withOpacity(0.08) : Colors.transparent,
            width: 1.0,
          ),
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Logo
              GestureDetector(
                onTap: () => _scrollTo(_heroKey),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.4),
                              blurRadius: 8,
                            )
                          ],
                        ),
                        child: const Icon(
                          Icons.theater_comedy,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "THE RANGMANCH",
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Navigation Links (Desktop)
              if (!isMobile)
                Row(
                  children: [
                    _buildNavLink("Founder", _aboutFounderKey),
                    _buildNavLink("Platform", _aboutPlatformKey),
                    _buildNavLink("Programs", _programsKey),
                    _buildNavLink("Roadmap", _roadmapKey),
                    _buildNavLink("FAQ", _faqKey),
                    const SizedBox(width: 20),
                    ElevatedButton.icon(
                      onPressed: () => _showPaymentDialog(),
                      icon: const Icon(Icons.payment, size: 16),
                      label: const Text("Register Online (₹99)"),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        backgroundColor: const Color(0xFF25D366),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),

              // Mobile Navigation Menu Icon
              if (isMobile)
                IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: AppColors.surface,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (context) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildMobileMenuLink("About Founder", _aboutFounderKey),
                              _buildMobileMenuLink("About The Rangmanch", _aboutPlatformKey),
                              _buildMobileMenuLink("Programs", _programsKey),
                              _buildMobileMenuLink("Roadmap", _roadmapKey),
                              _buildMobileMenuLink("FAQ", _faqKey),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _showPaymentDialog();
                                  },
                                  icon: const Icon(Icons.payment, size: 16),
                                  label: const Text("Register Online (₹99)"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF25D366),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavLink(String title, GlobalKey key) {
    return Container(
      margin: const EdgeInsets.only(left: 24),
      child: InkWell(
        onTap: () => _scrollTo(key),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileMenuLink(String title, GlobalKey key) {
    return ListTile(
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16),
        textAlign: TextAlign.center,
      ),
      onTap: () {
        Navigator.pop(context);
        _scrollTo(key);
      },
    );
  }

  // --- Hero Section ---
  Widget _buildHeroSection(double screenWidth, bool isMobile) {
    final heroHeight = isMobile ? 650.0 : 800.0;

    return Stack(
      key: _heroKey,
      children: [
        // Stage Spotlight Image Background with Gradient overlay
        Container(
          height: heroHeight,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/rangmanch_stage_hero.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          height: heroHeight,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0.4),
                Colors.black.withOpacity(0.7),
                AppColors.background,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),

        // Hero Content
        Positioned.fill(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
                    // Small tagline badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: glassDecoration(radius: 20).copyWith(
                        color: AppColors.primary.withOpacity(0.1),
                        border: Border.all(color: AppColors.primary.withOpacity(0.5)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, color: AppColors.secondary, size: 14),
                          const SizedBox(width: 8),
                          Text(
                            "FOUNDED BY SONAM YADAV",
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontSize: 12,
                              color: AppColors.secondary,
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Main Cinematic Header
                    Text(
                      "THE RANGMANCH",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontSize: isMobile ? 42 : 72,
                        letterSpacing: 4,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: AppColors.primary.withOpacity(0.8),
                            blurRadius: 20,
                          ),
                          Shadow(
                            color: AppColors.secondary.withOpacity(0.4),
                            blurRadius: 40,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Subtitle
                    Text(
                      "Acting Guidance & Mentorship Platform",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontSize: isMobile ? 18 : 28,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Badges for Founder credentials
                    Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: [
                        _buildHeroBadge("Actor"),
                        _buildHeroBadge("Casting Coordinator"),
                        _buildHeroBadge("Casting Assistant"),
                        _buildHeroBadge("Acting Mentor"),
                      ],
                    ),
                    const SizedBox(height: 40),

                    // Call to Action Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () => _scrollTo(_programsKey),
                          child: const Text("Explore Programs"),
                        ),
                        const SizedBox(width: 16),
                        OutlinedButton.icon(
                          onPressed: () => _launchURL("https://www.imdb.com"),
                          icon: const FaIcon(FontAwesomeIcons.imdb, color: AppColors.secondary),
                          label: const Text("IMDb Profile"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeroBadge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.3),
        ),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppColors.textPrimary,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // --- About Founder Section ---
  Widget _buildAboutFounderSection(bool isMobile) {
    return Container(
      key: _aboutFounderKey,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader("ABOUT SONAM YADAV", "THE ARTIST & FOUNDER"),
              const SizedBox(height: 48),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image/Glow Card on Left (Desktop)
                  if (!isMobile)
                    Expanded(
                      flex: 4,
                      child: HoverCard(
                        padding: EdgeInsets.zero,
                        child: Stack(
                          children: [
                            AspectRatio(
                              aspectRatio: 0.9,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  image: const DecorationImage(
                                    image: AssetImage("assets/images/acting_mentorship_concept.png"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.8),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 24,
                              left: 24,
                              right: 24,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Sonam Yadav",
                                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    "Founder • Actor • Casting",
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: AppColors.secondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (!isMobile) const SizedBox(width: 64),

                  // Biography Text on Right
                  Expanded(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isMobile) ...[
                          Center(
                            child: SizedBox(
                              width: 280,
                              child: AspectRatio(
                                aspectRatio: 1.0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: AppColors.primary, width: 2),
                                    image: const DecorationImage(
                                      image: AssetImage("assets/images/acting_mentorship_concept.png"),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                        ],
                        Text(
                          "Hi, I'm Sonam Yadav",
                          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            fontSize: 28,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "I am an Actor, Casting Coordinator, Casting Assistant, and the Founder of The Rangmanch.",
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "With over 5 years of active theatre experience, I have worked across different aspects of the entertainment industry while mentoring aspiring actors from all over India and abroad. My journey has taken me to projects like Colors TV – Junooniyatt and an Amazon miniTV project.",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "My ultimate vision is to simplify acting guidance, making it highly practical, real, and accessible to every passionate actor out there, regardless of their location, financial background, or prior exposure.",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 32),
                        
                        // Experience Badges Grid
                        Text(
                          "FOUNDER'S EXPERIENCE HIGHLIGHTS",
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            color: AppColors.secondary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            _buildHighlightChip(Icons.theater_comedy, "5+ Years Theatre Experience"),
                            _buildHighlightChip(Icons.video_camera_front, "TV & OTT Experience"),
                            _buildHighlightChip(Icons.groups, "800+ Actors Guided"),
                            _buildHighlightChip(Icons.person_pin, "Casting Coordinator & Assistant"),
                          ],
                        ),
                        const SizedBox(height: 32),
                        
                        OutlinedButton.icon(
                          onPressed: () => _launchURL("https://www.imdb.com"),
                          icon: const FaIcon(FontAwesomeIcons.imdb, color: AppColors.secondary),
                          label: const Text("Verify on IMDb Profile"),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.secondary),
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

  Widget _buildHighlightChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.primary, size: 18),
          const SizedBox(width: 10),
          Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // --- About Platform Section ---
  Widget _buildAboutPlatformSection(bool isMobile) {
    return Container(
      key: _aboutPlatformKey,
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            children: [
              _buildSectionHeader("ABOUT THE RANGMANCH", "OUR MISSION & VISION"),
              const SizedBox(height: 48),
              
              // Mission & Vision Layout
              isMobile
                  ? Column(
                      children: [
                        _buildPlatformCard(
                          title: "OUR MISSION",
                          description: "To provide genuine, practical, and affordable acting guidance that helps aspiring actors confidently take their first steps into the entertainment industry without being misguided by unverified resources.",
                          icon: Icons.rocket_launch,
                          color: AppColors.primary,
                        ),
                        const SizedBox(height: 24),
                        _buildPlatformCard(
                          title: "OUR VISION",
                          description: "To build a strong global acting community where every passionate artist has direct access to high-quality, practical mentorship, regular acting opportunities, and real industry insights.",
                          icon: Icons.visibility,
                          color: AppColors.secondary,
                        ),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _buildPlatformCard(
                            title: "OUR MISSION",
                            description: "To provide genuine, practical, and affordable acting guidance that helps aspiring actors confidently take their first steps into the entertainment industry without being misguided by unverified resources.",
                            icon: Icons.rocket_launch,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 32),
                        Expanded(
                          child: _buildPlatformCard(
                            title: "OUR VISION",
                            description: "To build a strong global acting community where every passionate artist has direct access to high-quality, practical mentorship, regular acting opportunities, and real industry insights.",
                            icon: Icons.visibility,
                            color: AppColors.secondary,
                          ),
                        ),
                      ],
                    ),
              
              const SizedBox(height: 40),
              
              // Platform description
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Text(
                  "The Rangmanch is an Acting Guidance & Mentorship Platform dedicated to supporting aspiring performers in building their careers with the right industry awareness. Our system is structured to help you skip common rookie mistakes by focusing entirely on camera mechanics, portfolio development, audition readiness, and persistent community engagement.",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlatformCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    return HoverCard(
      glowColor: color.withOpacity(0.2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontSize: 15,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  // --- Programs Section ---
  Widget _buildProgramsSection(bool isMobile) {
    return Container(
      key: _programsKey,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            children: [
              _buildSectionHeader("WHAT WE OFFER", "CHOOSE YOUR TRAINING PATH"),
              const SizedBox(height: 48),

              // Two interactive pricing cards
              isMobile
                  ? Column(
                      children: [
                        _buildProgramCard(
                          title: "Beginner Acting Workshop",
                          price: "₹99",
                          duration: "3 Days Live Online",
                          features: [
                            "Acting Career Roadmap",
                            "Audition Guidance & Tips",
                            "Profile Building Basics",
                            "Introduction Video Guidance",
                            "Self-Tape Preparation",
                            "Camera Confidence Exercises",
                            "Live Interactive Q&A Session",
                          ],
                          isPopular: true,
                          buttonText: "Register for ₹99",
                          onPressed: _showPaymentDialog,
                        ),
                        const SizedBox(height: 32),
                        _buildProgramCard(
                          title: "Advanced Acting Program",
                          price: "Custom Intake",
                          duration: "In-Depth Mentorship",
                          features: [
                            "Comprehensive Theatre Training",
                            "On-Camera Acting Mechanics",
                            "Advanced Character Development",
                            "Regular Monologue & Scene Practice",
                            "Practical Homework & Reviews",
                            "Personalized Mentor Feedback",
                            "Private WhatsApp Community Access",
                            "Lifetime Career Guidance Support",
                          ],
                          isPopular: false,
                          buttonText: "Inquire on WhatsApp",
                          onPressed: () => _launchURL("https://wa.me/919999999999?text=Hi%20Sonam,%20I%20want%20to%20know%20more%20details%20about%20the%20Advanced%20Acting%20Program!"),
                        ),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _buildProgramCard(
                            title: "Beginner Acting Workshop",
                            price: "₹99",
                            duration: "3 Days Live Online",
                            features: [
                              "Acting Career Roadmap",
                              "Audition Guidance & Tips",
                              "Profile Building Basics",
                              "Introduction Video Guidance",
                              "Self-Tape Preparation",
                              "Camera Confidence Exercises",
                              "Live Interactive Q&A Session",
                            ],
                            isPopular: true,
                            buttonText: "Register for ₹99",
                            onPressed: _showPaymentDialog,
                          ),
                        ),
                        const SizedBox(width: 32),
                        Expanded(
                          child: _buildProgramCard(
                            title: "Advanced Acting Program",
                            price: "Custom Intake",
                            duration: "In-Depth Mentorship",
                            features: [
                              "Comprehensive Theatre Training",
                              "On-Camera Acting Mechanics",
                              "Advanced Character Development",
                              "Regular Monologue & Scene Practice",
                              "Practical Homework & Reviews",
                              "Personalized Mentor Feedback",
                              "Private WhatsApp Community Access",
                              "Lifetime Career Guidance Support",
                            ],
                            isPopular: false,
                            buttonText: "Inquire on WhatsApp",
                            onPressed: () => _launchURL("https://wa.me/919999999999?text=Hi%20Sonam,%20I%20want%20to%20know%20more%20details%20about%20the%20Advanced%20Acting%20Program!"),
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

  Widget _buildProgramCard({
    required String title,
    required String price,
    required String duration,
    required List<String> features,
    required bool isPopular,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    return HoverCard(
      backgroundColor: AppColors.surface,
      glowColor: isPopular ? AppColors.primary : AppColors.secondary.withOpacity(0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Popular badge
          if (isPopular)
            Align(
              alignment: Alignment.topRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  "MOST POPULAR",
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            textBaseline: TextBaseline.alphabetic,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            children: [
              Text(
                price,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "/ $duration",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Colors.white10),
          const SizedBox(height: 16),
          
          // Features List
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: features.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      color: isPopular ? AppColors.primary : AppColors.secondary,
                      size: 18,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        features[index],
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 14.5,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: isPopular ? AppColors.primary : Colors.transparent,
                foregroundColor: Colors.white,
                side: isPopular ? null : const BorderSide(color: AppColors.secondary, width: 2),
                elevation: isPopular ? 4 : 0,
              ),
              child: Text(buttonText),
            ),
          ),
        ],
      ),
    );
  }

  // --- Acting Career Roadmap Section ---
  Widget _buildRoadmapSection(bool isMobile) {
    final steps = [
      const RoadmapStep(
        stepNumber: "01",
        title: "Start Acting from Zero",
        description: "Understand the core actor psychology, theatre vs. camera styles, and start training from scratch.",
        icon: Icons.play_arrow,
      ),
      const RoadmapStep(
        stepNumber: "02",
        title: "Career Roadmap",
        description: "Plan your acting goals, structure your training phases, and build a sustainable timeline.",
        icon: Icons.alt_route,
      ),
      const RoadmapStep(
        stepNumber: "03",
        title: "Audition Process",
        description: "Learn how modern casting works, how to reach directors, and how to behave in audition rooms.",
        icon: Icons.checklist,
      ),
      const RoadmapStep(
        stepNumber: "04",
        title: "Profile Building",
        description: "Organize professional headshots, compile resumes properly, and structure casting profiles.",
        icon: Icons.assignment_ind,
      ),
      const RoadmapStep(
        stepNumber: "05",
        title: "Self-Tape Preparation",
        description: "Master recording quality self-tape monologues with optimal angles, audio, and lighting at home.",
        icon: Icons.videocam,
      ),
      const RoadmapStep(
        stepNumber: "06",
        title: "Camera Confidence",
        description: "Overcome performance anxiety, learn camera lens sizes, framing, and eye-line rules.",
        icon: Icons.movie_creation_outlined,
      ),
      const RoadmapStep(
        stepNumber: "07",
        title: "Theatre Basics",
        description: "Absorb fundamentals of expression, voice projection, body posture, and physical theatre.",
        icon: Icons.theater_comedy,
      ),
      const RoadmapStep(
        stepNumber: "08",
        title: "Industry Knowledge",
        description: "Dodge scams, identify fake casting directors, negotiate contracts, and network correctly.",
        icon: Icons.business,
      ),
      const RoadmapStep(
        stepNumber: "09",
        title: "Personal Mentorship",
        description: "Benefit from continuous monologue reviews, direct WhatsApp group networking, and lifelong guidance.",
        icon: Icons.support_agent,
      ),
    ];

    return Container(
      key: _roadmapKey,
      color: AppColors.background,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Column(
            children: [
              _buildSectionHeader("WHAT YOU WILL LEARN", "YOUR STEP-BY-STEP ACTING ROADMAP"),
              const SizedBox(height: 48),
              RoadmapTimeline(steps: steps),
            ],
          ),
        ),
      ),
    );
  }

  // --- Auditions & Impact Stats Section ---
  Widget _buildAuditionAndImpactSection(bool isMobile) {
    final auditionCategories = [
      "TV Serials",
      "OTT Projects",
      "Web Series",
      "Feature Films",
      "Advertisements",
      "Music Videos",
      "Digital Content",
      "Brand Shoots",
      "Child Artists",
    ];

    return Container(
      key: _impactKey,
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            children: [
              _buildSectionHeader("AUDITION UPDATES & IMPACT", "CASTING SCOPE & SUCCESS TRACK RECORD"),
              const SizedBox(height: 48),
              
              // Audition Badge Grid
              Text(
                "CASTING UPDATES WE FREQUENTLY PROVIDE MENTORSHIP FOR",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: auditionCategories.map((cat) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.cardBg,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: AppColors.primary.withOpacity(0.4)),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.05),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Text(
                      cat,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  );
                }).toList(),
              ),
              
              const SizedBox(height: 64),
              
              // Impact Counter Stats
              isMobile
                  ? Column(
                      children: [
                        _buildStatBox("5+ Years", "Theatre & Film Experience"),
                        const SizedBox(height: 24),
                        _buildStatBox("800+", "Aspiring Actors Guided"),
                        const SizedBox(height: 24),
                        _buildStatBox("Global", "Students: India, Dubai, Oman, Sri Lanka"),
                        const SizedBox(height: 24),
                        _buildStatBox("Active", "Telegram & WhatsApp Acting Community"),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(child: _buildStatBox("5+ Years", "Theatre & Film Experience")),
                        const SizedBox(width: 24),
                        Expanded(child: _buildStatBox("800+", "Aspiring Actors Guided")),
                        const SizedBox(width: 24),
                        Expanded(child: _buildStatBox("Global Reach", "India, Dubai, Oman, Sri Lanka")),
                        const SizedBox(width: 24),
                        Expanded(child: _buildStatBox("Active", "WhatsApp Community")),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatBox(String bigText, String subtitle) {
    return HoverCard(
      glowColor: AppColors.secondary.withOpacity(0.2),
      child: Column(
        children: [
          Text(
            bigText,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              color: AppColors.secondary,
              fontWeight: FontWeight.w900,
              fontSize: 32,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // --- Why Choose Us Section ---
  Widget _buildWhyChooseSection(bool isMobile) {
    final points = [
      {"title": "Beginner-Friendly Learning", "desc": "No prior experience or theatre background needed. We start simple and grow fast."},
      {"title": "Practical Industry Guidance", "desc": "Skip outdated acting definitions. Learn exact camera techniques and casting rules."},
      {"title": "Live Interactive Sessions", "desc": "Not just pre-recorded classes. Ask direct questions, practice live, and clear doubts immediately."},
      {"title": "Personalized Mentorship", "desc": "Get tailored feedbacks on introduction videos, monologues, and profile submissions."},
      {"title": "Lifetime Community Support", "desc": "Join our WhatsApp networking groups to collaborate, discuss, and check regular castings."},
      {"title": "Pan India & Global Network", "desc": "Interact with and learn alongside acting peers from India, Dubai, Oman, and Sri Lanka."},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            children: [
              _buildSectionHeader("WHY CHOOSE THE RANGMANCH", "UNSURPASSED MENTORSHIP VALUES"),
              const SizedBox(height: 48),
              
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: points.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isMobile ? 1 : 3,
                  crossAxisSpacing: 24,
                  mainAxisSpacing: 24,
                  childAspectRatio: 180 / 100,
                ),
                itemBuilder: (context, index) {
                  final pt = points[index];
                  return HoverCard(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.verified, color: AppColors.secondary, size: 20),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                pt["title"]!,
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          pt["desc"]!,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Gallery Section ---
  Widget _buildGallerySection(bool isMobile) {
    return Container(
      key: _galleryKey,
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            children: [
              _buildSectionHeader("THE RANGMANCH GALLERY", "MOMENTS FROM WORKSHOPS, STAGE & SETS"),
              const SizedBox(height: 48),
              
              // We'll create a stylized artistic visual layout representing a gallery
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 4,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isMobile ? 1 : 2,
                  crossAxisSpacing: 24,
                  mainAxisSpacing: 24,
                  childAspectRatio: 1.5,
                ),
                itemBuilder: (context, index) {
                  final titles = [
                    "Live Acting Workshops",
                    "Theatre Stage Performances",
                    "Student Acting Practice",
                    "Behind-The-Scenes Castings",
                  ];
                  final sub = [
                    "Interactive online training modules",
                    "Refining expression, posture & speech",
                    "Monologue exercises & feedback loop",
                    "Real project coordinators working",
                  ];

                  return HoverCard(
                    padding: EdgeInsets.zero,
                    child: Stack(
                      children: [
                        // Beautiful gradient overlay in place of standard placeholders
                        Positioned.fill(
                          child: Image.asset(
                            "assets/images/acting_mentorship_concept.png",
                            fit: BoxFit.cover,
                            color: Colors.black.withOpacity(0.35 + (index * 0.1)),
                            colorBlendMode: BlendMode.srcOver,
                          ),
                        ),
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.85),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 24,
                          left: 24,
                          right: 24,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                titles[index],
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                sub[index],
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.secondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 16,
                          right: 16,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.zoom_in, color: Colors.white, size: 18),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 40),
              
              // YouTube and Social video nudge
              HoverCard(
                glowColor: Colors.red.withOpacity(0.3),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const FaIcon(FontAwesomeIcons.youtube, color: Colors.red, size: 28),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Watch Free Acting Guides on YouTube",
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "We regular upload videos on Acting tips, Audition practices, Casting updates, and Self-taping walkthroughs.",
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () => _launchURL("https://www.youtube.com"),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text("Subscribe"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Student Testimonials Section ---
  Widget _buildTestimonialsSection(bool isMobile) {
    final currentTestimonial = _testimonials[_currentTestimonialIndex];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            children: [
              _buildSectionHeader("STUDENT TESTIMONIALS", "WHAT ASPIRING PERFORMERS SAY"),
              const SizedBox(height: 48),
              
              // Interactive Testimonial Slider Card
              HoverCard(
                glowColor: AppColors.primary.withOpacity(0.2),
                child: Column(
                  children: [
                    const Icon(Icons.format_quote, color: AppColors.secondary, size: 60),
                    const SizedBox(height: 16),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Text(
                        currentTestimonial["quote"]!,
                        key: ValueKey(_currentTestimonialIndex),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      currentTestimonial["name"]!,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${currentTestimonial["role"]!} • ${currentTestimonial["location"]!}",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Slider Dots / Controls
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_testimonials.length, (index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _currentTestimonialIndex = index;
                            });
                          },
                          child: Container(
                            width: 12,
                            height: 12,
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentTestimonialIndex == index
                                  ? AppColors.primary
                                  : Colors.white.withOpacity(0.2),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- FAQ Section ---
  Widget _buildFaqSection(bool isMobile) {
    return Container(
      key: _faqKey,
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            children: [
              _buildSectionHeader("FREQUENTLY ASKED QUESTIONS", "GOT QUESTIONS? WE HAVE ANSWERS"),
              const SizedBox(height: 48),
              
              const FaqAccordionTile(
                question: "Who can join the workshops or programs?",
                answer: "Anyone who has a passion for acting! Whether you are a absolute beginner wanting to explore the craft, a student looking to improve camera confidence, or a theatre performer transitioning into television and OTT, you are welcome to join.",
              ),
              const FaqAccordionTile(
                question: "Do I need any prior acting experience?",
                answer: "No. Our Beginner Acting Workshop is specifically tailored for actors starting from zero. We introduce acting concepts, vocabulary, and methods in a very simple, understandable language.",
              ),
              const FaqAccordionTile(
                question: "Are the classes conducted online or offline?",
                answer: "Yes, our primary mentorship workshops are conducted Live Online via video conference, allowing students from all parts of India, Dubai, Oman, Sri Lanka, and abroad to participate without travel friction.",
              ),
              const FaqAccordionTile(
                question: "Will I get personalized guidance and feedback?",
                answer: "Absolutely! We do not believe in plain recorded lessons. In both the workshop and advanced programs, Sonam Yadav personally monitors student submissions, reviews profile introduction videos, monologues, and delivers feedback to make sure you improve.",
              ),
              const FaqAccordionTile(
                question: "Do I get post-workshop support or casting opportunities?",
                answer: "Yes. Every student gets added to our active WhatsApp / Telegram community groups where we share verified audition updates, discuss industry norms, answer questions, and guide actors long after the course wraps up.",
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Footer Section ---
  Widget _buildFooterSection(bool isMobile) {
    return Container(
      key: _contactKey,
      color: Colors.black,
      padding: const EdgeInsets.only(top: 80, bottom: 40, left: 24, right: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            children: [
              // Contact Actions Grid
              isMobile
                  ? Column(
                      children: [
                        _buildContactCard(const Icon(Icons.email, color: AppColors.primary, size: 24), "Email Us", "info@therangmanch.com", "mailto:info@therangmanch.com"),
                        const SizedBox(height: 16),
                        _buildContactCard(const FaIcon(FontAwesomeIcons.whatsapp, color: AppColors.primary, size: 24), "WhatsApp Community", "+91 99999 99999", "https://wa.me/919999999999"),
                        const SizedBox(height: 16),
                        _buildContactCard(const FaIcon(FontAwesomeIcons.instagram, color: AppColors.primary, size: 24), "Instagram Direct", "@therangmanch_official", "https://www.instagram.com/therangmanch_official"),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(child: _buildContactCard(const Icon(Icons.email, color: AppColors.primary, size: 24), "Email Us", "info@therangmanch.com", "mailto:info@therangmanch.com")),
                        const SizedBox(width: 20),
                        Expanded(child: _buildContactCard(const FaIcon(FontAwesomeIcons.whatsapp, color: AppColors.primary, size: 24), "WhatsApp Community", "+91 99999 99999", "https://wa.me/919999999999")),
                        const SizedBox(width: 20),
                        Expanded(child: _buildContactCard(const FaIcon(FontAwesomeIcons.instagram, color: AppColors.primary, size: 24), "Instagram Direct", "@therangmanch_official", "https://www.instagram.com/therangmanch_official")),
                      ],
                    ),
              
              const SizedBox(height: 64),
              const Divider(color: Colors.white10),
              const SizedBox(height: 40),
              
              // Bottom Footer Brand info
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Brand Summary
                  Expanded(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "THE RANGMANCH",
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Founded by Sonam Yadav",
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Helping aspiring actors build confidence through practical acting guidance, real industry mentorship, and active audition updates.",
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 48),
                  
                  // Quick Social Links
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: isMobile ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                      children: [
                        Text(
                          "CONNECT WITH US",
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: isMobile ? MainAxisAlignment.start : MainAxisAlignment.end,
                          children: [
                            _buildSocialIconButton(const FaIcon(FontAwesomeIcons.whatsapp, color: Colors.white, size: 18), "https://wa.me/919999999999"),
                            _buildSocialIconButton(const FaIcon(FontAwesomeIcons.instagram, color: Colors.white, size: 18), "https://www.instagram.com/therangmanch_official"),
                            _buildSocialIconButton(const FaIcon(FontAwesomeIcons.youtube, color: Colors.white, size: 18), "https://www.youtube.com"),
                            _buildSocialIconButton(const FaIcon(FontAwesomeIcons.imdb, color: Colors.white, size: 18), "https://www.imdb.com"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 48),
              const Divider(color: Colors.white10),
              const SizedBox(height: 24),
              
              // Copyright
              Text(
                "© 2026 The Rangmanch. All rights reserved. • Founded by Sonam Yadav",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textMuted,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactCard(Widget icon, String title, String subtitle, String url) {
    return HoverCard(
      onTap: () => _launchURL(url),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          icon,
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIconButton(Widget icon, String url) {
    return Container(
      margin: const EdgeInsets.only(left: 12),
      child: InkWell(
        onTap: () => _launchURL(url),
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: icon,
        ),
      ),
    );
  }

  // --- Section Header Helper ---
  Widget _buildSectionHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.secondary,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: 80,
          height: 3.5,
          decoration: BoxDecoration(
            gradient: AppColors.goldGradient,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }
}
