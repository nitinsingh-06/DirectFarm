import 'package:farmdirect/features/buyer/Buyer_dashboard.dart/buyer_dashboard_screen.dart';
import 'package:flutter/material.dart';

class OrderSuccessScreen extends StatefulWidget {
  final int totalAmount;
  final String orderId;
  final String deliveryTime;

  const OrderSuccessScreen({
    super.key,
    this.totalAmount = 805,
    this.orderId = 'FD5678',
    this.deliveryTime = 'Tomorrow, 07:00 AM - 11:00 AM',
  });

  @override
  State<OrderSuccessScreen> createState() =>
      _OrderSuccessScreenState();
}

class _OrderSuccessScreenState
    extends State<OrderSuccessScreen>
    with TickerProviderStateMixin {
  // ============================================================
  // ANIMATION CONTROLLERS
  // ============================================================

  late AnimationController _successController;
  late AnimationController _contentController;
  late AnimationController _buttonController;
  late AnimationController _pulseController;

  // ============================================================
  // ANIMATIONS
  // ============================================================

  late Animation<double> _successScale;
  late Animation<double> _successFade;

  late Animation<Offset> _titleSlide;
  late Animation<double> _titleFade;

  late Animation<Offset> _detailsSlide;
  late Animation<double> _detailsFade;

  late Animation<Offset> _deliverySlide;
  late Animation<double> _deliveryFade;

  late Animation<double> _buttonScale;
  late Animation<double> _buttonFade;

  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();

    // ==========================================================
    // SUCCESS ICON ANIMATION
    // ==========================================================

    _successController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _successScale = CurvedAnimation(
      parent: _successController,
      curve: Curves.elasticOut,
    );

    _successFade = CurvedAnimation(
      parent: _successController,
      curve: Curves.easeIn,
    );

    // ==========================================================
    // CONTENT ANIMATION
    // ==========================================================

    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(
          0.15,
          0.45,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    _titleFade = CurvedAnimation(
      parent: _contentController,
      curve: const Interval(
        0.15,
        0.45,
        curve: Curves.easeIn,
      ),
    );

    _detailsSlide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(
          0.35,
          0.65,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    _detailsFade = CurvedAnimation(
      parent: _contentController,
      curve: const Interval(
        0.35,
        0.65,
        curve: Curves.easeIn,
      ),
    );

    _deliverySlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(
          0.5,
          0.8,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    _deliveryFade = CurvedAnimation(
      parent: _contentController,
      curve: const Interval(
        0.5,
        0.8,
        curve: Curves.easeIn,
      ),
    );

    // ==========================================================
    // BUTTON ANIMATION
    // ==========================================================

    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _buttonScale = CurvedAnimation(
      parent: _buttonController,
      curve: Curves.elasticOut,
    );

    _buttonFade = CurvedAnimation(
      parent: _buttonController,
      curve: Curves.easeIn,
    );

    // ==========================================================
    // GLOW / PULSE ANIMATION
    // ==========================================================

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _pulse = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    // ==========================================================
    // START ANIMATIONS
    // ==========================================================

    _startAnimations();
  }

  // ============================================================
  // START
  // ============================================================

  Future<void> _startAnimations() async {
    await Future.delayed(
      const Duration(milliseconds: 150),
    );

    _successController.forward();

    await Future.delayed(
      const Duration(milliseconds: 400),
    );

    _contentController.forward();

    await Future.delayed(
      const Duration(milliseconds: 700),
    );

    _buttonController.forward();

    _pulseController.repeat(
      reverse: true,
    );
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _successController.dispose();
    _contentController.dispose();
    _buttonController.dispose();
    _pulseController.dispose();

    super.dispose();
  }

  // ============================================================
  // TRACK ORDER
  // ============================================================

  void _trackOrder() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Opening order tracking...',
        ),
      ),
    );

    // Later:
    //
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (_) => OrderTrackingScreen(
    //       orderId: widget.orderId,
    //     ),
    //   ),
    // );
  }

  // ============================================================
  // CONTINUE SHOPPING
  // ============================================================
