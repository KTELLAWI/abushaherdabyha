// // ignore_for_file: prefer_single_quotes, lines_longer_than_80_chars final
// Map<String, dynamic> environment = {
//   "appConfig":"https://bojee.codlar.com//wp-json/wc/v2/flutter/cache?lang=ar",
//   //"lib/config/config_en.json",

//   "serverConfig": {
//     /// 🌍 The register URL domain that matches with Envato Purchase Code
//     /// 🔑 Also, make sure to update the envatoPurchaseCode from configs/env.props
//     'url': 'https://bojee.codlar.com/',
//     'type': 'woo',
//     'consumerKey': 'ck_c567bc248cd968a1d5f91f36acb7d51df56b8297',
//     'consumerSecret': 'cs_42a2ea85000467b73284084320a2147119d69545',

//     /// Wordpress blog, it could be removed if using the same above url
//     //'blog': 'https://mstore.io',
//   },

//   /// ➡️ lib/common/config/general.dart
//   "defaultDarkTheme": false,
//   "enableRemoteConfigFirebase": false,
//   "enableFirebaseAnalytics": false,
//   "loginSMSConstants": {
//     "countryCodeDefault": "US",
//     "dialCodeDefault": "+1",
//     "nameDefault": "United States",
//   },
//   "phoneNumberConfig": {
//     "enablePhoneNumberValidation": false,
//     "countryCodeDefault": "US",
//     "dialCodeDefault": "+1",
//     "useInternationalFormat": true,
//     "selectorFlagAsPrefixIcon": true,
//     "showCountryFlag": true,
//     "customCountryList": [], // List alpha_2_code. E.g: ["VN", "AU"]
//     "selectorType": "BOTTOM_SHEET", // [DROPDOWN, BOTTOM_SHEET, DIALOG]
//   },
//   "storeIdentifier": {
//     "disable": true,
//     "android": "com.bojeestore.digistacks",
//     "ios": "1469772800"
//   },
//   "advanceConfig": {
//     "DefaultLanguage": "ar",
//     "DetailedBlogLayout": "halfSizeImageType",
//     "EnablePointReward": false,
//     "hideOutOfStock": false,
//     "HideEmptyTags": true,
//     "HideEmptyCategories": true,
//     "EnableRating": true,
//     "hideEmptyProductListRating": true,

//     "EnableCart": true,

//     /// Enable search by SKU in search screen
//     "EnableSkuSearch": true,

//     /// Show stock Status on product List & Product Detail
//     "showStockStatus": true,

//     /// Gird count setting on Category screen
//     "GridCount": 3,

//     /// set isCaching to true if you have upload the config file to mstore-api
//     /// set kIsResizeImage to true if you have finished running Re-generate image plugin
//     /// ref: https://support.inspireui.com/help-center/articles/3/8/19/app-performance
//     "isCaching": tue,
//     "kIsResizeImage": true,
//     "httpCache": true,

//     /// Stripe payment only: set currencyCode and smallestUnitRate.
//     /// All API requests expect amounts to be provided in a currency’s smallest unit.
//     /// For example, to charge 10 USD, provide an amount value of 1000 (i.e., 1000 cents).
//     /// Reference: https://stripe.com/docs/currencies#zero-decimal
//     "DefaultCurrency": {
//       "symbol": "\$",
//       "decimalDigits": 2,
//       "symbolBeforeTheNumber": true,
//       "currency": "USD",
//       "currencyCode": "usd",
//       "smallestUnitRate": 100,

//       /// 100 cents = 1 usd
//     },
//     "Currencies": [
//       {
//         "symbol": "\$",
//         "decimalDigits": 2,
//         "symbolBeforeTheNumber": true,
//         "currency": "USD",
//         "currencyCode": "USD",
//         "smallestUnitRate": 100,

//         /// 100 cents = 1 usd
//       },
//       {
//         "symbol": "₹",
//         "decimalDigits": 0,
//         "symbolBeforeTheNumber": true,
//         "currency": "INR",
//         "currencyCode": "INR",
//       },
//       {
//         "symbol": "đ",
//         "decimalDigits": 2,
//         "symbolBeforeTheNumber": false,
//         "currency": "VND",
//         "currencyCode": "VND",
//       },
//       {
//         "symbol": "€",
//         "decimalDigits": 2,
//         "symbolBeforeTheNumber": true,
//         "currency": "EUR",
//         "currencyCode": "EUR",
//       },
//       {
//         "symbol": "£",
//         "decimalDigits": 2,
//         "symbolBeforeTheNumber": true,
//         "currency": "Pound sterling",
//         "currencyCode": "GBP",
//         "smallestUnitRate": 100,

//         /// 100 pennies = 1 pound
//       },
//       {
//         'symbol': 'AR\$',
//         'decimalDigits': 2,
//         'symbolBeforeTheNumber': true,
//         'currency': 'ARS',
//         'currencyCode': 'ARS',
//       },
//       {
//         'symbol': 'R',
//         'decimalDigits': 2,
//         'symbolBeforeTheNumber': true,
//         'currency': 'ZAR',
//         'currencyCode': 'ZAR',
//       }
//     ],

//     /// Below config is used for Magento store
//     "DefaultStoreViewCode": "",
//     "EnableAttributesConfigurableProduct": ["color", "size"],
//     "EnableAttributesLabelConfigurableProduct": ["color", "size"],

//     /// if the woo commerce website supports multi languages
//     /// set false if the website only have one language
//     "isMultiLanguages": true,

//     ///Review gets approved automatically on woocommerce admin without requiring administrator to approve.
//     "EnableApprovedReview": false,

//     /// Sync Cart from website and mobile
//     "EnableSyncCartFromWebsite": false,
//     "EnableSyncCartToWebsite": false,

//     /// Enable firebase to support FCM, realtime chat for Fluxstore MV
//     "EnableFirebase": true,

//     /// ratio Product Image, default value is 1.2 = height / width
//     "RatioProductImage": 1.2,

//     /// Enable Coupon Code When checkout
//     "EnableCouponCode": true,

//     /// Enable to Show Coupon list.
//     "ShowCouponList": true,

//     /// Enable this will show all coupons in Coupon list.
//     /// Disable will show only coupons which is restricted to the current user"s email.
//     "ShowAllCoupons": true,

//     /// Show expired coupons in Coupon list.
//     "ShowExpiredCoupons": true,
//     "AlwaysShowTabBar": false,

//     /// Privacy Policies page ID. Accessible in the app via Settings > Privacy menu.
//     "PrivacyPoliciesPageId": 25569,

//     /// If page id null
//     /// Privacy Policies page Url. Accessible in the app via Settings > Privacy menu.
//     "PrivacyPoliciesPageUrl": "https://policies.google.com/",

//     "SupportPageUrl": "https://support.inspireui.com/",

//     "DownloadPageUrl": 'https://mstore.io/#download',

//     "SocialConnectUrl": [
//       {
//         "name": "Facebook",
//         "icon": "assets/icons/logins/facebook.png",
//         "url": "https://www.facebook.com/inspireui"
//       },
//       {
//         "name": "Instagram",
//         "icon": "assets/icons/logins/instagram.png",
//         "url": "https://www.instagram.com/inspireui9/"
//       },
//     ],

//     "AutoDetectLanguage": false,
//     "QueryRadiusDistance": 10,
//     "MinQueryRadiusDistance": 1,

//     /// Distance by km
//     "MaxQueryRadiusDistance": 10,

//     /// Enable Membership Pro Ultimate WP
//     "EnableMembershipUltimate": false,

//     /// Enable Paid Membership Pro
//     "EnablePaidMembershipPro": false,

//     /// Enable Delivery Date when doing checkout
//     "EnableDeliveryDateOnCheckout": true,

//     /// Enable new SMS Login
//     "EnableNewSMSLogin": false,

//     /// Enable bottom add to cart from product card view
//     "EnableBottomAddToCart": true,

//     /// Disable inAppWebView to use webview_flutter
//     /// so webview can navigate to external app.
//     /// Useful for webview checkout which need to handle payment in another app.
//     "inAppWebView": false,
//     'AlwaysClearWebViewCache': false,
//     "WebViewScript": "",

//     'AlwaysRefreshBlog': false,

//     ///support multi currency via WOOCS – Currency Switcher for WooCommerce plugin (https://wordpress.org/plugins/woocommerce-currency-switcher/)
//     "EnableWOOCSCurrencySwitcher": true,

//     /// Enable product backdrop layout - https://tppr.me/L5Pnf
//     "enableProductBackdrop": false,

//     /// false: show category menu as Text https://tppr.me/v3bLI
//     /// true: show as Category Image
//     "categoryImageMenu": true,

//     ///Support Digits : WordPress Mobile Number Signup and Login plugin (https://codecanyon.net/item/digits-wordpress-mobile-number-signup-and-login/19801105)
//     "EnableDigitsMobileLogin": false,
//     "EnableDigitsMobileFirebase": false,

