import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class DetailedAnalyticsScreen extends StatefulWidget {
  final int todayEarningsRupees;
  final int jobsCompletedToday;
  final int cashDuesRupees;
  final VoidCallback onClearCashDues;

  const DetailedAnalyticsScreen({
    super.key,
    required this.todayEarningsRupees,
    required this.jobsCompletedToday,
    required this.cashDuesRupees,
    required this.onClearCashDues,
  });

  @override
  State<DetailedAnalyticsScreen> createState() =>
      _DetailedAnalyticsScreenState();
}

class _DetailedAnalyticsScreenState extends State<DetailedAnalyticsScreen> {
  static const int _duesCapRupees = 1000;

  int _periodIdx = 1; // 0 = Today, 1 = This Week, 2 = This Month
  int _withdrawableBalance = 3840;

  static const List<Tr> _weekDays = [
    Tr('Mon', 'सोम'),
    Tr('Tue', 'मंगल'),
    Tr('Wed', 'बुध'),
    Tr('Thu', 'गुरु'),
    Tr('Fri', 'शुक्र'),
    Tr('Sat', 'शनि'),
    Tr('Sun', 'रवि'),
  ];
  static const List<int> _weeklyAmounts = [1120, 1380, 960, 1640, 1890, 2150, 1450];

  /// ₹1,120 -> "1.1k", ₹960 -> "960"
  String _compactRupees(int amount) {
    if (amount < 1000) return '${BrandConfig.currency}$amount';
    return '${BrandConfig.currency}${(amount / 1000).toStringAsFixed(1)}k';
  }

