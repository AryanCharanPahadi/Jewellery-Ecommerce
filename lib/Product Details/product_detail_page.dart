import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellary/Product%20Details/product_modal.dart';
import '../../Api Helper/api_helper.dart';
import '../../Component/text_container.dart';
import '../../Component/text_style.dart';
import '../../Footer/footer.dart';
import '../../Headers/custom_header.dart';
import '../../Headers/header2_delegates.dart';
import '../../Headers/second_header.dart';
import '../../Home Screen/home_controller.dart';
import '../../Shared Preferences/shared_preferences_helper.dart';
import '../../Wishlist/wishlist_controller.dart';
import 'SImilar Product/related_products.dart';
import 'add_to_cart_button.dart';
import 'add_to_wishlist_button.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product? product;

  const ProductDetailScreen({super.key, this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late Future<List<Product>> _products;
  final ScrollController _scrollController = ScrollController();
  bool isInCart = false;
  final WishlistController wishlistController = Get.put(WishlistController());

  @override
  void initState() {
    super.initState();
    _products = ApiService().fetchJewellaryProducts(widget.product!.itemTitle);
    _checkIfProductInCart();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _checkIfProductInCart() async {
    if (widget.product != null) {
      bool productExists = await _isProductInCart(widget.product!.itemId);
      setState(() {
        isInCart = productExists;
      });
    }
  }

  Future<bool> _isProductInCart(int productId) async {
    int? userId = await SharedPreferencesHelper.getUserId();
    if (userId == null) return false;
    final cartProducts = await ApiService().fetchAddToCartProducts(userId);
    return cartProducts.any((product) => product.itemId == productId);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final Product loadedProduct = widget.product ?? _getProductFromArguments();

    if (loadedProduct == null) {
      return const Scaffold(
        body: Center(child: Text("Product not found")),
      );
    }

    final images = loadedProduct.itemImg.split(',');
    final Map<String, String> specifications = loadedProduct.itemSize.isNotEmpty
        ? Map<String, String>.from(jsonDecode(loadedProduct.itemSize))
        : {};

    double getResponsiveFontSize(double baseSize) {
      if (screenWidth < 200) return baseSize * 0.7;
      if (screenWidth < 250) return baseSize * 0.8;
      if (screenWidth < 300) return baseSize * 0.9;
      return baseSize;
    }

    final MyHomePageController controller = Get.put(MyHomePageController());
    controller.loadJewellaryBannerImages();
    controller.loadJewellaryCategoryImages();

    return Scaffold(
      body: FutureBuilder<bool>(
        future: _isProductInCart(loadedProduct.itemId),
        builder: (context, snapshot) {
          bool isInCart = snapshot.data ?? false;

          return CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(child: Header()),
              SliverPersistentHeader(
                pinned: true,
                delegate: Header2Delegate(child: const Header2()),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4.0,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Left: Images
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // First Image
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey.shade300,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          child: Image.network(
                                            images[0],
                                            fit: BoxFit.cover,
                                            height: screenWidth * 0.4,
                                            width: screenWidth * 0.4,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8.0),

                                      // Additional Images (Two per row)
                                      Wrap(
                                        spacing: 8.0,
                                        runSpacing: 8.0,
                                        children: images
                                            .skip(1)
                                            .map(
                                              (image) => ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color:
                                                          Colors.grey.shade300,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  child: Image.network(
                                                    image,
                                                    fit: BoxFit.cover,
                                                    height: screenWidth * 0.2,
                                                    width: screenWidth * 0.2,
                                                  ),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ],
                                  ),
                                ),

                                // Separator Line
                                Container(
                                  width: 1.0,
                                  color: Colors.grey.shade300,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                ),

                                // Right: Product Details
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Product Name
                                      Text(
                                        loadedProduct.itemName,
                                        style: getTextStyle(
                                          fontSize: getResponsiveFontSize(28),
                                        ),
                                      ),
                                      const SizedBox(height: 8),

                                      // Product Price
                                      Text(
                                        '₹ ${loadedProduct.itemPrice}',
                                        style: getTextStyle(
                                            fontSize: getResponsiveFontSize(20),
                                            color: Colors.green),
                                      ),
                                      const SizedBox(height: 16),

                                      // Product Description
                                      Text(
                                        loadedProduct.itemDesc,
                                        style: getTextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: getResponsiveFontSize(16),
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 16),

                                      // Product Specifications Table
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.shade300,
                                              blurRadius: 4.0,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Table(
                                            border: TableBorder.all(
                                              color: Colors.grey.shade300,
                                              width: 1.0,
                                            ),
                                            columnWidths: const {
                                              0: FlexColumnWidth(1),
                                              1: FlexColumnWidth(2),
                                            },
                                            children: specifications.entries
                                                .map((entry) {
                                              return TableRow(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      entry.key,
                                                      style: getTextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            getResponsiveFontSize(
                                                                16),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      entry.value,
                                                      style: getTextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            getResponsiveFontSize(
                                                                16),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 16),

                                      // Add to Cart / Go to Cart Button
                                      Column(
                                        children: [
                                          AddToCartButton(
                                            isInCart: isInCart,
                                            loadedProduct: loadedProduct,
                                            onCartUpdated: (bool updated) {
                                              setState(() {
                                                isInCart = updated;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      AddToWishlistButton(
                                        loadedProduct: loadedProduct,
                                        wishlistController: wishlistController,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const TextContainer(title: "RELATED PRODUCTS"),
                  const SizedBox(height: 30),
                  RelatedProducts(
                    productsFuture: _products,
                    scrollController: _scrollController,
                  ),
                  const SizedBox(height: 30),
                  const ResponsiveFooter(),
                ]),
              )
            ],
          );
        },
      ),
    );
  }

  Product _getProductFromArguments() {
    final args = Get.arguments;
    if (args != null && args is Map<String, dynamic>) {
      return Product.fromJson(args);
    }
    return Product(
      itemId: 0,
      itemTitle: '',
      itemName: '',
      itemPrice: '',
      itemSize: '',
      itemDesc: '',
      itemImg: '',
    );
  }
}
