import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


// CardModel class definition
class CardModel {
  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final double price;
  final double rating;
  // New fields for category hierarchy
  final String category;          // e.g., "pharma", "tailoring"
  final String subcategory;       // e.g., "medicines", "equipment"
  final String subSubcategory;    // e.g., "painkillers", "antibiotics"

  CardModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.price,
    required this.rating,
    required this.category,
    required this.subcategory,
    required this.subSubcategory,
  });
}


Future<List<CardModel>> fetchCards() async {
  try {
    final url = Uri.parse('https://yourserver.com/api/products');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((jsonItem) => CardModel(
        id: jsonItem['id'],
        title: jsonItem['title'],
        subtitle: jsonItem['subtitle'],
        imageUrl: jsonItem['imageUrl'],
        price: (jsonItem['price'] as num).toDouble(),
        rating: (jsonItem['rating'] as num).toDouble(),
        category: jsonItem['category'] ?? '',
        subcategory: jsonItem['subcategory'] ?? '',
        subSubcategory: jsonItem['subSubcategory'] ?? '',
      )).toList();
    } else {
      throw Exception('Failed to load products: ${response.statusCode}');
    }
  } catch (e) {
    // If API fails, return mock data as fallback
    print('API Error: $e. Using mock data instead.');
    return [
      CardModel(
        id: '1',
        title: 'Premium Tailoring',
        subtitle: 'Custom fits for every occasion',
        imageUrl: 'https://via.placeholder.com/150',
        price: 299.99,
        rating: 4.8,
        category: 'tailoring',
        subcategory: 'custom',
        subSubcategory: 'premium',
      ),
      CardModel(
        id: '2',
        title: 'Wedding Dresses',
        subtitle: 'Beautiful designs for your special day',
        imageUrl: 'https://via.placeholder.com/150',
        price: 899.99,
        rating: 4.9,
        category: 'tailoring',
        subcategory: 'wedding',
        subSubcategory: 'bridal',
      ),
      CardModel(
        id: '3',
        title: 'Pain Relief Medicine',
        subtitle: 'Fast-acting pain relief tablets',
        imageUrl: 'https://via.placeholder.com/150',
        price: 49.99,
        rating: 4.5,
        category: 'pharma',
        subcategory: 'medicines',
        subSubcategory: 'painkillers',
      ),
      CardModel(
        id: '4',
        title: 'Formal Suits',
        subtitle: 'Professional attire for business',
        imageUrl: 'https://via.placeholder.com/150',
        price: 599.99,
        rating: 4.7,
        category: 'tailoring',
        subcategory: 'formal',
        subSubcategory: 'business',
      ),
    ];
  }
}

// ProductCards widget
class ProductCards extends StatelessWidget {
  final String title;
  final List<CardModel> cards;

  const ProductCards({
    super.key,
    required this.title,
    required this.cards,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        SizedBox(
          height: 244,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: cards.length,
            itemBuilder: (context, index) {
              return ProductCard(card: cards[index]);
            },
          ),
        ),
      ],
    );
  }
}

// Individual ProductCard widget
class ProductCard extends StatelessWidget {
  final CardModel card;

  const ProductCard({
    super.key,
    required this.card,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Container(
                height: 130,
                width: double.infinity,
                color: Colors.grey[300],
                child: card.imageUrl.isNotEmpty && card.imageUrl != 'https://via.placeholder.com/150'
                    ? Image.network(
                  card.imageUrl,
                  height: 130,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 130,
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.broken_image,
                        size: 50,
                        color: Colors.grey,
                      ),
                    );
                  },
                )
                    : const Icon(
                  Icons.image,
                  size: 50,
                  color: Colors.grey,
                ),
              ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      card.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ),
                    const SizedBox(height: 4),

                    // Subtitle
                    Text(
                      card.subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),

                    // Price and Rating
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '₹${card.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A08A3),
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              size: 14,
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 1),
                            Text(
                              card.rating.toString(),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
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