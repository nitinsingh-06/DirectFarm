import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _search = '';

  // Replace with your real support details.
  static const String supportPhone = '18003008843';
  static const String whatsappNumber = '916395712645';
  static const String supportEmail = 'nitinsinghbagri005@gmail.com';

  final List<_HelpItem> _items = const [
    _HelpItem(
      title: 'Account & Profile',
      subtitle: 'Manage your\naccount',
      icon: Icons.person_rounded,
      iconColor: Color(0xFF159447),
      iconBg: Color(0xFFE7F7EA),
      keywords: ['account', 'profile', 'login', 'password'],
    ),
    _HelpItem(
      title: 'List & Sell\nProducts',
      subtitle: 'Add, edit and\nmanage products',
      icon: Icons.eco_rounded,
      iconColor: Color(0xFF159447),
      iconBg: Color(0xFFE7F7EA),
      keywords: ['product', 'products', 'sell', 'add', 'edit', 'stock'],
    ),
    _HelpItem(
      title: 'Orders & Payments',
      subtitle: 'Track orders\nand payouts',
      icon: Icons.inventory_2_rounded,
      iconColor: Color(0xFFF28A17),
      iconBg: Color(0xFFFFF1DD),
      keywords: ['order', 'orders', 'payment', 'payout'],
    ),
    _HelpItem(
      title: 'Delivery & Logistics',
      subtitle: 'Learn about\ndelivery options',
      icon: Icons.local_shipping_rounded,
      iconColor: Color(0xFF287EDB),
      iconBg: Color(0xFFE8F2FF),
      keywords: ['delivery', 'logistics', 'shipping'],
    ),
    _HelpItem(
      title: 'KYC & Aadhaar',
      subtitle: 'Update your\ndocuments',
      icon: Icons.badge_rounded,
      iconColor: Color(0xFF7651D7),
      iconBg: Color(0xFFF0EAFF),
      keywords: ['kyc', 'aadhaar', 'aadhar', 'document'],
    ),
    _HelpItem(
      title: 'Other Queries',
      subtitle: 'General help\nand support',
      icon: Icons.help_rounded,
      iconColor: Color(0xFF18A6B8),
      iconBg: Color(0xFFE4F8FA),
      keywords: ['help', 'support', 'query', 'problem'],
    ),
  ];

  final List<_Faq> _faqs = const [
    _Faq(
      question: 'How to list and sell my organic crops?',
      answer:
          'Open Add Product from your farmer dashboard, enter the crop details, price, unit and available quantity, then save the product.',
      keywords: ['product', 'sell', 'crop', 'add'],
    ),
    _Faq(
      question: 'How do payouts and secure bank transfers work?',
      answer:
          'Payment and payout processing depends on the order and payment flow configured for FarmDirect.',
      keywords: ['payment', 'payout', 'bank', 'transfer'],
    ),
    _Faq(
      question: 'What is the delivery and logistics process?',
      answer:
          'After an order is confirmed, delivery and logistics are coordinated according to the selected delivery option.',
      keywords: ['delivery', 'logistics', 'shipping'],
    ),
    _Faq(
      question: 'How can I update my Aadhaar details?',
      answer:
          'Open your farmer profile and account settings to update the available KYC information.',
      keywords: ['aadhaar', 'aadhar', 'kyc', 'document'],
    ),
    _Faq(
      question: 'How can I change my product stock?',
      answer:
          'Open Manage Products, select the product and use Manage Stock to update the available quantity.',
      keywords: ['stock', 'quantity', 'product'],
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_Faq> get _filteredFaqs {
    if (_search.trim().isEmpty) return _faqs;

    final q = _search.toLowerCase().trim();

    return _faqs.where((faq) {
      final text = '${faq.question} ${faq.answer} ${faq.keywords.join(' ')}'
          .toLowerCase();
      return text.contains(q);
    }).toList();
  }

  Future<void> _callSupport() async {
    try {
      final opened = await launchUrl(
        Uri.parse('tel:$supportPhone'),
        mode: LaunchMode.externalApplication,
      );

      if (!opened) {
        _message('Could not open the phone dialer.');
      }
    } catch (_) {
      _message('Could not open the phone dialer.');
    }
  }

  Future<void> _openWhatsApp() async {
    final number = whatsappNumber.replaceAll(RegExp(r'[^0-9]'), '');
    final message = Uri.encodeComponent(
      'Hello FarmDirect Support, I need help.',
    );

    try {
      final opened = await launchUrl(
        Uri.parse('whatsapp://send?phone=$number&text=$message'),
        mode: LaunchMode.externalApplication,
      );

      if (opened) return;
    } catch (_) {}

    try {
      final opened = await launchUrl(
        Uri.parse('https://wa.me/$number?text=$message'),
        mode: LaunchMode.externalApplication,
      );

      if (!opened) {
        _message('WhatsApp could not be opened.');
      }
    } catch (_) {
      _message('Please install WhatsApp and try again.');
    }
  }

  Future<void> _sendEmail() async {
    final uri = Uri(
      scheme: 'mailto',
      path: supportEmail,
      queryParameters: {
        'subject': 'FarmDirect Support Request',
        'body': 'Hello FarmDirect Support,\n\nI need help with:',
      },
    );

    try {
      final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);

      if (!opened) {
        _message('No email application is available.');
      }
    } catch (_) {
      _message('Could not open your email application.');
    }
  }

  void _message(String text) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text), behavior: SnackBarBehavior.floating),
    );
  }

  void _searchChanged(String value) {
    setState(() => _search = value);
  }

  void _openCategory(_HelpItem item) {
    final matches = _faqs.where((faq) {
      return faq.keywords.any(item.keywords.contains);
    }).toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _FaqSheet(
        title: item.title.replaceAll('\n', ' '),
        faqs: matches.isEmpty ? _faqs : matches,
      ),
    );
  }

  void _openAllFaqs() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _FaqSheet(
        title: 'Frequently Asked Questions',
        faqs: _faqsStatic,
      ),
    );
  }

  static const List<_Faq> _faqsStatic = [
    _Faq(
      question: 'How to list and sell my organic crops?',
      answer:
          'Open Add Product from your farmer dashboard, enter the crop details, price, unit and available quantity, then save the product.',
      keywords: ['product'],
    ),
    _Faq(
      question: 'How do payouts and secure bank transfers work?',
      answer:
          'Payment and payout processing depends on the order and payment flow configured for FarmDirect.',
      keywords: ['payment'],
    ),
    _Faq(
      question: 'What is the delivery and logistics process?',
      answer:
          'After an order is confirmed, delivery and logistics are coordinated according to the selected delivery option.',
      keywords: ['delivery'],
    ),
    _Faq(
      question: 'How can I update my Aadhaar details?',
      answer:
          'Open your farmer profile and account settings to update the available KYC information.',
      keywords: ['aadhaar'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final searching = _search.trim().isNotEmpty;
    final results = _filteredFaqs;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FBFA),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              _hero(),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 7),
                child: Column(
                  children: [
                    if (searching) _searchResults(results) else _categoryGrid(),
                    const SizedBox(height: 8),
                    _immediateHelp(),
                    const SizedBox(height: 9),
                    _contactSection(),
                    if (!searching) ...[
                      const SizedBox(height: 12),
                      _faqPreview(),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 8),
              _footer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _hero() {
    return SizedBox(
      height: 157,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
       
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: 157,
            child: Image.asset(
              'assets/images/help_support_header.png',
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),

          // -------------------------------------------------------
          // BACK BUTTON
          // -------------------------------------------------------
          Positioned(
            left: 8,
            top: 9,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 27,
                height: 27,
                decoration: const BoxDecoration(
                  color: Color(0xFFEAF7EE),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back_rounded,
                  size: 17,
                  color: Color(0xFF075B47),
                ),
              ),
            ),
          ),

          // -------------------------------------------------------
          // TITLE
          // -------------------------------------------------------
          const Positioned(
            left: 31,
            top: 31,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Help & Support',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF123F34),
                  ),
                ),
                SizedBox(height: 1),
                Text(
                  'We’re here to help you grow',
                  style: TextStyle(fontSize: 11, color: Color(0xFF6E7B75)),
                ),
                Text(
                  'your farming business',
                  style: TextStyle(fontSize: 11, color: Color(0xFF6E7B75)),
                ),
              ],
            ),
          ),

          // -------------------------------------------------------
          // SEARCH BAR
          // -------------------------------------------------------
          Positioned(left: 7, right: 7, bottom: 0, child: _searchBar()),
        ],
      ),
    );
  }
