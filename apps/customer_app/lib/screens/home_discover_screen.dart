import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'checkout_payment_screen.dart';
import 'live_tracking_screen.dart';
import 'schedule_slot_screen.dart';
import 'service_detail_screen.dart';

class CustomerMainShell extends StatefulWidget {
  const CustomerMainShell({super.key});

  @override
  State<CustomerMainShell> createState() => _CustomerMainShellState();
}

class _CustomerMainShellState extends State<CustomerMainShell> {
  int _tabIndex = 0;
  String _selectedCategoryId = 'ALL';
  String _searchQuery = '';
  bool _homeInstantToggle = true;
  int _selectedHomePkgIndex = 2; // Defaults to 1.5 hours Bestseller
  late ServiceItem _cartService;
  late ServicePackageTier _cartPackage;

  final List<BookingOrder> _bookings = [
    BookingOrder(
      id: 'BK-2841',
      service: CatalogData.services.first,
      selectedPackage: CatalogData.services.first.packages[2],
      isInstant: true,
      scheduleLabel: 'Instant • Arrives in 14 mins',
      totalAmountRupees: 89,
      paymentMode: PaymentMode.cash,
      status: BookingStatus.enRoute,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _cartService = CatalogData.services.first;
    _cartPackage = _cartService.packages[_selectedHomePkgIndex];
  }

  void _addBooking(BookingOrder order) {
    setState(() {
      _bookings.insert(0, order);
    });
  }

  void _openService(ServiceItem service, {String? heroTag}) {
    Navigator.of(context).push(
      SmoothPageRoute(
        page: ServiceDetailScreen(
          service: service,
          heroTag: heroTag,
          onBookingCreated: _addBooking,
        ),
      ),
    );
  }

  void _openDirectSchedule(ServiceItem service, ServicePackageTier pkg) {
    Navigator.of(context).push(
      SmoothPageRoute(
        page: ScheduleSlotScreen(
          service: service,
          selectedPackage: pkg,
          onBookingCreated: _addBooking,
        ),
      ),
    );
  }

  void _openDirectCheckout(ServiceItem service, ServicePackageTier pkg) {
    Navigator.of(context).push(
      SmoothPageRoute(
        page: CheckoutPaymentScreen(
          service: service,
          selectedPackage: pkg,
          isInstant: true,
          scheduleLabel: context.trPair(
            'Instant • Arrives in ${service.instantEtaMinutes} mins',
            'तुरंत • ${service.instantEtaMinutes} मिनट में आगमन',
          ),
          surchargeRupees: 0,
          onBookingCreated: _addBooking,
        ),
      ),
    );
  }

  void _openSubCategoryRateCardSheet({String initialCategoryId = 'ALL'}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _SubCategoryRateCardSheet(
        initialCategoryId: initialCategoryId,
        currentService: _cartService,
        currentPackage: _cartPackage,
        onSelectPackage: (svc, pkg) {
          setState(() {
            _cartService = svc;
            _cartPackage = pkg;
            if (svc.id == CatalogData.services.first.id) {
              final idx = svc.packages.indexWhere((p) => p.id == pkg.id);
              if (idx >= 0) _selectedHomePkgIndex = idx;
            }
          });
        },
        onInstantCheckout: (svc, pkg) {
          Navigator.of(context).pop();
          _openDirectCheckout(svc, pkg);
        },
        onOpenFullService: (svc) {
          Navigator.of(context).pop();
          _openService(svc);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: QSevaColors.of(context).base,
      body: Stack(
        children: [
          // Peach Pop pastel blob backdrop
          PastelBackdrop(),

          AnimatedSwitcher(
            duration: Duration(milliseconds: 240),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            child: KeyedSubtree(
              key: ValueKey<int>(_tabIndex),
              child: _buildCurrentTab(context),
            ),
          ),

          // Stitch-Inspired Floating Layered Cart Pill on Home Tab
          if (_tabIndex == 0)
            Positioned(
              left: 16,
              right: 16,
              bottom: 12,
              child: GlassSurface(
                borderRadius: 16,
                boxShadow: QSevaColors.of(context).e3,
                child: _buildFloatingCartPill(
                context,
                _cartService,
                _cartPackage,
              ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: GlassSurface(
        borderRadius: QRadius.xl,
        margin: EdgeInsets.fromLTRB(16, 0, 16, 10),
        padding: EdgeInsets.zero,
        boxShadow: QSevaColors.of(context).e3,
        child: QFloatingNavBar(
          selectedIndex: _tabIndex,
          onSelected: (idx) => setState(() => _tabIndex = idx),
          backgroundColor: QSevaColors.of(context).ink,
          indicatorColor: QSevaColors.of(context).accentStart,
          activeColor: QSevaColors.of(context).onAccent,
        items: [
          QNavItem(
            icon: Icons.home_outlined,
            selectedIcon: Icons.home_rounded,
            label: context.trPair('Home', 'होम'),
          ),
          QNavItem(
            icon: Icons.grid_view_outlined,
            selectedIcon: Icons.grid_view_rounded,
            label: context.trPair('Discover', 'डिस्कवर'),
          ),
          QNavItem(
            icon: Icons.receipt_long_outlined,
            selectedIcon: Icons.receipt_long_rounded,
            label: context.trPair('Bookings', 'बुकिंग्स'),
            badgeCount: _bookings.length,
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildCurrentTab(BuildContext context) {
    switch (_tabIndex) {
      case 0:
        return _buildHomeTab(context);
      case 1:
        return _buildDiscoverMasonryTab(context);
      default:
        return _buildBookingsTab(context);
    }
  }

  Widget _buildFloatingCartPill(
    BuildContext context,
    ServiceItem service,
    ServicePackageTier pkg,
  ) {
    return ElasticBounceWrapper(
      triggerKey: '${service.id}_${pkg.id}_${pkg.priceRupees}_$_homeInstantToggle',
      child: LayeredShapeCard(
        backgroundColor: QSevaColors.of(context).ink,
        primaryShapeColor: QSevaColors.of(context).ink,
        secondaryShapeColor: QSevaColors.of(context).accentStart,
        borderRadius: 16,
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        boxShadow: QSevaColors.of(context).e3,
        onTap: () {
          if (_homeInstantToggle) {
            _openDirectCheckout(service, pkg);
          } else {
            _openDirectSchedule(service, pkg);
          }
        },
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: QSevaColors.of(context).accentStart,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.shopping_bag_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          '${context.tr(service.name)} • ${context.tr(pkg.title)} • ',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      RollingRupeeText(
                        amountRupees: pkg.priceRupees,
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w900,
                          color: QSevaColors.of(context).highlight,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        _homeInstantToggle
                            ? Icons.bolt_rounded
                            : Icons.calendar_today_rounded,
                        size: 13,
                        color: QSevaColors.of(context).highlight,
                      ),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          _homeInstantToggle
                              ? context.trPair(
                                  'Express ${service.instantEtaMinutes}-min dispatch • Escrow protected',
                                  '${service.instantEtaMinutes}-मिनट एक्सप्रेस • एस्क्रो सुरक्षित',
                                )
                              : context.trPair(
                                  'Scheduled slot • Pay post job',
                                  'शेड्यूल स्लॉट • काम के बाद भुगतान',
                                ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white.withValues(alpha: 0.78),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: QSevaColors.of(context).accentStart,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                context.trPair('Checkout →', 'चेकआउट →'),
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // TAB 1: HOME SCREEN (STITCH LAYERED SHAPES + UC SCREENSHOT #1 & #2)
  // ===========================================================================
  Widget _buildHomeTab(BuildContext context) {
    final houseHelpService = CatalogData.services.first;
    final filteredServices = CatalogData.services.where((s) {
      final matchesCat =
          _selectedCategoryId == 'ALL' || s.categoryId == _selectedCategoryId;
      final q = _searchQuery.trim().toLowerCase();
      final matchesSearch = q.isEmpty ||
          s.name.en.toLowerCase().contains(q) ||
          s.name.hi.toLowerCase().contains(q) ||
          s.tagline.en.toLowerCase().contains(q);
      return matchesCat && matchesSearch;
    }).toList();

    return SafeArea(
      child: CustomScrollView(
              slivers: [
                // Top Header with Stitch Live Availability Strip, Address, Brand & EN/HI Switcher
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: QSevaColors.of(context).surface,
                border: Border(
                  bottom: BorderSide(color: QSevaColors.of(context).border),
                ),
              ),
              child: Stack(
                children: [
                  // Subtle layered geometric shape in header top-right
                  Positioned(
                    right: -28,
                    top: -32,
                    child: Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: QSevaColors.of(context).lilac.withValues(alpha: 0.45),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(18, 12, 18, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top Status Row: Live Availability Pill + Compact Active Booking Chip
                        Padding(
                          padding: EdgeInsets.only(bottom: 12),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: QSevaColors.of(context).pistachio,
                                  borderRadius: BorderRadius.circular(999),
                                  border: Border.all(
                                    color: QSevaColors.of(context).border,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    LiveStatusDot(
                                      color: QSevaColors.of(context).highlight,
                                      size: 7,
                                    ),
                                    SizedBox(width: 5),
                                    Icon(
                                      Icons.bolt_rounded,
                                      size: 13,
                                      color: QSevaColors.of(context).highlight,
                                    ),
                                    SizedBox(width: 2),
                                    Flexible(
                                      child: Text(
                                        context.trPair(
                                          '${BrandConfig.instantPromiseMinutes}-MIN EXPRESS • 42 Pros',
                                          '${BrandConfig.instantPromiseMinutes}-मिनट एक्सप्रेस • 42 प्रो',
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.w800,
                                          color: QSevaColors.of(context).highlight,
                                          letterSpacing: 0.1,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (_bookings.isNotEmpty)
                                PressableScale(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      SmoothPageRoute(
                                        page: LiveTrackingScreen(
                                          order: _bookings.first,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: QSevaColors.of(context).ink,
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.two_wheeler_rounded,
                                          size: 13,
                                          color: QSevaColors.of(context).highlight,
                                        ),
                                        SizedBox(width: 5),
                                        Flexible(
                                          child: Text(
                                            context.trPair(
                                              'OTP ${_bookings.first.startOtp} • Track →',
                                              'OTP ${_bookings.first.startOtp} • ट्रैक →',
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 10.5,
                                              fontWeight: FontWeight.w800,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),

                        // Location Row + Language Toggle Pill
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(9),
                              decoration: BoxDecoration(
                                color: QSevaColors.of(context).peachTint,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.location_on_rounded,
                                color: QSevaColors.of(context).accentStart,
                                size: 20,
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          '${BrandConfig.name(context.lang)} • ${context.tr(BrandConfig.defaultAddressLabel)}',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 13.5,
                                            fontWeight: FontWeight.w800,
                                            color: QSevaColors.of(context).ink,
                                          ),
                                        ),
                                      ),
                                      Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        size: 18,
                                        color: QSevaColors.of(context).ink,
                                      ),
                                    ],
                                  ),
                                  Text(
                                    context.tr(BrandConfig.defaultAddressLine),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: QSevaColors.of(context).inkMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            LanguageTogglePill(),
                          ],
                        ),
                        SizedBox(height: 14),

                        // Search Bar with Animated Rotating Placeholder & Voice Mic Pill
                        Stack(
                          alignment: Alignment.centerLeft,
                          children: [
                            TextField(
                              onChanged: (v) =>
                                  setState(() => _searchQuery = v),
                              decoration: InputDecoration(
                                hintText: '',
                                prefixIcon: Icon(
                                  Icons.search_rounded,
                                  color: QSevaColors.of(context).accentStart,
                                ),
                                suffixIcon: Container(
                                  margin: EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: QSevaColors.of(context).lilac,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    Icons.mic_none_rounded,
                                    size: 18,
                                    color: QSevaColors.of(context).purpleAccent,
                                  ),
                                ),
                                filled: true,
                                fillColor: QSevaColors.of(context).base,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(
                                    color: QSevaColors.of(context).border,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(
                                    color: QSevaColors.of(context).accentStart,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),
                            if (_searchQuery.isEmpty)
                              Positioned(
                                left: 46,
                                right: 52,
                                child: IgnorePointer(
                                  child: RotatingHintText(
                                    prefix: context.trPair(
                                      'Search ',
                                      'खोजें: ',
                                    ),
                                    hints: context.lang == AppLanguage.hi
                                        ? const [
                                            '"14 मिनट में हाउस हेल्प"',
                                            '"प्लम्बर और नल रिपेयर"',
                                            '"AC फोम-जेट सर्विस"',
                                            '"सैलून और ब्यूटी पार्लर"',
                                            '"इलेक्ट्रीशियन और MCB"',
                                          ]
                                        : const [
                                            '"House help in 14 mins"',
                                            '"Plumber & tap repair"',
                                            '"AC foam-jet service"',
                                            '"Salon & facial at home"',
                                            '"Electrician & MCB fix"',
                                          ],
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: QSevaColors.of(context).inkMuted,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    highlightStyle: TextStyle(
                                      fontSize: 13,
                                      color: QSevaColors.of(context).inkMuted,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // =================================================================
          // AUTO-ADVANCING PROMO CAROUSEL (TURBO + SUPER SAVER + ESCROW)
          // =================================================================
          SliverToBoxAdapter(
            child: StaggeredEntrance(
              index: 0,
              child: Padding(
              padding: EdgeInsets.only(top: 14, bottom: 4),
              child: PromoCarousel(
                height: 174,
                slides: [
                  // Slide 1: Turbo 14-Min Express Hero
                  LayeredShapeCard(
                    backgroundColor: QSevaColors.of(context).ink,
                    primaryShapeColor: QSevaColors.of(context).ink,
                    secondaryShapeColor: QSevaColors.of(context).warning,
                    borderRadius: 20,
                    padding: EdgeInsets.all(16),
                    boxShadow: QSevaColors.of(context).e3,
                    onTap: () => _openService(
                      houseHelpService,
                      heroTag: 'turbo-hero-${houseHelpService.id}',
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 9,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: QSevaColors.of(context).warning,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.bolt_rounded,
                                    size: 12,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 3),
                                  Flexible(
                                    child: Text(
                                      context.trPair(
                                        'TURBO • AVG ${BrandConfig.instantPromiseMinutes} MINS',
                                        'टर्बो • औसत ${BrandConfig.instantPromiseMinutes} मिनट',
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 9,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                context.trPair(
                                  'Zero Surge • Fixed Fare',
                                  'जीरो सर्ज • फिक्स रेट',
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    context.trPair(
                                      'Need Help in ${BrandConfig.instantPromiseMinutes} Mins?',
                                      'क्या ${BrandConfig.instantPromiseMinutes} मिनट में मदद चाहिए?',
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 18.5,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                      height: 1.15,
                                      letterSpacing: -0.4,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    context.trPair(
                                      'Instant House Help, Plumber, Electrician & AC Pros.',
                                      'तुरंत हाउस हेल्प, प्लम्बर, इलेक्ट्रीशियन और AC प्रो।',
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white.withValues(alpha: 0.8),
                                      height: 1.25,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 10),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 9,
                              ),
                              decoration: BoxDecoration(
                                color: QSevaColors.of(context).accentStart,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                context.trPair(
                                  'From ₹49 →',
                                  '₹49 से →',
                                ),
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Slide 2: Super Saver 3-Visits Pack (Pastel Purple Promo Highlight)
                  LayeredShapeCard(
                    backgroundColor: QSevaColors.of(context).lilac,
                    primaryShapeColor: QSevaColors.of(context).surface,
                    secondaryShapeColor: QSevaColors.of(context).purpleAccent,
                    borderRadius: 20,
                    padding: EdgeInsets.all(16),
                    border: Border.all(
                      color: QSevaColors.of(context).purpleAccent.withValues(alpha: 0.18),
                    ),
                    boxShadow: QSevaColors.of(context).e2,
                    onTap: () => _openService(houseHelpService),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: QSevaColors.of(context).purpleAccent,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.local_offer_rounded,
                                size: 11,
                                color: Colors.white,
                              ),
                              SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  context.trPair(
                                    'SUPER SAVER • EXTRA 85% OFF',
                                    'सुपर सेवर • 85% छूट',
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    context.trPair(
                                      '3-Visits Pack at ₹33/visit',
                                      '3-विज़िट पैक सिर्फ ₹33/विज़िट',
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 18.5,
                                      fontWeight: FontWeight.w900,
                                      color: QSevaColors.of(context).ink,
                                      letterSpacing: -0.4,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    context.trPair(
                                      'Valid 30 days • Sweeping, mopping, dishes & bathroom.',
                                      '30 दिन वैध • झाड़ू-पोछा, बर्तन और सफाई।',
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: QSevaColors.of(context).inkSecondary,
                                      height: 1.25,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 10),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 9,
                              ),
                              decoration: BoxDecoration(
                                color: QSevaColors.of(context).ink,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                context.trPair('Claim →', 'लें →'),
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Slide 3: QuickSeva Escrow & Safety Shield
                  LayeredShapeCard(
                    backgroundColor: QSevaColors.of(context).ink,
                    primaryShapeColor: QSevaColors.of(context).ink,
                    secondaryShapeColor: QSevaColors.of(context).highlight,
                    borderRadius: 20,
                    padding: EdgeInsets.all(16),
                    boxShadow: QSevaColors.of(context).e3,
                    onTap: () => _openSubCategoryRateCardSheet(
                      initialCategoryId: 'cat_repairs',
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: QSevaColors.of(context).highlight,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.verified_user_rounded,
                                size: 12,
                                color: Colors.white,
                              ),
                              SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  context.trPair(
                                    '100% ESCROW PROTECTED',
                                    '100% एस्क्रो सुरक्षित',
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    context.trPair(
                                      'Pay Only After 4-Digit OTP',
                                      '4-अंकीय OTP के बाद ही भुगतान',
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                      letterSpacing: -0.4,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    context.trPair(
                                      'Police-verified pros • Fixed spare-parts tariff card.',
                                      'पुलिस वेरिफाइड प्रो • फिक्स स्पेयर-पार्ट्स रेट कार्ड।',
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white.withValues(alpha: 0.82),
                                      height: 1.25,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 10),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 9,
                              ),
                              decoration: BoxDecoration(
                                color: QSevaColors.of(context).highlight,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                context.trPair('Tariff →', 'रेट कार्ड →'),
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ),
          ),

          // =================================================================
          // SECTION A: UC SCREENSHOT #1 SPOTLIGHT
          // "House help by QuickSeva, cleaning & more"
          // =================================================================
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.fromLTRB(18, 14, 18, 8),
              decoration: BoxDecoration(
                color: QSevaColors.of(context).surface,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: QSevaColors.of(context).border),
                boxShadow: QSevaColors.of(context).e1,
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  // Layered geometric shape accents on the card backdrop
                  Positioned(
                    right: -36,
                    top: -36,
                    child: Container(
                      width: 128,
                      height: 128,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: QSevaColors.of(context).rose.withValues(alpha: 0.55),
                      ),
                    ),
                  ),
                  Positioned(
                    left: -24,
                    bottom: 60,
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: QSevaColors.of(context).surfaceSunken.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                context.trPair(
                                  'House help by ${BrandConfig.brandName},\ncleaning & more',
                                  '${BrandConfig.brandNameHindi} द्वारा हाउस हेल्प,\nसफाई और बहुत कुछ',
                                ),
                                style: TextStyle(
                                  fontSize: 21,
                                  fontWeight: FontWeight.w900,
                                  color: QSevaColors.of(context).ink,
                                  height: 1.18,
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () => _openService(houseHelpService),
                              icon: Icon(
                                Icons.open_in_full_rounded,
                                size: 15,
                              ),
                              label: Text(
                                context.trPair('Full View', 'पूरा देखें'),
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 14),

                        // "⚡ In 14 mins" vs "Later" Toggle
                        InstantLaterSegmentedControl(
                          isInstant: _homeInstantToggle,
                          instantMinutes: BrandConfig.instantPromiseMinutes,
                          onChanged: (val) {
                            setState(() => _homeInstantToggle = val);
                            if (!val) {
                              _openDirectSchedule(
                                houseHelpService,
                                houseHelpService
                                    .packages[_selectedHomePkgIndex],
                              );
                            }
                          },
                        ),
                        SizedBox(height: 16),

                        // Horizontal Package Cards (45 mins ₹49, 1 hour ₹59, 1.5 hours ₹89 Bestseller)
                        SizedBox(
                          height: 186,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: houseHelpService.packages.length,
                            separatorBuilder: (_, _) =>
                                SizedBox(width: 12),
                            itemBuilder: (context, idx) {
                              final tier = houseHelpService.packages[idx];
                              return PackageDurationCard(
                                tier: tier,
                                isSelected: _selectedHomePkgIndex == idx,
                                onBookTap: () {
                                  setState(() {
                                    _selectedHomePkgIndex = idx;
                                    _cartService = houseHelpService;
                                    _cartPackage = tier;
                                  });
                                  if (_homeInstantToggle) {
                                    _openService(houseHelpService);
                                  } else {
                                    _openDirectSchedule(houseHelpService, tier);
                                  }
                                },
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 18),

                        // Super Saver Pack Banner ("3-visits pack at ₹225 -> ₹33/visit")
                        if (houseHelpService.superSaverPack != null)
                          SuperSaverPackBanner(
                            pack: houseHelpService.superSaverPack!,
                            onBookTap: () => _openService(houseHelpService),
                          ),
                        SizedBox(height: 16),

                        // "One help who can do it all" strip
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                context.trPair(
                                  'One help who can do it all',
                                  'एक हेल्पर जो सभी काम निपटाए',
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: QSevaColors.of(context).ink,
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            GestureDetector(
                              onTap: () => _openService(houseHelpService),
                              child: Text(
                                context.trPair('See all →', 'सभी देखें →'),
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                  color: QSevaColors.of(context).accentStart,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // =================================================================
          // STITCH 2×2 ESSENTIAL SERVICES BENTO GRID + INTERACTIVE RATE CARD
          // =================================================================
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(18, 12, 18, 4),
              child: _buildStitchEssentialBentoGrid(context),
            ),
          ),

          // =================================================================
          // SECTION B: 7 SERVICE CATEGORIES GRID
          // =================================================================
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(18, 16, 18, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          context.trPair(
                            'Explore All Categories',
                            'सभी श्रेणियां देखें',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w900,
                            color: QSevaColors.of(context).ink,
                            letterSpacing: -0.4,
                          ),
                        ),
                      ),
                      if (_selectedCategoryId != 'ALL')
                        TextButton(
                          onPressed: () =>
                              setState(() => _selectedCategoryId = 'ALL'),
                          child: Text(
                            context.trPair('Show All', 'सभी दिखाएं'),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 12),
                  SizedBox(
                    height: 108,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: CatalogData.categories.length,
                      separatorBuilder: (_, _) => SizedBox(width: 10),
                      itemBuilder: (context, idx) {
                        final cat = CatalogData.categories[idx];
                        final isSelected = _selectedCategoryId == cat.id;
                        return PressableScale(
                          onTap: () {
                            setState(() {
                              _selectedCategoryId =
                                  isSelected ? 'ALL' : cat.id;
                            });
                          },
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 200),
                            curve: Curves.easeOutCubic,
                            width: 106,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? QSevaColors.of(context).peachTint
                                  : QSevaColors.of(context).surface,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected
                                    ? QSevaColors.of(context).accentStart
                                    : QSevaColors.of(context).border,
                                width: isSelected ? 1.8 : 1.0,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(9),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? QSevaColors.of(context).accentStart
                                            : QSevaColors.of(context).supportColor(idx),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        cat.icon,
                                        size: 22,
                                        color: isSelected
                                            ? Colors.white
                                            : QSevaColors.of(context).supportForeground(idx),
                                      ),
                                    ),
                                    if (cat.badgeText != null)
                                      Positioned(
                                        top: -6,
                                        right: -18,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 5,
                                            vertical: 1.5,
                                          ),
                                          decoration: BoxDecoration(
                                            color: QSevaColors.of(context).purpleAccent,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            context.tr(cat.badgeText!),
                                            style: TextStyle(
                                              fontSize: 8.5,
                                              fontWeight: FontWeight.w800,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Text(
                                  context.tr(cat.name),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: isSelected
                                        ? FontWeight.w800
                                        : FontWeight.w700,
                                    color: QSevaColors.of(context).ink,
                                    height: 1.15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // =================================================================
          // SECTION C: DISCOVER MASONRY GRID (MATCHES UC SCREENSHOT #2)
          // =================================================================
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(18, 12, 18, 10),
              child: _buildMasonrySection(context),
            ),
          ),

          // =================================================================
          // STITCH ESCROW & SAFETY SHIELD BANNER
          // =================================================================
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(18, 8, 18, 8),
              child: _buildEscrowShieldCard(context),
            ),
          ),

          // =================================================================
          // SECTION D: COMPLETE ALL-SERVICES DIRECTORY
          // =================================================================
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(18, 16, 18, 10),
              child: Text(
                context.trPair(
                  'All Services & Express Packages (${filteredServices.length})',
                  'सभी सेवाएं और पैकेज (${filteredServices.length})',
                ),
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                  color: QSevaColors.of(context).ink,
                  letterSpacing: -0.4,
                ),
              ),
            ),
          ),

          SliverPadding(
            // Extra bottom padding so the floating cart bar never covers the last card
            padding: EdgeInsets.fromLTRB(18, 0, 18, 96),
            sliver: SliverList.separated(
              itemCount: filteredServices.length,
              separatorBuilder: (_, _) => SizedBox(height: 12),
              itemBuilder: (context, index) {
                final s = filteredServices[index];
                final heroTag = 'list-svc-${s.id}';
                return ScrollDepthCard(
                  index: index,
                  child: _ServiceListRowCard(
                    service: s,
                    heroTag: heroTag,
                    onTap: () => _openService(s, heroTag: heroTag),
                    onQuickSheetTap: () => _openSubCategoryRateCardSheet(
                      initialCategoryId: s.categoryId,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // STITCH 2×2 ESSENTIAL SERVICES BENTO GRID (LAYERED SHAPES + QUICK RATE CARD)
  // ===========================================================================
  Widget _buildStitchEssentialBentoGrid(BuildContext context) {
    final essentials = [
      (
        serviceId: 'svc_plumber_repair',
        categoryId: 'cat_repairs',
        title: Tr('Plumber', 'प्लम्बर'),
        subtitle:
            Tr('प्लम्बर • Tap, Pipe, Flush', 'नल, पाइप और फ्लश रिपेयर'),
        badge: Tr('Fast 14m', 'तेज़ 14m'),
        icon: Icons.plumbing_rounded,
        iconBg: QSevaColors.of(context).lilac,
        iconColor: QSevaColors.of(context).purpleAccent,
      ),
      (
        serviceId: 'svc_electrician_repair',
        categoryId: 'cat_repairs',
        title: Tr('Electrician', 'इलेक्ट्रीशियन'),
        subtitle:
            Tr('इलेक्ट्रीशियन • Fan, MCB, Wiring', 'पंखा, MCB, वायरिंग'),
        badge: Tr('Top Pick', 'टॉप पिक'),
        icon: Icons.electrical_services_rounded,
        iconBg: QSevaColors.of(context).peachTint,
        iconColor: QSevaColors.of(context).accentStart,
      ),
      (
        serviceId: 'svc_ac_foam_jet',
        categoryId: 'cat_ac_appliance',
        title: Tr('AC & Appliance', 'AC और उपकरण'),
        subtitle:
            Tr('एसी रिपेयर • Foam-Jet, Gas', 'फोम-जेट सर्विस, कूलिंग'),
        badge: Tr('30-day War.', '30-दिन वारंटी'),
        icon: Icons.ac_unit_rounded,
        iconBg: QSevaColors.of(context).pistachio,
        iconColor: QSevaColors.of(context).highlight,
      ),
      (
        serviceId: 'svc_carpenter_work',
        categoryId: 'cat_repairs',
        title: Tr('Carpenter', 'बढ़ई (कारपेंटर)'),
        subtitle:
            Tr('बढ़ई • Locks, Door & Wood', 'ताला, दरवाज़ा और फर्नीचर'),
        badge: Tr('Fixed Rate', 'फिक्स रेट'),
        icon: Icons.handyman_rounded,
        iconBg: QSevaColors.of(context).lilac,
        iconColor: QSevaColors.of(context).purpleAccent,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                context.trPair(
                  'Essential Home Repairs',
                  'ज़रूरी घरेलू रिपेयर सेवाएं',
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                  color: QSevaColors.of(context).ink,
                  letterSpacing: -0.4,
                ),
              ),
            ),
            SizedBox(width: 6),
            PressableScale(
              key: ValueKey('open-rate-card-sheet'),
              onTap: () => _openSubCategoryRateCardSheet(
                initialCategoryId: 'cat_repairs',
              ),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: QSevaColors.of(context).ink,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.receipt_long_rounded,
                      size: 13,
                      color: Colors.white,
                    ),
                    SizedBox(width: 4),
                    Text(
                      context.trPair('Rate Card +', 'रेट कार्ड +'),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _EssentialBentoTile(
                data: essentials[0],
                onTap: () => _openService(
                  CatalogData.serviceById(essentials[0].serviceId),
                ),
                onQuickRateTap: () => _openSubCategoryRateCardSheet(
                  initialCategoryId: essentials[0].categoryId,
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _EssentialBentoTile(
                data: essentials[1],
                onTap: () => _openService(
                  CatalogData.serviceById(essentials[1].serviceId),
                ),
                onQuickRateTap: () => _openSubCategoryRateCardSheet(
                  initialCategoryId: essentials[1].categoryId,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _EssentialBentoTile(
                data: essentials[2],
                onTap: () => _openService(
                  CatalogData.serviceById(essentials[2].serviceId),
                ),
                onQuickRateTap: () => _openSubCategoryRateCardSheet(
                  initialCategoryId: essentials[2].categoryId,
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _EssentialBentoTile(
                data: essentials[3],
                onTap: () => _openService(
                  CatalogData.serviceById(essentials[3].serviceId),
                ),
                onQuickRateTap: () => _openSubCategoryRateCardSheet(
                  initialCategoryId: essentials[3].categoryId,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ===========================================================================
  // STITCH ESCROW & SAFETY SHIELD CARD
  // ===========================================================================
  Widget _buildEscrowShieldCard(BuildContext context) {
    return LayeredShapeCard(
      backgroundColor: QSevaColors.of(context).surface,
      primaryShapeColor: QSevaColors.of(context).pistachio,
      secondaryShapeColor: QSevaColors.of(context).accentStart,
      borderRadius: 18,
      padding: EdgeInsets.all(16),
      border: Border.all(color: QSevaColors.of(context).border, width: 1.2),
      boxShadow: QSevaColors.of(context).e1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: QSevaColors.of(context).pistachio,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.verified_user_rounded,
                  color: QSevaColors.of(context).highlight,
                  size: 18,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.trPair(
                        '${BrandConfig.brandName} Escrow Shield • 100% Safe',
                        '${BrandConfig.brandNameHindi} एस्क्रो शील्ड • 100% सुरक्षित',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: QSevaColors.of(context).ink,
                      ),
                    ),
                    Text(
                      context.trPair(
                        'Pay only after the job is verified with your 4-digit OTP',
                        '4-अंकीय OTP से काम पूरा होने के बाद ही भुगतान करें',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11.5,
                        color: QSevaColors.of(context).inkMuted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          QMarquee(
            height: 30,
            pixelsPerSecond: 24,
            gap: 8,
            children: [
              _TrustPill(
                icon: Icons.account_balance_wallet_outlined,
                label: context.trPair('Zero Upfront Cash', 'जीरो एडवांस नकद'),
              ),
              _TrustPill(
                icon: Icons.badge_outlined,
                label: context.trPair('Police Verified', 'पुलिस वेरिफाइड'),
              ),
              _TrustPill(
                icon: Icons.replay_circle_filled_outlined,
                label:
                    context.trPair('7-Day Free Re-work', '7-दिन फ्री री-वर्क'),
              ),
              _TrustPill(
                icon: Icons.receipt_long_outlined,
                label: context.trPair('Fixed Spare Tariff', 'फिक्स स्पेयर रेट'),
              ),
              _TrustPill(
                icon: Icons.bolt_rounded,
                label: context.trPair('14-Min Express', '14-मिनट एक्सप्रेस'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // MASONRY SECTION (MATCHES UC SCREENSHOT #2: "Discover")
  // ===========================================================================
  Widget _buildMasonrySection(BuildContext context, {String prefix = 'home'}) {
    final leftCards = <DiscoveryCardItem>[];
    final rightCards = <DiscoveryCardItem>[];
    for (int i = 0; i < CatalogData.discoveryCards.length; i++) {
      if (i.isEven) {
        leftCards.add(CatalogData.discoveryCards[i]);
      } else {
        rightCards.add(CatalogData.discoveryCards[i]);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.trPair('Discover', 'डिस्कवर'),
          style: QText.displayM.copyWith(
            color: QSevaColors.of(context).ink,
          ),
        ),
        SizedBox(height: 4),
        Text(
          context.trPair(
            'Choose from services for you and your home',
            'अपने और अपने घर के लिए बेहतरीन सेवाएं चुनें',
          ),
          style: TextStyle(
            fontSize: 14.5,
            color: QSevaColors.of(context).inkMuted,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Column
            Expanded(
              child: Column(
                children: List.generate(leftCards.length, (i) {
                  final card = leftCards[i];
                  final heroTag = '$prefix-masonry-${card.id}';
                  return Padding(
                    padding: EdgeInsets.only(bottom: 14),
                    child: ScrollDepthCard(
                      index: i * 2,
                      child: MasonryDiscoveryCard(
                        item: card,
                        heroTag: heroTag,
                        imageHeight: i.isEven ? 168 : 194,
                        onTap: () => _openService(
                          CatalogData.serviceById(card.serviceId),
                          heroTag: heroTag,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            SizedBox(width: 14),
            // Right Column (staggered top offset like UC Screenshot #2!)
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 26),
                child: Column(
                  children: List.generate(rightCards.length, (i) {
                    final card = rightCards[i];
                    final heroTag = '$prefix-masonry-${card.id}';
                    return Padding(
                      padding: EdgeInsets.only(bottom: 14),
                      child: ScrollDepthCard(
                        index: (i * 2) + 1,
                        child: MasonryDiscoveryCard(
                          item: card,
                          heroTag: heroTag,
                          imageHeight: i.isEven ? 186 : 162,
                          onTap: () => _openService(
                            CatalogData.serviceById(card.serviceId),
                            heroTag: heroTag,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ===========================================================================
  // TAB 2: DEDICATED DISCOVER FULL PAGE
  // ===========================================================================
  Widget _buildDiscoverMasonryTab(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: EdgeInsets.all(18),
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: LanguageTogglePill(),
          ),
          _buildMasonrySection(context, prefix: 'discover-tab'),
        ],
      ),
    );
  }

  // ===========================================================================
  // TAB 3: MY BOOKINGS TAB
  // ===========================================================================
  Widget _buildBookingsTab(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: EdgeInsets.all(18),
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  context.trPair('My Bookings', 'मेरी बुकिंग्स'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: QText.titleL.copyWith(
                    color: QSevaColors.of(context).ink,
                  ),
                ),
              ),
              SizedBox(width: 8),
              LanguageTogglePill(),
            ],
          ),
          SizedBox(height: 16),
          ..._bookings.map((b) {
            return LayeredShapeCard(
              margin: EdgeInsets.only(bottom: 14),
              padding: EdgeInsets.all(16),
              backgroundColor: QSevaColors.of(context).surface,
              primaryShapeColor: QSevaColors.of(context).pistachio,
              secondaryShapeColor: QSevaColors.of(context).accentStart,
              borderRadius: 16,
              border: Border.all(color: QSevaColors.of(context).border),
              boxShadow: QSevaColors.of(context).e1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: QSevaColors.of(context).pistachio,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '#${b.id} • ${b.status.name.toUpperCase()}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: QSevaColors.of(context).accentStart,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        '${BrandConfig.currency}${b.totalAmountRupees}',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                          color: QSevaColors.of(context).ink,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    context.tr(b.service.name),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: QSevaColors.of(context).ink,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${context.tr(b.selectedPackage.title)} • ${b.scheduleLabel}',
                    style: TextStyle(
                      fontSize: 13,
                      color: QSevaColors.of(context).inkMuted,
                    ),
                  ),
                  SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          SmoothPageRoute(
                            page: LiveTrackingScreen(order: b),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.location_searching_rounded,
                            size: 17,
                          ),
                          SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              context.trPair(
                                'Open Live Tracker & Start OTP (${b.startOtp})',
                                'लाइव ट्रैकर और OTP (${b.startOtp}) देखें',
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _EssentialBentoTile extends StatelessWidget {
  final ({
    String serviceId,
    String categoryId,
    Tr title,
    Tr subtitle,
    Tr badge,
    IconData icon,
    Color iconBg,
    Color iconColor,
  }) data;
  final VoidCallback onTap;
  final VoidCallback onQuickRateTap;

  const _EssentialBentoTile({
    required this.data,
    required this.onTap,
    required this.onQuickRateTap,
  });

  @override
  Widget build(BuildContext context) {
    return ScrollDepthCard(
      index: data.serviceId.hashCode.abs() % 4,
      parallaxStrength: 2.5,
      child: LayeredShapeCard(
        backgroundColor: QSevaColors.of(context).surface,
        primaryShapeColor: data.iconBg.withValues(alpha: 0.72),
        secondaryShapeColor: data.iconColor,
        borderRadius: 18,
        padding: EdgeInsets.all(13),
        border: Border.all(color: QSevaColors.of(context).border),
        boxShadow: QSevaColors.of(context).e1,
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: data.iconBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    data.icon,
                    size: 20,
                    color: data.iconColor,
                  ),
                ),
                SizedBox(width: 4),
                Flexible(
                  child: GestureDetector(
                    onTap: onQuickRateTap,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: QSevaColors.of(context).surfaceSunken,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        context.tr(data.badge),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w800,
                          color: QSevaColors.of(context).ink,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              context.tr(data.title),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w900,
                color: QSevaColors.of(context).ink,
                letterSpacing: -0.2,
              ),
            ),
            SizedBox(height: 2),
            Text(
              context.tr(data.subtitle),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                color: QSevaColors.of(context).inkMuted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrustPill extends StatelessWidget {
  final IconData icon;
  final String label;

  const _TrustPill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: QSevaColors.of(context).base,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: QSevaColors.of(context).border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: QSevaColors.of(context).accentStart),
          SizedBox(width: 5),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: QSevaColors.of(context).inkSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceListRowCard extends StatelessWidget {
  final ServiceItem service;
  final String heroTag;
  final VoidCallback onTap;
  final VoidCallback onQuickSheetTap;

  const _ServiceListRowCard({
    required this.service,
    required this.heroTag,
    required this.onTap,
    required this.onQuickSheetTap,
  });

  @override
  Widget build(BuildContext context) {
    return PressableScale(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: QSevaColors.of(context).surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: QSevaColors.of(context).border),
          boxShadow: QSevaColors.of(context).e1,
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned(
              right: -24,
              bottom: -24,
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: QSevaColors.of(context).pistachio.withValues(alpha: 0.6),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: heroTag,
                    child: QNetworkImage(
                      url: service.imageUrl,
                      width: 88,
                      height: 88,
                      radius: 12,
                    ),
                  ),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (service.supportsInstant)
                          Container(
                            margin: EdgeInsets.only(bottom: 5),
                            padding: EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: QSevaColors.of(context).peachTint,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.bolt_rounded,
                                  size: 12,
                                  color: QSevaColors.of(context).accentStart,
                                ),
                                SizedBox(width: 2),
                                Text(
                                  context.trPair(
                                    'In ${service.instantEtaMinutes} mins',
                                    '${service.instantEtaMinutes} मिनट में',
                                  ),
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w800,
                                    color: QSevaColors.of(context).accentStart,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        Text(
                          context.tr(service.name),
                          style: TextStyle(
                            fontSize: 15.5,
                            fontWeight: FontWeight.w800,
                            color: QSevaColors.of(context).ink,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          context.tr(service.tagline),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: QSevaColors.of(context).inkMuted,
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 5,
                                children: [
                                  Text(
                                    '${BrandConfig.currency}${service.startingPriceRupees}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                      color: QSevaColors.of(context).ink,
                                    ),
                                  ),
                                  Text(
                                    '${BrandConfig.currency}${service.originalStartingPriceRupees}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: QSevaColors.of(context).inkMuted,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 8),
                            SizedBox(
                              height: 34,
                              child: OutlinedButton(
                                onPressed: onTap,
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: QSevaColors.of(context).surface,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                ),
                                child: Text(
                                  context.trPair('Book', 'बुक करें'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
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

/// ============================================================================
/// UC-STYLE INTERACTIVE SUB-CATEGORY & FIXED RATE-CARD BOTTOM SHEET
/// Allows quick package switching & spare-part rate inspection without leaving Home
/// ============================================================================
class _SubCategoryRateCardSheet extends StatefulWidget {
  final String initialCategoryId;
  final ServiceItem currentService;
  final ServicePackageTier currentPackage;
  final void Function(ServiceItem service, ServicePackageTier pkg)
      onSelectPackage;
  final void Function(ServiceItem service, ServicePackageTier pkg)
      onInstantCheckout;
  final ValueChanged<ServiceItem> onOpenFullService;

  const _SubCategoryRateCardSheet({
    required this.initialCategoryId,
    required this.currentService,
    required this.currentPackage,
    required this.onSelectPackage,
    required this.onInstantCheckout,
    required this.onOpenFullService,
  });

  @override
  State<_SubCategoryRateCardSheet> createState() =>
      _SubCategoryRateCardSheetState();
}

class _SubCategoryRateCardSheetState extends State<_SubCategoryRateCardSheet> {
  late String _activeCatId;
  late ServiceItem _selectedService;
  late ServicePackageTier _selectedPackage;

  static final List<({Tr name, int priceRupees, Tr warranty})> _sparePartRates =
      [
    (
      name: Tr('ISI Brass Tap Spindle / Washer', 'ISI ब्रास नल स्पिंडल / वॉशर'),
      priceRupees: 49,
      warranty: Tr('30-day warranty', '30-दिन वारंटी'),
    ),
    (
      name: Tr('Anchor / Havells 16A Switch & Socket', '16A स्विच और सॉकेट रिप्लेसमेंट'),
      priceRupees: 89,
      warranty: Tr('Fixed spare rate', 'फिक्स स्पेयर रेट'),
    ),
    (
      name: Tr('Heavy-Duty PVC Drain / Flush Pipe', 'हेवी-ड्यूटी PVC ड्रेन / फ्लश पाइप'),
      priceRupees: 119,
      warranty: Tr('Zero extra labor', 'कोई अतिरिक्त लेबर नहीं'),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _activeCatId = widget.initialCategoryId;
    _selectedService = widget.currentService;
    _selectedPackage = widget.currentPackage;
  }

  @override
  Widget build(BuildContext context) {
    final servicesInCat = _activeCatId == 'ALL'
        ? CatalogData.services
        : CatalogData.servicesByCategory(_activeCatId);

    return SafeArea(
      top: false,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.82,
        ),
        margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
        decoration: BoxDecoration(
          color: QSevaColors.of(context).base,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: QSevaColors.of(context).border, width: 1.5),
          boxShadow: QSevaColors.of(context).e3,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Layered Deep Slate Header
            LayeredShapeCard(
              backgroundColor: QSevaColors.of(context).ink,
              primaryShapeColor: QSevaColors.of(context).ink,
              secondaryShapeColor: QSevaColors.of(context).accentStart,
              borderRadius: 0,
              padding: EdgeInsets.fromLTRB(18, 16, 18, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: QSevaColors.of(context).warning,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          context.trPair(
                            'FIXED RATE CARD',
                            'फिक्स रेट कार्ड',
                          ),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    context.trPair(
                      'Quick Add Sub-Services & Standard Tariff',
                      'सब-सर्विसेज और फिक्स रेट कार्ड',
                    ),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    context.trPair(
                      'Select any package directly into your cart with zero hidden charges.',
                      'बिना किसी छुपे शुल्क के सीधे अपने कार्ट में पैकेज जोड़ें।',
                    ),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),

            // Category Filter Chips
            Container(
              height: 50,
              color: QSevaColors.of(context).surface,
              child: ListView.separated(
                padding:
                    EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                scrollDirection: Axis.horizontal,
                itemCount: CatalogData.categories.length,
                separatorBuilder: (_, _) => SizedBox(width: 8),
                itemBuilder: (context, idx) {
                  final cat = CatalogData.categories[idx];
                  final active = _activeCatId == cat.id;
                  return ChoiceChip(
                    label: Text(context.tr(cat.name)),
                    selected: active,
                    selectedColor: QSevaColors.of(context).pistachio,
                    backgroundColor: QSevaColors.of(context).base,
                    labelStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: active ? FontWeight.w800 : FontWeight.w600,
                      color: active ? QSevaColors.of(context).accentStart : QSevaColors.of(context).inkSecondary,
                    ),
                    onSelected: (_) => setState(() => _activeCatId = cat.id),
                  );
                },
              ),
            ),

            // Sub-Services & Packages List
            Flexible(
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.all(16),
                children: [
                  ...servicesInCat.map((svc) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 12),
                      padding: EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: QSevaColors.of(context).surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: QSevaColors.of(context).border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  context.tr(svc.name),
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w900,
                                    color: QSevaColors.of(context).ink,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () =>
                                    widget.onOpenFullService(svc),
                                child: Text(
                                  context.trPair('Details →', 'विवरण →'),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          ...svc.packages.map((pkg) {
                            final isSelected = _selectedService.id == svc.id &&
                                _selectedPackage.id == pkg.id;
                            return Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          context.tr(pkg.title),
                                          style: TextStyle(
                                            fontSize: 13.5,
                                            fontWeight: FontWeight.w700,
                                            color: QSevaColors.of(context).inkSecondary,
                                          ),
                                        ),
                                        Text(
                                          '${BrandConfig.currency}${pkg.priceRupees} (${pkg.discountPercent}% OFF)',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w800,
                                            color: QSevaColors.of(context).accentStart,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  OutlinedButton(
                                    onPressed: () {
                                      setState(() {
                                        _selectedService = svc;
                                        _selectedPackage = pkg;
                                      });
                                      widget.onSelectPackage(svc, pkg);
                                    },
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: isSelected
                                          ? QSevaColors.of(context).accentStart
                                          : QSevaColors.of(context).surface,
                                      foregroundColor: isSelected
                                          ? Colors.white
                                          : QSevaColors.of(context).accentStart,
                                      minimumSize: Size(82, 34),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                    ),
                                    child: Text(
                                      isSelected
                                          ? context.trPair('Added ✓', 'जुड़ गया ✓')
                                          : context.trPair('Add +', 'जोड़ें +'),
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    );
                  }),

                  // Standard Spare Parts Rate Card Reference
                  Container(
                    padding: EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: QSevaColors.of(context).surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: QSevaColors.of(context).border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.trPair(
                            'Standard Spare Parts Tariff (If Needed)',
                            'मानक स्पेयर पार्ट्स रेट कार्ड (यदि आवश्यक हो)',
                          ),
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w900,
                            color: QSevaColors.of(context).accentEnd,
                          ),
                        ),
                        SizedBox(height: 8),
                        ..._sparePartRates.map((item) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '${context.tr(item.name)} (${context.tr(item.warranty)})',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: QSevaColors.of(context).inkSecondary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  '${BrandConfig.currency}${item.priceRupees}',
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w900,
                                    color: QSevaColors.of(context).ink,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Sticky Sheet Footer with Rolling Rupee Counter & Elastic Bounce
            ElasticBounceWrapper(
              triggerKey:
                  '${_selectedService.id}_${_selectedPackage.id}_${_selectedPackage.priceRupees}',
              child: Container(
                padding: EdgeInsets.fromLTRB(16, 12, 16, 14),
                decoration: BoxDecoration(
                  color: QSevaColors.of(context).surface,
                  border: Border(top: BorderSide(color: QSevaColors.of(context).border)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            context.tr(_selectedService.name),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: QSevaColors.of(context).inkMuted,
                            ),
                          ),
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  '${context.tr(_selectedPackage.title)} • ',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w900,
                                    color: QSevaColors.of(context).ink,
                                  ),
                                ),
                              ),
                              RollingRupeeText(
                                amountRupees: _selectedPackage.priceRupees,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w900,
                                  color: QSevaColors.of(context).accentStart,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8),
                    Flexible(
                      child: ElevatedButton(
                        key: ValueKey('rate-card-checkout'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                        ),
                        onPressed: () => widget.onInstantCheckout(
                          _selectedService,
                          _selectedPackage,
                        ),
                        child: Text(
                          context.trPair('Book Instant →', 'तुरंत बुक →'),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
