import 'dart:convert';

class Product {
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final List<String> tags;
  final String brand;
  final String sku;
  final int weight;
  final Dimensions dimensions;
  final String warrantyInformation;
  final String shippingInformation;
  final String availabilityStatus;
  final List<Review> reviews;
  final String returnPolicy;
  final int minimumOrderQuantity;
  final Meta meta;
  final List<String> images;
  final String thumbnail;

  @override
  String toString() {
    return 'Product(id: $id, title: $title, description: $description, price: $price, rating: $rating)';
  }

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.tags,
    required this.brand,
    required this.sku,
    required this.weight,
    required this.dimensions,
    required this.warrantyInformation,
    required this.shippingInformation,
    required this.availabilityStatus,
    required this.reviews,
    required this.returnPolicy,
    required this.minimumOrderQuantity,
    required this.meta,
    required this.images,
    required this.thumbnail,
  });

  Product copyWith({
    int? id,
    String? title,
    String? description,
    String? category,
    double? price,
    double? discountPercentage,
    double? rating,
    int? stock,
    List<String>? tags,
    String? brand,
    String? sku,
    int? weight,
    Dimensions? dimensions,
    String? warrantyInformation,
    String? shippingInformation,
    String? availabilityStatus,
    List<Review>? reviews,
    String? returnPolicy,
    int? minimumOrderQuantity,
    Meta? meta,
    List<String>? images,
    String? thumbnail,
  }) =>
      Product(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        category: category ?? this.category,
        price: price ?? this.price,
        discountPercentage: discountPercentage ?? this.discountPercentage,
        rating: rating ?? this.rating,
        stock: stock ?? this.stock,
        tags: tags ?? this.tags,
        brand: brand ?? this.brand,
        sku: sku ?? this.sku,
        weight: weight ?? this.weight,
        dimensions: dimensions ?? this.dimensions,
        warrantyInformation: warrantyInformation ?? this.warrantyInformation,
        shippingInformation: shippingInformation ?? this.shippingInformation,
        availabilityStatus: availabilityStatus ?? this.availabilityStatus,
        reviews: reviews ?? this.reviews,
        returnPolicy: returnPolicy ?? this.returnPolicy,
        minimumOrderQuantity: minimumOrderQuantity ?? this.minimumOrderQuantity,
        meta: meta ?? this.meta,
        images: images ?? this.images,
        thumbnail: thumbnail ?? this.thumbnail,
      );

  factory Product.fromRawJson(String str) => Product.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        title: json["title"] ?? "", // Default empty string if null
        description: json["description"] ?? "", // Default empty string if null
        category: json["category"] ?? "", // Default empty string if null
        price: json["price"]?.toDouble() ?? 0.0, // Default 0.0 if null
        discountPercentage: json["discountPercentage"]?.toDouble() ??
            0.0, // Default 0.0 if null
        rating: json["rating"]?.toDouble() ?? 0.0, // Default 0.0 if null
        stock: json["stock"] ?? 0, // Default 0 if null
        tags: List<String>.from(
            json["tags"]?.map((x) => x) ?? []), // Default empty list if null
        brand: json["brand"] ?? "", // Default empty string if null
        sku: json["sku"] ?? "", // Default empty string if null
        weight: json["weight"] ?? 0, // Default 0 if null
        dimensions: Dimensions.fromJson(
            json["dimensions"] ?? {}), // Default empty object if null
        warrantyInformation:
            json["warrantyInformation"] ?? "", // Default empty string if null
        shippingInformation:
            json["shippingInformation"] ?? "", // Default empty string if null
        availabilityStatus:
            json["availabilityStatus"] ?? "", // Default empty string if null
        reviews: List<Review>.from(
            json["reviews"]?.map((x) => Review.fromJson(x)) ??
                []), // Default empty list if null
        returnPolicy:
            json["returnPolicy"] ?? "", // Default empty string if null
        minimumOrderQuantity:
            json["minimumOrderQuantity"] ?? 0, // Default 0 if null
        meta: Meta.fromJson(json["meta"] ?? {}), // Default empty object if null
        images: List<String>.from(
            json["images"]?.map((x) => x) ?? []), // Default empty list if null
        thumbnail: json["thumbnail"] ?? "", // Default empty string if null
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "category": category,
        "price": price,
        "discountPercentage": discountPercentage,
        "rating": rating,
        "stock": stock,
        "tags": List<dynamic>.from(tags.map((x) => x)),
        "brand": brand,
        "sku": sku,
        "weight": weight,
        "dimensions": dimensions.toJson(),
        "warrantyInformation": warrantyInformation,
        "shippingInformation": shippingInformation,
        "availabilityStatus": availabilityStatus,
        "reviews": List<dynamic>.from(reviews.map((x) => x.toJson())),
        "returnPolicy": returnPolicy,
        "minimumOrderQuantity": minimumOrderQuantity,
        "meta": meta.toJson(),
        "images": List<dynamic>.from(images.map((x) => x)),
        "thumbnail": thumbnail,
      };
}

