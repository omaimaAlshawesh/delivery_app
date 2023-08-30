// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'model.dart';

class Product extends Equatable {
  final String id;
  final String titleEn;
  final String descriptionEn;
  final String titleAr;
  final String descriptionAr;
  final String coverUrl;
  final List<String> images;
  final bool soldOut;
  final String category;
  final double price;
  final int quantity;
  final int discount;
  final bool active;
  final List<Review> reviews;

  const Product({
    required this.id,
    required this.titleAr,
    required this.descriptionAr,
    required this.titleEn,
    required this.descriptionEn,
    required this.coverUrl,
    required this.images,
    required this.active,
    required this.soldOut,
    required this.category,
    required this.price,
    required this.quantity,
    required this.discount,
    required this.reviews,
  });

  static Product empty() => const Product(
        id: '',
        titleEn: '',
        descriptionEn: '',
        titleAr: '',
        descriptionAr: '',
        coverUrl: '',
        images: [],
        soldOut: false,
        category: '',
        price: 0,
        active: false,
        quantity: 0,
        discount: 0,
        reviews: [],
      );

  @override
  List<Object?> get props => [
        id,
        titleAr,
        descriptionAr,
        titleEn,
        descriptionEn,
        coverUrl,
        images,
        soldOut,
        category,
        price,
        active,
        quantity,
        discount,
        reviews
      ];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'titleEn': titleEn,
      'descriptionEn': descriptionEn,
      'titleAr': titleAr,
      'descriptionAr': descriptionAr,
      'coverUrl': coverUrl,
      'images': images,
      'soldOut': soldOut,
      'category': category,
      'price': price,
      'quantity': quantity,
      'discount': discount,
      'active': active,
      'reviews': reviews.map((x) => x.toMap()).toList(),
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as String,
      titleEn: map['titleEn'] as String,
      descriptionEn: map['descriptionEn'] as String,
      titleAr: map['titleAr'] as String,
      descriptionAr: map['descriptionAr'] as String,
      coverUrl: map['coverUrl'] as String,
      images: List<String>.from(map['images'].map((e) => e)),
      soldOut: map['soldOut'] as bool,
      category: map['category'] as String,
      price: map['price'] as double,
      quantity: map['quantity'] as int,
      discount: map['discount'] as int,
      active: map['active'] as bool,
      reviews: List<Review>.from(
        map['reviews'].map<Review>(
          (x) => Review.fromMap(x),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source) as Map<String, dynamic>);

  Product copyWith({
    String? id,
    String? titleEn,
    String? descriptionEn,
    String? titleAr,
    String? descriptionAr,
    String? coverUrl,
    List<String>? images,
    bool? soldOut,
    String? category,
    double? price,
    int? quantity,
    int? discount,
    bool? active,
    List<Review>? reviews,
  }) {
    return Product(
      id: id ?? this.id,
      titleEn: titleEn ?? this.titleEn,
      descriptionEn: descriptionEn ?? this.descriptionEn,
      titleAr: titleAr ?? this.titleAr,
      descriptionAr: descriptionAr ?? this.descriptionAr,
      coverUrl: coverUrl ?? this.coverUrl,
      images: images ?? this.images,
      soldOut: soldOut ?? this.soldOut,
      category: category ?? this.category,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      discount: discount ?? this.discount,
      active: active ?? this.active,
      reviews: reviews ?? this.reviews,
    );
  }
}