Widget _searchBar() {
  return Material(
    elevation: 3,
    shadowColor: const Color(0x22075B47),
    borderRadius: BorderRadius.circular(20),
    child: Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF8BC5A1),
          width: 1,
        ),
      ),
      child: Center(
        child: TextField(
          controller: _searchController,
          onChanged: _searchChanged,
          textInputAction: TextInputAction.search,
          textAlignVertical: TextAlignVertical.center,

          style: const TextStyle(
            fontSize: 10,
            color: Color(0xFF36443F),
          ),

          decoration: InputDecoration(
            isDense: true,

            prefixIcon: const Icon(
              Icons.search_rounded,
              size: 20,
              color: Color(0xFF385B54),
            ),

            // suffixIcon: _search.isEmpty
            //     ? const Icon(
            //         Icons.mic_none_rounded,
            //         size: 19,
            //         color: Color(0xFF385B54),
            //       )
            //     : IconButton(
            //         padding: EdgeInsets.zero,
            //         onPressed: () {
            //           _searchController.clear();

            //           setState(() {
            //             _search = '';
            //           });
            //         },
            //         icon: const Icon(
            //           Icons.close_rounded,
            //           size: 18,
            //           color: Color(0xFF65756F),
            //         ),
            //       ),

            hintText: 'Search for help, FAQs...',
            hintStyle: const TextStyle(
              fontSize: 10,
              color: Color(0xFF7D8985),
              height: 1.0,
            ),

            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,

            contentPadding: const EdgeInsets.symmetric(
              vertical: 0,
              horizontal: 0,
            ),
          ),
        ),
      ),
    ),
  );
}

  Widget _categoryGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        childAspectRatio: 0.91,
      ),
      itemBuilder: (_, index) {
        final item = _items[index];

        return InkWell(
          borderRadius: BorderRadius.circular(7),
          onTap: () => _openCategory(item),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(7),
              border: Border.all(color: const Color(0xFFE5EAE7)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: item.iconBg,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(item.icon, color: item.iconColor, size: 18),
                ),
                const SizedBox(height: 4),
                Text(
                  item.title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: const TextStyle(
                    fontSize: 7.5,
                    height: 1.0,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF173D34),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.subtitle,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: const TextStyle(
                    fontSize: 6.2,
                    height: 1.0,
                    color: Color(0xFF7B8782),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _immediateHelp() {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (_) => _ContactSheet(
            onCall: _callSupport,
            onWhatsApp: _openWhatsApp,
            onEmail: _sendEmail,
          ),
        );
      },
      child: Container(
        height: 61,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 7),
        decoration: BoxDecoration(
          color: const Color(0xFFEAF8ED),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: Color(0xFFD6F0DC),
                shape: BoxShape.circle,
              ),
              child: const Image(
                image: AssetImage('assets/images/help_agent.png'),
              ),
            ),
            const SizedBox(width: 7),
            const Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Need immediate help?',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF173D34),
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Our support team is available\nto assist you.',
                    style: TextStyle(
                      fontSize: 7.5,
                      height: 1.1,
                      color: Color(0xFF74817B),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              size: 18,
              color: Color(0xFF173D34),
            ),
          ],
        ),
      ),
    );
  }

  Widget _contactSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 1, bottom: 5),
          child: Text(
            'Contact Us Directly',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w900,
              color: Color(0xFF123F34),
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: _contactCard(
                icon: Image.asset('assets/images/phone_icon.png',scale: 1,fit: BoxFit.cover,),
                color: const Color(0xFF159447),
                title: 'Call Support',
                value: '1800 300 8843',
                subtitle: 'Mon - Sat, 9 AM - 7 PM',
                onTap: _callSupport,
              ),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: _contactCard(
                icon: Image.asset('assets/images/whatsapp_icons.png',scale: 1,fit: BoxFit.cover,),
                color: const Color(0xFF159447),
                title: 'Chat on WhatsApp',
                value: '+91 6395712645',
                subtitle: 'Get instant help',
                onTap: _openWhatsApp,
              ),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: _contactCard(
               icon: Image.asset('assets/images/email_icon.png',scale: 1,fit: BoxFit.cover,),
                color: const Color(0xFF159BA9),
                title: 'Email Support',
                value: 'nitinsinghbagri005@gmail.com',
                subtitle: 'We’ll respond soon',
                onTap: _sendEmail,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _contactCard({
    required Image icon,
    required Color color,
    required String title,
    required String value,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(7),
      onTap: onTap,
      child: Container(
        height: 84,
        padding: const EdgeInsets.fromLTRB(2, 5, 2, 3),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(7),
          border: Border.all(color: const Color(0xFFE2E9E5)),
        ),
        child: Column(
          children: [
            Container(
              width: 27,
              height: 27,
              decoration: BoxDecoration(
                color: color.withOpacity(.12),
                shape: BoxShape.circle,
              ),
              child: icon,
            ),
            const SizedBox(height: 3),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 7.2,
                fontWeight: FontWeight.w900,
                color: Color(0xFF173D34),
              ),
            ),
            const SizedBox(height: 1),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 6.8,
                fontWeight: FontWeight.w900,
                color: color,
              ),
            ),
            const SizedBox(height: 1),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 5.8, color: Color(0xFF7A8580)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _faqPreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Frequently Asked Questions',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w900,
                color: Color(0xFF123F34),
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: _openAllFaqs,
              child: const Text(
                'View All',
                style: TextStyle(
                  fontSize: 7,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF159447),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(7),
            border: Border.all(color: const Color(0xFFE3E9E6)),
          ),
          child: Column(
            children: _faqs.take(3).map((faq) {
              return InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (_) => _FaqSheet(title: 'Help', faqs: [faq]),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 7,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.description_outlined,
                        size: 12,
                        color: Color(0xFF8B9691),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          faq.question,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 7.5,
                            color: Color(0xFF4B5B55),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 14,
                        color: Color(0xFF78847F),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _searchResults(List<_Faq> results) {
    if (results.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE2E9E5)),
        ),
        child: const Column(
          children: [
            Icon(Icons.search_off_rounded, size: 28, color: Color(0xFF9AA49F)),
            SizedBox(height: 6),
            Text(
              'No results found',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: Color(0xFF173D34),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E9E5)),
      ),
      child: Column(
        children: results.map((faq) {
          return InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (_) => _FaqSheet(title: 'Search Result', faqs: [faq]),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  const Icon(
                    Icons.help_outline_rounded,
                    color: Color(0xFF159447),
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      faq.question,
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF30483F),
                      ),
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded, size: 17),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _footer() {
    return SizedBox(
      height: 56,
      width: double.infinity,
      child: CustomPaint(painter: _FarmPainter()),
    );
  }
}

// ================================================================
// FAQ BOTTOM SHEET
// ================================================================

class _FaqSheet extends StatelessWidget {
  final String title;
  final List<_Faq> faqs;

  const _FaqSheet({required this.title, required this.faqs});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        constraints: const BoxConstraints(maxHeight: 520),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 9),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Color(0xFFD3DBD6),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(17, 14, 8, 7),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF123F34),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(12, 3, 12, 20),
                itemCount: faqs.length,
                separatorBuilder: (_, __) => const SizedBox(height: 7),
                itemBuilder: (_, index) {
                  return _FaqExpansion(faq: faqs[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FaqExpansion extends StatefulWidget {
  final _Faq faq;

  const _FaqExpansion({required this.faq});

  @override
  State<_FaqExpansion> createState() => _FaqExpansionState();
}

class _FaqExpansionState extends State<_FaqExpansion> {
  bool open = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9FBFA),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE3EAE6)),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => open = !open),
            child: Padding(
              padding: const EdgeInsets.all(11),
              child: Row(
                children: [
                  const Icon(
                    Icons.help_outline_rounded,
                    size: 16,
                    color: Color(0xFF159447),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.faq.question,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF27473D),
                      ),
                    ),
                  ),
                  Icon(
                    open
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    size: 17,
                  ),
                ],
              ),
            ),
          ),
          if (open)
            Padding(
              padding: const EdgeInsets.fromLTRB(35, 0, 12, 12),
              child: Text(
                widget.faq.answer,
                style: const TextStyle(
                  fontSize: 9,
                  height: 1.4,
                  color: Color(0xFF6C7873),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ================================================================
// CONTACT SHEET
// ================================================================

class _ContactSheet extends StatelessWidget {
  final VoidCallback onCall;
  final VoidCallback onWhatsApp;
  final VoidCallback onEmail;

  const _ContactSheet({
    required this.onCall,
    required this.onWhatsApp,
    required this.onEmail,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Color(0xFFD3DBD6),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              'Need immediate help?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: Color(0xFF123F34),
              ),
            ),
            const SizedBox(height: 12),
            _action(
              icon: Icons.phone_rounded,
              title: 'Call Support',
              subtitle: '1800 300 8843',
              color: const Color(0xFF159447),
              onTap: onCall,
            ),
            const SizedBox(height: 7),
            _action(
              icon: Icons.chat_rounded,
              title: 'Chat on WhatsApp',
              subtitle: '+91 6395712645',
              color: const Color(0xFF159447),
              onTap: onWhatsApp,
            ),
            const SizedBox(height: 7),
            _action(
              icon: Icons.email_rounded,
              title: 'Email Support',
              subtitle: 'nitinsinghbagri005@gmail.com',
              color: const Color(0xFF159BA9),
              onTap: onEmail,
            ),
          ],
        ),
      ),
    );
  }

  Widget _action({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(11),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FBF9),
          borderRadius: BorderRadius.circular(11),
          border: Border.all(color: const Color(0xFFE2E9E5)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 21,
              backgroundColor: color.withOpacity(.12),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 9,
                      color: color,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded),
          ],
        ),
      ),
    );
  }
}

