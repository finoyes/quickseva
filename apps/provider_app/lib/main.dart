import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'screens/detailed_analytics_screen.dart';
import 'screens/simple_duty_screen.dart';

void main() {
  runApp(const QuickSevaProviderApp());
}

class QuickSevaProviderApp extends StatefulWidget {
  const QuickSevaProviderApp({super.key});

  @override
  State<QuickSevaProviderApp> createState() => _QuickSevaProviderAppState();
}

class _QuickSevaProviderAppState extends State<QuickSevaProviderApp> {
  final LanguageController _languageController = LanguageController();

  @override
  void dispose() {
    _languageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LanguageScope(
      controller: _languageController,
      child: AnimatedBuilder(
        animation: _languageController,
        builder: (context, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: '${BrandConfig.brandName} Partner',
            theme: QTheme.lightTheme(),
            home: const ProviderMainShell(),
          );
        },
      ),
    );
  }
}

class ProviderMainShell extends StatefulWidget {
  const ProviderMainShell({super.key});

  @override
  State<ProviderMainShell> createState() => _ProviderMainShellState();
}

class _ProviderMainShellState extends State<ProviderMainShell> {
  int _tabIndex = 0;
  bool _isOnline = true;
  int _todayEarningsRupees = 1450;
  int _jobsCompletedToday = 4;
  int _cashDuesRupees = 420;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: QColors.warmIvoryBg,
      body: IndexedStack(
        index: _tabIndex,
        children: [
          SimpleDutyScreen(
            isOnline: _isOnline,
            onOnlineChanged: (val) => setState(() => _isOnline = val),
            todayEarningsRupees: _todayEarningsRupees,
            jobsCompletedToday: _jobsCompletedToday,
            cashDuesRupees: _cashDuesRupees,
            onJobCompleted: (job) {
              setState(() {
                _todayEarningsRupees += job.netPayoutRupees;
                _jobsCompletedToday += 1;
                // Cash jobs: customer paid the partner directly, so the
                // platform fee is owed back as dues (ARCHITECTURE.md 9.5).
                if (job.paymentMode == PaymentMode.cash) {
                  _cashDuesRupees += job.platformFeeRupees;
                }
              });
            },
            onSwitchToAnalyticsTab: () => setState(() => _tabIndex = 1),
          ),
          DetailedAnalyticsScreen(
            todayEarningsRupees: _todayEarningsRupees,
            jobsCompletedToday: _jobsCompletedToday,
            cashDuesRupees: _cashDuesRupees,
            onClearCashDues: () {
              setState(() => _cashDuesRupees = 0);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: QColors.primaryGreen,
                  content: Text(
                    context.trPair(
                      'Cash Dues cleared via Dummy UPI! Full dispatch eligibility active.',
                      'डेमो UPI द्वारा नकद बकाया चुकता हो गया!',
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tabIndex,
        onDestinationSelected: (idx) => setState(() => _tabIndex = idx),
        backgroundColor: QColors.cleanWhite,
        indicatorColor: QColors.softGreenTint,
        elevation: 8,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.bolt_outlined),
            selectedIcon: const Icon(
              Icons.bolt_rounded,
              color: QColors.primaryGreen,
            ),
            label: context.trPair('Duty', 'ड्यूटी'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.query_stats_rounded),
            selectedIcon: const Icon(
              Icons.query_stats_rounded,
              color: QColors.primaryGreen,
            ),
            label: context.trPair('Earnings', 'कमाई'),
          ),
        ],
      ),
    );
  }
}
