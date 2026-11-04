import 'package:flutter/material.dart';
import 'l10n.dart';
import 'models.dart';

class CatalogData {
  CatalogData._();

  // ===========================================================================
  // 1. TOP-LEVEL CATEGORIES (7 CATEGORIES)
  // ===========================================================================
  static const List<ServiceCategory> categories = [
    ServiceCategory(
      id: 'cat_instant_help',
      name: Tr('Insta House Help', 'इंस्टा हाउस हेल्प'),
      subtitle: Tr('Arrives in 14 mins', '14 मिनट में घर पर'),
      icon: Icons.bolt_rounded,
      imageUrl:
          'https://images.unsplash.com/photo-1581578731548-c64695cc6952?auto=format&fit=crop&w=600&q=80',
      hasInstantBadge: true,
      badgeText: Tr('14 MINS', '14 मिनट'),
    ),
    ServiceCategory(
      id: 'cat_cleaning',
      name: Tr('Home & Bathroom Cleaning', 'होम और बाथरूम क्लीनिंग'),
      subtitle: Tr('Deep clean, sofa, kitchen', 'डीप क्लीनिंग, सोफा, किचन'),
      icon: Icons.cleaning_services_rounded,
      imageUrl:
          'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?auto=format&fit=crop&w=600&q=80',
    ),
    ServiceCategory(
      id: 'cat_appliances',
      name: Tr('AC & Appliance Repair', 'AC और अप्लायंस रिपेयर'),
      subtitle: Tr('AC, RO, Fridge, Washer', 'AC, RO, फ्रिज, वॉशिंग मशीन'),
      icon: Icons.ac_unit_rounded,
      imageUrl:
          'https://images.unsplash.com/photo-1621905251189-08b45d6a269e?auto=format&fit=crop&w=600&q=80',
      hasInstantBadge: true,
      badgeText: Tr('FAST', 'तेज़'),
    ),
    ServiceCategory(
      id: 'cat_repairs',
      name: Tr('Electrician, Plumber & Carpenter', 'इलेक्ट्रीशियन, प्लंबर, कारपेंटर'),
      subtitle: Tr('Quick repairs & installation', 'तुरंत रिपेयर और फिटिंग'),
      icon: Icons.handyman_rounded,
      imageUrl:
          'https://images.unsplash.com/photo-1621905252507-b35492cc74b4?auto=format&fit=crop&w=600&q=80',
      hasInstantBadge: true,
      badgeText: Tr('20 MINS', '20 मिनट'),
    ),
    ServiceCategory(
      id: 'cat_women_salon',
      name: Tr("Women's Salon & Spa", 'महिला सैलून और स्पा'),
      subtitle: Tr('Waxing, facial, manicure, spa', 'वैक्सिंग, फेशियल, स्पा'),
      icon: Icons.spa_rounded,
      imageUrl:
          'https://images.unsplash.com/photo-1560750588-73207b1ef5b8?auto=format&fit=crop&w=600&q=80',
    ),
    ServiceCategory(
      id: 'cat_men_grooming',
      name: Tr("Men's Grooming & Massage", 'पुरुष ग्रूमिंग और मसाज'),
      subtitle: Tr('Haircut, beard, stress relief', 'हेयरकट, बियर्ड, मसाज'),
      icon: Icons.content_cut_rounded,
      imageUrl:
          'https://images.unsplash.com/photo-1503951914875-452162b0f3f1?auto=format&fit=crop&w=600&q=80',
    ),
    ServiceCategory(
      id: 'cat_painting_pest',
      name: Tr('Pest Control & Painting', 'पेस्ट कंट्रोल और पेंटिंग'),
      subtitle: Tr('Cockroach, termite, express paint', 'पेस्ट कंट्रोल, होम पेंटिंग'),
      icon: Icons.format_paint_rounded,
      imageUrl:
          'https://images.unsplash.com/photo-1562259949-e8e7689d7828?auto=format&fit=crop&w=600&q=80',
    ),
  ];

  // ===========================================================================
  // 2. MASONRY DISCOVERY CARDS (MATCHING UC SCREENSHOT #2 "Discover")
  // ===========================================================================
  static const List<DiscoveryCardItem> discoveryCards = [
    DiscoveryCardItem(
      id: 'disc_1',
      serviceId: 'svc_house_help',
      title: Tr('House Help in 14 Mins', '14 मिनट में हाउस हेल्प'),
      imageUrl:
          'https://images.unsplash.com/photo-1581578731548-c64695cc6952?auto=format&fit=crop&w=700&q=80',
      aspectRatio: 0.88,
      badge: Tr('⚡ In 14 mins', '⚡ 14 मिनट में'),
    ),
    DiscoveryCardItem(
      id: 'disc_2',
      serviceId: 'svc_women_salon',
      title: Tr('Beauty Services', 'ब्यूटी सर्विसेज़'),
      imageUrl:
          'https://images.unsplash.com/photo-1560750588-73207b1ef5b8?auto=format&fit=crop&w=700&q=80',
      aspectRatio: 0.78,
    ),
    DiscoveryCardItem(
      id: 'disc_3',
      serviceId: 'svc_men_grooming',
      title: Tr("Men's Grooming", 'मेन्स ग्रूमिंग'),
      imageUrl:
          'https://images.unsplash.com/photo-1503951914875-452162b0f3f1?auto=format&fit=crop&w=700&q=80',
      aspectRatio: 0.82,
    ),
    DiscoveryCardItem(
      id: 'disc_4',
      serviceId: 'svc_bathroom_clean',
      title: Tr('Bathroom Cleaning', 'बाथरूम क्लीनिंग'),
      imageUrl:
          'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?auto=format&fit=crop&w=700&q=80',
      aspectRatio: 0.88,
      badge: Tr('₹399 onwards', '₹399 से शुरू'),
    ),
    DiscoveryCardItem(
      id: 'disc_5',
      serviceId: 'svc_ro_repair',
      title: Tr('Water Purifier & RO', 'वॉटर प्यूरीफायर और RO'),
      imageUrl:
          'https://images.unsplash.com/photo-1585704032915-c3400ca199e7?auto=format&fit=crop&w=700&q=80',
      aspectRatio: 0.85,
    ),
    DiscoveryCardItem(
      id: 'disc_6',
      serviceId: 'svc_women_spa',
      title: Tr('Ayurvedic & Relaxing Spa', 'आयुर्वेदिक और रिलैक्सिंग स्पा'),
      imageUrl:
          'https://images.unsplash.com/photo-1544161515-4ab6ce6db874?auto=format&fit=crop&w=700&q=80',
      aspectRatio: 0.85,
    ),
    DiscoveryCardItem(
      id: 'disc_7',
      serviceId: 'svc_ac_repair',
      title: Tr('AC Foam-Jet Service', 'AC फोम-जेट सर्विस'),
      imageUrl:
          'https://images.unsplash.com/photo-1621905251189-08b45d6a269e?auto=format&fit=crop&w=700&q=80',
      aspectRatio: 0.82,
      badge: Tr('Bestseller', 'बेस्टसेलर'),
    ),
    DiscoveryCardItem(
      id: 'disc_8',
      serviceId: 'svc_full_home_clean',
      title: Tr('Home Deep Cleaning', 'होम डीप क्लीनिंग'),
      imageUrl:
          'https://images.unsplash.com/photo-1527515637462-cff94eecc1ac?auto=format&fit=crop&w=700&q=80',
      aspectRatio: 0.88,
    ),
  ];