class Dimensions {
  final double width;
  final double height;
  final double depth;

  Dimensions({
    required this.width,
    required this.height,
    required this.depth,
  });

  Dimensions copyWith({
    double? width,
    double? height,
    double? depth,
  }) =>
      Dimensions(
        width: width ?? this.width,
        height: height ?? this.height,
        depth: depth ?? this.depth,
      );

  factory Dimensions.fromRawJson(String str) =>
      Dimensions.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Dimensions.fromJson(Map<String, dynamic> json) => Dimensions(
        width: json["width"]?.toDouble(),
        height: json["height"]?.toDouble(),
        depth: json["depth"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "width": width,
        "height": height,
        "depth": depth,
      };
}

class Meta {
  final DateTime createdAt;
  final DateTime updatedAt;
  final String barcode;
  final String qrCode;

  Meta({
    required this.createdAt,
    required this.updatedAt,
    required this.barcode,
    required this.qrCode,
  });

  Meta copyWith({
    DateTime? createdAt,
    DateTime? updatedAt,
    String? barcode,
    String? qrCode,
  }) =>
      Meta(
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        barcode: barcode ?? this.barcode,
        qrCode: qrCode ?? this.qrCode,
      );

  factory Meta.fromRawJson(String str) => Meta.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        barcode: json["barcode"],
        qrCode: json["qrCode"],
      );

  Map<String, dynamic> toJson() => {
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "barcode": barcode,
        "qrCode": qrCode,
      };
}

class Review {
  final int rating;
  final String comment;
  final DateTime date;
  final String reviewerName;
  final String reviewerEmail;

  Review({
    required this.rating,
    required this.comment,
    required this.date,
    required this.reviewerName,
    required this.reviewerEmail,
  });

  Review copyWith({
    int? rating,
    String? comment,
    DateTime? date,
    String? reviewerName,
    String? reviewerEmail,
  }) =>
      Review(
        rating: rating ?? this.rating,
        comment: comment ?? this.comment,
        date: date ?? this.date,
        reviewerName: reviewerName ?? this.reviewerName,
        reviewerEmail: reviewerEmail ?? this.reviewerEmail,
      );

  factory Review.fromRawJson(String str) => Review.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        rating: json["rating"],
        comment: json["comment"],
        date: DateTime.parse(json["date"]),
        reviewerName: json["reviewerName"],
        reviewerEmail: json["reviewerEmail"],
      );

  Map<String, dynamic> toJson() => {
        "rating": rating,
        "comment": comment,
        "date": date.toIso8601String(),
        "reviewerName": reviewerName,
        "reviewerEmail": reviewerEmail,
      };
}

class TypesProduct {
  final List<String> types;

  // Constructor khởi tạo mặc định
  TypesProduct()
      : types = [
          "beauty",
          "fragrances",
          "furniture",
          "groceries",
          "home-decoration",
          "kitchen-accessories",
          "laptops",
          "mens-shirts",
          "mens-shoes",
          "mens-watches",
          "mobile-accessories",
          "motorcycle",
          "skin-care",
          "smartphones",
          "sports-accessories",
          "sunglasses",
          "tablets",
          "tops",
          "vehicle",
          "womens-bags",
          "womens-dresses",
          "womens-jewellery",
          "womens-shoes",
          "womens-watches",
        ];
}

