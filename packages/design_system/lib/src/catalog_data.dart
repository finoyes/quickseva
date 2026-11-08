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
      id: 'cat_masonry_civil',
      name: Tr('Masonry, Civil & Daily Labour', 'राजमिस्त्री, सिविल और दिहाड़ी लेबर'),
      subtitle: Tr('Rajmistri, Tile, Welder, Beldar', 'राजमिस्त्री, टाइल, वेल्डर, बेलदार'),
      icon: Icons.construction_rounded,
      imageUrl:
          'https://images.unsplash.com/photo-1504307651254-35680f356dfd?auto=format&fit=crop&w=600&q=80',
      hasInstantBadge: true,
      badgeText: Tr('SKILLED', 'कुशल लेबर'),
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
      badge: Tr('In 14 mins', '14 मिनट में'),
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
    DiscoveryCardItem(
      id: 'disc_9',
      serviceId: 'svc_masonry_civil',
      title: Tr('Mason / Rajmistri & Civil Work', 'राजमिस्त्री और सिविल निर्माण'),
      imageUrl:
          'https://images.unsplash.com/photo-1504307651254-35680f356dfd?auto=format&fit=crop&w=700&q=80',
      aspectRatio: 0.84,
      badge: Tr('Half / Full Day', 'दिहाड़ी / ठेका'),
    ),
    DiscoveryCardItem(
      id: 'disc_10',
      serviceId: 'svc_tile_marble_mistri',
      title: Tr('Tile, Marble & Granite Mistri', 'टाइल, मार्बल और ग्रेनाइट मिस्त्री'),
      imageUrl:
          'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&w=700&q=80',
      aspectRatio: 0.86,
      badge: Tr('Laser Level', 'लेज़र लेवल'),
    ),
    DiscoveryCardItem(
      id: 'disc_11',
      serviceId: 'svc_welder_fabricator',
      title: Tr('Welder & Iron Fabricator', 'वेल्डर और गेट/ग्रिल रिपेयर'),
      imageUrl:
          'https://images.unsplash.com/photo-1504917595217-d4dc5ebe6122?auto=format&fit=crop&w=700&q=80',
      aspectRatio: 0.82,
    ),
    DiscoveryCardItem(
      id: 'disc_12',
      serviceId: 'svc_construction_helper',
      title: Tr('Beldar / Site & Shifting Helper', 'बेलदार / निर्माण और शिफ्टिंग लेबर'),
      imageUrl:
          'https://images.unsplash.com/photo-1541888946425-d09bb18086f6?auto=format&fit=crop&w=700&q=80',
      aspectRatio: 0.85,
      badge: Tr('₹249 onwards', '₹249 से शुरू'),
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

    // --- 12. MASONRY / RAJMISTRI & CIVIL WORK ---
    ServiceItem(
      id: 'svc_masonry_civil',
      categoryId: 'cat_masonry_civil',
      name: Tr(
        'Mason / Rajmistri (Brickwork, Plaster & Civil)',
        'राजमिस्त्री (ईंट चुनाई, प्लास्टर और सिविल रिपेयर)',
      ),
      tagline: Tr(
        'Skilled Rajmistri for brickwork, wall plastering, PCC flooring, slope fix & civil repair',
        'ईंट की दीवार, सीमेंट प्लास्टर, फर्श ढलाई (PCC), ढलान सुधार और सिविल मरम्मत के लिए अनुभवी राजमिस्त्री',
      ),
      description: Tr(
        'Book a verified senior Rajmistri by task or for a 4-hour half-day / 8-hour full-day dihadi shift, with optional Beldar helper.',
        'छोटी मरम्मत या 4-घंटे हाफ-डे / 8-घंटे फुल-डे दिहाड़ी पर अनुभवी राजमिस्त्री और बेलदार बुक करें।',
      ),
      imageUrl:
          'https://images.unsplash.com/photo-1504307651254-35680f356dfd?auto=format&fit=crop&w=800&q=80',
      rating: 4.89,
      bookingsCountLabel: '410K+',
      supportsInstant: true,
      instantEtaMinutes: 25,
      startingPriceRupees: 349,
      originalStartingPriceRupees: 549,
      estimatedDurationMinutes: 240,
      packages: [
        ServicePackageTier(
          id: 'pkg_mason_patch',
          title: Tr('Minor Civil / Plaster Patch', 'छोटा प्लास्टर / सिविल पैच रिपेयर'),
          subtitle: Tr(
            'Wall crack sealing, bathroom threshold or slab patch (2 hrs)',
            'दीवार दरार, बाथरूम देहलीज़ या स्लैब मरम्मत (2 घंटे)',
          ),
          priceRupees: 349,
          originalPriceRupees: 549,
          durationMinutes: 120,
          inclusions: [
            Tr('Includes trowel, plumb-bob & spirit-level tools', 'कन्नी, साहुल और लेवल टूल के साथ'),
            Tr('Clean post-work cement mortar sweeping', 'काम के बाद मलबा समेटना शामिल'),
          ],
        ),
        ServicePackageTier(
          id: 'pkg_mason_half',
          title: Tr('Half-Day Rajmistri (4 Hrs)', 'हाफ-डे राजमिस्त्री (4 घंटे)'),
          subtitle: Tr(
            'Brick partition patch, chamber cover or kitchen platform fix',
            'छोटी चुनाई, चैंबर ढक्कन या किचन स्लैब रिपेयर',
          ),
          priceRupees: 499,
          originalPriceRupees: 799,
          durationMinutes: 240,
        ),
        ServicePackageTier(
          id: 'pkg_mason_full',
          title: Tr('Full-Day Rajmistri (8 Hrs)', 'फुल-डे सीनियर राजमिस्त्री (8 घंटे)'),
          subtitle: Tr(
            'Complete 8-hour shift for brickwork, plastering or PCC floor',
            'ईंट चुनाई, प्लास्टर या फर्श ढलाई के लिए पूरे 8 घंटे की शिफ्ट',
          ),
          priceRupees: 899,
          originalPriceRupees: 1299,
          durationMinutes: 480,
          isBestseller: true,
        ),
        ServicePackageTier(
          id: 'pkg_mason_team',
          title: Tr('Rajmistri + Beldar Helper (8 Hrs)', 'राजमिस्त्री + बेलदार हेल्पर जोड़ी (8 घंटे)'),
          subtitle: Tr(
            '1 Senior Mason + 1 Mortar/Material Helper for 2X faster work',
            '1 राजमिस्त्री + 1 मसाला/ईंट पकड़ाने वाला बेलदार (दोगुनी तेज़ गति)',
          ),
          priceRupees: 1399,
          originalPriceRupees: 1999,
          durationMinutes: 480,
        ),
      ],
      capabilities: [
        Tr('4-inch & 9-inch brick wall masonry (Chunai)', '4-इंच और 9-इंच ईंट दीवार की चुनाई'),
        Tr('Internal & external smooth cement plastering', 'अंदर और बाहर की दीवारों पर चिकना सीमेंट प्लास्टर'),
        Tr('Bathroom/balcony floor slope & waterproofing screed', 'बाथरूम और बालकनी का ढलान व वाटरप्रूफिंग कोबा'),
        Tr('Manhole chamber, drainage & boundary wall repair', 'मेनहोल चैंबर, नाली और बाउंड्री वॉल मरम्मत'),
      ],
      formFields: [
        ServiceFormField(
          key: 'mason_work_type',
          type: FormFieldType.select,
          label: Tr('Select type of masonry work', 'सिविल / राजमिस्त्री का काम चुनें'),
          options: [
            ServiceFormOption(
              value: 'plaster_patch',
              label: Tr('Wall Plaster / Dampness Repair', 'दीवार प्लास्टर / सीलन रिपेयर'),
            ),
            ServiceFormOption(
              value: 'brickwork',
              label: Tr('Brick Wall Construction (Chunai)', 'नई ईंट दीवार चुनाई'),
              extraPriceRupees: 100,
            ),
            ServiceFormOption(
              value: 'floor_pcc',
              label: Tr('Floor PCC / Slope Correction', 'फर्श ढलाई (PCC) / ढलान सुधार'),
              extraPriceRupees: 150,
            ),
          ],
        ),
        ServiceFormField(
          key: 'mason_days',
          type: FormFieldType.stepper,
          label: Tr('Number of days / shifts needed', 'कितने दिन के लिए मिस्त्री चाहिए?'),
          min: 1,
          max: 10,
          defaultValue: 1,
        ),
      ],
    ),

    // --- 13. TILE, MARBLE & GRANITE FITTING MISTRI ---
    ServiceItem(
      id: 'svc_tile_marble_mistri',
      categoryId: 'cat_masonry_civil',
      name: Tr(
        'Tile, Marble & Granite Fitting Mistri',
        'टाइल, मार्बल और ग्रेनाइट फिटिंग मिस्त्री',
      ),
      tagline: Tr(
        'Laser-level floor & wall tiling, granite kitchen counter, moulding & epoxy grouting',
        'लेज़र-लेवल फ्लोर और वॉल टाइल फिटिंग, किचन ग्रेनाइट स्लैब, मोल्डिंग और एपॉक्सी ग्राउटिंग',
      ),
      description: Tr(
        'Specialist tile & stone craftsmen equipped with electric tile cutters, rubber mallets & laser levels.',
        'इलेक्ट्रिक टाइल कटर, रबर हैमर और लेज़र लेवल से लैस विशेषज्ञ टाइल व मार्बल मिस्त्री।',
      ),
      imageUrl:
          'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&w=800&q=80',
      rating: 4.90,
      bookingsCountLabel: '265K+',
      supportsInstant: true,
      instantEtaMinutes: 30,
      startingPriceRupees: 399,
      originalStartingPriceRupees: 649,
      estimatedDurationMinutes: 180,
      packages: [
        ServicePackageTier(
          id: 'pkg_tile_repair',
          title: Tr('Up to 5 Loose / Broken Tiles Fix', '5 टूटी / उखड़ी टाइलों की रिपेयर'),
          subtitle: Tr(
            'Popped or hollow floor/wall tile re-fixing with adhesive',
            'उखड़ी या खाली आवाज़ करने वाली टाइलों को केमिकल से दोबारा लगाना',
          ),
          priceRupees: 399,
          originalPriceRupees: 649,
          durationMinutes: 90,
        ),
        ServicePackageTier(
          id: 'pkg_tile_grout',
          title: Tr('Bathroom Epoxy Tile Grouting', 'बाथरूम एपॉक्सी टाइल ग्राउटिंग'),
          subtitle: Tr(
            'Leak-proof joint sealing for 1 bathroom floor & walls',
            '1 बाथरूम के टाइल जोड़ों में लीक-प्रूफ एपॉक्सी फिलिंग',
          ),
          priceRupees: 699,
          originalPriceRupees: 1099,
          durationMinutes: 150,
        ),
        ServicePackageTier(
          id: 'pkg_tile_fullday',
          title: Tr('Full-Day Tile/Marble Mistri (8 Hrs)', 'फुल-डे टाइल/मार्बल मिस्त्री (8 घंटे)'),
          subtitle: Tr(
            'Vitrified tiles, granite slab cutting, skirting & moulding',
            'फ्लोर/वॉल टाइल, किचन ग्रेनाइट कटिंग और धार मोल्डिंग (8 घंटे)',
          ),
          priceRupees: 949,
          originalPriceRupees: 1399,
          durationMinutes: 480,
          isBestseller: true,
        ),
      ],
      capabilities: [
        Tr('2×2 & 2×4 vitrified floor tile laying with spacers', 'स्पेसर के साथ 2×2 और 2×4 विट्रीफाइड फ्लोर टाइल फिटिंग'),
        Tr('Kitchen granite counter sink cutout & half-round moulding', 'किचन ग्रेनाइट सिंक कटिंग और हाफ-राउंड मोल्डिंग'),
        Tr('Staircase marble risers, Kota stone & skirting', 'सीढ़ियों पर मार्बल, कोटा स्टोन और स्कर्टिंग फिटिंग'),
      ],
    ),

    // --- 14. EXPERT CARPENTER / BADHAI ---
    ServiceItem(
      id: 'svc_carpenter_work',
      categoryId: 'cat_repairs',
      name: Tr(
        'Expert Carpenter (Badhai) & Furniture Repair',
        'एक्सपर्ट बढ़ई (कारपेंटर) और फर्नीचर रिपेयर',
      ),
      tagline: Tr(
        'Door lock, hinge, hydraulic bed, wardrobe slider, modular kitchen & wood work',
        'दरवाज़ा लॉक, कब्ज़ा, हाइड्रोलिक बेड, अलमारी स्लाइडर, मॉड्यूलर किचन और लकड़ी का काम',
      ),
      description: Tr(
        'On-demand skilled carpenters for quick hardware fixes, furniture assembly or full-day woodwork.',
        'तुरंत हार्डवेयर फिटिंग, फर्नीचर रिपेयर या पूरे दिन के लकड़ी काम के लिए कुशल बढ़ई।',
      ),
      imageUrl:
          'https://images.unsplash.com/photo-1589939705384-5185137a7f0f?auto=format&fit=crop&w=800&q=80',
      rating: 4.88,
      bookingsCountLabel: '530K+',
      supportsInstant: true,
      instantEtaMinutes: 20,
      startingPriceRupees: 149,
      originalStartingPriceRupees: 279,
      estimatedDurationMinutes: 60,
      packages: [
        ServicePackageTier(
          id: 'pkg_carp_lock',
          title: Tr('Door Lock / Hinge / Stopper Fix', 'दरवाज़ा लॉक / कब्ज़ा / कुंडी रिपेयर'),
          subtitle: Tr(
            'Jammed door planing, handle latch or hydraulic closer',
            'अटकते दरवाज़े की रंदा घिसाई, हैंडल या डोर क्लोज़र रिपेयर',
          ),
          priceRupees: 149,
          originalPriceRupees: 279,
          durationMinutes: 45,
        ),
        ServicePackageTier(
          id: 'pkg_carp_furn',
          title: Tr('Bed / Wardrobe / Kitchen Repair', 'बेड / अलमारी / किचन कैबिनेट रिपेयर'),
          subtitle: Tr(
            'Drawer telescopic channel, cabinet hinge or bed dismantling',
            'दराज चैनल, किचन कैबिनेट कब्ज़ा या बेड खोलना/जोड़ना',
          ),
          priceRupees: 299,
          originalPriceRupees: 499,
          durationMinutes: 75,
          isBestseller: true,
        ),
        ServicePackageTier(
          id: 'pkg_carp_fullday',
          title: Tr('Full-Day Carpenter (8 Hrs Dihadi)', 'फुल-डे बढ़ई / कारपेंटर (8 घंटे दिहाड़ी)'),
          subtitle: Tr(
            'Custom plywood shelf, laminate pasting & modular woodwork',
            'प्लाईवुड शेल्फ, सनमाइका पेस्टिंग और कस्टम फर्नीचर काम (8 घंटे)',
          ),
          priceRupees: 849,
          originalPriceRupees: 1299,
          durationMinutes: 480,
        ),
      ],
      capabilities: [
        Tr('Main door mortise/digital lock & peephole installation', 'मेन डोर लॉक, डिजिटल लॉक और पीपहोल इंस्टॉलेशन'),
        Tr('Modular kitchen soft-close hinges & drawer channels', 'मॉड्यूलर किचन सॉफ्ट-क्लोज़ कब्ज़े और दराज चैनल'),
        Tr('Curtain rods, wall mirrors, TV frame & cloth hanger drill', 'पर्दे की रॉड, शीशा और सीलिंग क्लॉथ हैंगर ड्रिलिंग'),
      ],
    ),

    // --- 15. WELDER & IRON / GATE FABRICATOR ---
    ServiceItem(
      id: 'svc_welder_fabricator',
      categoryId: 'cat_masonry_civil',
      name: Tr(
        'On-Site Welder & Iron Gate Fabricator',
        'ऑन-साइट वेल्डर और लोहा गेट/ग्रिल फैब्रिकेटर',
      ),
      tagline: Tr(
        'Main iron gate hinge welding, window safety grill, staircase railing & tin shed work',
        'लोहे के मेन गेट कब्ज़ा वेल्डिंग, खिड़की सेफ्टी ग्रिल, रेलिंग और टिन शेड निर्माण',
      ),
      description: Tr(
        'Certified arc & MIG welders bringing portable inverter welding machine, grinder & safety gear to your doorstep.',
        'पोर्टेबल इन्वर्टर वेल्डिंग मशीन और ग्राइंडर के साथ आपके घर पर तुरंत वेल्डिंग सेवा।',
      ),
      imageUrl:
          'https://images.unsplash.com/photo-1504917595217-d4dc5ebe6122?auto=format&fit=crop&w=800&q=80',
      rating: 4.86,
      bookingsCountLabel: '195K+',
      supportsInstant: true,
      instantEtaMinutes: 25,
      startingPriceRupees: 349,
      originalStartingPriceRupees: 599,
      estimatedDurationMinutes: 60,
      packages: [
        ServicePackageTier(
          id: 'pkg_weld_gate',
          title: Tr('On-Site Gate / Grill Welding', 'गेट / ग्रिल ऑन-साइट वेल्डिंग'),
          subtitle: Tr(
            'Broken gate hinge, latch, lock-plate or railing joint weld',
            'टूटे गेट कब्ज़े, कुंडी या रेलिंग जोड़ की मजबूत आर्क वेल्डिंग',
          ),
          priceRupees: 349,
          originalPriceRupees: 599,
          durationMinutes: 60,
          isBestseller: true,
        ),
        ServicePackageTier(
          id: 'pkg_weld_grill',
          title: Tr('Safety Grill / AC Cage Fitting', 'सेफ्टी ग्रिल / AC लोहे का पिंजरा फिटिंग'),
          subtitle: Tr(
            'Window grill, balcony mesh frame or outdoor AC security cage',
            'खिड़की ग्रिल, बालकनी जाली फ्रेम या आउटडोर AC सेफ्टी केज फिटिंग',
          ),
          priceRupees: 599,
          originalPriceRupees: 999,
          durationMinutes: 150,
        ),
        ServicePackageTier(
          id: 'pkg_weld_fullday',
          title: Tr('Full-Day Welder + Machine (8 Hrs)', 'फुल-डे वेल्डर + वेल्डिंग मशीन (8 घंटे)'),
          subtitle: Tr(
            'Roof tin/profile-sheet shed, iron stairs & heavy fabrication',
            'छत का टिन शेड, लोहे की सीढ़ी और भारी फैब्रिकेशन काम (8 घंटे)',
          ),
          priceRupees: 999,
          originalPriceRupees: 1499,
          durationMinutes: 480,
        ),
      ],
      capabilities: [
        Tr('Portable single-phase inverter welding machine included', 'पोर्टेबल सिंगल-फेज वेल्डिंग मशीन और रॉड शामिल'),
        Tr('Angle grinder cutting, buffing & rust primer touch-up', 'एंगल ग्राइंडर कटिंग, घिसाई और प्राइमर टच-अप'),
        Tr('MS gate, rolling shutter spring & rooftop shed repair', 'लोहे का गेट, शटर स्प्रिंग और रूफ शेड रिपेयर'),
      ],
    ),

    // --- 16. HOUSE PAINTER, WALL PUTTY & WATERPROOFING ---
    ServiceItem(
      id: 'svc_painter_putty',
      categoryId: 'cat_painting_pest',
      name: Tr(
        'House Painter, Wall Putty & Waterproofing',
        'हाउस पेंटर, वॉल पुट्टी और वाटरप्रूफिंग मिस्त्री',
      ),
      tagline: Tr(
        'Damp wall seepage cure, Birla putty, 1-day room repaint, texture & wood/iron enamel',
        'सीलन वाली दीवार का इलाज, बिरला पुट्टी, 1-दिन रूम पेंटिंग और दरवाज़ा/ग्रिल पेंट',
      ),
      description: Tr(
        'Dust-free mechanized sanding, furniture plastic masking & trained painters available per wall, per room or daily dihadi.',
        'फर्नीचर प्लास्टिक कवरिंग और डस्ट-फ्री सैंडिंग के साथ 1 दीवार, 1 कमरा या दिहाड़ी पर कुशल पेंटर।',
      ),
      imageUrl:
          'https://images.unsplash.com/photo-1562259949-e8e7689d7828?auto=format&fit=crop&w=800&q=80',
      rating: 4.87,
      bookingsCountLabel: '380K+',
      supportsInstant: true,
      instantEtaMinutes: 30,
      startingPriceRupees: 499,
      originalStartingPriceRupees: 849,
      estimatedDurationMinutes: 240,
      packages: [
        ServicePackageTier(
          id: 'pkg_paint_wall',
          title: Tr('1 Wall Damp Patch + Repaint', '1 दीवार सीलन रिपेयर + पेंट'),
          subtitle: Tr(
            'Scraping, waterproof coat, 2 coats putty + primer & paint',
            'पपड़ी हटाना, वाटरप्रूफ कोट, पुट्टी + प्राइमर और पेंट',
          ),
          priceRupees: 499,
          originalPriceRupees: 849,
          durationMinutes: 180,
        ),
        ServicePackageTier(
          id: 'pkg_paint_fullday',
          title: Tr('Full-Day Skilled Painter (8 Hrs)', 'फुल-डे कुशल पेंटर (8 घंटे दिहाड़ी)'),
          subtitle: Tr(
            'Hire a pro painter for walls, doors, windows or grill enamel',
            'दीवार, दरवाज़े, खिड़की या लोहे की ग्रिल पेंट के लिए 8 घंटे पेंटर',
          ),
          priceRupees: 799,
          originalPriceRupees: 1199,
          durationMinutes: 480,
          isBestseller: true,
        ),
        ServicePackageTier(
          id: 'pkg_paint_room',
          title: Tr('1 Room Express Repaint (Labour)', '1 कमरा एक्सप्रेस पेंटिंग (लेबर पैक)'),
          subtitle: Tr(
            '2 Painters • Complete 4 walls + ceiling putty touch-up & 2 coats',
            '2 पेंटर • चारों दीवारें + छत टच-अप और 2 कोट फिनिशिंग',
          ),
          priceRupees: 1499,
          originalPriceRupees: 2399,
          durationMinutes: 480,
        ),
      ],
      capabilities: [
        Tr('Crack filling, dampness waterproofing & 2-coat wall putty', 'दरार भरना, सीलन वाटरप्रूफिंग और 2-कोट वॉल पुट्टी'),
        Tr('Plastic drop-cloth masking for beds, sofas & switches', 'बेड, सोफा और स्विचबोर्ड की पूरी प्लास्टिक मास्किंग'),
        Tr('Wood polish (melamine/PU) & iron grill synthetic enamel', 'लकड़ी पॉलिश और लोहे की ग्रिल पर एनामेल पेंट'),
      ],
    ),

    // --- 17. CONSTRUCTION HELPER / BELDAR & SHIFTING LABOUR ---
    ServiceItem(
      id: 'svc_construction_helper',
      categoryId: 'cat_masonry_civil',
      name: Tr(
        'Beldar / Construction Helper & Shifting Labour',
        'बेलदार / निर्माण हेल्पर और शिफ्टिंग मज़दूर',
      ),
      tagline: Tr(
        'Hardworking helpers for cement mortar mixing, brick lifting, demolition, debris removal & house shifting',
        'मसाला मिलाने, ईंट/रेत ढोने, तुड़ाई, मलबा हटाने और घर का भारी सामान शिफ्ट करने के लिए मेहनती बेलदार',
      ),
      description: Tr(
        'Book verified, physically fit daily-wage Beldars & helpers for 2 hours, half-day (4 hrs) or full-day (8 hrs).',
        '2 घंटे, हाफ-डे (4 घंटे) या फुल-डे (8 घंटे) के लिए सत्यापित और मेहनती बेलदार व लोडिंग लेबर बुक करें।',
      ),
      imageUrl:
          'https://images.unsplash.com/photo-1541888946425-d09bb18086f6?auto=format&fit=crop&w=800&q=80',
      rating: 4.85,
      bookingsCountLabel: '610K+',
      supportsInstant: true,
      instantEtaMinutes: 18,
      startingPriceRupees: 249,
      originalStartingPriceRupees: 399,
      estimatedDurationMinutes: 120,
      packages: [
        ServicePackageTier(
          id: 'pkg_beldar_2hr',
          title: Tr('2 Hours Heavy Shifting / Loading', '2 घंटे सामान शिफ्टिंग / लोडिंग लेबर'),
          subtitle: Tr(
            'Furniture moving, truck unloading or rooftop material carry',
            'भारी फर्नीचर शिफ्टिंग, ट्रक अनलोडिंग या छत पर सामान पहुंचाना',
          ),
          priceRupees: 249,
          originalPriceRupees: 399,
          durationMinutes: 120,
        ),
        ServicePackageTier(
          id: 'pkg_beldar_half',
          title: Tr('Half-Day Beldar Helper (4 Hrs)', 'हाफ-डे बेलदार / हेल्पर (4 घंटे)'),
          subtitle: Tr(
            'Site cleaning, malba bagging, digging or mason assistance',
            'साइट सफाई, मलबा कट्टों में भरना, खुदाई या मिस्त्री की मदद',
          ),
          priceRupees: 349,
          originalPriceRupees: 549,
          durationMinutes: 240,
        ),
        ServicePackageTier(
          id: 'pkg_beldar_full',
          title: Tr('Full-Day Beldar / Mazdoor (8 Hrs)', 'फुल-डे बेलदार / मज़दूर (8 घंटे दिहाड़ी)'),
          subtitle: Tr(
            'Complete 8-hour shift for construction, mortar mixing & lifting',
            'निर्माण कार्य, मसाला बनाने और माल ढुलाई के लिए पूरे 8 घंटे',
          ),
          priceRupees: 599,
          originalPriceRupees: 849,
          durationMinutes: 480,
          isBestseller: true,
        ),
        ServicePackageTier(
          id: 'pkg_beldar_pair',
          title: Tr('2 Helpers Team (8 Hrs Shift)', '2 बेलदार / हेल्पर की टीम (8 घंटे)'),
          subtitle: Tr(
            'Ideal for wall/tile demolition, house shifting or bulk unloading',
            'दीवार/टाइल तुड़ाई, घर शिफ्टिंग या भारी माल अनलोडिंग के लिए 2 लेबर',
          ),
          priceRupees: 1099,
          originalPriceRupees: 1599,
          durationMinutes: 480,
        ),
      ],
      capabilities: [
        Tr('Sand, cement & aggregate mortar mixing (Masala banana)', 'रेत, सीमेंट और गिट्टी का मसाला बनाना व पकड़ाना'),
        Tr('Brick, cement bag & tile lifting to upper floors', 'ईंट, सीमेंट कट्टे और टाइल ऊपरी मंजिल तक पहुंचाना'),
        Tr('Old plaster/tile chipping, trench digging & malba bagging', 'पुराना प्लास्टर/टाइल उखाड़ना, खुदाई और मलबा भरना'),
      ],
    ),

    // --- 18. POP, GYPSUM FALSE CEILING & SHUTTERING MISTRI ---
    ServiceItem(
      id: 'svc_pop_false_ceiling',
      categoryId: 'cat_masonry_civil',
      name: Tr(
        'POP, False Ceiling & Shuttering Mistri',
        'POP, जिप्सम फॉल्स सीलिंग और शटरिंग मिस्त्री',
      ),
      tagline: Tr(
        'Gypsum board cove ceiling, POP punning/moulding & RCC slab centring/shuttering',
        'जिप्सम बोर्ड कोव सीलिंग, POP फिनिशिंग/मोल्डिंग और छत की आरसीसी शटरिंग',
      ),
      description: Tr(
        'Specialized POP & false-ceiling artisans for LED cove ceilings, wall punning and structural shuttering.',
        'एलईडी कोव फॉल्स सीलिंग, दीवार POP फिनिशिंग और छत शटरिंग के लिए विशेषज्ञ कारीगर।',
      ),
      imageUrl:
          'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?auto=format&fit=crop&w=800&q=80',
      rating: 4.86,
      bookingsCountLabel: '140K+',
      supportsInstant: false,
      startingPriceRupees: 399,
      originalStartingPriceRupees: 699,
      estimatedDurationMinutes: 240,
      packages: [
        ServicePackageTier(
          id: 'pkg_pop_patch',
          title: Tr('POP Ceiling / Cornice Repair', 'POP सीलिंग / कॉर्निस पैच रिपेयर'),
          subtitle: Tr(
            'Damaged false-ceiling patch, fan hook cutout or joint tape fix',
            'टूटी फॉल्स सीलिंग रिपेयर, पंखे का कटआउट या जॉइंट फिनिशिंग',
          ),
          priceRupees: 399,
          originalPriceRupees: 699,
          durationMinutes: 120,
        ),
        ServicePackageTier(
          id: 'pkg_pop_fullday',
          title: Tr('Full-Day POP / Ceiling Mistri (8 Hrs)', 'फुल-डे POP / फॉल्स सीलिंग मिस्त्री (8 घंटे)'),
          subtitle: Tr(
            'GI channel framing, gypsum board fixing & POP wall punning',
            'GI चैनल फ्रेमिंग, जिप्सम बोर्ड फिटिंग और POP पुनिंग (8 घंटे)',
          ),
          priceRupees: 949,
          originalPriceRupees: 1399,
          durationMinutes: 480,
          isBestseller: true,
        ),
        ServicePackageTier(
          id: 'pkg_shuttering_full',
          title: Tr('RCC Shuttering / Bar-Bender (8 Hrs)', 'छत शटरिंग / सरिया जाल मिस्त्री (8 घंटे)'),
          subtitle: Tr(
            'Slab centring plates, column box shuttering or TMT sariya binding',
            'छत की प्लेट शटरिंग, कॉलम बॉक्स या सरिया (TMT) बांधने का काम',
          ),
          priceRupees: 999,
          originalPriceRupees: 1499,
          durationMinutes: 480,
        ),
      ],
      capabilities: [
        Tr('Gypsum & PVC false ceiling with concealed LED cove', 'कन्सील्ड LED लाइट कोव के साथ जिप्सम और PVC फॉल्स सीलिंग'),
        Tr('Plaster of Paris (POP) smooth wall punning & moulding', 'प्लास्टर ऑफ पेरिस (POP) दीवार फिनिशिंग और डिजाइनर कोर'),
        Tr('RCC lintel, beam, column shuttering & TMT bar bending', 'आरसीसी बीम, कॉलम शटरिंग और सरिया बंधाई'),
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
    ProviderJobOffer(
      offerId: 'OFF-9043',
      bookingId: 'BK-2854',
      serviceName: Tr('Mason / Rajmistri + Beldar (Full Day)', 'राजमिस्त्री + बेलदार हेल्पर (फुल-डे)'),
      packageName: Tr(
        'Brick partition wall & cement plastering (8 Hrs)',
        'ईंट दीवार चुनाई और सीमेंट प्लास्टर (8 घंटे)',
      ),
      isInstant: true,
      customerName: Tr('Rajendra Rathore', 'राजेंद्र राठौड़'),
      addressArea: Tr('Vaishali Nagar, Jaipur', 'वैशाली नगर, जयपुर'),
      fullAddress: Tr(
        'Plot 42, Queens Road, Vaishali Nagar, Jaipur',
        'प्लॉट 42, क्वींस रोड, वैशाली नगर, जयपुर',
      ),
      distanceKm: 1.8,
      etaMinutes: 9,
      grossAmountRupees: 1399,
      platformFeeRupees: 199,
      netPayoutRupees: 1200,
      paymentMode: PaymentMode.cash,
      startOtp: '5924',
      taskChecklist: [
        Tr('Carry trowel (kanni), plumb-bob (sahul) & spirit level', 'कन्नी, साहुल और लेवल टूल साथ रखें'),
        Tr('Verify 4-digit Start OTP (5924) with customer', 'ग्राहक से 4-अंकीय OTP (5924) सत्यापित करें'),
        Tr('Complete 4-inch brickwork & smooth cement plastering', 'ईंट चुनाई और प्लास्टर का काम पूरा करें'),
        Tr('Sweep mortar debris & collect ₹1,399 Cash', 'मलबा साफ करें और ₹1,399 नकद प्राप्त करें'),
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

  /// Synonym keywords per service ID so searching in English, Hindi, or Hinglish
  /// (e.g. "rajmistri", "mistri", "chunai", "tile", "badhai", "beldar", "mazdoor",
  /// "dihadi", "welder", "sariya", "putty", "plumber") finds the exact skilled labour.
  static const Map<String, List<String>> _serviceSearchSynonyms = {
    'svc_house_help': ['maid', 'bai', 'jhadu', 'pocha', 'bartan', 'cook', 'helper', 'housekeeping'],
    'svc_bathroom_clean': ['toilet', 'washroom', 'acid wash', 'tile scrub', 'commode'],
    'svc_full_home_clean': ['sofa', 'kitchen clean', 'deep clean', 'sanitization'],
    'svc_ac_repair': ['air conditioner', 'split ac', 'window ac', 'gas refill', 'cooling', 'foam jet'],
    'svc_ro_repair': ['water purifier', 'kent', 'aquaguard', 'filter', 'membrane', 'tds'],
    'svc_electrician': ['bijli', 'light', 'fan', 'mcb', 'switch', 'wiring', 'inverter', 'fuse'],
    'svc_plumber': ['nal', 'pipe', 'leakage', 'tap', 'tank', 'flush', 'drain', 'motor'],
    'svc_women_salon': ['beauty', 'parlour', 'waxing', 'facial', 'threading', 'pedicure'],
    'svc_women_spa': ['massage', 'therapy', 'ayurvedic', 'body spa'],
    'svc_men_grooming': ['barber', 'haircut', 'beard', 'shave', 'champi', 'nai'],
    'svc_pest_control': ['cockroach', 'termite', 'deemak', 'khatmal', 'bedbug', 'spray'],
    'svc_masonry_civil': [
      'mason', 'masonry', 'rajmistri', 'mistri', 'kadiya', 'brick', 'chunai',
      'plaster', 'cement', 'concrete', 'pcc', 'civil', 'wall', 'construction',
      'labour', 'labor', 'dihadi', 'theka', 'राजमिस्त्री', 'मिस्त्री', 'चुनाई', 'प्लास्टर',
    ],
    'svc_tile_marble_mistri': [
      'tile', 'tiles', 'marble', 'granite', 'stone', 'kota', 'grouting', 'epoxy',
      'flooring', 'moulding', 'skirting', 'mistri', 'टाइल', 'मार्बल', 'ग्रेनाइट',
    ],
    'svc_carpenter_work': [
      'carpenter', 'badhai', 'khati', 'wood', 'furniture', 'door', 'lock',
      'hinge', 'almirah', 'wardrobe', 'bed', 'plywood', 'sunmica', 'laminate',
      'बढ़ई', 'कारपेंटर', 'फर्नीचर', 'दरवाजा',
    ],
    'svc_welder_fabricator': [
      'welder', 'welding', 'fabricator', 'fabrication', 'iron', 'loha', 'gate',
      'grill', 'railing', 'shutter', 'shed', 'tin', 'arc', 'वेल्डर', 'वेल्डिंग', 'लोहा',
    ],
    'svc_painter_putty': [
      'painter', 'painting', 'paint', 'putty', 'birla', 'whitewash', 'distemper',
      'waterproofing', 'seepage', 'damp', 'polish', 'enamel', 'पेंटर', 'पुट्टी', 'पेंट',
    ],
    'svc_construction_helper': [
      'helper', 'beldar', 'mazdoor', 'majdoor', 'labour', 'labor', 'dihadi',
      'loading', 'unloading', 'shifting', 'coolie', 'demolition', 'malba',
      'digging', 'masala', 'बेलदार', 'मज़दूर', 'लेबर', 'दिहाड़ी', 'हेल्पर',
    ],
    'svc_pop_false_ceiling': [
      'pop', 'false ceiling', 'gypsum', 'pvc ceiling', 'cornice', 'shuttering',
      'centring', 'sariya', 'bar bender', 'rcc', 'slab', 'शटरिंग', 'फॉल्स सीलिंग', 'सरिया',
    ],
  };

  /// Full-text + bilingual + Hinglish synonym search across all services.
  static List<ServiceItem> searchServices(
    String rawQuery, {
    String categoryId = 'ALL',
  }) {
    final q = rawQuery.trim().toLowerCase();
    return services.where((s) {
      final matchesCat = categoryId == 'ALL' || s.categoryId == categoryId;
      if (!matchesCat) return false;
      if (q.isEmpty) return true;

      if (s.name.en.toLowerCase().contains(q) ||
          s.name.hi.toLowerCase().contains(q) ||
          s.tagline.en.toLowerCase().contains(q) ||
          s.tagline.hi.toLowerCase().contains(q) ||
          s.description.en.toLowerCase().contains(q) ||
          s.description.hi.toLowerCase().contains(q)) {
        return true;
      }

      for (final cap in s.capabilities) {
        if (cap.en.toLowerCase().contains(q) ||
            cap.hi.toLowerCase().contains(q)) {
          return true;
        }
      }

      for (final pkg in s.packages) {
        if (pkg.title.en.toLowerCase().contains(q) ||
            pkg.title.hi.toLowerCase().contains(q) ||
            pkg.subtitle.en.toLowerCase().contains(q) ||
            pkg.subtitle.hi.toLowerCase().contains(q)) {
          return true;
        }
      }

      final synonyms = _serviceSearchSynonyms[s.id] ?? const [];
      for (final syn in synonyms) {
        if (syn.toLowerCase().contains(q) || q.contains(syn.toLowerCase())) {
          return true;
        }
      }

      return false;
    }).toList();
  }
}