// ================================================================
// MODELS
// ================================================================

class _HelpItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final List<String> keywords;

  const _HelpItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.keywords,
  });
}

class _Faq {
  final String question;
  final String answer;
  final List<String> keywords;

  const _Faq({
    required this.question,
    required this.answer,
    required this.keywords,
  });
}

// ================================================================
// FARM FOOTER PAINTER
// ================================================================

class _FarmPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint();

    // Sky.
    p.color = const Color(0xFFE9F7F4);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), p);

    // Back hills.
    p.color = const Color(0xFFB6DCD5);
    final hills = Path()
      ..moveTo(0, size.height * .72)
      ..quadraticBezierTo(
        size.width * .18,
        size.height * .10,
        size.width * .37,
        size.height * .70,
      )
      ..quadraticBezierTo(
        size.width * .58,
        size.height * .08,
        size.width * .80,
        size.height * .67,
      )
      ..quadraticBezierTo(
        size.width * .92,
        size.height * .35,
        size.width,
        size.height * .62,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(hills, p);

    // Green field.
    p.color = const Color(0xFF66B45E);
    final field = Path()
      ..moveTo(0, size.height * .72)
      ..quadraticBezierTo(
        size.width * .24,
        size.height * .48,
        size.width * .47,
        size.height * .73,
      )
      ..quadraticBezierTo(
        size.width * .73,
        size.height * .48,
        size.width,
        size.height * .70,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(field, p);

    // Dark foreground.
    p.color = const Color(0xFF4B9B52);
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * .82, size.width, size.height * .18),
      p,
    );

    _tree(canvas, size.width * .12, size.height * .71, 10);
    _tree(canvas, size.width * .87, size.height * .69, 9);

    // House.
    final hx = size.width * .73;
    final hy = size.height * .58;

    p.color = const Color(0xFFFFF5DE);
    canvas.drawRect(
      Rect.fromLTWH(hx, hy + 7, size.width * .13, size.height * .29),
      p,
    );

    p.color = const Color(0xFFD85E43);
    final roof = Path()
      ..moveTo(hx - 2, hy + 8)
      ..lineTo(hx + size.width * .065, hy - 3)
      ..lineTo(hx + size.width * .145, hy + 8)
      ..close();
    canvas.drawPath(roof, p);

    p.color = const Color(0xFF85674B);
    canvas.drawRect(
      Rect.fromLTWH(
        hx + size.width * .055,
        hy + size.height * .15,
        size.width * .025,
        size.height * .14,
      ),
      p,
    );
  }

  void _tree(Canvas canvas, double x, double y, double r) {
    final p = Paint();

    p.color = const Color(0xFF765B43);
    canvas.drawRect(Rect.fromLTWH(x - 1.5, y, 3, r * 1.8), p);

    p.color = const Color(0xFF2E7D32);
    canvas.drawCircle(Offset(x, y), r, p);

    p.color = const Color(0xFF58A95B);
    canvas.drawCircle(Offset(x - r * .45, y + r * .15), r * .62, p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
