import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/colors.dart';

/// Notifikasi Screen - Notification Preferences
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _dailyReminder = true;
  bool _weeklyReport = true;
  bool _moodCheckIn = true;
  bool _wellbeingTip = true;
  bool _crisisAlert = true;
  bool _communityUpdate = false;

  String _reminderTime = '08:00';
  String _reportDay = 'Jumat';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi'),
        elevation: 0,
        backgroundColor: TaraColors.bgCoolWhite,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main notifications toggle
            const Text(
              'Notifikasi Umum',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: TaraColors.textDeepIndigo,
              ),
            ),
            const SizedBox(height: 16),
            _NotificationTile(
              icon: Icons.notifications_active,
              title: 'Push Notification',
              subtitle: 'Notifikasi real-time di perangkat Anda',
              value: _pushNotifications,
              onChanged: (value) {
                setState(() => _pushNotifications = value);
              },
            ),
            const SizedBox(height: 12),
            _NotificationTile(
              icon: Icons.mail_outline,
              title: 'Email Notification',
              subtitle: 'Ringkasan mingguan dan update penting',
              value: _emailNotifications,
              onChanged: (value) {
                setState(() => _emailNotifications = value);
              },
            ),
            const SizedBox(height: 32),

            // Daily reminders
            const Text(
              'Pengingat Harian',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: TaraColors.textDeepIndigo,
              ),
            ),
            const SizedBox(height: 16),
            _NotificationTile(
              icon: Icons.schedule,
              title: 'Daily Check-in Reminder',
              subtitle: 'Pengingat untuk daily mood check-in',
              value: _dailyReminder,
              onChanged: (value) {
                setState(() => _dailyReminder = value);
              },
              trailing: _dailyReminder
                  ? GestureDetector(
                      onTap: () {
                        // TODO: Time picker
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: TaraColors.bgCoolWhite,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _reminderTime,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: TaraColors.blue,
                          ),
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(height: 12),
            _NotificationTile(
              icon: Icons.trending_up,
              title: 'Weekly Report',
              subtitle: 'Laporan mingguan mood dan progress',
              value: _weeklyReport,
              onChanged: (value) {
                setState(() => _weeklyReport = value);
              },
              trailing: _weeklyReport
                  ? GestureDetector(
                      onTap: () {
                        // TODO: Day picker
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: TaraColors.bgCoolWhite,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _reportDay,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: TaraColors.blue,
                          ),
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(height: 32),

            // Content preferences
            const Text(
              'Preferensi Konten',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: TaraColors.textDeepIndigo,
              ),
            ),
            const SizedBox(height: 16),
            _NotificationTile(
              icon: Icons.mood,
              title: 'Mood Check-in Reminder',
              subtitle: 'Pengingat untuk check-in emosi Anda',
              value: _moodCheckIn,
              onChanged: (value) {
                setState(() => _moodCheckIn = value);
              },
            ),
            const SizedBox(height: 12),
            _NotificationTile(
              icon: Icons.lightbulb_outline,
              title: 'Daily Wellbeing Tip',
              subtitle: 'Tips kesehatan mental dan aktivitas harian',
              value: _wellbeingTip,
              onChanged: (value) {
                setState(() => _wellbeingTip = value);
              },
            ),
            const SizedBox(height: 12),
            _NotificationTile(
              icon: Icons.warning,
              title: 'Crisis Support Alert',
              subtitle: 'Notifikasi dukungan krisis ketika diperlukan',
              value: _crisisAlert,
              onChanged: (value) {
                setState(() => _crisisAlert = value);
              },
            ),
            const SizedBox(height: 12),
            _NotificationTile(
              icon: Icons.groups_outlined,
              title: 'Community Updates',
              subtitle: 'Update komunitas dan event khusus',
              value: _communityUpdate,
              onChanged: (value) {
                setState(() => _communityUpdate = value);
              },
            ),
            const SizedBox(height: 32),

            // Notification frequency
            const Text(
              'Frekuensi Notifikasi',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: TaraColors.textDeepIndigo,
              ),
            ),
            const SizedBox(height: 16),
            _FrequencyOption(
              label: 'Optimal (Recommended)',
              description: '2-3 notifikasi per hari',
              isSelected: true,
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _FrequencyOption(
              label: 'Minimal',
              description: 'Hanya notifikasi penting',
              isSelected: false,
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _FrequencyOption(
              label: 'Silent',
              description: 'Tidak ada notifikasi',
              isSelected: false,
              onTap: () {},
            ),
            const SizedBox(height: 32),

            // Do Not Disturb
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: TaraColors.bgCoolWhite,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: TaraColors.divider),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Do Not Disturb Mode',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'OFF',
                        style: TextStyle(
                          fontSize: 12,
                          color: TaraColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Jeda notifikasi antara jam tertentu',
                    style: TextStyle(
                      fontSize: 12,
                      color: TaraColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: TaraColors.bgCoolWhite,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: TaraColors.divider),
                          ),
                          child: const Center(
                            child: Text(
                              '22:00',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'hingga',
                        style: TextStyle(
                          fontSize: 12,
                          color: TaraColors.textMuted,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: TaraColors.bgCoolWhite,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: TaraColors.divider),
                          ),
                          child: const Center(
                            child: Text(
                              '08:00',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Clear notifications
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: TaraColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: TaraColors.error.withOpacity(0.3),
                ),
              ),
              child: Center(
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Hapus Semua Notifikasi',
                    style: TextStyle(
                      color: TaraColors.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Widget? trailing;

  const _NotificationTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: TaraColors.bgCoolWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: TaraColors.divider),
      ),
      child: Row(
        children: [
          Icon(icon, color: TaraColors.blue, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: TaraColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 8),
            trailing!,
          ] else
            const SizedBox(width: 8),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: TaraColors.blue,
          ),
        ],
      ),
    );
  }
}

class _FrequencyOption extends StatelessWidget {
  final String label;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const _FrequencyOption({
    required this.label,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? TaraColors.blue.withOpacity(0.1) : Colors.white,
          border: Border.all(
            color: isSelected ? TaraColors.blue : TaraColors.divider,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? TaraColors.blue : TaraColors.divider,
                  width: 2,
                ),
                color: isSelected ? TaraColors.blue : Colors.white,
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 12,
                      color: Colors.white,
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: TaraColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