  // ===========================================================================
  // 3. COMPLETE SERVICES CATALOGUE (ACROSS ALL 7 CATEGORIES)
  // ===========================================================================
  static const List<ServiceItem> services = [
    // --- 1. HOUSE HELP BY QUICKSEVA (MATCHES UC SCREENSHOT #1) ---
    ServiceItem(
      id: 'svc_house_help',
      categoryId: 'cat_instant_help',
      name: Tr(
        'House help, cleaning & more',
        'हाउस हेल्प, सफाई और घर के काम',
      ),
      tagline: Tr(
        'One trained helper who can do sweeping, mopping, dishes & more',
        'झाड़ू-पोछा, बर्तन, डस्टिंग और किचन की मदद के लिए प्रशिक्षित हेल्पर',
      ),
      description: Tr(
        'Verified, uniform-wearing house help at your doorstep in 14 minutes or at your scheduled slot.',
        'सत्यापित और प्रशिक्षित हाउस हेल्प केवल 14 मिनट में या आपके चुने गए समय पर।',
      ),
      imageUrl:
          'https://images.unsplash.com/photo-1581578731548-c64695cc6952?auto=format&fit=crop&w=800&q=80',
      rating: 4.89,
      bookingsCountLabel: '1.4M+',
      supportsInstant: true,
      instantEtaMinutes: 14,
      startingPriceRupees: 49,
      originalStartingPriceRupees: 225,
      estimatedDurationMinutes: 60,
      packages: [
        ServicePackageTier(
          id: 'pkg_hh_45',
          title: Tr('45 mins', '45 मिनट'),
          subtitle: Tr(
            'Ideal for 1 BHK quick sweep, mop or dishes',
            '1 BHK झाड़ू-पोछा या बर्तन के लिए उपयुक्त',
          ),
          priceRupees: 49,
          originalPriceRupees: 225,
          durationMinutes: 45,
          inclusions: [
            Tr('Sweeping & mopping up to 2 rooms', '2 कमरों तक झाड़ू और पोछा'),
            Tr('Utensil dishwashing in sink', 'सिंक के बर्तनों की धुलाई'),
          ],
        ),
        ServicePackageTier(
          id: 'pkg_hh_60',
          title: Tr('1 hour', '1 घंटा'),
          subtitle: Tr(
            'Covers sweeping, mopping + dishwashing for 2 BHK',
            '2 BHK झाड़ू-पोछा + बर्तन के लिए परफेक्ट',
          ),
          priceRupees: 59,
          originalPriceRupees: 245,
          durationMinutes: 60,
          inclusions: [
            Tr('Full 2 BHK sweeping & floor mopping', 'पूरे 2 BHK में झाड़ू और पोछा'),
            Tr('Utensil washing & kitchen counter wipe', 'बर्तन धुलाई और किचन स्लैब की सफाई'),
          ],
        ),
        ServicePackageTier(
          id: 'pkg_hh_90',
          title: Tr('1.5 hours', '1.5 घंटे'),
          subtitle: Tr(
            'Complete 2-3 BHK daily chores + laundry folding',
            '2-3 BHK के सभी काम + कपड़े तह करना',
          ),
          priceRupees: 89,
          originalPriceRupees: 365,
          durationMinutes: 90,
          isBestseller: true,
          inclusions: [
            Tr('Sweeping, mopping & surface dusting', 'झाड़ू, पोछा और डस्टिंग'),
            Tr('Dishes, kitchen slab & laundry folding', 'बर्तन, किचन और कपड़े फोल्ड करना'),
          ],
        ),
        ServicePackageTier(
          id: 'pkg_hh_120',
          title: Tr('2 hours', '2 घंटे'),
          subtitle: Tr(
            'Full home chores + vegetable chopping & bathroom rinse',
            'पूरे घर की सफाई + सब्जी काटना और बाथरूम धुलाई',
          ),
          priceRupees: 119,
          originalPriceRupees: 480,
          durationMinutes: 120,
          inclusions: [
            Tr('All-round housework for large 3-4 BHK homes', '3-4 BHK घर का संपूर्ण काम'),
            Tr('Includes meal prep assistance & organizing', 'सब्जी काटना और सामान व्यवस्थित करना'),
          ],
        ),
      ],
      superSaverPack: SuperSaverPack(
        id: 'ssp_hh_3',
        badgeText: Tr('EXTRA 85% OFF', 'अतिरिक्त 85% छूट'),
        headline: Tr('3-visits pack at ₹225', '3-विज़िट पैक ₹225 के बजाय'),
        pricePerVisitText: Tr('₹33/visit', '₹33/विज़िट'),
        validityText: Tr('Valid till 1 month', '1 महीने तक मान्य'),
        packPriceRupees: 99,
        originalPriceRupees: 225,
      ),
      capabilities: [
        Tr('Sweeping & Floor Mopping', 'झाड़ू और फर्श पोछा'),
        Tr('Utensil & Dish Washing', 'बर्तनों की सफाई'),
        Tr('Kitchen Slab & Stove Wipe', 'किचन स्लैब और गैस की सफाई'),
        Tr('Dusting & Cobweb Removal', 'डस्टिंग और जाले साफ करना'),
        Tr('Clothes Folding & Drying', 'कपड़े सुखाना और तह करना'),
        Tr('Vegetable Chopping Help', 'सब्जियां काटने में मदद'),
      ],
      formFields: [
        ServiceFormField(
          key: 'tasks',
          type: FormFieldType.select,
          label: Tr('Primary task priority', 'मुख्य काम चुनें'),
          options: [
            ServiceFormOption(
              value: 'all_round',
              label: Tr('Sweeping + Mopping + Dishes', 'झाड़ू-पोछा + बर्तन'),
            ),
            ServiceFormOption(
              value: 'dishes_kitchen',
              label: Tr('Kitchen & Utensils Focus', 'केवल किचन और बर्तन'),
            ),
            ServiceFormOption(
              value: 'cleaning_dusting',
              label: Tr('Deep Sweeping, Mopping & Dusting', 'झाड़ू-पोछा और डस्टिंग'),
            ),
          ],
        ),
        ServiceFormField(
          key: 'rooms',
          type: FormFieldType.stepper,
          label: Tr('Number of rooms / BHK size', 'कमरों की संख्या (BHK)'),
          min: 1,
          max: 6,
          defaultValue: 2,
        ),
      ],
    ),

    // --- 2. BATHROOM DEEP CLEANING ---
    ServiceItem(
      id: 'svc_bathroom_clean',
      categoryId: 'cat_cleaning',
      name: Tr('Bathroom & Toilet Deep Cleaning', 'बाथरूम और टॉयलेट डीप क्लीनिंग'),
      tagline: Tr(
        'Hard-water stain removal, tile scrubbing & sanitization',
        'हार्ड-वॉटर दाग हटाना, टाइल स्क्रबिंग और सैनिटाइजेशन',
      ),
      description: Tr(
        'Machine scrubbing and hospital-grade descaling for sparkling tiles, taps, glass & commode.',
        'मशीन स्क्रबिंग और केमिकल डीस्केलिंग से चमकते टाइल्स, नल और कमोड।',
      ),
      imageUrl:
          'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?auto=format&fit=crop&w=800&q=80',
      rating: 4.86,
      bookingsCountLabel: '920K+',
      supportsInstant: true,
      instantEtaMinutes: 25,
      startingPriceRupees: 399,
      originalStartingPriceRupees: 599,
      estimatedDurationMinutes: 90,
      packages: [
        ServicePackageTier(
          id: 'pkg_bath_1',
          title: Tr('1 Bathroom', '1 बाथरूम'),
          subtitle: Tr('Classic scrubbing & stain removal', 'क्लासिक स्क्रबिंग और दाग सफाई'),
          priceRupees: 399,
          originalPriceRupees: 599,
          durationMinutes: 60,
        ),
        ServicePackageTier(
          id: 'pkg_bath_2',
          title: Tr('2 Bathrooms', '2 बाथरूम'),
          subtitle: Tr('Intense descaling with rotary machine', 'रोटरी मशीन से डीप क्लीनिंग'),
          priceRupees: 749,
          originalPriceRupees: 1199,
          durationMinutes: 110,
          isBestseller: true,
        ),
        ServicePackageTier(
          id: 'pkg_bath_3',
          title: Tr('3 Bathrooms', '3 बाथरूम'),
          subtitle: Tr('Complete family pack + exhaust fan clean', '3 बाथरूम + एग्जॉस्ट फैन सफाई'),
          priceRupees: 1049,
          originalPriceRupees: 1699,
          durationMinutes: 150,
        ),
      ],
      capabilities: [
        Tr('Hard-water scaling removal on taps & tiles', 'नल और टाइल्स से खारे पानी के दाग हटाना'),
        Tr('Commode, washbasin & drain sanitization', 'कमोड, वॉशबेसिन और ड्रेन कीटाणुशोधन'),
        Tr('Mirror, glass partition & exhaust cleaning', 'शीशा, ग्लास और एग्जॉस्ट फैन की सफाई'),
      ],
    ),

    // --- 3. FULL HOME DEEP CLEANING ---
    ServiceItem(
      id: 'svc_full_home_clean',
      categoryId: 'cat_cleaning',
      name: Tr('Full Home Deep Cleaning', 'संपूर्ण घर की डीप क्लीनिंग'),
      tagline: Tr(
        'Every room, kitchen, bathroom & balcony scrubbed clean',
        'हर कमरा, किचन, बाथरूम और बालकनी की मशीन से सफाई',
      ),
      description: Tr(
        '4-hour intensive cleaning by a team of 2–4 professionals with industrial vacuum & scrubbers.',
        '2-4 विशेषज्ञों की टीम द्वारा इंडस्ट्रियल वैक्यूम और स्क्रबर से 4 घंटे की गहन सफाई।',
      ),
      imageUrl:
          'https://images.unsplash.com/photo-1527515637462-cff94eecc1ac?auto=format&fit=crop&w=800&q=80',
      rating: 4.84,
      bookingsCountLabel: '510K+',
      supportsInstant: false,
      startingPriceRupees: 1999,
      originalStartingPriceRupees: 3299,
      estimatedDurationMinutes: 240,
      packages: [
        ServicePackageTier(
          id: 'pkg_home_1bhk',
          title: Tr('1 BHK Home', '1 BHK घर'),
          subtitle: Tr('2 cleaners • ~3 hours', '2 क्लीनर • ~3 घंटे'),
          priceRupees: 1999,
          originalPriceRupees: 3299,
          durationMinutes: 180,
        ),
        ServicePackageTier(
          id: 'pkg_home_2bhk',
          title: Tr('2 BHK Home', '2 BHK घर'),
          subtitle: Tr('3 cleaners • ~4 hours', '3 क्लीनर • ~4 घंटे'),
          priceRupees: 2799,
          originalPriceRupees: 4499,
          durationMinutes: 240,
          isBestseller: true,
        ),
        ServicePackageTier(
          id: 'pkg_home_3bhk',
          title: Tr('3 BHK Home', '3 BHK घर'),
          subtitle: Tr('4 cleaners • ~4.5 hours', '4 क्लीनर • ~4.5 घंटे'),
          priceRupees: 3699,
          originalPriceRupees: 5999,
          durationMinutes: 270,
        ),
      ],
      capabilities: [
        Tr('Floor scrubbing, sofa dry vacuuming & window tracks', 'फर्श स्क्रबिंग, सोफा वैक्यूम और खिड़की ट्रैक'),
        Tr('Kitchen oil/grease degreasing & cabinet wipe', 'किचन के तेल-चिकनाई और कैबिनेट की सफाई'),
        Tr('All bathrooms descaled & sanitized', 'सभी बाथरूम की डीस्केलिंग और सैनिटाइजेशन'),
      ],
    ),

    // --- 4. AC SERVICE & REPAIR ---
    ServiceItem(
      id: 'svc_ac_repair',
      categoryId: 'cat_appliances',
      name: Tr('AC Foam-Jet Service & Repair', 'AC फोम-जेट सर्विस और रिपेयर'),
      tagline: Tr(
        '2X deeper cooling with high-pressure foam jet & gas check',
        'हाई-प्रेशर फोम जेट और गैस चेक के साथ 2 गुना बेहतर कूलिंग',
      ),
      description: Tr(
        'Trained AC technicians for Split & Window ACs. Includes 30-day service warranty.',
        'स्प्लिट और विंडो AC के लिए प्रशिक्षित तकनीशियन। 30 दिन की वारंटी के साथ।',
      ),
      imageUrl:
          'https://images.unsplash.com/photo-1621905251189-08b45d6a269e?auto=format&fit=crop&w=800&q=80',
      rating: 4.88,
      bookingsCountLabel: '1.1M+',
      supportsInstant: true,
      instantEtaMinutes: 20,
      startingPriceRupees: 299,
      originalStartingPriceRupees: 599,
      estimatedDurationMinutes: 60,
      packages: [
        ServicePackageTier(
          id: 'pkg_ac_check',
          title: Tr('AC Repair / Inspection', 'AC रिपेयर जांच'),
          subtitle: Tr('Not cooling, water leak or noise diagnosis', 'कूलिंग न होना, पानी टपकना या आवाज़'),
          priceRupees: 299,
          originalPriceRupees: 499,
          durationMinutes: 45,
        ),
        ServicePackageTier(
          id: 'pkg_ac_foam1',
          title: Tr('1 AC Foam-Jet', '1 AC फोम-जेट सर्विस'),
          subtitle: Tr('Indoor coil foam wash + outdoor jet wash', 'इनडोर फोम वॉश + आउटडोर जेट वॉश'),
          priceRupees: 499,
          originalPriceRupees: 799,
          durationMinutes: 60,
          isBestseller: true,
        ),
        ServicePackageTier(
          id: 'pkg_ac_foam2',
          title: Tr('2 ACs Saver Pack', '2 AC सेवर पैक'),
          subtitle: Tr('Complete foam-jet service for 2 ACs', '2 AC की संपूर्ण फोम-जेट सर्विस'),
          priceRupees: 899,
          originalPriceRupees: 1598,
          durationMinutes: 105,
        ),
      ],
      capabilities: [
        Tr('Mess-free AC jacket used to protect walls', 'दीवारों को गंदा होने से बचाने के लिए जैकेट कवर'),
        Tr('Cooling coil, blower, drain pipe & filter wash', 'कूलिंग कॉइल, ब्लोअर, ड्रेन पाइप और फिल्टर वॉश'),
        Tr('Gas pressure & amp check included', 'गैस प्रेशर और एम्पियर की जांच शामिल'),
      ],
      formFields: [
        ServiceFormField(
          key: 'ac_issue',
          type: FormFieldType.select,
          label: Tr('What service do you need?', 'आपको कौन सी सर्विस चाहिए?'),
          options: [
            ServiceFormOption(
              value: 'wet_service',
              label: Tr('Seasonal Foam-Jet Servicing', 'फोम-जेट सर्विसिंग'),
            ),
            ServiceFormOption(
              value: 'not_cooling',
              label: Tr('Less / No Cooling Issue', 'कम या बिल्कुल कूलिंग नहीं'),
            ),
            ServiceFormOption(
              value: 'water_leak',
              label: Tr('Water Leaking Indoor', 'अंदर पानी टपकने की समस्या'),
            ),
          ],
        ),
        ServiceFormField(
          key: 'ac_units',
          type: FormFieldType.stepper,
          label: Tr('Number of AC units', 'AC की संख्या'),
          min: 1,
          max: 5,
          defaultValue: 1,
        ),
      ],
    ),

    // --- 5. WATER PURIFIER / RO SERVICE ---
    ServiceItem(
      id: 'svc_ro_repair',
      categoryId: 'cat_appliances',
      name: Tr('Water Purifier (RO) Service & Repair', 'वॉटर प्यूरीफायर (RO) सर्विस और रिपेयर'),
      tagline: Tr(
        'TDS check, sediment/carbon filter replacement & membrane clean',
        'TDS चेक, फिल्टर बदलाव और मेम्ब्रेन क्लीनिंग',
      ),
      description: Tr(
        'Genuine spare filters for Kent, Aquaguard, Pureit, Livpure & all RO brands.',
        'सभी RO ब्रांड्स के लिए असली फिल्टर और अनुभवी तकनीशियन।',
      ),
      imageUrl:
          'https://images.unsplash.com/photo-1585704032915-c3400ca199e7?auto=format&fit=crop&w=800&q=80',
      rating: 4.83,
      bookingsCountLabel: '340K+',
      supportsInstant: true,
      instantEtaMinutes: 25,
      startingPriceRupees: 249,
      originalStartingPriceRupees: 449,
      estimatedDurationMinutes: 45,
      packages: [
        ServicePackageTier(
          id: 'pkg_ro_visit',
          title: Tr('Checkup & Tune-up', 'RO चेकअप और सर्विस'),
          subtitle: Tr('Filter cleaning + TDS calibration', 'फिल्टर सफाई + TDS जांच'),
          priceRupees: 249,
          originalPriceRupees: 449,
          durationMinutes: 40,
        ),
        ServicePackageTier(
          id: 'pkg_ro_full',
          title: Tr('Full Filter Kit Kit', 'फुल फिल्टर चेंज किट'),
          subtitle: Tr('Sediment + Carbon + RO Membrane', 'सेडिमेंट + कार्बन + RO मेम्ब्रेन'),
          priceRupees: 1499,
          originalPriceRupees: 2499,
          durationMinutes: 60,
          isBestseller: true,
        ),
      ],
    ),

    // --- 6. ELECTRICIAN ON DEMAND ---
    ServiceItem(
      id: 'svc_electrician',
      categoryId: 'cat_repairs',
      name: Tr('Expert Electrician', 'एक्सपर्ट इलेक्ट्रीशियन'),
      tagline: Tr(
        'Switchboard, ceiling fan, MCB fuse, inverter & light fittings',
        'स्विचबोर्ड, पंखा, MCB फ्यूज, इन्वर्टर और लाइट फिटिंग',
      ),
      description: Tr(
        'Certified electricians arriving in 20 minutes for emergencies or installations.',
        'इमरजेंसी रिपेयर या नई फिटिंग के लिए 20 मिनट में प्रमाणित इलेक्ट्रीशियन।',
      ),
      imageUrl:
          'https://images.unsplash.com/photo-1621905252507-b35492cc74b4?auto=format&fit=crop&w=800&q=80',
      rating: 4.87,
      bookingsCountLabel: '870K+',
      supportsInstant: true,
      instantEtaMinutes: 18,
      startingPriceRupees: 109,
      originalStartingPriceRupees: 199,
      estimatedDurationMinutes: 45,
      packages: [
        ServicePackageTier(
          id: 'pkg_elec_switch',
          title: Tr('Switch / Socket Repair', 'स्विच / सॉकेट रिपेयर'),
          subtitle: Tr('Up to 2 switchboards checked & fixed', '2 स्विचबोर्ड तक की जांच और रिपेयर'),
          priceRupees: 109,
          originalPriceRupees: 199,
          durationMinutes: 30,
        ),
        ServicePackageTier(
          id: 'pkg_elec_fan',
          title: Tr('Fan Install / Repair', 'पंखा इंस्टॉल / रिपेयर'),
          subtitle: Tr('Ceiling fan regulator, capacitor or installation', 'सीलिंग फैन कैपेसिटर, रेगुलेटर या फिटिंग'),
          priceRupees: 149,
          originalPriceRupees: 299,
          durationMinutes: 45,
          isBestseller: true,
        ),
        ServicePackageTier(
          id: 'pkg_elec_mcb',
          title: Tr('Power Trip / Inverter', 'पावर ट्रिप / इन्वर्टर'),
          subtitle: Tr('MCB trip diagnosis & wiring fault resolution', 'MCB ट्रिप और वायरिंग फॉल्ट समाधान'),
          priceRupees: 199,
          originalPriceRupees: 349,
          durationMinutes: 45,
        ),
      ],
    ),

    // --- 7. PLUMBER ON DEMAND ---
    ServiceItem(
      id: 'svc_plumber',
      categoryId: 'cat_repairs',
      name: Tr('Quick Plumber & Leak Fix', 'क्विक प्लंबर और लीकेज रिपेयर'),
      tagline: Tr(
        'Tap leak, sink blockage, flush tank, jet spray & motor fitting',
        'नल लीकेज, सिंक ब्लॉकेज, फ्लश टैंक और मोटर फिटिंग',
      ),
      description: Tr(
        'Fast plumbing repairs with transparent spare-part pricing.',
        'पारदर्शी रेट्स के साथ तेज़ प्लंबिंग रिपेयर।',
      ),
      imageUrl:
          'https://images.unsplash.com/photo-1585704032915-c3400ca199e7?auto=format&fit=crop&w=800&q=80',
      rating: 4.82,
      bookingsCountLabel: '640K+',
      supportsInstant: true,
      instantEtaMinutes: 20,
      startingPriceRupees: 119,
      originalStartingPriceRupees: 229,
      estimatedDurationMinutes: 45,
      packages: [
        ServicePackageTier(
          id: 'pkg_plumb_tap',
          title: Tr('Tap / Jet Spray Fix', 'नल / जेट स्प्रे रिपेयर'),
          subtitle: Tr('Leakage stop or new tap installation', 'लीकेज बंद करना या नया नल लगाना'),
          priceRupees: 119,
          originalPriceRupees: 229,
          durationMinutes: 30,
          isBestseller: true,
        ),
        ServicePackageTier(
          id: 'pkg_plumb_drain',
          title: Tr('Drain / Sink Blockage', 'ड्रेन / सिंक ब्लॉकेज'),
          subtitle: Tr('Kitchen sink or bathroom pipe unclogging', 'किचन सिंक या बाथरूम पाइप खोलना'),
          priceRupees: 199,
          originalPriceRupees: 349,
          durationMinutes: 45,
        ),
      ],
    ),

    // --- 8. WOMEN'S SALON AT HOME ---
    ServiceItem(
      id: 'svc_women_salon',
      categoryId: 'cat_women_salon',
      name: Tr("Women's Salon at Home", 'घर पर महिला सैलून'),
      tagline: Tr(
        'Rica waxing, Korean facial, manicure, pedicure & threading',
        'रिका वैक्सिंग, कोरियन फेशियल, मैनीक्योर, पेडीक्योर और थ्रेडिंग',
      ),
      description: Tr(
        'Single-use sealed mono-doses, disposable sheets & certified beauticians.',
        'सिंगल-यूज़ सील्ड प्रोडक्ट्स, डिस्पोजेबल शीट्स और सर्टिफाइड ब्यूटीशियन।',
      ),
      imageUrl:
          'https://images.unsplash.com/photo-1560750588-73207b1ef5b8?auto=format&fit=crop&w=800&q=80',
      rating: 4.91,
      bookingsCountLabel: '1.2M+',
      supportsInstant: false,
      startingPriceRupees: 599,
      originalStartingPriceRupees: 1099,
      estimatedDurationMinutes: 90,
      packages: [
        ServicePackageTier(
          id: 'pkg_ws_wax',
          title: Tr('Complete Waxing Pack', 'कम्पलीट वैक्सिंग पैक'),
          subtitle: Tr('Full arms + full legs + underarms (Rica)', 'फुल आर्म्स + फुल लेग्स + अंडरआर्म्स'),
          priceRupees: 599,
          originalPriceRupees: 1099,
          durationMinutes: 60,
          isBestseller: true,
        ),
        ServicePackageTier(
          id: 'pkg_ws_glow',
          title: Tr('Glow Facial + Mani-Pedi', 'ग्लो फेशियल + मैनी-पेडी'),
          subtitle: Tr('O3+ cleanup/facial + classic pedicure + threading', 'फेशियल + पेडीक्योर + थ्रेडिंग'),
          priceRupees: 1199,
          originalPriceRupees: 2199,
          durationMinutes: 110,
        ),
      ],
    ),

    // --- 9. WOMEN'S SPA THERAPY ---
    ServiceItem(
      id: 'svc_women_spa',
      categoryId: 'cat_women_salon',
      name: Tr('Luxury Spa Therapy for Women', 'महिलाओं के लिए लक्ज़री स्पा थेरेपी'),
      tagline: Tr(
        'Portable massage table, aromatic oils & stress-relief therapy',
        'पोर्टेबल मसाज टेबल, अरोमा ऑयल और स्ट्रेस-रिलीफ थेरेपी',
      ),
      description: Tr(
        'Certified female therapists bring a foldable spa bed, fresh linens & calming music.',
        'सर्टिफाइड महिला थेरेपिस्ट फोल्डेबल स्पा बेड और अरोमा ऑयल के साथ।',
      ),
      imageUrl:
          'https://images.unsplash.com/photo-1544161515-4ab6ce6db874?auto=format&fit=crop&w=800&q=80',
      rating: 4.92,
      bookingsCountLabel: '420K+',
      supportsInstant: false,
      startingPriceRupees: 999,
      originalStartingPriceRupees: 1699,
      estimatedDurationMinutes: 60,
      packages: [
        ServicePackageTier(
          id: 'pkg_spa_swedish',
          title: Tr('60 mins Swedish Spa', '60 मिनट स्वीडिश स्पा'),
          subtitle: Tr('Full body relaxation & sleep therapy', 'फुल बॉडी रिलैक्सेशन थेरेपी'),
          priceRupees: 999,
          originalPriceRupees: 1699,
          durationMinutes: 60,
          isBestseller: true,
        ),
        ServicePackageTier(
          id: 'pkg_spa_deep',
          title: Tr('90 mins Deep Tissue', '90 मिनट डीप टिश्यू स्पा'),
          subtitle: Tr('Targets back, neck & shoulder knots + head massage', 'पीठ, गर्दन दर्द से राहत + हेड मसाज'),
          priceRupees: 1399,
          originalPriceRupees: 2299,
          durationMinutes: 90,
        ),
      ],
    ),

    // --- 10. MEN'S GROOMING & SALON ---
    ServiceItem(
      id: 'svc_men_grooming',
      categoryId: 'cat_men_grooming',
      name: Tr("Men's Salon & Grooming", 'मेन्स सैलून और ग्रूमिंग'),
      tagline: Tr(
        'Mess-free haircut, beard styling, detan & relaxing head massage',
        'मेस-फ्री हेयरकट, बियर्ड स्टाइलिंग, डी-टैन और हेड मसाज',
      ),
      description: Tr(
        'Includes floor hair-sheet so zero hair stays on your floor after the cut.',
        'फर्श पर एक भी बाल न रहे इसके लिए फ्लोर प्रोटेक्शन शीट के साथ सर्विस।',
      ),
      imageUrl:
          'https://images.unsplash.com/photo-1503951914875-452162b0f3f1?auto=format&fit=crop&w=800&q=80',
      rating: 4.88,
      bookingsCountLabel: '780K+',
      supportsInstant: true,
      instantEtaMinutes: 25,
      startingPriceRupees: 249,
      originalStartingPriceRupees: 449,
      estimatedDurationMinutes: 45,
      packages: [
        ServicePackageTier(
          id: 'pkg_men_hc',
          title: Tr('Haircut + Head Massage', 'हेयरकट + हेड मसाज'),
          subtitle: Tr('Precision cut + 10 min champi', 'हेयरकट + 10 मिनट चंपी मसाज'),
          priceRupees: 249,
          originalPriceRupees: 449,
          durationMinutes: 40,
          isBestseller: true,
        ),
        ServicePackageTier(
          id: 'pkg_men_combo',
          title: Tr('Haircut + Beard + Detan', 'हेयरकट + बियर्ड + डी-टैन'),
          subtitle: Tr('Complete grooming makeover pack', 'कम्पलीट मेन्स ग्रूमिंग पैक'),
          priceRupees: 499,
          originalPriceRupees: 899,
          durationMinutes: 70,
        ),
      ],
    ),

    // --- 11. PEST CONTROL & EXPRESS PAINTING ---
    ServiceItem(
      id: 'svc_pest_control',
      categoryId: 'cat_painting_pest',
      name: Tr('Odorless Herbal Pest Control', 'गंधरहित हर्बल पेस्ट कंट्रोल'),
      tagline: Tr(
        'Cockroach, ant & bed-bug treatment — no need to empty kitchen',
        'कॉकरोच, चींटी और खटमल का पक्का इलाज — किचन खाली करने की ज़रूरत नहीं',
      ),
      description: Tr(
        'Bayer-certified gel and herbal spray safe for children, elders & pets.',
        'बच्चों और पालतू जानवरों के लिए सुरक्षित हर्बल जेल और स्प्रे ट्रीटमेंट।',
      ),
      imageUrl:
          'https://images.unsplash.com/photo-1562259949-e8e7689d7828?auto=format&fit=crop&w=800&q=80',
      rating: 4.85,
      bookingsCountLabel: '290K+',
      supportsInstant: false,
      startingPriceRupees: 799,
      originalStartingPriceRupees: 1299,
      estimatedDurationMinutes: 60,
      packages: [
        ServicePackageTier(
          id: 'pkg_pest_2bhk',
          title: Tr('1–2 BHK Pest Control', '1–2 BHK पेस्ट कंट्रोल'),
          subtitle: Tr('Gel + spray with 60-day warranty', 'जेल + स्प्रे (60 दिन की वारंटी)'),
          priceRupees: 799,
          originalPriceRupees: 1299,
          durationMinutes: 45,
          isBestseller: true,
        ),
        ServicePackageTier(
          id: 'pkg_pest_3bhk',
          title: Tr('3–4 BHK Pest Control', '3–4 BHK पेस्ट कंट्रोल'),
          subtitle: Tr('Complete apartment + utility & balconies', 'पूरा घर + बालकनी और स्टोर रूम'),
          priceRupees: 1099,
          originalPriceRupees: 1799,
          durationMinutes: 65,
        ),
      ],
    ),
  ];