//     /// Enable Ajax Search Pro, https://your-domain/wp-json/ajax-search-pro/v0/woo_search?s=
//     "AjaxSearchURL": "",

//     "gdpr": {
//       "showPrivacyPolicyFirstTime": false,
//       "showDeleteAccount": true,
//       "confirmCaptcha": "PERMANENTLY DELETE",
//     },

//     /// show order notes in order detail with private notes
//     "OrderNotesWithPrivateNote": true,

//     "OrderNotesLinkSupport": false,

//     /// Just accept select the country on this list
//     /// example: {"vn", "ae"}
//     "supportCountriesShipping": null,

//     // Enable the request Notify permission from onboarding
//     "showRequestNotification": true,

//     "EnableVersionCheck": false,
//     "inAppUpdateForAndroid": {
//       "enable": true,
//       // "flexible, immediate"
//       "typeUpdate": "flexible",
//     },
//     "categoryConfig": {
//       // Enable this option when the store has more than 100 category items
//       "enableLargeCategories": false,
//       "deepLevel": 3,
//     },

//     /// Example: "pinnedProductTags": ["feature", "new"],
//     /// will show the tag before product title in the product list.
//     "pinnedProductTags": [],
//   },
//   "defaultDrawer": {
//     "logo": "assets/images/logo.png",
//     "background": null,
//     "items": [
//       {"type": "home", "show": true},
//       {"type": "blog", "show": true},
//       {"type": "categories", "show": true},
//       {"type": "cart", "show": true},
//       {"type": "profile", "show": true},
//       {"type": "login", "show": true},
//       {"type": "category", "show": true}
//     ]
//   },
//   "defaultSettings": [
//     "biometrics",
//     "products",
//     "chat",
//     "wishlist",
//     "notifications",
//     "language",
//     "currencies",
//     "darkTheme",
//     "order",
//     "point",
//     "rating",
//     "privacy",
//     "about",
//   ],
//   "loginSetting": {
//     "IsRequiredLogin": false,
//     "showAppleLogin": true,
//     "showFacebook": false,
//     "showSMSLogin": true,
//     "showGoogleLogin": true,
//     "showPhoneNumberWhenRegister": false,
//     "requirePhoneNumberWhenRegister": false,
//     "isResetPasswordSupported": true,
//     "smsLoginAsDefault": false,

//     /// For Facebook login.
//     /// These configs are only used for FluxBuilder's Auto build feature.
//     /// To update manually, follow this below doc:
//     /// https://support.inspireui.com/help-center/articles/42/44/32/social-login#login
//     "facebookAppId": "430258564493822",
//     "facebookLoginProtocolScheme": "fb430258564493822",
//   },
//   "oneSignalKey": {
//     "enable": false,
//     "appID": "8b45b6db-7421-45e1-85aa-75e597f62714"
//   },

//   /// ➡️ lib/common/onboarding.dart
//   "onBoardingData": [
//     {
//       'title': 'Welcome to FluxStore',
//       'image': 'assets/images/fogg-delivery-1.png',
//       'desc': 'Fluxstore is on the way to serve you. '
//     },
//     {
//       'title': 'Connect Surrounding World',
//       'image': 'assets/images/fogg-uploading-1.png',
//       'desc':
//           'See all things happening around you just by a click in your phone. Fast, convenient and clean.'
//     },
//     {
//       'title': "Let's Get Started",
//       'image': 'assets/images/fogg-order-completed.png',
//       'desc': "Waiting no more, let's see what we get!"
//     }
//   ],

//   "vendorOnBoardingData": [
//     {
//       'title': 'Welcome aboard',
//       'image': 'assets/images/searching.png',
//       'desc': 'Just a few more steps to become our vendor'
//     },
//     {
//       'title': 'Let\'s Get Started',
//       'image': 'assets/images/manage.png',
//       'desc': 'Good Luck for great beginnings.'
//     }
//   ],

//   /// ➡️ lib/common/advertise.dart
//   "adConfig": {
//     "enable": false,
//     "facebookTestingId": "",
//     "googleTestingId": [],
//     "ads": [
//       {
//         "type": "banner",
//         "provider": "google",
//         "iosId": "ca-app-pub-3940256099942544/2934735716",
//         "androidId": "ca-app-pub-3940256099942544/6300978111",
//         "showOnScreens": ["home", "search"],
//         "waitingTimeToDisplay": 2,
//       },
//       {
//         "type": "banner",
//         "provider": "google",
//         "iosId": "ca-app-pub-2101182411274198/5418791562",
//         "androidId": "ca-app-pub-2101182411274198/4052745095",

//         /// "showOnScreens": ["home", "category", "product-detail"],
//       },
//       {
//         "type": "interstitial",
//         "provider": "google",
//         "iosId": "ca-app-pub-3940256099942544/4411468910",
//         "androidId": "ca-app-pub-3940256099942544/4411468910",
//         "showOnScreens": ["profile"],
//         "waitingTimeToDisplay": 5,
//       },
//       {
//         "type": "reward",
//         "provider": "google",
//         "iosId": "ca-app-pub-3940256099942544/1712485313",
//         "androidId": "ca-app-pub-3940256099942544/4411468910",
//         "showOnScreens": ["cart"],

//         /// "waitingTimeToDisplay": 8,
//       },
//       {
//         "type": "banner",
//         "provider": "facebook",
//         "iosId": "IMG_16_9_APP_INSTALL#430258564493822_876131259906548",
//         "androidId": "IMG_16_9_APP_INSTALL#430258564493822_489007588618919",
//         "showOnScreens": ["home"],

//         /// "waitingTimeToDisplay": 8,
//       },
//       {
//         "type": "interstitial",
//         "provider": "facebook",
//         "iosId": "430258564493822_489092398610438",
//         "androidId": "IMG_16_9_APP_INSTALL#430258564493822_489092398610438",

//         /// "showOnScreens": ["profile"],
//         /// "waitingTimeToDisplay": 8,
//       },
//     ],

//     /// "adMobAppId" is only used for FluxBuilder's Auto build feature.
//     /// To update manually, follow this below doc:
//     /// https://support.inspireui.com/help-center/articles/42/44/17/admob-and-facebook-ads#2-setup-google-admob-for-flutter
//     "adMobAppIdIos": "ca-app-pub-7432665165146018~2664444130",
//     "adMobAppIdAndroid": "ca-app-pub-7432665165146018~2664444130",
//   },

//   /// ➡️ lib/common/dynamic_link.dart
//   "firebaseDynamicLinkConfig": {
//     "isEnabled": true,
//     "shortDynamicLinkEnable": true,

//     /// Domain is the domain name for your product.
//     /// Let’s assume here that your product domain is “example.com”.
//     /// Then you have to mention the domain name as : https://example.page.link.
//     "uriPrefix": "https://fluxstoreinspireui.page.link",
//     //The link your app will open
//     "link": "https://mstore.io/",
//     //----------* Android Setting *----------//
//     "androidPackageName": "com.bojeestore.digistacks",
//     "androidAppMinimumVersion": 1,
//     //----------* iOS Setting *----------//
//     "iOSBundleId": "com.inspireui.mstore.flutter",
//     "iOSAppMinimumVersion": "1.0.1",
//     "iOSAppStoreId": "1469772800"
//   },

