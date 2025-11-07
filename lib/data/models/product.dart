// lib/data/models/product.dart
import 'package:json_annotation/json_annotation.dart';

// Harus ada file terpisah: part 'product.g.dart';
part 'product.g.dart'; 

@JsonSerializable()
class Product {
  final int id;
  final String name;
  final String? description; // nullable sesuai skema DB Golang
  final int price;

  Product({
    required this.id,
    required this.name,
    this.description,
    required this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
  Map<String, dynamic> toJson() => _$ProductToJson(this);
}