// Giả YourCarts
class YourCarts {
  List<Product> dataYourCarts;
  YourCarts()
      : dataYourCarts = [
          Product(
            id: 1,
            title: "Essence Mascara Lash Princess 1",
            description: "A popular mascara known for its volumizing effects.",
            category: "beauty",
            price: 9.99,
            discountPercentage: 7.17,
            rating: 4.94,
            stock: 5,
            tags: ["beauty", "mascara"],
            brand: "Essence",
            sku: "RCH45Q1A",
            weight: 2,
            dimensions: Dimensions(width: 23.17, height: 14.43, depth: 28.01),
            warrantyInformation: "1 month warranty",
            shippingInformation: "Ships in 1 month",
            availabilityStatus: "Low Stock",
            reviews: [
              Review(
                rating: 5,
                comment: "Very satisfied!",
                date: DateTime.parse("2024-05-23T08:56:21.618Z"),
                reviewerName: "Scarlett Wright",
                reviewerEmail: "scarlett.wright@x.dummyjson.com",
              ),
            ],
            returnPolicy: "30 days return policy",
            minimumOrderQuantity: 24,
            meta: Meta(
              createdAt: DateTime.parse("2024-05-23T08:56:21.618Z"),
              updatedAt: DateTime.parse("2024-05-23T08:56:21.618Z"),
              barcode: "9164035109868",
              qrCode: "https://assets.dummyjson.com/public/qr-code.png",
            ),
            images: [
              "https://cdn.dummyjson.com/products/images/beauty/Essence%20Mascara%20Lash%20Princess/1.png"
            ],
            thumbnail:
                "https://cdn.dummyjson.com/products/images/beauty/Essence%20Mascara%20Lash%20Princess/thumbnail.png",
          ),
          Product(
            id: 2,
            title: "Essence Mascara Lash Princess 2",
            description: "A popular mascara known for its volumizing effects.",
            category: "beauty",
            price: 9.99,
            discountPercentage: 7.17,
            rating: 4.94,
            stock: 5,
            tags: ["beauty", "mascara"],
            brand: "Essence",
            sku: "RCH45Q1A",
            weight: 2,
            dimensions: Dimensions(width: 23.17, height: 14.43, depth: 28.01),
            warrantyInformation: "1 month warranty",
            shippingInformation: "Ships in 1 month",
            availabilityStatus: "Low Stock",
            reviews: [
              Review(
                rating: 5,
                comment: "Very satisfied!",
                date: DateTime.parse("2024-05-23T08:56:21.618Z"),
                reviewerName: "Scarlett Wright",
                reviewerEmail: "scarlett.wright@x.dummyjson.com",
              ),
            ],
            returnPolicy: "30 days return policy",
            minimumOrderQuantity: 24,
            meta: Meta(
              createdAt: DateTime.parse("2024-05-23T08:56:21.618Z"),
              updatedAt: DateTime.parse("2024-05-23T08:56:21.618Z"),
              barcode: "9164035109868",
              qrCode: "https://assets.dummyjson.com/public/qr-code.png",
            ),
            images: [
              "https://cdn.dummyjson.com/products/images/beauty/Essence%20Mascara%20Lash%20Princess/1.png"
            ],
            thumbnail:
                "https://cdn.dummyjson.com/products/images/beauty/Essence%20Mascara%20Lash%20Princess/thumbnail.png",
          ),
          Product(
            id: 3,
            title: "Essence Mascara Lash Princess 3",
            description: "A popular mascara known for its volumizing effects.",
            category: "beauty",
            price: 9.99,
            discountPercentage: 7.17,
            rating: 4.94,
            stock: 5,
            tags: ["beauty", "mascara"],
            brand: "Essence",
            sku: "RCH45Q1A",
            weight: 2,
            dimensions: Dimensions(width: 23.17, height: 14.43, depth: 28.01),
            warrantyInformation: "1 month warranty",
            shippingInformation: "Ships in 1 month",
            availabilityStatus: "Low Stock",
            reviews: [
              Review(
                rating: 5,
                comment: "Very satisfied!",
                date: DateTime.parse("2024-05-23T08:56:21.618Z"),
                reviewerName: "Scarlett Wright",
                reviewerEmail: "scarlett.wright@x.dummyjson.com",
              ),
            ],
            returnPolicy: "30 days return policy",
            minimumOrderQuantity: 24,
            meta: Meta(
              createdAt: DateTime.parse("2024-05-23T08:56:21.618Z"),
              updatedAt: DateTime.parse("2024-05-23T08:56:21.618Z"),
              barcode: "9164035109868",
              qrCode: "https://assets.dummyjson.com/public/qr-code.png",
            ),
            images: [
              "https://cdn.dummyjson.com/products/images/beauty/Essence%20Mascara%20Lash%20Princess/1.png"
            ],
            thumbnail:
                "https://cdn.dummyjson.com/products/images/beauty/Essence%20Mascara%20Lash%20Princess/thumbnail.png",
          ),
          Product(
            id: 4,
            title: "Essence Mascara Lash Princess 4",
            description: "A popular mascara known for its volumizing effects.",
            category: "beauty",
            price: 9.99,
            discountPercentage: 7.17,
            rating: 4.94,
            stock: 5,
            tags: ["beauty", "mascara"],
            brand: "Essence",
            sku: "RCH45Q1A",
            weight: 2,
            dimensions: Dimensions(width: 23.17, height: 14.43, depth: 28.01),
            warrantyInformation: "1 month warranty",
            shippingInformation: "Ships in 1 month",
            availabilityStatus: "Low Stock",
            reviews: [
              Review(
                rating: 5,
                comment: "Very satisfied!",
                date: DateTime.parse("2024-05-23T08:56:21.618Z"),
                reviewerName: "Scarlett Wright",
                reviewerEmail: "scarlett.wright@x.dummyjson.com",
              ),
            ],
            returnPolicy: "30 days return policy",
            minimumOrderQuantity: 24,
            meta: Meta(
              createdAt: DateTime.parse("2024-05-23T08:56:21.618Z"),
              updatedAt: DateTime.parse("2024-05-23T08:56:21.618Z"),
              barcode: "9164035109868",
              qrCode: "https://assets.dummyjson.com/public/qr-code.png",
            ),
            images: [
              "https://cdn.dummyjson.com/products/images/beauty/Essence%20Mascara%20Lash%20Princess/1.png"
            ],
            thumbnail:
                "https://cdn.dummyjson.com/products/images/beauty/Essence%20Mascara%20Lash%20Princess/thumbnail.png",
          )
        ];
}