//   /// ➡️ lib/common/languages.dart
//   "languagesInfo": [
//     // 1 English - en.arb
//     {
//       "name": "English",
//       "icon": "assets/images/country/gb.png",
//       "code": "en",
//       "text": "English",
//       "storeViewCode": ""
//     },
//     // 3 Hindi - hi.arb
//     {
//       "name": "Hindi",
//       "icon": "assets/images/country/in.png",
//       "code": "hi",
//       "text": "हिन्दी",
//       "storeViewCode": "hi"
//     },
//     // 4 Spanish - es.arb
//     {
//       "name": "Spanish",
//       "icon": "assets/images/country/es.png",
//       "code": "es",
//       "text": "Español",
//       "storeViewCode": ""
//     },
//     // 5 French - fr.arb
//     {
//       "name": "French",
//       "icon": "assets/images/country/fr.png",
//       "code": "fr",
//       "text": "Français",
//       "storeViewCode": "fr"
//     },
//     // 6 Arabic ar.arb
//     {
//       "name": "Arabic",
//       "icon": "assets/images/country/ar.png",
//       "code": "ar",
//       "text": "العربية",
//       "storeViewCode": "ar"
//     },
//     // 7 Russian ru.arb
//     {
//       "name": "Russian",
//       "icon": "assets/images/country/ru.png",
//       "code": "ru",
//       "text": "Русский",
//       "storeViewCode": "ru"
//     },
//     // 8 Indonesian id.arb
//     {
//       "name": "Indonesian",
//       "icon": "assets/images/country/id.png",
//       "code": "id",
//       "text": "Bahasa Indonesia",
//       "storeViewCode": "id"
//     },
//     // 9 Japanese ja.arb
//     {
//       "name": "Japanese",
//       "icon": "assets/images/country/ja.png",
//       "code": "ja",
//       "text": "日本語",
//       "storeViewCode": ""
//     },
//     // 10 Korean ko.arb
//     {
//       "name": "Korean",
//       "icon": "assets/images/country/ko.png",
//       "code": "ko",
//       "text": "한국어/조선말",
//       "storeViewCode": "ko"
//     },
//     // 11 Vietnamese vi.arb
//     {
//       "name": "Vietnamese",
//       "icon": "assets/images/country/vn.png",
//       "code": "vi",
//       "text": "Tiếng Việt",
//       "storeViewCode": ""
//     },
//     // 12 Romanian ro.arb
//     {
//       "name": "Romanian",
//       "icon": "assets/images/country/ro.png",
//       "code": "ro",
//       "text": "Românește",
//       "storeViewCode": "ro"
//     },
//     // 13 Turkish - tr.arb
//     {
//       "name": "Turkish",
//       "icon": "assets/images/country/tr.png",
//       "code": "tr",
//       "text": "Türkçe",
//       "storeViewCode": "tr"
//     },
//     // 14 Italian - it.arb
//     {
//       "name": "Italian",
//       "icon": "assets/images/country/it.png",
//       "code": "it",
//       "text": "Italiano",
//       "storeViewCode": "it"
//     },
//     // 15 German - de.arb
//     {
//       "name": "German",
//       "icon": "assets/images/country/de.png",
//       "code": "de",
//       "text": "Deutsch",
//       "storeViewCode": "de"
//     },
//     // 16 Portuguese - pt.arb
//     {
//       "name": "Portuguese",
//       "icon": "assets/images/country/pt.png",
//       "code": "pt",
//       "text": "Português",
//       "storeViewCode": "pt"
//     },
//     // 17 Hungarian - hu.arb
//     {
//       "name": "Hungarian",
//       "icon": "assets/images/country/hu.png",
//       "code": "hu",
//       "text": "Magyar nyelv",
//       "storeViewCode": "hu"
//     },
//     // 18 Hebrew - he.arb
//     {
//       "name": "Hebrew",
//       "icon": "assets/images/country/he.png",
//       "code": "he",
//       "text": "עִבְרִית",
//       "storeViewCode": "he"
//     },
//     // 19 Thai - th.arb
//     {
//       "name": "Thai",
//       "icon": "assets/images/country/th.png",
//       "code": "th",
//       "text": "ภาษาไทย",
//       "storeViewCode": "th"
//     },
//     // 20 Dutch - nl.arb
//     {
//       "name": "Dutch",
//       "icon": "assets/images/country/nl.png",
//       "code": "nl",
//       "text": "Nederlands",
//       "storeViewCode": "nl"
//     },
//     // 21 Serbian - sr.arb
//     {
//       "name": "Serbian",
//       "icon": "assets/images/country/sr.jpeg",
//       "code": "sr",
//       "text": "српски",
//       "storeViewCode": "sr"
//     },
//     // 22 Polish - pl.arb
//     {
//       "name": "Polish",
//       "icon": "assets/images/country/pl.png",
//       "code": "pl",
//       "text": "Język polski",
//       "storeViewCode": "pl"
//     },
//     // 23 Persian - fa.arb
//     {
//       "name": "Persian",
//       "icon": "assets/images/country/fa.png",
//       "code": "fa",
//       "text": "زبان فارسی",
//       "storeViewCode": ""
//     },
//     // 24 Ukrainian - uk.arb
//     {
//       "name": "Ukrainian",
//       "icon": "assets/images/country/uk.png",
//       "code": "uk",
//       "text": "Українська мова",
//       "storeViewCode": ""
//     },
//     // 25 Bengali - bn.arb
//     {
//       "name": "Bengali",
//       "icon": "assets/images/country/bn.png",
//       "code": "bn",
//       "text": "বাংলা",
//       "storeViewCode": ""
//     },
//     // 26 Tamil - ta.arb
//     {
//       "name": "Tamil",
//       "icon": "assets/images/country/ta.png",
//       "code": "ta",
//       "text": "தமிழ்",
//       "storeViewCode": ""
//     },
//     // 27 Kurdish - ku.arb
//     {
//       "name": "Kurdish",
//       "icon": "assets/images/country/ku.png",
//       "code": "ku",
//       "text": "Kurdî / کوردی",
//       "storeViewCode": ""
//     },
//     // 28 Czech - cs.arb
//     {
//       "name": "Czech",
//       "icon": "assets/images/country/cs.png",
//       "code": "cs",
//       "text": "Čeština",
//       "storeViewCode": "cs"
//     },
//     // 29 Swedish sv.arb
//     {
//       "name": "Swedish",
//       "icon": "assets/images/country/sv.png",
//       "code": "sv",
//       "text": "Svenska",
//       "storeViewCode": ""
//     },
//     // 30 Finland fi.arb
//     {
//       "name": "Finland",
//       "icon": "assets/images/country/fi.png",
//       "code": "fi",
//       "text": "Suomi",
//       "storeViewCode": ""
//     },
//     // 31 Greek el.arb
//     {
//       "name": "Greek",
//       "icon": "assets/images/country/el.png",
//       "code": "el",
//       "text": "Ελληνικά",
//       "storeViewCode": ""
//     },
//     // 32 Khmer km.arb
//     {
//       "name": "Khmer",
//       "icon": "assets/images/country/km.png",
//       "code": "km",
//       "text": "ភាសាខ្មែរ",
//       "storeViewCode": ""
//     },
//     // 33 Kannada intl_kn.arb
//     {
//       "name": "Kannada",
//       "icon": "assets/images/country/kn.png",
//       "code": "kn",
//       "text": "ಕನ್ನಡ",
//       "storeViewCode": ""
//     },
//     // 34 Marathi intl_mr.arb
//     {
//       "name": "Marathi",
//       "icon": "assets/images/country/mr.jpeg",
//       "code": "mr",
//       "text": "मराठी भाषा",
//       "storeViewCode": ""
//     },
//     // 35 Malay intl_ms.arb
//     {
//       "name": "Malay",
//       "icon": "assets/images/country/ms.jpeg",
//       "code": "ms",
//       "text": "بهاس ملايو",
//       "storeViewCode": ""
//     },
//     // 36 Bosnian intl_bs.arb
//     {
//       "name": "Bosnian",
//       "icon": "assets/images/country/bs.png",
//       "code": "bs",
//       "text": "босански",
//       "storeViewCode": ""
//     },
//     // 37 Lao intl_lo.arb
//     {
//       "name": "Lao",
//       "icon": "assets/images/country/lo.png",
//       "code": "lo",
//       "text": "ພາສາລາວ",
//       "storeViewCode": ""
//     },
//     // 38 Slovak intl_sk.arb
//     {
//       "name": "Slovak",
//       "icon": "assets/images/country/sk.png",
//       "code": "sk",
//       "text": "Slovaščina",
//       "storeViewCode": ""
//     },
//     // 39 Swahili intl_sw.arb
//     {
//       "name": "Swahili",
//       "icon": "assets/images/country/sw.png",
//       "code": "sw",
//       "text": "كِيْسَوَاحِيْلِيْ",
//       "storeViewCode": ""
//     },
//     // 2 zh-Chinese
//     {
//       "name": "Chinese",
//       "icon": "assets/images/country/zh.png",
//       "code": "zh",
//       "text": "中文",
//       "storeViewCode": ""
//     },
//     // 40 Chinese Traditional intl_zh_Hant.arb
//     {
//       "name": "Chinese (traditional)",
//       "icon": "assets/images/country/zh.png",
//       "code": "zh_TW",
//       "text": "漢語",
//       "storeViewCode": ""
//     },
//     // 41 Chinese Simplified intl_zh_Hans.arb
//     {
//       "name": "Chinese (simplified)",
//       "icon": "assets/images/country/zh.png",
//       "code": "zh_CN",
//       "text": "汉语",
//       "storeViewCode": ""
//     },
//     // 42 Burmese intl_my.arb
//     {
//       "name": "Burmese",
//       "icon": "assets/images/country/my.png",
//       "code": "my",
//       "text": "မြန်မာဘာသာစကား",
//       "storeViewCode": ""
//     },
//     // 43 Albanian intl_sq.arb
//     {
//       "name": "Albanian",
//       "icon": "assets/images/country/sq.png",
//       "code": "sq",
//       "text": "Shqip",
//       "storeViewCode": ""
//     },
//     // 44 Danish intl_da.arb
//     {
//       "name": "Danish",
//       "icon": "assets/images/country/da.svg",
//       "code": "da",
//       "text": "Dansk",
//       "storeViewCode": ""
//     },
//     // 45 Tigrinya intl_ti.arb
//     {
//       "name": "Tigrinya",
//       "icon": "assets/images/country/er.png",
//       "code": "ti",
//       "text": "ትግርኛ",
//       "storeViewCode": "ti"
//     },
//     // 46 Urdu intl_ur.arb
//     {
//       "name": "Urdu",
//       "icon": "assets/images/country/pk.png",
//       "code": "ur",
//       "text": "اُردُو",
//       "storeViewCode": ""
//     },
//     // 47 Azerbaijani intl_az.arb
//     {
//       "name": "Azerbaijani",
//       "icon": "assets/images/country/az.jpg",
//       "code": "az",
//       "text": "Azərbaycan dili",
//       "storeViewCode": ""
//     },
//   ],

