import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

currencyFormat(int price, {String currency = 'IDR'}) {
  var priceWithCurrency =
      '$currency ${intl.NumberFormat.decimalPattern().format(price)}';

  return priceWithCurrency;
}