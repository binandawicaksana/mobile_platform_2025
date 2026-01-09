import 'package:flutter/material.dart';
import 'sqan_qr.dart';

class DetailMenuScreen extends StatefulWidget {
  final String name;
  final String description;
  final String price;
  final String imagePath;
  final Color imageColor;

  const DetailMenuScreen({
    super.key,
    required this.name,
    required this.description,
    required this.price,
    required this.imagePath,
    required this.imageColor,
  });

  @override
  State<DetailMenuScreen> createState() => _DetailMenuScreenState();
}

class _DetailMenuScreenState extends State<DetailMenuScreen> {
  int quantity = 1;
  bool isExpanded = false;

  // Default description text
  String get fullDescription {
    switch (widget.name.toLowerCase()) {
      case 'hamburger':
        return 'A Hamburger is a sandwich with a beef patty, served between two soft buns, and topped with various condiments such as cheese, lettuce and ketchup. Its a popular fast food item loved by many around the world.';
      case 'pizza':
        return 'A delicious pizza topped with melted mozzarella cheese and various fresh ingredients. Baked to perfection with a crispy crust and gooey cheese.';
      case 'hotdog':
        return 'A classic hotdog made with chicken, served in a soft bun with your favorite condiments. A quick and satisfying snack for any time of day.';
      case 'corndog':
        return 'A tasty corndog coated with crispy cornmeal batter, filled with cheese. Perfect combination of savory and sweet flavors.';
      default:
        return 'A delicious food item that you will surely love. Made with fresh ingredients and served with care.';
    }
  }

  String get shortDescription {
    return '${fullDescription.substring(0, 80)}...';
  }

  @override
  Widget build(BuildContext context) {
    // Get screen width to make layout responsive
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFFFE5E5),
      body: Stack(
        children: [
          // Red background with precise layout
          Positioned(
            left: -21,
            top: -149,
            child: Container(
              width: 435,
              height: 440,
              decoration: const BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(250),
                  bottomRight: Radius.circular(250),
                ),
              ),
            ),
          ),
          
          // Main Content
          SafeArea(
            child: Column(
              children: [
                // Top section (Back button and Image)
                SizedBox(
                  height: 350,
                  child: Stack(
                    children: [
                      // Back button
                      Positioned(
                        top: 16,
                        left: 16,
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.black,
                                width: 1.5,
                              ),
                            ),
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      // Food Image
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: Hero(
                            tag: widget.name,
                            child: widget.imagePath.isNotEmpty
                                ? Image.asset(
                                    widget.imagePath,
                                    width: 250,
                                    height: 250,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(
                                        Icons.fastfood,
                                        size: 200,
                                        color: Colors.white.withOpacity(0.9),
                                      );
                                    },
                                  )
                                : Icon(
                                    Icons.fastfood,
                                    size: 200,
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Bottom section (Details)
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Name
                        Text(
                          widget.name,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Subtitle
                        Text(
                          widget.description,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF8B0000), // Dark red
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Description
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isExpanded = !isExpanded;
                            });
                          },
                          child: Text(
                            isExpanded ? fullDescription : shortDescription,
                            style: TextStyle(
                              fontSize: 14,
                              color: const Color(0xFF8B0000).withOpacity(0.7),
                              height: 1.5,
                            ),
                          ),
                        ),
                        if (!isExpanded)
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isExpanded = true;
                              });
                            },
                            child: const Text(
                              'See more.',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF8B0000),
                              ),
                            ),
                          ),
                        const Spacer(),
                        // Quantity selector and Add to Cart button
                        Row(
                          children: [
                            // Quantity Selector
                            Container(
                              width: 120,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (quantity > 1) {
                                        setState(() {
                                          quantity--;
                                        });
                                      }
                                    },
                                    child: const Icon(
                                      Icons.remove,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                  Text(
                                    quantity.toString(),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        quantity++;
                                      });
                                    },
                                    child: const Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Add to Cart Button
                            Expanded(
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.red,
                                    width: 2,
                                  ),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      // Navigate to ScanQrScreen
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const ScanQrScreen(),
                                        ),
                                      );
                                    },
                                    borderRadius: BorderRadius.circular(12),
                                    child: const Center(
                                      child: Text(
                                        'Add to Cart',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