//   /// ➡️  lib/common/config/payments.dart
//   "paymentConfig": {
//     "DefaultCountryISOCode": "US",

//     "DefaultStateISOCode": "LA",

//     /// Enable the Shipping option from Checkout, support for the Digital Download
//     "EnableShipping": true,

//     /// Enable the address shipping.
//     /// Set false if use for the app like Download Digial Asset which is not required the shipping feature.
//     "EnableAddress": true,

//     /// Allow customers to add note when order
//     "EnableCustomerNote": true,

//     /// Allow customers to add address location link to order note
//     "EnableAddressLocationNote": false,

//     /// Allow both alphabetical and numerical characters in ZIP code
//     "EnableAlphanumericZipCode": false,

//     /// Enable the product review option
//     "EnableReview": true,

//     /// Enable the Google Maps picker from Billing Address.
//     "allowSearchingAddress": true,

//     "GuestCheckout": true,

//     /// Enable Payment option
//     "EnableOnePageCheckout": false,
//     "NativeOnePageCheckout": false,

//     "ShowWebviewCheckoutSuccessScreen": true,

//     /// This config is same with checkout page slug in the website
//     "CheckoutPageSlug": {"en": "checkout"},

//     /// Enable Credit card payment (only available for Fluxstore Shopipfy)
//     "EnableCreditCard": false,

//     /// Enable update order status to processing after checkout by COD on woo commerce
//     "UpdateOrderStatus": false,

//     /// Show order notes in order history detail.
//     "ShowOrderNotes": true,

//     /// Show Refund and Cancel button on Order Detail
//     "EnableRefundCancel": true,

//     /// If the order completed date is after this period (days), the refund button will be hidden.
//     "RefundPeriod": 7,

//     /// Apply the extra fee for the COD method
//     /// amountStop: Amount to stop charge the extra fee
//     "SmartCOD": {"enabled": true, "extraFee": 10, "amountStop": 200},

//     /// List ids to hide some unnecessary payment methods
//     "excludedPaymentIds": [],
//   },
//   "payments": {
//     "stripe_v2_apple_pay": "assets/icons/payment/apple-pay-mark.svg",
//     "stripe_v2_google_pay": "assets/icons/payment/google-pay-mark.png",
//     "paypal": "assets/icons/payment/paypal.svg",
//     "stripe": "assets/icons/payment/stripe.svg",
//     "razorpay": "assets/icons/payment/razorpay.svg",
//     "tap": "assets/icons/payment/tap.png"
//   },
//   "shopifyPaymentConfig": {
//     "shopName": "FluxStore",
//     "countryCode": "US",
//     "productionMode": false,
//     "paymentCardConfig": {
//       "enable": true,
//       "serverEndpoint": "https://test-stripe-nine.vercel.app",
//     },
//     "applePayConfig": {
//       "enable": true,
//       "merchantId": "merchant.com.bojeestore.digistacks",
//     },
//     "googlePayConfig": {
//       "enable": true,
//       "stripePublishableKey": "pk_test_O3awus9i5mA2wIX9a7pU3MSi00gZPcpJWX",
//       "merchantId": "merchant.com.bojeestore.digistacks"
//     },
//   },
//   "stripeConfig": {
//     "serverEndpoint": "https://stripe-server-node.vercel.app",
//     "publishableKey":
//         "pk_test_51HNabPCinksNdU0OwGkZ6uMdZOrLT42NGJkBxmVJwx3oM5mafpJaQRfDHifJMg2iREDZxbPkR1TvDtmBeTyjmgv200mCojR2dG",
//     "paymentMethodIds": ["stripe"],
//     "enabled": true,
//     "enableApplePay": true,
//     "enableGooglePay": true,
//     "merchantDisplayName": "FluxStore",
//     "merchantIdentifier": "merchant.com.inspireui.mstore.flutter",
//     "merchantCountryCode": "US",
//     "useV1": false,
//     "returnUrl": "fluxstore://inspireui.com",

//     /// Enable this automatically captures funds when the customer authorizes the payment.
//     /// Disable will Place a hold on the funds when the customer authorizes the payment,
//     /// but don’t capture the funds until later. (Not all payment methods support this.)
//     /// https://stripe.com/docs/payments/capture-later
//     /// Default: false
//     "enableManualCapture": false
//   },
//   "paypalConfig": {
//     "clientId":
//         "ASlpjFreiGp3gggRKo6YzXMyGM6-NwndBAQ707k6z3-WkSSMTPDfEFmNmky6dBX00lik8wKdToWiJj5w",
//     "secret":
//         "ECbFREri7NFj64FI_9WzS6A0Az2DqNLrVokBo0ZBu4enHZKMKOvX45v9Y1NBPKFr6QJv2KaSp5vk5A1G",
//     "production": false,
//     "paymentMethodId": "paypal",
//     "enabled": true,
//     "nativeMode": false,
//   },
//   "razorpayConfig": {
//     "keyId": "rzp_test_SDo2WKBNQXDk5Y",
//     "keySecret": "RrgfT3oxbJdaeHSzvuzaJRZf",
//     "paymentMethodId": "razorpay",
//     "enabled": true
//   },
//   "tapConfig": {
//     "SecretKey": "sk_test_XKokBfNWv6FIYuTMg5sLPjhJ",
//     "paymentMethodId": "tap",
//     "enabled": true
//   },
//   "mercadoPagoConfig": {
//     "accessToken":
//         "TEST-5726912977510261-102413-65873095dc5b0a877969b7f6ffcceee4-613803978",
//     "production": false,
//     "paymentMethodId": "woo-mercado-pago-basic",
//     "enabled": true
//   },
//   "payTmConfig": {
//     "paymentMethodId": "paytm",
//     "merchantId": "your-merchant-id",
//     "production": false,
//     "enabled": true
//   },
//   "payStackConfig": {
//     'paymentMethodId': 'paystack',
//     'publicKey': 'pk_test_a1a37615c9ca90dead5dd84dedbb5e476b640a6f',
//     'supportedCurrencies': ['ZAR'],
//     'production': false,
//     'enabled': true
//   },
//   "flutterwaveConfig": {
//     'paymentMethodId': 'rave',
//     'publicKey': 'FLWPUBK_TEST-72b90e0734da8c9e43916adf63cd711e-X',
//     'production': false,
//     'enabled': true
//   },
//   "myFatoorahConfig": {
//     "paymentMethodId": "myfatoorah_v2",
//     "apiToken":
//         "rLtt6JWvbUHDDhsZnfpAhpYk4dxYDQkbcPTyGaKp2TYqQgG7FGZ5Th_WD53Oq8Ebz6A53njUoo1w3pjU1D4vs_ZMqFiz_j0urb_BH9Oq9VZoKFoJEDAbRZepGcQanImyYrry7Kt6MnMdgfG5jn4HngWoRdKduNNyP4kzcp3mRv7x00ahkm9LAK7ZRieg7k1PDAnBIOG3EyVSJ5kK4WLMvYr7sCwHbHcu4A5WwelxYK0GMJy37bNAarSJDFQsJ2ZvJjvMDmfWwDVFEVe_5tOomfVNt6bOg9mexbGjMrnHBnKnZR1vQbBtQieDlQepzTZMuQrSuKn-t5XZM7V6fCW7oP-uXGX-sMOajeX65JOf6XVpk29DP6ro8WTAflCDANC193yof8-f5_EYY-3hXhJj7RBXmizDpneEQDSaSz5sFk0sV5qPcARJ9zGG73vuGFyenjPPmtDtXtpx35A-BVcOSBYVIWe9kndG3nclfefjKEuZ3m4jL9Gg1h2JBvmXSMYiZtp9MR5I6pvbvylU_PP5xJFSjVTIz7IQSjcVGO41npnwIxRXNRxFOdIUHn0tjQ-7LwvEcTXyPsHXcMD8WtgBh-wxR8aKX7WPSsT1O8d8reb2aR7K3rkV3K82K_0OgawImEpwSvp9MNKynEAJQS6ZHe_J_l77652xwPNxMRTMASk1ZsJL",
//     'accountCountry': 'KW',
//     // KW (KUWAIT), SA (SAUDI_ARABIA), BH (BAHRAIN), AR (UNITED_ARAB_EMIRATES), QA (QATAR), OM (OMAN), JO (JORDAN), EG (EGYPT)
//     "production": false,
//     "enabled": true
//   },
//   "midtransConfig": {
//     'paymentMethodId': 'midtrans',
//     'clientKey': 'SB-Mid-client-he8W_FIlvugfA2RD',
//     'production': false,
//     'enabled': true
//   },
//   "inAppPurchaseConfig": {
//     'consumableProductIDs': [
//       'com.bojeestore.digistacks.test',
//     ],
//     'nonConsumableProductIDs': [],
//     'subscriptionProductIDs': [
//       'com.bojeestore.digistacks.subscription.test',
//     ],
//     "enabled": false
//   },
//   "defaultCountryShipping": [],