  // ===========================================================================
  // 4. SCHEDULE DATE & TIME SLOTS (MATCHING UC SCREENSHOT #3)
  // ===========================================================================
  static const List<DateSlotItem> dateSlots = [
    DateSlotItem(
      id: 'd_wed_01',
      dayShort: Tr('Wed', 'बुध'),
      dateNumber: '01',
      fullDateLabel: Tr('Wednesday, 1 Nov', 'बुधवार, 1 नवंबर'),
      trend: DemandTrend.highUp,
    ),
    DateSlotItem(
      id: 'd_thu_02',
      dayShort: Tr('Thu', 'गुरु'),
      dateNumber: '02',
      fullDateLabel: Tr('Thursday, 2 Nov', 'गुरुवार, 2 नवंबर'),
      trend: DemandTrend.lowDown,
    ),
    DateSlotItem(
      id: 'd_fri_03',
      dayShort: Tr('Fri', 'शुक्र'),
      dateNumber: '03',
      fullDateLabel: Tr('Friday, 3 Nov', 'शुक्रवार, 3 नवंबर'),
    ),
    DateSlotItem(
      id: 'd_sat_04',
      dayShort: Tr('Sat', 'शनि'),
      dateNumber: '04',
      fullDateLabel: Tr('Saturday, 4 Nov', 'शनिवार, 4 नवंबर'),
      trend: DemandTrend.highUp,
    ),
    DateSlotItem(
      id: 'd_sun_05',
      dayShort: Tr('Sun', 'रवि'),
      dateNumber: '05',
      fullDateLabel: Tr('Sunday, 5 Nov', 'रविवार, 5 नवंबर'),
    ),
  ];

