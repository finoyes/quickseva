import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'checkout_payment_screen.dart';

/// Matches UC Screenshot #3 + Stitch Layered Shape Accents:
/// - Saved Address bar ("Home - House 416, Sector 3, Ud ... >")
/// - "Select date and time" + "Your service will take approximately..."
/// - Horizontal Date cards ("Wed 01", "Thu 02", "Fri 03") with demand arrows
/// - 3-Column Time Slot Grid ("9:30 AM", "10:00 AM", "11:30 AM +₹20", ...)
/// - Sticky bottom button: "Proceed to checkout"
class ScheduleSlotScreen extends StatefulWidget {
  final ServiceItem service;
  final ServicePackageTier selectedPackage;
  final ValueChanged<BookingOrder> onBookingCreated;

  const ScheduleSlotScreen({
    super.key,
    required this.service,
    required this.selectedPackage,
    required this.onBookingCreated,
  });

  @override
  State<ScheduleSlotScreen> createState() => _ScheduleSlotScreenState();
}

class _ScheduleSlotScreenState extends State<ScheduleSlotScreen> {
  late DateSlotItem _selectedDate;
  late TimeSlotItem _selectedTime;

  @override
  void initState() {
    super.initState();
    // Default to Fri 03 like UC Screenshot #3
    _selectedDate = CatalogData.dateSlots[2];
    _selectedTime = CatalogData.timeSlots[4]; // 11:30 AM
  }

  String _durationText(BuildContext context) {
    final mins = widget.selectedPackage.durationMinutes;
    if (mins >= 60 && mins % 60 == 0) {
      final hrs = mins ~/ 60;
      return context.trPair(
        'Your service will take approximately $hrs ${hrs == 1 ? 'hour' : 'hours'}',
        'आपकी सर्विस में लगभग $hrs घंटे लगेंगे',
      );
    }
    return context.trPair(
      'Your service will take approximately $mins mins',
      'आपकी सर्विस में लगभग $mins मिनट लगेंगे',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: QSevaColors.of(context).surface,
      appBar: AppBar(
        backgroundColor: QSevaColors.of(context).surface,
        title: Text(
          context.trPair('Schedule Slot', 'समय और तारीख चुनें'),
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: QSevaColors.of(context).ink,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: LanguageTogglePill(),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(20, 8, 20, 24),
                children: [
                  // Top Address Bar (Matches UC Screenshot #3) inside a LayeredShapeCard
                  LayeredShapeCard(
                    backgroundColor: QSevaColors.of(context).base,
                    primaryShapeColor: QSevaColors.of(context).pistachio,
                    secondaryShapeColor: QSevaColors.of(context).accentStart,
                    borderRadius: 16,
                    padding: EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                    border: Border.all(color: QSevaColors.of(context).border),
                    child: Row(
                      children: [
                        Icon(
                          Icons.home_outlined,
                          size: 21,
                          color: QSevaColors.of(context).ink,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: RichText(
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 14,
                                color: QSevaColors.of(context).ink,
                              ),
                              children: [
                                TextSpan(
                                  text:
                                      '${context.tr(BrandConfig.defaultAddressLabel)} - ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                TextSpan(
                                  text: context
                                      .tr(BrandConfig.defaultAddressLine),
                                  style: TextStyle(
                                    color: QSevaColors.of(context).inkSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Icon(
                          Icons.chevron_right_rounded,
                          size: 20,
                          color: QSevaColors.of(context).inkMuted,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 22),

                  // Title & Duration Subtitle
                  Text(
                    context.trPair(
                      'Select date and time',
                      'तारीख और समय चुनें',
                    ),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: QSevaColors.of(context).ink,
                      letterSpacing: -0.4,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    _durationText(context),
                    style: TextStyle(
                      fontSize: 14,
                      color: QSevaColors.of(context).inkMuted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 20),

                  // Horizontal Date Selector Row (Matches UC Screenshot #3)
                  SizedBox(
                    height: 84,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      clipBehavior: Clip.none,
                      itemCount: CatalogData.dateSlots.length,
                      separatorBuilder: (_, _) => SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final dateSlot = CatalogData.dateSlots[index];
                        return DateSlotCard(
                          slot: dateSlot,
                          isSelected: _selectedDate.id == dateSlot.id,
                          onTap: () => setState(() => _selectedDate = dateSlot),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 22),

                  // Dotted / Subtle Divider
                  Row(
                    children: List.generate(
                      36,
                      (i) => Expanded(
                        child: Container(
                          height: 1.2,
                          color: i.isEven
                              ? QSevaColors.of(context).border
                              : Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),

                  // 3-Column Time Slot Grid (Matches UC Screenshot #3)
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: CatalogData.timeSlots.length,
                    gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 12,
                      childAspectRatio: 2.25,
                    ),
                    itemBuilder: (context, idx) {
                      final slot = CatalogData.timeSlots[idx];
                      return TimeSlotCell(
                        slot: slot,
                        isSelected: _selectedTime.id == slot.id,
                        onTap: () => setState(() => _selectedTime = slot),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Sticky Bottom CTA ("Proceed to checkout")
            Container(
              padding: EdgeInsets.fromLTRB(20, 14, 20, 18),
              decoration: BoxDecoration(
                color: QSevaColors.of(context).surface,
                border: Border(
                  top: BorderSide(color: QSevaColors.of(context).border),
                ),
                boxShadow: QSevaColors.of(context).e1,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    final scheduleStr =
                        '${context.tr(_selectedDate.fullDateLabel)} • ${_selectedTime.label}';
                    Navigator.of(context).push(
                      SmoothPageRoute(
                        page: CheckoutPaymentScreen(
                          service: widget.service,
                          selectedPackage: widget.selectedPackage,
                          isInstant: false,
                          scheduleLabel: scheduleStr,
                          surchargeRupees: _selectedTime.peakSurchargeRupees,
                          onBookingCreated: widget.onBookingCreated,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    context.trPair(
                      'Proceed to checkout',
                      'चेकआउट पर आगे बढ़ें',
                    ),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
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