//   /// config for after shipping
//   "afterShip": {
//     "api": "e2e9bae8-ee39-46a9-a084-781d0139274f",
//     "tracking_url": "https://fluxstore.aftership.com"
//   },

//   /// Ref: https://support.inspireui.com/help-center/articles/3/25/16/google-map-address
//   "googleApiKey": {
//     'android': 'AIzaSyDSNYVC-8DU9BTcyqkeN9c5pgVhwOBAvGg',
//     'ios': 'AIzaSyDSNYVC-8DU9BTcyqkeN9c5pgVhwOBAvGg',
//     'web': 'AIzaSyDSNYVC-8DU9BTcyqkeN9c5pgVhwOBAvGg'
//   },

//   /// ➡️ lib/common/products.dart
//   "productDetail": {
//     "height": 0.6,
//     "marginTop": 0,
//     "safeArea": false,
//     "showVideo": true,
//     "showBrand": true,
//     "showThumbnailAtLeast": 1,
//     "layout": "simpleType",
//     "borderRadius": 3.0,

//     /// Enable this to show selected image variant in the top banner.
//     "ShowSelectedImageVariant": true,

//     "autoPlayGallery": false,
//     "SliderShowGoBackButton": true,
//     "ShowImageGallery": true,

//     /// "SliderIndicatorType" can be "number", "dot". Default: "number".
//     "SliderIndicatorType": 'number',

//     /// Enable this to add a white background to top banner for transparent product image.
//     "ForceWhiteBackground": false,

//     /// Auto select first attribute of variable product if there is no default attribute.
//     "AutoSelectFirstAttribute": true,

//     /// Enable this to show review in product description.
//     "enableReview": true,
//     "attributeImagesSize": 50.0,
//     "showSku": true,
//     "showStockQuantity": true,
//     "showProductCategories": true,
//     "showProductTags": true,
//     "hideInvalidAttributes": false,

//     /// Enable this to show a quantity selector in product list.
//     "showQuantityInList": false,

//     /// Enable this to show Add to cart icon in search result list.
//     "showAddToCartInSearchResult": true,

//     /// Increase this number if you have yellow layout overflow error in product list.
//     /// Should check "RatioProductImage" before changing this number.
//     "productListItemHeight": 125,

//     /// Limit the time a user can make an appointment. Units are in days.
//     /// If the value is not set, there will be no limit on the appointment date.
//     /// For example:
//     ///  Today is October 11, 2020 and limitDayBooking is 7 days.
//     /// --> So users can only book appointments from October 11, 2020 to October 18, 2020
//     "limitDayBooking": 14,

//     // Hide or show related products in product detail screen.
//     "showRelatedProductFromSameStore": true,
//     "showRelatedProduct": true,
//     "showRecentProduct": true,

//     // Product image layout
//     "productImageLayout": "page",

//     "expandDescription": true,
//     "expandInfors": true,
//     "expandCategories": true,
//     "expandTags": true,
//     "expandReviews": true,
//     "expandTaxonomies": true,
//     "expandListingMenu": true,
//     "expandMap": true,
//   },
//   "blogDetail": {
//     'showComment': true,
//     'showHeart': true,
//     'showSharing': true,
//     'showTextAdjustment': true,
//     'enableAudioSupport': false,
//   },
//   "productVariantLayout": {
//     "color": "color",
//     "size": "box",
//     "height": "option",
//     "color-image": "image"
//   },
//   "productAddons": {
//     /// Set the allowed file type for file upload.
//     /// On iOS will open Photos app.
//     "allowImageType": true,
//     "allowVideoType": true,

//     /// Enable to allow upload files other than image/video.
//     /// On iOS will open Files app.
//     "allowCustomType": true,

//     /// Set allowed file extensions for custom type.
//     /// Leave empty ("allowedCustomType": []) to support all extensions.
//     "allowedCustomType": ["png", "pdf", "docx"],

//     /// NOTE: WordPress might restrict some file types for security purpose.
//     /// To allow it, you can add this line to wp-config.php:
//     /// define('ALLOW_UNFILTERED_UPLOADS', true);
//     /// - which is NOT recommended.
//     /// Instead, try to use a plugin like https://wordpress.org/plugins/wp-extra-file-types
//     /// to allow custom file types.
//     /// Allow selecting multiple files for upload. Default: false.
//     "allowMultiple": false,

//     /// Set the file size limit (in MB) for upload. Recommended: <15MB.
//     "fileUploadSizeLimit": 5.0
//   },
//   "cartDetail": {"minAllowTotalCartValue": 0, "maxAllowQuantity": 10},

//   /// Translate the product variant by languages
//   /// As it could be limited with the REST API when request variant
//   "productVariantLanguage": {
//     "en": {
//       "color": "Color",
//       "size": "Size",
//       "height": "Height",
//       "color-image": "Color"
//     },
//     "ar": {
//       "color": "اللون",
//       "size": "بحجم",
//       "height": "ارتفاع",
//       "color-image": "اللون"
//     },
//     "vi": {
//       "color": "Màu",
//       "size": "Kích thước",
//       "height": "Chiều Cao",
//       "color-image": "Màu"
//     }
//   },

//   /// Exclude this categories from the list
//   "excludedCategory": 311,
//   "saleOffProduct": {
//     /// Show Count Down for product type SaleOff
//     "ShowCountDown": true,
//     "HideEmptySaleOffLayout": false,
//     "Color": "#C7222B"
//   },

//   /// This is strict mode option to check the `visible` option from product variant
//   /// https://tppr.me/4DJJs - default value is false
//   "notStrictVisibleVariant": true,

//   /// ➡️ lib/common/smartchat.dart
//   "configChat": {
//     "EnableSmartChat": true,
//     "UseRealtimeChat": false,
//     "showOnScreens": ["profile"],
//     "hideOnScreens": [],
//     "version": "2",
//   },
//   "openAIConfig": {
//     'enableChat': true,
//     'supabaseUrl': 'https://rtkrqvtslujdzjxhjocu.supabase.co',
//     'supabaseAnonKey':
//         'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJ0a3JxdnRzbHVqZHpqeGhqb2N1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2NzU5OTI5MzMsImV4cCI6MTk5MTU2ODkzM30.qKtfNHhL6AKqGsmDfjMq90bIWIWlnN3UVgnwcLF_vGY',
//   },

//   /// config for the chat app
//   /// config Whatapp: https://faq.whatsapp.com/en/iphone/23559013
//   "smartChat": [
//     {
//       "app": "firebase",
//       "imageData":
//           "https://trello.com/1/cards/611a38c89ebde41ec7cf10e2/attachments/611a392cceb1b534aa92a83e/previews/611a392dceb1b534aa92a84d/download",
//       "description": "Realtime Chat",
//     },
//     {
//       "app": "chatGPT",
//       "imageData": "https://i.imgur.com/pp1qlPd.png",
//       "description": "Chat GPT"
//     },
//     {
//       "app": "https://wa.me/849908854",
//       "iconData": "whatsapp",
//       "description": "WhatsApp"
//     },
//     {"app": "tel:8499999999", "iconData": "phone", "description": "Call Us"},
//     {"app": "sms://8499999999", "iconData": "sms", "description": "Send SMS"},
//     {
//       "app": "https://tawk.to/chat/5d830419c22bdd393bb69888/default",
//       "iconData": "whatsapp",
//       "description": "Tawk Chat"
//     },
//     {
//       "app": "http://m.me/inspireui",
//       "iconData": "facebookMessenger",
//       "description": "Facebook Chat"
//     },
//     {
//       "app":
//           "https://twitter.com/messages/compose?recipient_id=821597032011931648",
//       "imageData":
//           "https://trello.com/1/cards/611a38c89ebde41ec7cf10e2/attachments/611a38d026894f10dc1091c8/previews/611a38d126894f10dc1091d6/download",
//       "description": "Twitter Chat"
//     }
//   ],
//   "adminEmail": "admininspireui@gmail.com",
//   "adminName": "InspireUI",

//   /// ➡️ lib/common/vendor.dart
//   "vendorConfig": {
//     /// Show Register by Vendor
//     "VendorRegister": true,

//     /// Disable show shipping methods by vendor
//     "DisableVendorShipping": false,

//     /// Enable/Disable showing all vendor markers on Map screen
//     "ShowAllVendorMarkers": true,

//     /// Enable/Disable native store management
//     "DisableNativeStoreManagement": true,