  static const List<TimeSlotItem> timeSlots = [
    TimeSlotItem(id: 't_0930', label: '9:30 AM'),
    TimeSlotItem(id: 't_1000', label: '10:00 AM'),
    TimeSlotItem(id: 't_1030', label: '10:30 AM'),
    TimeSlotItem(id: 't_1100', label: '11:00 AM'),
    TimeSlotItem(id: 't_1130', label: '11:30 AM', peakSurchargeRupees: 20),
    TimeSlotItem(id: 't_1200', label: '12:00 PM'),
    TimeSlotItem(id: 't_1230', label: '12:30 PM'),
    TimeSlotItem(id: 't_1300', label: '1:00 PM'),
    TimeSlotItem(id: 't_1330', label: '1:30 PM'),
    TimeSlotItem(id: 't_1400', label: '2:00 PM'),
    TimeSlotItem(id: 't_1430', label: '2:30 PM'),
    TimeSlotItem(id: 't_1500', label: '3:00 PM'),
    TimeSlotItem(id: 't_1600', label: '4:00 PM'),
    TimeSlotItem(id: 't_1700', label: '5:00 PM', peakSurchargeRupees: 20),
    TimeSlotItem(id: 't_1830', label: '6:30 PM'),
  ];

  // ===========================================================================
  // 5. PROVIDER SAMPLE OFFERS & LEDGER SEED DATA
  // ===========================================================================
  static const List<ProviderJobOffer> sampleProviderOffers = [
    ProviderJobOffer(
      offerId: 'OFF-9041',
      bookingId: 'BK-2841',
      serviceName: Tr('Insta House Help • 1.5 Hours', 'इंस्टा हाउस हेल्प • 1.5 घंटे'),
      packageName: Tr(
        'Sweeping, Mopping & Utensils (2 BHK)',
        'झाड़ू-पोछा और बर्तन (2 BHK)',
      ),
      isInstant: true,
      customerName: Tr('Ananya Singhania', 'अनन्या सिंघानिया'),
      addressArea: Tr('Sector 3, Udaipur', 'सेक्टर 3, उदयपुर'),
      fullAddress: Tr(
        'House 416, Sector 3, Near Community Park, Udaipur',
        'मकान 416, सेक्टर 3, कम्युनिटी पार्क के पास, उदयपुर',
      ),
      distanceKm: 1.2,
      etaMinutes: 6,
      grossAmountRupees: 380,
      platformFeeRupees: 56,
      netPayoutRupees: 324,
      paymentMode: PaymentMode.cash,
      startOtp: '4829',
      taskChecklist: [
        Tr('Wear QuickSeva ID badge & mask', 'क्विकसेवा आईडी और मास्क पहनें'),
        Tr('Enter 4-digit Start OTP (4829) from customer', 'ग्राहक से 4-अंकीय OTP (4829) दर्ज करें'),
        Tr('Complete sweeping, mopping & dishwashing', 'झाड़ू-पोछा और बर्तन का काम पूरा करें'),
        Tr('Collect ₹380 Cash or verify online status', '₹380 नकद लें या ऑनलाइन पेमेंट जांचें'),
      ],
    ),
    ProviderJobOffer(
      offerId: 'OFF-9042',
      bookingId: 'BK-2849',
      serviceName: Tr('AC Foam-Jet Service (2 Units)', 'AC फोम-जेट सर्विस (2 AC)'),
      packageName: Tr('Indoor coil foam + Outdoor jet wash', 'इनडोर फोम + आउटडोर जेट वॉश'),
      isInstant: true,
      customerName: Tr('Vikramaditya Mehta', 'विक्रमादित्य मेहता'),
      addressArea: Tr('Fatehpura Circle, Udaipur', 'फतहपुरा सर्कल, उदयपुर'),
      fullAddress: Tr(
        'B-204, Aravali Heights, Fatehpura, Udaipur',
        'B-204, अरावली हाइट्स, फतहपुरा, उदयपुर',
      ),
      distanceKm: 2.4,
      etaMinutes: 11,
      grossAmountRupees: 899,
      platformFeeRupees: 149,
      netPayoutRupees: 750,
      paymentMode: PaymentMode.dummyOnline,
      startOtp: '7310',
      taskChecklist: [
        Tr('Set up waterproof AC service jacket', 'वॉटरप्रूफ AC जैकेट लगाएं'),
        Tr('Verify 4-digit Start OTP (7310)', '4-अंकीय OTP (7310) सत्यापित करें'),
        Tr('Foam-jet wash both indoor & outdoor units', 'दोनों AC यूनिट्स की फोम-जेट सफाई करें'),
        Tr('Check cooling temperature & gas pressure', 'कूलिंग और गैस प्रेशर चेक करें'),
      ],
    ),
  ];