void _continueShopping() {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (context) => const BuyerDashboard(),
    ),
    (route) => false,
  );
}

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF075842),

      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 70),

                      // ==================================================
                      // ANIMATED SUCCESS ICON
                      // ==================================================

                      FadeTransition(
                        opacity: _successFade,
                        child: ScaleTransition(
                          scale: _successScale,
                          child: AnimatedBuilder(
                            animation: _pulse,
                            builder: (
                              context,
                              child,
                            ) {
                              return _buildSuccessIcon(
                                _pulse.value,
                              );
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 55),

                      // ==================================================
                      // ANIMATED TITLE
                      // ==================================================

                      SlideTransition(
                        position: _titleSlide,
                        child: FadeTransition(
                          opacity: _titleFade,
                          child: const Text(
                            'Order Placed!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 9),

                      // ==================================================
                      // ANIMATED ORDER DETAILS
                      // ==================================================

                      SlideTransition(
                        position: _detailsSlide,
                        child: FadeTransition(
                          opacity: _detailsFade,
                          child: Text(
                            'Order ID: #${widget.orderId} • '
                            'Successfully recorded in escrow',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFFD4E8E2),
                              fontSize: 9,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      // ==================================================
                      // ANIMATED DELIVERY CARD
                      // ==================================================

                      SlideTransition(
                        position: _deliverySlide,
                        child: FadeTransition(
                          opacity: _deliveryFade,
                          child: _buildDeliveryCard(),
                        ),
                      ),

                      const SizedBox(height: 65),

                      // ==================================================
                      // ANIMATED BUTTONS
                      // ==================================================

                      FadeTransition(
                        opacity: _buttonFade,
                        child: ScaleTransition(
                          scale: _buttonScale,
                          child: Column(
                            children: [
                              _buildTrackButton(),

                              const SizedBox(height: 11),

                              _buildContinueButton(),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 45),
                    ],
                  ),
                ),
              ),
            ),

            // ======================================================
            // HOME INDICATOR
            // ======================================================

            Container(
              width: 105,
              height: 4,
              margin: const EdgeInsets.only(
                bottom: 8,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF034936),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // SUCCESS ICON
  // ============================================================

  Widget _buildSuccessIcon(double pulse) {
    final double glow = 20 + (pulse * 12);

    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF82D20B),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF82D20B).withOpacity(
              0.25 + (pulse * 0.15),
            ),
            blurRadius: glow,
            spreadRadius: 4 + (pulse * 4),
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: 66,
          height: 66,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF075842),
              width: 3,
            ),
          ),
          child: const Icon(
            Icons.check,
            size: 48,
            color: Color(0xFF075842),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // DELIVERY CARD
  // ============================================================

  Widget _buildDeliveryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF236D5B),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        children: [
          const Text(
            'ESTIMATED DELIVERY',
            style: TextStyle(
              color: Color(0xFF82D20B),
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 9),

          Text(
            widget.deliveryTime,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 9),

          const Text(
            'Fresh harvest will be dispatched shortly',
            style: TextStyle(
              color: Color(0xFFD4E8E2),
              fontSize: 8,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // TRACK ORDER
  // ============================================================

  Widget _buildTrackButton() {
    return SizedBox(
      width: double.infinity,
      height: 37,
      child: ElevatedButton(
        onPressed: _trackOrder,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF82D20B),
          foregroundColor: const Color(0xFF075842),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: const Text(
          'Track Order',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // CONTINUE SHOPPING
  // ============================================================

  Widget _buildContinueButton() {
    return SizedBox(
      width: double.infinity,
      height: 37,
      child: OutlinedButton(
        onPressed: _continueShopping,
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: const BorderSide(
            color: Colors.white,
            width: 1.2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: const Text(
          'Continue Shopping',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}