//     /// Dokan Vendor Dashboard
//     "dokan": "my-account?vendor_admin=true",
//     "wcfm": "store-manager?vendor_admin=true",

//     /// Disable multivendor checkout
//     "DisableMultiVendorCheckout": false,

//     /// If this is false, then when creating/modifying products in FluxStore Manager
//     /// The publish status will be removed.
//     "DisablePendingProduct": false,

//     /// Default status when Add New Product from MV app.
//     /// Support 'draft', 'pending', 'public'.
//     "NewProductStatus": "draft",

//     /// Default Vendor image.
//     "DefaultStoreImage": "assets/images/default-store-banner.png",

//     /// Set this to true to automatically approve the vendor application.
//     /// When it is set to false, these are the cases:
//     /// - For WCFM - It will set the registered role to subscribe with the meta "wcfm_membership_application_status": "pending".
//     /// - For Dokan - It still keeps the registered role as "seller" but the selling capability will be set to false. The meta for it is "dokan_enable_selling" : false
//     "EnableAutoApplicationApproval": false,

//     "BannerFit": "cover",
//     "ExpandStoreLocationByDefault": true,

//     /// Enable/Disable native delivery boy management
//     "DisableDeliveryManagement": true
//   },

//   /// Enable Delivery Boy Management in FluxStore Manager(WCFM)
//   "deliveryConfig": {
//     'appLogo': 'assets/images/app_icon_transparent.png',
//     'appName': 'FluxStore Delivery',
//     'dashboardName1': 'FluxStore',
//     'dashboardName2': 'Delivery',
//     'enableSystemNotes': false,
//   },

//   /// Enable Vendor Admin in FluxStore manager
//   "managerConfig": {
//     'appLogo': 'assets/images/app_icon_transparent.png',
//     'appName': 'FluxStore Admin',
//     'enableDeliveryFeature': false,
//   },

//   /// ➡️ lib/common/loading.dart
//   "loadingIcon": {"size": 30.0, "type": "fadingCube"},
//   "splashScreen": {
//     "enable": true,

//     /// duration in milliseconds, used for all types except "rive" and "flare"
//     "duration": 2000,

//     ///  Type should be: 'fade-in', 'zoom-in', 'zoom-out', 'top-down', 'rive', 'flare', ''static'
//     "type": "flare",
//     "image": "assets/images/splashscreen.flr",

//     /// AnimationName's is used for 'rive' and 'flare' type
//     "animationName": "fluxstore",

//     "boxFit": "contain",
//     "backgroundColor": "#ffffff",
//     "paddingTop": 0,
//     "paddingBottom": 0,
//     "paddingLeft": 0,
//     "paddingRight": 0,


//   }
// };