  static const List<LedgerJournalItem> sampleLedgerEntries = [
    LedgerJournalItem(
      id: 'JRN-1088',
      title: Tr('AC Foam-Jet Service (#BK-2831)', 'AC फोम-जेट सर्विस (#BK-2831)'),
      subtitle: Tr(
        'Online Split Settlement • Gross ₹899 - Fee ₹149',
        'ऑनलाइन स्प्लिट पेमेंट • कुल ₹899 - शुल्क ₹149',
      ),
      timestampLabel: 'Today, 4:15 PM',
      amountRupees: 750,
      isCredit: true,
      tag: Tr('ONLINE PAYOUT', 'ऑनलाइन आय'),
    ),
    LedgerJournalItem(
      id: 'JRN-1087',
      title: Tr('Daily Peak Target Bonus (4 Jobs)', 'डेली टारगेट बोनस (4 जॉब्स)'),
      subtitle: Tr('Zero-cancellation streak reward', 'बिना कैंसिलेशन बोनस रिवॉर्ड'),
      timestampLabel: 'Today, 3:00 PM',
      amountRupees: 250,
      isCredit: true,
      tag: Tr('INCENTIVE', 'बोनस'),
    ),
    LedgerJournalItem(
      id: 'JRN-1086',
      title: Tr('Cash Job Commission Accrued (#BK-2819)', 'नकद जॉब कमीशन (#BK-2819)'),
      subtitle: Tr(
        'Customer paid ₹499 Cash to you • 15% + GST fee',
        'ग्राहक ने ₹499 नकद दिया • 15% प्लेटफॉर्म शुल्क',
      ),
      timestampLabel: 'Today, 12:40 PM',
      amountRupees: 88,
      isCredit: false,
      tag: Tr('CASH DUES', 'नकद बकाया'),
    ),
    LedgerJournalItem(
      id: 'JRN-1085',
      title: Tr('Bathroom Deep Cleaning (#BK-2804)', 'बाथरूम डीप क्लीनिंग (#BK-2804)'),
      subtitle: Tr(
        'Online Split Settlement • Gross ₹749 - Fee ₹129',
        'ऑनलाइन स्प्लिट पेमेंट • कुल ₹749 - शुल्क ₹129',
      ),
      timestampLabel: 'Yesterday, 6:10 PM',
      amountRupees: 620,
      isCredit: true,
      tag: Tr('ONLINE PAYOUT', 'ऑनलाइन आय'),
    ),
  ];

  static ServiceItem serviceById(String id) {
    return services.firstWhere(
      (s) => s.id == id,
      orElse: () => services.first,
    );
  }

  static List<ServiceItem> servicesByCategory(String categoryId) {
    return services.where((s) => s.categoryId == categoryId).toList();
  }
}

