import 'package:intl/intl.dart';
import 'package:quiver/strings.dart';
import 'package:provider/provider.dart';
//import '../models/index.dart';

import '../../models/entities/currency.dart';
import '../../models/index.dart' show AddonsOption, Product, AppModel;
import '../config.dart' show kAdvanceConfig;
import '../constants.dart' show printLog;

class PriceTools {
  static String? getAddsOnPriceProductValue(
    Product product,
    List<AddonsOption> selectedOptions,
    Map<String, dynamic> rates,
    String? currency, {
    bool? onSale,
  }) {
    var price = double.tryParse(onSale == true
            ? (isNotBlank(product.salePrice)
                ? product.salePrice!
                : product.price!)
            : product.price!) ??
        0.0;
    price += selectedOptions
        .map((e) => double.tryParse(e.price ?? '0.0') ?? 0.0)
        .reduce((a, b) => a + b);

    return getCurrencyFormatted(price, rates, currency: currency);
  }

  static String? getVariantPriceProductValue(
    product,
    Map<String, dynamic> rates,
    String? currency, {
    bool? onSale,
    List<AddonsOption>? selectedOptions,
  }) {
    var price = double.tryParse(
            '${onSale == true ? (isNotBlank(product.salePrice) ? product.salePrice : product.price) : product.price}') ??
        0.0;
    if (selectedOptions != null && selectedOptions.isNotEmpty) {
      price += selectedOptions
          .map((e) => double.tryParse(e.price ?? '0.0') ?? 0.0)
          .reduce((a, b) => a + b);
    }
    return getCurrencyFormatted(price, rates, currency: currency);
  }

  static String? getPriceProductValue(Product? product, String? currency,
      {bool? onSale}) {
    try {
      var price = onSale == true
          ? (isNotBlank(product!.salePrice)
              ? product.salePrice ?? '0'
              : product.price)
          : (isNotBlank(product!.regularPrice)
              ? product.regularPrice ?? '0'
              : product.price);
      return price;
    } catch (e, trace) {
      printLog(e.toString());
      printLog(trace.toString());
      return '';
    }
  }

  static String? getPriceProduct(
      product, Map<String, dynamic>? rates, String? currency,
      {bool? onSale}) {
    var price = getPriceProductValue(product, currency, onSale: onSale);

    if (price == null || price == '') {
      return '';
    }
    return getCurrencyFormatted(price, rates, currency: currency);
  }