  @override
  Widget build(BuildContext context) {
    final weeklyTotal = _weeklyAmounts.fold<int>(0, (s, e) => s + e);
    final displayedTotal = switch (_periodIdx) {
      0 => widget.todayEarningsRupees,
      1 => weeklyTotal,
      _ => weeklyTotal * 4,
    };

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
        children: [
          _buildHeader(context),
          const SizedBox(height: 16),
          _buildPeriodSelector(context),
          const SizedBox(height: 14),
          _buildEarningsChartCard(context, displayedTotal),
          const SizedBox(height: 14),
          _buildWalletCard(context),
          const SizedBox(height: 14),
          _buildHealthCard(context),
          const SizedBox(height: 18),
          _buildLedger(context),
        ],
      ),
    );
  }

  // ===========================================================================
  // HEADER
  // ===========================================================================
  Widget _buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.trPair('Earnings & Ledger', 'कमाई और खाता'),
                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w900,
                  color: QColors.inkDark,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                context.trPair(
                  'Plan: 15% commission + daily bonus',
                  'प्लान: 15% कमीशन + डेली बोनस',
                ),
                style: const TextStyle(
                  fontSize: 12.5,
                  color: QColors.primaryGreen,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        const LanguageTogglePill(),
      ],
    );
  }

  // ===========================================================================
  // PERIOD SELECTOR
  // ===========================================================================
  Widget _buildPeriodSelector(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: QColors.warmIvorySurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: QColors.borderSubtle),
      ),
      child: Row(
        children: [
          _PeriodTab(
            label: context.trPair('Today', 'आज'),
            selected: _periodIdx == 0,
            onTap: () => setState(() => _periodIdx = 0),
          ),
          _PeriodTab(
            label: context.trPair('Week', 'सप्ताह'),
            selected: _periodIdx == 1,
            onTap: () => setState(() => _periodIdx = 1),
          ),
          _PeriodTab(
            label: context.trPair('Month', 'महीना'),
            selected: _periodIdx == 2,
            onTap: () => setState(() => _periodIdx = 2),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // 1. EARNINGS CHART
  // ===========================================================================
  Widget _buildEarningsChartCard(BuildContext context, int displayedTotal) {
    final maxAmount = _weeklyAmounts.reduce((a, b) => a > b ? a : b);

    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.trPair('Net partner earnings', 'कुल शुद्ध कमाई'),
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: QColors.inkMuted,
            ),
          ),
          const SizedBox(height: 2),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 10,
            runSpacing: 6,
            children: [
              RollingRupeeText(
                amountRupees: displayedTotal,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: QColors.inkDark,
                  letterSpacing: -0.8,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: QColors.softGreenTint,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  context.trPair('+18% vs last week', 'पिछले सप्ताह से +18%'),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: QColors.primaryGreen,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // 7-day bar chart: every column is Expanded and spring-grows upward.
          SizedBox(
            height: 140,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(_weeklyAmounts.length, (i) {
                final baseAmount = _weeklyAmounts[i];
                final scaledAmount = switch (_periodIdx) {
                  0 => i == _weeklyAmounts.length - 1
                      ? widget.todayEarningsRupees
                      : (baseAmount * 0.4).round(),
                  1 => baseAmount,
                  _ => baseAmount * 4,
                };
                final periodMax = switch (_periodIdx) {
                  0 => maxAmount,
                  1 => maxAmount,
                  _ => maxAmount * 4,
                };
                final ratio = (scaledAmount / periodMax).clamp(0.15, 1.0);
                final isToday = i == _weeklyAmounts.length - 1;
                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          _compactRupees(scaledAmount),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight:
                                isToday ? FontWeight.w900 : FontWeight.w600,
                            color: isToday
                                ? QColors.primaryGreen
                                : QColors.inkMuted,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      TweenAnimationBuilder<double>(
                        key: ValueKey('bar_${_periodIdx}_$i'),
                        tween: Tween<double>(begin: 10.0, end: 84.0 * ratio),
                        duration: Duration(milliseconds: 300 + (i * 45)),
                        curve: Curves.easeOutBack,
                        builder: (context, animH, _) {
                          return Container(
                            height: animH.clamp(8.0, 92.0),
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              color: isToday
                                  ? QColors.primaryGreen
                                  : QColors.softGreenBorder,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 6),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          context.tr(_weekDays[i]),
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight:
                                isToday ? FontWeight.w900 : FontWeight.w600,
                            color:
                                isToday ? QColors.inkDark : QColors.inkMuted,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // 2. WALLET: withdrawable balance + cash dues cap
  // ===========================================================================
  Widget _buildWalletCard(BuildContext context) {
    final dues = widget.cashDuesRupees;
    final duesRatio = (dues / _duesCapRupees).clamp(0.0, 1.0);
    final duesColor = duesRatio > 0.75 ? QColors.dangerRed : QColors.amberGold;

    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Withdrawable balance
          Text(
            context.trPair('Withdrawable balance', 'निकालने योग्य राशि'),
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: QColors.inkMuted,
            ),
          ),
          const SizedBox(height: 4),
          RollingRupeeText(
            amountRupees: _withdrawableBalance,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: QColors.primaryGreen,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _withdrawableBalance > 0 ? _instantPayout : null,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
              icon: const Icon(Icons.account_balance_rounded, size: 18),
              label: Text(
                context.trPair('Instant payout to bank', 'तुरंत बैंक में भेजें'),
              ),
            ),
          ),
          const Divider(height: 30),

          // Cash dues (cash jobs accrue platform commission owed)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  context.trPair('Cash job dues', 'नकद काम का बकाया'),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: QColors.inkDark,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${BrandConfig.currency}$dues / ${BrandConfig.currency}$_duesCapRupees',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w900,
                  color: duesColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: duesRatio,
              minHeight: 8,
              backgroundColor: QColors.warmIvorySurface,
              color: duesColor,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            context.trPair(
              'Keep dues below ${BrandConfig.currency}$_duesCapRupees to keep receiving jobs.',
              'नई बुकिंग पाते रहने के लिए बकाया ${BrandConfig.currency}$_duesCapRupees से कम रखें।',
            ),
            style: const TextStyle(
              fontSize: 12,
              color: QColors.inkMuted,
              height: 1.35,
            ),
          ),
          if (dues > 0) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: widget.onClearCashDues,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(46),
                ),
                icon: const Icon(Icons.qr_code_rounded, size: 18),
                label: Text(
                  context.trPair(
                    'Pay ${BrandConfig.currency}$dues dues (demo UPI)',
                    '${BrandConfig.currency}$dues बकाया चुकाएं (डेमो UPI)',
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _instantPayout() {
    final paid = _withdrawableBalance;
    setState(() => _withdrawableBalance = 0);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: QColors.primaryGreen,
        content: Text(
          context.trPair(
            'Instant payout of ${BrandConfig.currency}$paid sent to your bank / UPI.',
            '${BrandConfig.currency}$paid आपके बैंक / UPI खाते में भेज दिए गए।',
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // 3. PERFORMANCE & DEVICE HEALTH (2x2 grid, always fits)
  // ===========================================================================
  Widget _buildHealthCard(BuildContext context) {
    final badges = [
      _DiagnosticBadge(
        label: context.trPair('Acceptance', 'स्वीकृति दर'),
        value: '94%',
      ),
      _DiagnosticBadge(
        label: context.trPair('On-time arrival', 'समय पर आगमन'),
        value: '98%',
      ),
      _DiagnosticBadge(
        label: context.trPair('KYC', 'KYC'),
        value: context.trPair('Verified', 'सत्यापित'),
      ),
      _DiagnosticBadge(
        label: context.trPair('Battery saver', 'बैटरी सेवर'),
        value: context.trPair('Unrestricted', 'बंद (सही)'),
      ),
    ];

    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.trPair('Performance & phone health', 'प्रदर्शन और फोन स्थिति'),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: QColors.inkDark,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: badges[0]),
              const SizedBox(width: 10),
              Expanded(child: badges[1]),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: badges[2]),
              const SizedBox(width: 10),
              Expanded(child: badges[3]),
            ],
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // 4. LEDGER JOURNAL
  // ===========================================================================
  Widget _buildLedger(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.trPair('Transaction history', 'लेन-देन इतिहास'),
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w900,
            color: QColors.inkDark,
          ),
        ),
        const SizedBox(height: 10),
        ...CatalogData.sampleLedgerEntries.map(
          (entry) => _LedgerRow(entry: entry),
        ),
      ],
    );
  }
}

// =============================================================================
// BUILDING BLOCKS
// =============================================================================

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return LayeredShapeCard(
      backgroundColor: QColors.cleanWhite,
      primaryShapeColor: QColors.softGreenTint,
      secondaryShapeColor: QColors.primaryGreen,
      padding: const EdgeInsets.all(16),
      borderRadius: 18,
      border: Border.all(color: QColors.borderSubtle),
      boxShadow: QTheme.softShadow,
      child: child,
    );
  }
}

class _LedgerRow extends StatelessWidget {
  final LedgerJournalItem entry;
  const _LedgerRow({required this.entry});

  @override
  Widget build(BuildContext context) {
    final color = entry.isCredit ? QColors.primaryGreen : QColors.amberGold;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: QColors.cleanWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: QColors.borderSubtle),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: entry.isCredit
                  ? QColors.softGreenTint
                  : QColors.amberSoftBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              entry.isCredit
                  ? Icons.south_west_rounded
                  : Icons.north_east_rounded,
              size: 18,
              color: color,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr(entry.title),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: QColors.inkDark,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  context.tr(entry.subtitle),
                  style: const TextStyle(
                    fontSize: 12,
                    color: QColors.inkMuted,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: QColors.warmIvorySurface,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        context.tr(entry.tag),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: QColors.inkBody,
                        ),
                      ),
                    ),
                    Text(
                      entry.timestampLabel,
                      style: const TextStyle(
                        fontSize: 11,
                        color: QColors.inkLight,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${entry.isCredit ? '+' : '−'}${BrandConfig.currency}${entry.amountRupees}',
            style: TextStyle(
              fontSize: 15.5,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _PeriodTab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _PeriodTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          height: 38,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: selected ? QColors.primaryGreen : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: selected ? Colors.white : QColors.inkBody,
            ),
          ),
        ),
      ),
    );
  }
}

class _DiagnosticBadge extends StatelessWidget {
  final String label;
  final String value;

  const _DiagnosticBadge({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: QColors.warmIvoryBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: QColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              color: QColors.inkMuted,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: QColors.primaryGreen,
            ),
          ),
        ],
      ),
    );
  }
}
