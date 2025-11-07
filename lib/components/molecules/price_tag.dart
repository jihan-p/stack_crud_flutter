// lib/components/molecules/price_tag.dart

import 'package:flutter/material.dart';
import '../atoms/app_typography.dart';
import 'package:intl/intl.dart'; // Perlu ditambahkan di pubspec.yaml

class PriceTag extends StatelessWidget {
  final int price;

  const PriceTag({required this.price, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Formatting Harga ke Rupiah/Mata Uang Lokal
    final formatter = NumberFormat.currency(
      locale: 'id_ID', 
      symbol: 'Rp', 
      decimalDigits: 0
    );
    final formattedPrice = formatter.format(price);

    return Text(
      formattedPrice,
      style: priceStyle, // Menggunakan Atom styling
    );
  }
}