  static String? getCurrencyFormatted(price, Map<String, dynamic>? rates,
      {currency}) {
     //final currency = Provider.of<AppModel>(context).currency;

    if (kAdvanceConfig.defaultCurrency == null) {
      return price;
    }

    var defaultCurrency =
        kAdvanceConfig.defaultCurrency ?? Currency.fromJson({});

    var currencies = kAdvanceConfig.currencies;
    var formatCurrency = NumberFormat.currency(
      locale: kAdvanceConfig.defaultLanguage,
      name: '',
      decimalDigits: defaultCurrency.decimalDigits,
    );

    try {
      if (currency != null && currencies.isNotEmpty) {
        for (var item in currencies) {
          if (item.currencyCode == currency ||
              item.currencyDisplay == currency) {
            defaultCurrency = item;
            formatCurrency = NumberFormat.currency(
              locale: kAdvanceConfig.defaultLanguage,
              name: '',
              decimalDigits: defaultCurrency.decimalDigits,
            );
            break;
          }
        }
      }

      if (rates != null && rates[defaultCurrency.currencyCode] != null) {
        price = getPriceValueByCurrency(
          price,
          defaultCurrency.currencyCode,
          rates,
        );
      }

      String? number = '';
      if (price == null) {
        number = '';
      } else if (price is String) {
        final newString = price.replaceAll(RegExp('[^\\d.,]+'), '');
        number = formatCurrency
            .format(newString.isNotEmpty ? double.parse(newString) : 0);
      } else {
        number = formatCurrency.format(price);
      }
 //defaultCurrency.symbol
      return number + '  ' + defaultCurrency.symbol;
      // defaultCurrency.symbolBeforeTheNumber
      //     ? defaultCurrency.symbol + number
      //     : defaultCurrency.symbol + number  ;
    } catch (err, trace) {
      printLog(trace);
      printLog('getCurrencyFormatted $err');
      return defaultCurrency.symbolBeforeTheNumber
          ? defaultCurrency.symbol + formatCurrency.format(0)
          : formatCurrency.format(0) + defaultCurrency.symbol;
    }
  }
  static String? getCurrencyFormattedEnglish(price, Map<String, dynamic>? rates,
      {currency}) {
    if (kAdvanceConfig.defaultCurrency == null) {
      return price;
    }

    var defaultCurrency =
        kAdvanceConfig.defaultCurrency ?? Currency.fromJson({});

    var currencies = kAdvanceConfig.currencies;
    var formatCurrency = NumberFormat.currency(
      locale: kAdvanceConfig.defaultLanguage,
      name: '',
      decimalDigits: defaultCurrency.decimalDigits,
    );

    try {
      if (currency != null && currencies.isNotEmpty) {
        for (var item in currencies) {
          if (item.currencyCode == currency ||
              item.currencyDisplay == currency) {
            defaultCurrency = item;
            formatCurrency = NumberFormat.currency(
              locale: kAdvanceConfig.defaultLanguage,
              name: '',
              decimalDigits: defaultCurrency.decimalDigits,
            );
            break;
          }
        }
      }

      if (rates != null && rates[defaultCurrency.currencyCode] != null) {
        price = getPriceValueByCurrency(
          price,
          defaultCurrency.currencyCode,
          rates,
        );
      }

      String? number = '';
      if (price == null) {
        number = '';
      } else if (price is String) {
        final newString = price.replaceAll(RegExp('[^\\d.,]+'), '');
        number = formatCurrency
            .format(newString.isNotEmpty ? double.parse(newString) : 0);
      } else {
        number = formatCurrency.format(price);
      }
 //defaultCurrency.symbol
      return number + '  ' +" defaultCurrency.symbol" ;
      // defaultCurrency.symbolBeforeTheNumber
      //     ? defaultCurrency.symbol + number
      //     : defaultCurrency.symbol + number  ;
    } catch (err, trace) {
      printLog(trace);
      printLog('getCurrencyFormatted $err');
      return defaultCurrency.symbolBeforeTheNumber
          ? defaultCurrency.symbol + formatCurrency.format(0)
          : formatCurrency.format(0) + defaultCurrency.symbol;
    }
  }

  static double? getPriceByRate(price, Map<String, dynamic>? rates,
      {currency}) {
    if (kAdvanceConfig.defaultCurrency == null) {
      return price;
    }

    var defaultCurrency =
        kAdvanceConfig.defaultCurrency ?? Currency.fromJson({});

    var currencies = kAdvanceConfig.currencies;

    try {
      if (currency != null && currencies.isNotEmpty) {
        for (var item in currencies) {
          if (item.currencyCode == currency ||
              item.currencyDisplay == currency) {
            defaultCurrency = item;
            break;
          }
        }
      }

      if (rates != null && rates[defaultCurrency.currencyCode] != null) {
        price = getPriceValueByCurrency(
          price,
          defaultCurrency.currencyCode,
          rates,
        );
      }

      if (price == null) {
        return 0;
      } else  {
        return price;
      }
    } catch (err, trace) {
      printLog(trace);
      printLog('getCurrencyFormatted $err');
      return price;
    }
  }

  static double getPriceValueByCurrency(
      price, String currency, Map<String, dynamic> rates) {
    final currencyVal = currency.toUpperCase();
    double rate = rates[currencyVal] ?? 1.0;

    if (price == '' || price == null) {
      return 0;
    }
    return double.parse(price.toString()) * rate;
  }
}