// ignore_for_file: prefer_single_quotes, lines_longer_than_80_chars final 
          Map<String, dynamic> environment = {"appConfig":"lib/config/config_ar.json","serverConfig":{"url":"https://bojee.codlar.com/","type":"woo","consumerKey":"ck_c567bc248cd968a1d5f91f36acb7d51df56b8297","consumerSecret":"cs_42a2ea85000467b73284084320a2147119d69545"},"defaultDarkTheme":false,"enableRemoteConfigFirebase":false,"loginSMSConstants":{"countryCodeDefault":"US","dialCodeDefault":"+1","nameDefault":"United States"},"phoneNumberConfig":{"enable":false,"countryCodeDefault":"US","dialCodeDefault":"+1","useInternationalFormat":true,"showCountryFlag":true,"customCountryList":[],"formatInput":false,"selectorType":"BOTTOM_SHEET","selectorFlagAsPrefixIcon":true},"storeIdentifier":{"disable":true,"android":"com.bojeestore.digistacks","ios":"1469772800"},"advanceConfig":{"DefaultLanguage":"ar","DetailedBlogLayout":"halfSizeImageType","EnablePointReward":false,"hideOutOfStock":false,"HideEmptyTags":true,"HideEmptyCategories":false,"EnableRating":false,"hideEmptyProductListRating":false,"EnableCart":true,"ShowBottomCornerCart":true,"EnableSkuSearch":false,"showStockStatus":true,"GridCount":3,"isCaching":true,"kIsResizeImage":true,"httpCache":true,"Currencies":[{"symbol":"\$","decimalDigits":2,"symbolBeforeTheNumber":true,"currency":"USD","currencyCode":"USD","smallestUnitRate":100},{"symbol":"₹","decimalDigits":0,"symbolBeforeTheNumber":true,"currency":"INR","currencyCode":"INR","smallestUnitRate":100},{"symbol":"đ","decimalDigits":2,"symbolBeforeTheNumber":false,"currency":"VND","currencyCode":"VND","smallestUnitRate":100},{"symbol":"€","decimalDigits":2,"symbolBeforeTheNumber":true,"currency":"EUR","currencyCode":"EUR","smallestUnitRate":100},{"symbol":"£","decimalDigits":2,"symbolBeforeTheNumber":true,"currency":"Pound sterling","currencyCode":"GBP","smallestUnitRate":100},{"symbol":"AR\$","decimalDigits":2,"symbolBeforeTheNumber":true,"currency":"ARS","currencyCode":"ARS","smallestUnitRate":100}],"DefaultStoreViewCode":"","EnableAttributesConfigurableProduct":["color","size"],"EnableAttributesLabelConfigurableProduct":["color","size"],"isMultiLanguages":false,"EnableApprovedReview":true,"EnableSyncCartFromWebsite":true,"EnableSyncCartToWebsite":true,"EnableFirebase":false,"RatioProductImage":1.2,"EnableCouponCode":true,"ShowCouponList":false,"ShowAllCoupons":true,"ShowExpiredCoupons":false,"AlwaysShowTabBar":false,"PrivacyPoliciesPageId":null,"PrivacyPoliciesPageUrl":"https://mstore.io/","SupportPageUrl":"https://support.inspireui.com/","DownloadPageUrl":"https://mstore.io/#download","SocialConnectUrl":[{"name":"Facebook","icon":"assets/icons/logins/facebook.png","url":"https://www.facebook.com/inspireui"},{"name":"Instagram","icon":"assets/icons/logins/instagram.png","url":"https://www.instagram.com/inspireui9/"}],"AutoDetectLanguage":false,"QueryRadiusDistance":10,"MinQueryRadiusDistance":1,"MaxQueryRadiusDistance":10,"EnableMembershipUltimate":false,"EnablePaidMembershipPro":false,"EnableDeliveryDateOnCheckout":true,"EnableNewSMSLogin":false,"EnableBottomAddToCart":false,"inAppWebView":false,"EnableWOOCSCurrencySwitcher":false,"enableProductBackdrop":true,"categoryImageMenu":true,"EnableDigitsMobileLogin":false,"OnBoardOnlyShowFirstTime":true,"WebViewScript":"","EnableVersionCheck":false,"AjaxSearchURL":"","AlwaysClearWebViewCache":false,"AlwaysRefreshBlog":false,"OrderNotesWithPrivateNote":true,"OrderNotesLinkSupport":false,"inAppUpdateForAndroid":{"enable":false,"typeUpdate":"flexible"},"categoryConfig":{"enableLargeCategories":true,"deepLevel":15},"pinnedProductTags":[]},"defaultDrawer":{"logo":"assets/images/logo.png","items":[{"type":"home","show":true},{"type":"blog","show":true},{"type":"categories","show":true},{"type":"cart","show":true},{"type":"profile","show":true},{"type":"login","show":true},{"type":"category","show":true}]},"defaultSettings":["products","chat","wishlist","notifications","language","currencies","darkTheme","order","point","rating","privacy","about"],"loginSetting":{"IsRequiredLogin":false,"showAppleLogin":true,"showFacebook":true,"showSMSLogin":true,"showGoogleLogin":true,"showPhoneNumberWhenRegister":false,"requirePhoneNumberWhenRegister":false,"isResetPasswordSupported":true,"smsLoginAsDefault":false,"facebookAppId":"430258564493822","facebookLoginProtocolScheme":"fb430258564493822"},"oneSignalKey":{"enable":false,"appID":"8b45b6db-7421-45e1-85aa-75e597f62714"},"onBoardingData":[{"title":"Warmly Welcome!","image":"assets/images/fogg-delivery-1.png","desc":"Fluxstore is on the way to serve you. "},{"title":"Connect Surrounding World","image":"assets/images/fogg-uploading-1.png","desc":"See all things happening around you just by a click in your phone. Fast, convenient and clean."},{"title":"Let's Get Started","image":"assets/images/fogg-order-completed.png","desc":"Waiting no more, let's see what we get!"}],"adConfig":{"enable":false,"facebookTestingId":"","googleTestingId":[],"ads":[{"type":"banner","provider":"google","iosId":"ca-app-pub-3940256099942544/2934735716","androidId":"ca-app-pub-3940256099942544/6300978111","showOnScreens":["home","search"],"waitingTimeToDisplay":2},{"type":"banner","provider":"google","iosId":"ca-app-pub-2101182411274198/5418791562","androidId":"ca-app-pub-2101182411274198/4052745095"},{"type":"interstitial","provider":"google","iosId":"ca-app-pub-3940256099942544/4411468910","androidId":"ca-app-pub-3940256099942544/4411468910","showOnScreens":["profile"],"waitingTimeToDisplay":5},{"type":"reward","provider":"google","iosId":"ca-app-pub-3940256099942544/1712485313","androidId":"ca-app-pub-3940256099942544/4411468910","showOnScreens":["cart"]},{"type":"banner","provider":"facebook","iosId":"IMG_16_9_APP_INSTALL#430258564493822_876131259906548","androidId":"IMG_16_9_APP_INSTALL#430258564493822_489007588618919","showOnScreens":["home"]},{"type":"interstitial","provider":"facebook","iosId":"430258564493822_489092398610438","androidId":"IMG_16_9_APP_INSTALL#430258564493822_489092398610438"}],"adMobAppIdIos":"ca-app-pub-7432665165146018~2664444130","adMobAppIdAndroid":"ca-app-pub-7432665165146018~2664444130"},"firebaseDynamicLinkConfig":{"isEnabled":true,"shortDynamicLinkEnable":true,"uriPrefix":"https://fluxstoreinspireui.page.link","link":"https://mstore.io/","androidPackageName":"com.bojeestore.digistacks","androidAppMinimumVersion":1,"iOSBundleId":"com.inspireui.mstore.flutter","iOSAppMinimumVersion":"1.0.1","iOSAppStoreId":"1469772800"},"languagesInfo":[{"name":"English","icon":"assets/images/country/gb.png","code":"en","text":"English","storeViewCode":""},{"name":"Hindi","icon":"assets/images/country/in.png","code":"hi","text":"हिन्दी","storeViewCode":"hi"},{"name":"Spanish","icon":"assets/images/country/es.png","code":"es","text":"Español","storeViewCode":""},{"name":"French","icon":"assets/images/country/fr.png","code":"fr","text":"Français","storeViewCode":"fr"},{"name":"Arabic","icon":"assets/images/country/ar.png","code":"ar","text":"العربية","storeViewCode":"ar"},{"name":"Russian","icon":"assets/images/country/ru.png","code":"ru","text":"Русский","storeViewCode":"ru"},{"name":"Indonesian","icon":"assets/images/country/id.png","code":"id","text":"Bahasa Indonesia","storeViewCode":"id"},{"name":"Japanese","icon":"assets/images/country/ja.png","code":"ja","text":"日本語","storeViewCode":""},{"name":"Korean","icon":"assets/images/country/ko.png","code":"ko","text":"한국어/조선말","storeViewCode":"ko"},{"name":"Vietnamese","icon":"assets/images/country/vn.png","code":"vi","text":"Tiếng Việt","storeViewCode":""},{"name":"Romanian","icon":"assets/images/country/ro.png","code":"ro","text":"Românește","storeViewCode":"ro"},{"name":"Turkish","icon":"assets/images/country/tr.png","code":"tr","text":"Türkçe","storeViewCode":"tr"},{"name":"Italian","icon":"assets/images/country/it.png","code":"it","text":"Italiano","storeViewCode":"it"},{"name":"German","icon":"assets/images/country/de.png","code":"de","text":"Deutsch","storeViewCode":"de"},{"name":"Portuguese","icon":"assets/images/country/pt.png","code":"pt","text":"Português","storeViewCode":"pt"},{"name":"Hungarian","icon":"assets/images/country/hu.png","code":"hu","text":"Magyar nyelv","storeViewCode":"hu"},{"name":"Hebrew","icon":"assets/images/country/he.png","code":"he","text":"עִבְרִית","storeViewCode":"he"},{"name":"Thai","icon":"assets/images/country/th.png","code":"th","text":"ภาษาไทย","storeViewCode":"th"},{"name":"Dutch","icon":"assets/images/country/nl.png","code":"nl","text":"Nederlands","storeViewCode":"nl"},{"name":"Serbian","icon":"assets/images/country/sr.jpeg","code":"sr","text":"српски","storeViewCode":"sr"},{"name":"Polish","icon":"assets/images/country/pl.png","code":"pl","text":"Język polski","storeViewCode":"pl"},{"name":"Persian","icon":"assets/images/country/fa.png","code":"fa","text":"زبان فارسی","storeViewCode":""},{"name":"Ukrainian","icon":"assets/images/country/uk.png","code":"uk","text":"Українська мова","storeViewCode":""},{"name":"Bengali","icon":"assets/images/country/bn.png","code":"bn","text":"বাংলা","storeViewCode":""},{"name":"Tamil","icon":"assets/images/country/ta.png","code":"ta","text":"தமிழ்","storeViewCode":""},{"name":"Kurdish","icon":"assets/images/country/ku.png","code":"ku","text":"Kurdî / کوردی","storeViewCode":""},{"name":"Czech","icon":"assets/images/country/cs.png","code":"cs","text":"Čeština","storeViewCode":"cs"},{"name":"Swedish","icon":"assets/images/country/sv.png","code":"sv","text":"Svenska","storeViewCode":""},{"name":"Finland","icon":"assets/images/country/fi.png","code":"fi","text":"Suomi","storeViewCode":""},{"name":"Greek","icon":"assets/images/country/el.png","code":"el","text":"Ελληνικά","storeViewCode":""},{"name":"Khmer","icon":"assets/images/country/km.png","code":"km","text":"ភាសាខ្មែរ","storeViewCode":""},{"name":"Kannada","icon":"assets/images/country/kn.png","code":"kn","text":"ಕನ್ನಡ","storeViewCode":""},{"name":"Marathi","icon":"assets/images/country/mr.jpeg","code":"mr","text":"मराठी भाषा","storeViewCode":""},{"name":"Malay","icon":"assets/images/country/ms.jpeg","code":"ms","text":"بهاس ملايو","storeViewCode":""},{"name":"Bosnian","icon":"assets/images/country/bs.png","code":"bs","text":"босански","storeViewCode":""},{"name":"Lao","icon":"assets/images/country/lo.png","code":"lo","text":"ພາສາລາວ","storeViewCode":""},{"name":"Slovak","icon":"assets/images/country/sk.png","code":"sk","text":"Slovaščina","storeViewCode":""},{"name":"Swahili","icon":"assets/images/country/sw.png","code":"sw","text":"كِيْسَوَاحِيْلِيْ","storeViewCode":""},{"name":"Chinese","icon":"assets/images/country/zh.png","code":"zh","text":"中文","storeViewCode":""},{"name":"Chinese (traditional)","icon":"assets/images/country/zh.png","code":"zh_TW","text":"漢語","storeViewCode":""},{"name":"Chinese (simplified)","icon":"assets/images/country/zh.png","code":"zh_CN","text":"汉语","storeViewCode":""},{"name":"Burmese","icon":"assets/images/country/my.png","code":"my","text":"မြန်မာဘာသာစကား","storeViewCode":""},{"name":"Albanian","icon":"assets/images/country/sq.png","code":"sq","text":"Shqip","storeViewCode":""},{"name":"Danish","icon":"assets/images/country/da.svg","code":"da","text":"Dansk","storeViewCode":""},{"name":"Tigrinya","icon":"assets/images/country/er.png","code":"ti","text":"ትግርኛ","storeViewCode":"ti"},{"name":"Urdu","icon":"assets/images/country/pk.png","code":"ur","text":"اُردُو","storeViewCode":""},{"name":"Azerbaijani","icon":"assets/images/country/az.jpg","code":"az","text":"Azərbaycan dili","storeViewCode":""}],"paymentConfig":{"DefaultCountryISOCode":"US","DefaultStateISOCode":"LA","EnableShipping":true,"EnableAddress":true,"EnableCustomerNote":true,"EnableAddressLocationNote":false,"EnableAlphanumericZipCode":false,"EnableReview":true,"allowSearchingAddress":true,"GuestCheckout":true,"EnableOnePageCheckout":false,"NativeOnePageCheckout":false,"CheckoutPageSlug":{"en":"checkout"},"EnableCreditCard":false,"UpdateOrderStatus":false,"ShowOrderNotes":true,"EnableRefundCancel":true,"RefundPeriod":7,"SmartCOD":{"enabled":true,"extraFee":10,"amountStop":200}},"payments":{"stripe_v2_apple_pay":"assets/icons/payment/apple-pay-mark.svg","stripe_v2_google_pay":"assets/icons/payment/google-pay-mark.png","paypal":"assets/icons/payment/paypal.svg","stripe":"assets/icons/payment/stripe.svg","razorpay":"assets/icons/payment/razorpay.svg","tap":"assets/icons/payment/tap.png"},"stripeConfig":{"serverEndpoint":"https://stripe-server-node.vercel.app","publishableKey":"pk_test_51HNabPCinksNdU0OwGkZ6uMdZOrLT42NGJkBxmVJwx3oM5mafpJaQRfDHifJMg2iREDZxbPkR1TvDtmBeTyjmgv200mCojR2dG","paymentMethodId":"stripe","paymentMethodIds":["stripe","stripe"],"enabled":false,"enableApplePay":true,"enableGooglePay":true,"merchantDisplayName":"FluxStore","merchantIdentifier":"merchant.com.inspireui.mstore.flutter","merchantCountryCode":"US","useV1":false,"returnUrl":"fluxstore://inspireui.com","enableManualCapture":false},"paypalConfig":{"clientId":"ASlpjFreiGp3gggRKo6YzXMyGM6-NwndBAQ707k6z3-WkSSMTPDfEFmNmky6dBX00lik8wKdToWiJj5w","secret":"ECbFREri7NFj64FI_9WzS6A0Az2DqNLrVokBo0ZBu4enHZKMKOvX45v9Y1NBPKFr6QJv2KaSp5vk5A1G","production":false,"paymentMethodId":"paypal","enabled":true},"razorpayConfig":{"keyId":"rzp_test_SDo2WKBNQXDk5Y","keySecret":"RrgfT3oxbJdaeHSzvuzaJRZf","paymentMethodId":"razorpay","enabled":true},"tapConfig":{"SecretKey":"sk_test_XKokBfNWv6FIYuTMg5sLPjhJ","paymentMethodId":"tap","enabled":false},"mercadoPagoConfig":{"accessToken":"TEST-5726912977510261-102413-65873095dc5b0a877969b7f6ffcceee4-613803978","production":false,"paymentMethodId":"woo-mercado-pago-basic","enabled":true},"payTmConfig":{"paymentMethodId":"paytm","merchantId":"your-merchant-id","production":false,"enabled":true},"payStackConfig":{"paymentMethodId":"paystack","publicKey":"pk_test_a1a37615c9ca90dead5dd84dedbb5e476b640a6f","production":false,"enabled":true},"flutterwaveConfig":{"paymentMethodId":"rave","publicKey":"FLWPUBK_TEST-72b90e0734da8c9e43916adf63cd711e-X","production":false,"enabled":true},"myFatoorahConfig":{"paymentMethodId":"myfatoorah_v2","apiToken":"rLtt6JWvbUHDDhsZnfpAhpYk4dxYDQkbcPTyGaKp2TYqQgG7FGZ5Th_WD53Oq8Ebz6A53njUoo1w3pjU1D4vs_ZMqFiz_j0urb_BH9Oq9VZoKFoJEDAbRZepGcQanImyYrry7Kt6MnMdgfG5jn4HngWoRdKduNNyP4kzcp3mRv7x00ahkm9LAK7ZRieg7k1PDAnBIOG3EyVSJ5kK4WLMvYr7sCwHbHcu4A5WwelxYK0GMJy37bNAarSJDFQsJ2ZvJjvMDmfWwDVFEVe_5tOomfVNt6bOg9mexbGjMrnHBnKnZR1vQbBtQieDlQepzTZMuQrSuKn-t5XZM7V6fCW7oP-uXGX-sMOajeX65JOf6XVpk29DP6ro8WTAflCDANC193yof8-f5_EYY-3hXhJj7RBXmizDpneEQDSaSz5sFk0sV5qPcARJ9zGG73vuGFyenjPPmtDtXtpx35A-BVcOSBYVIWe9kndG3nclfefjKEuZ3m4jL9Gg1h2JBvmXSMYiZtp9MR5I6pvbvylU_PP5xJFSjVTIz7IQSjcVGO41npnwIxRXNRxFOdIUHn0tjQ-7LwvEcTXyPsHXcMD8WtgBh-wxR8aKX7WPSsT1O8d8reb2aR7K3rkV3K82K_0OgawImEpwSvp9MNKynEAJQS6ZHe_J_l77652xwPNxMRTMASk1ZsJL","accountCountry":"KW","production":false,"enabled":false},"defaultCountryShipping":[],"afterShip":{"api":"e2e9bae8-ee39-46a9-a084-781d0139274f","tracking_url":"https://fluxstore.aftership.com"},"googleApiKey":{"android":"AIzaSyDW3uXzZepWBPi-69BIYKyS-xo9NjFSFhQ","ios":"AIzaSyDW3uXzZepWBPi-69BIYKyS-xo9NjFSFhQ","web":"AIzaSyDW3uXzZepWBPi-69BIYKyS-xo9NjFSFhQ"},"productDetail":{"height":0.6,"marginTop":0,"safeArea":false,"showVideo":true,"showThumbnailAtLeast":1,"layout":"simpleType","borderRadius":3,"ShowSelectedImageVariant":true,"ForceWhiteBackground":false,"AutoSelectFirstAttribute":true,"enableReview":true,"attributeImagesSize":50,"showSku":true,"showStockQuantity":true,"showProductCategories":true,"showProductTags":true,"hideInvalidAttributes":false,"ShowImageGallery":true,"autoPlayGallery":false,"allowMultiple":false,"showBrand":true,"showQuantityInList":false,"showAddToCartInSearchResult":true,"productListItemHeight":125,"limitDayBooking":14,"boxFit":"scaleDown","SliderShowGoBackButton":true,"SliderIndicatorType":"number","productMetaDataKey":"","showRelatedProductFromSameStore":true,"showRelatedProduct":true,"productImageLayout":"page"},"blogDetail":{"showComment":true,"showHeart":true,"showSharing":true,"showTextAdjustment":true,"enableAudioSupport":false},"productVariantLayout":{"color":"color","size":"box","height":"option","color-image":"image"},"productAddons":{"allowImageType":true,"allowVideoType":true,"allowCustomType":true,"allowedCustomType":["png","pdf","docx"],"allowMultiple":false,"fileUploadSizeLimit":5},"cartDetail":{"minAllowTotalCartValue":0,"maxAllowQuantity":10},"productVariantLanguage":{"en":{"color":"Color","size":"Size","height":"Height","color-image":"Color"},"ar":{"color":"اللون","size":"بحجم","height":"ارتفاع","color-image":"اللون"},"vi":{"color":"Màu","size":"Kích thước","height":"Chiều Cao","color-image":"Màu"}},"excludedCategory":311,"saleOffProduct":{"ShowCountDown":true,"HideEmptySaleOffLayout":false,"Color":"#C7222B"},"notStrictVisibleVariant":true,"configChat":{"EnableSmartChat":true,"UseRealtimeChat":false,"showOnScreens":["profile"],"hideOnScreens":[],"version":"2"},"smartChat":[{"app":"firebase","imageData":"https://trello.com/1/cards/611a38c89ebde41ec7cf10e2/attachments/611a392cceb1b534aa92a83e/previews/611a392dceb1b534aa92a84d/download","description":"Realtime Chat"},{"app":"https://wa.me/849908854","iconData":"whatsapp","description":"WhatsApp"},{"app":"tel:8499999999","iconData":"phone","description":"Call Us"},{"app":"sms://8499999999","iconData":"sms","description":"Send SMS"},{"app":"https://tawk.to/chat/5d830419c22bdd393bb69888/default","iconData":"whatsapp","description":"Tawk Chat"},{"app":"http://m.me/inspireui","iconData":"facebookMessenger","description":"Facebook Chat"},{"app":"https://twitter.com/messages/compose?recipient_id=821597032011931648","imageData":"https://trello.com/1/cards/611a38c89ebde41ec7cf10e2/attachments/611a38d026894f10dc1091c8/previews/611a38d126894f10dc1091d6/download","description":"Twitter Chat"}],"adminEmail":"admininspireui@gmail.com","adminName":"InspireUI","deliveryConfig":{"appLogo":"assets/images/app_icon_transparent.png","appName":"FluxStore Delivery","dashboardName1":"FluxStore","dashboardName2":"Delivery","enableSystemNotes":false},"managerConfig":{"appLogo":"assets/images/app_icon_transparent.png","appName":"FluxStore Admin","enableDeliveryFeature":false},"loadingIcon":{"layout":"spinkit","type":"spinningCircle"},"splashScreen":{"enable":true,"duration":2000,"type":"static","image":"https://trello.com/1/cards/63587806a57fae002ab4b20f/attachments/6427849e099c24e9a2d25c13/download/splashscreen.png","animationName":"fluxstore","boxFit":"contain","backgroundColor":"#ffffff","paddingTop":0,"paddingBottom":0,"paddingLeft":0,"paddingRight":0},"productCard":{"hidePrice":false,"hideStore":false,"hideTitle":false,"borderRadius":5,"enableRating":false,"showCartButton":false,"showCartIcon":true,"showCartIconColor":false,"showCartButtonWithQuantity":false,"boxFit":"contain"},"darkConfig":{"MainColor":"#3FC1BE"},"lightConfig":{"MainColor":"ffd4af37","logo":"https://trello.com/1/cards/63587806a57fae002ab4b20f/attachments/642784355b516524d0d1b305/download/5.png"}};
          