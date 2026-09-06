import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  static const Color primary = Color(0xFF075B4A);
  static const Color background = Color(0xFFF7F9F8);
  static const Color textDark = Color(0xFF293530);
  static const Color textGrey = Color(0xFF6F7975);
  static const Color borderColor = Color(0xFFE0E5E2);

  bool orderUpdates = true;
  bool deliveryAlerts = true;
  bool priceDrops = true;
  bool promotionsOffers = false;
  bool newFarmsProducts = true;
  bool weeklyDigest = false;

  bool pushNotifications = true;
  bool smsNotifications = true;
  bool emailNotifications = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  // ----------------------------------------------------------
  // LOAD SAVED SETTINGS
  // ----------------------------------------------------------

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      orderUpdates = prefs.getBool('notification_order_updates') ?? true;
      deliveryAlerts =
          prefs.getBool('notification_delivery_alerts') ?? true;
      priceDrops = prefs.getBool('notification_price_drops') ?? true;
      promotionsOffers =
          prefs.getBool('notification_promotions') ?? false;
      newFarmsProducts =
          prefs.getBool('notification_new_farms') ?? true;
      weeklyDigest =
          prefs.getBool('notification_weekly_digest') ?? false;

      pushNotifications =
          prefs.getBool('notification_push') ?? true;
      smsNotifications =
          prefs.getBool('notification_sms') ?? true;
      emailNotifications =
          prefs.getBool('notification_email') ?? false;
    });
  }

  // ----------------------------------------------------------
  // SAVE SETTING
  // ----------------------------------------------------------

  Future<void> _saveSetting(
    String key,
    bool value,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  // ----------------------------------------------------------
  // BUILD
  // ----------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: primary,
            size: 21,
          ),
        ),

        title: const Text(
          'Notification Settings',
          style: TextStyle(
            color: primary,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            8,
            3,
            8,
            20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle('ALERT CATEGORIES'),

              const SizedBox(height: 7),

              _buildAlertCategories(),

              const SizedBox(height: 18),

              _sectionTitle('DELIVERY CHANNELS'),

              const SizedBox(height: 7),

              _buildDeliveryChannels(),
            ],
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // SECTION TITLE
  // ----------------------------------------------------------

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 2),
      child: Text(
        text,
        style: const TextStyle(
          color: primary,
          fontSize: 9,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // ALERT CATEGORIES
  // ----------------------------------------------------------

  Widget _buildAlertCategories() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor,
        ),
      ),
      child: Column(
        children: [
          _switchRow(
            title: 'Order Updates',
            value: orderUpdates,
            onChanged: (value) {
              setState(() {
                orderUpdates = value;
              });

              _saveSetting(
                'notification_order_updates',
                value,
              );
            },
          ),

          _divider(),

          _switchRow(
            title: 'Delivery Alerts',
            value: deliveryAlerts,
            onChanged: (value) {
              setState(() {
                deliveryAlerts = value;
              });

              _saveSetting(
                'notification_delivery_alerts',
                value,
              );
            },
          ),

          _divider(),

          _switchRow(
            title: 'Price Drops',
            value: priceDrops,
            onChanged: (value) {
              setState(() {
                priceDrops = value;
              });

              _saveSetting(
                'notification_price_drops',
                value,
              );
            },
          ),

          _divider(),

          _switchRow(
            title: 'Promotions & Offers',
            value: promotionsOffers,
            onChanged: (value) {
              setState(() {
                promotionsOffers = value;
              });

              _saveSetting(
                'notification_promotions',
                value,
              );
            },
          ),

          _divider(),

          _switchRow(
            title: 'New Farms & Products',
            value: newFarmsProducts,
            onChanged: (value) {
              setState(() {
                newFarmsProducts = value;
              });

              _saveSetting(
                'notification_new_farms',
                value,
              );
            },
          ),

          _divider(),

          _switchRow(
            title: 'Weekly Digest',
            value: weeklyDigest,
            onChanged: (value) {
              setState(() {
                weeklyDigest = value;
              });

              _saveSetting(
                'notification_weekly_digest',
                value,
              );
            },
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // DELIVERY CHANNELS
  // ----------------------------------------------------------

  Widget _buildDeliveryChannels() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor,
        ),
      ),
      child: Column(
        children: [
          _channelRow(
            icon: Icons.notifications_none_outlined,
            title: 'Push Notifications',
            value: pushNotifications,
            onChanged: (value) {
              setState(() {
                pushNotifications = value;
              });

              _saveSetting(
                'notification_push',
                value,
              );
            },
          ),

          _divider(),

          _channelRow(
            icon: Icons.sms_outlined,
            title: 'SMS / संदेश',
            value: smsNotifications,
            onChanged: (value) {
              setState(() {
                smsNotifications = value;
              });

              _saveSetting(
                'notification_sms',
                value,
              );
            },
          ),

          _divider(),

          _channelRow(
            icon: Icons.mail_outline,
            title: 'Email / ईमेल',
            value: emailNotifications,
            onChanged: (value) {
              setState(() {
                emailNotifications = value;
              });

              _saveSetting(
                'notification_email',
                value,
              );
            },
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // SWITCH ROW
  // ----------------------------------------------------------

  Widget _switchRow({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SizedBox(
      height: 38,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 11,
          right: 8,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: textDark,
                ),
              ),
            ),

            Switch(
              value: value,
              onChanged: onChanged,

              activeColor: Colors.white,
              activeTrackColor: const Color(0xFF08A878),

              inactiveThumbColor: Colors.white,
              inactiveTrackColor: const Color(0xFFAAB3B8),

              materialTapTargetSize:
                  MaterialTapTargetSize.shrinkWrap,
            ),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // CHANNEL ROW
  // ----------------------------------------------------------

  Widget _channelRow({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SizedBox(
      height: 39,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 11,
          right: 8,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: primary,
            ),

            const SizedBox(width: 9),

            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: textDark,
                ),
              ),
            ),

            Transform.scale(
              scale: 0.85,
              child: Checkbox(
                value: value,
                onChanged: (newValue) {
                  onChanged(newValue ?? false);
                },

                activeColor: const Color(0xFF08A878),

                side: const BorderSide(
                  color: Color(0xFFD8DFDC),
                  width: 1.4,
                ),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),

                materialTapTargetSize:
                    MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // DIVIDER
  // ----------------------------------------------------------

  Widget _divider() {
    return const Divider(
      height: 1,
      thickness: 0.7,
      color: borderColor,
    );
  }
}