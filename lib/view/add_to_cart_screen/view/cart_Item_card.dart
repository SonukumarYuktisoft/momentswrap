// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:Xkart/controllers/cart_controller/cart_controller.dart';

// class CartItemCard extends StatefulWidget {
//   final String imageUrl;
//   final String title;
//   final double price;
//   final int quantity;
//   final String productId;
//   final VoidCallback? onIncrease;
//   final VoidCallback? onDecrease;
//   final VoidCallback? onDelete;

//   const CartItemCard({
//     super.key,
//     required this.imageUrl,
//     required this.title,
//     required this.price,
//     required this.quantity,
//     required this.productId,
//     this.onIncrease,
//     this.onDecrease,
//     this.onDelete,
//   });

//   @override
//   State<CartItemCard> createState() => _CartItemCardState();
// }

// class _CartItemCardState extends State<CartItemCard> {
//   final CartController cartController = Get.find<CartController>();

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Row(
//           children: [
//             // Product Image
//             ClipRRect(
//               borderRadius: BorderRadius.circular(8),
//               child: Image.network(
//                 widget.imageUrl.isNotEmpty
//                     ? widget.imageUrl
//                     : 'https://via.placeholder.com/80',
//                 width: 80,
//                 height: 80,
//                 fit: BoxFit.cover,
//                 errorBuilder: (context, error, stackTrace) {
//                   return Container(
//                     width: 80,
//                     height: 80,
//                     decoration: BoxDecoration(
//                       color: Colors.grey[200],
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: const Icon(
//                       Icons.image_not_supported,
//                       color: Colors.grey,
//                       size: 32,
//                     ),
//                   );
//                 },
//                 loadingBuilder: (context, child, loadingProgress) {
//                   if (loadingProgress == null) return child;
//                   return Container(
//                     width: 80,
//                     height: 80,
//                     decoration: BoxDecoration(
//                       color: Colors.grey[200],
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: const Center(
//                       child: CircularProgressIndicator(strokeWidth: 2),
//                     ),
//                   );
//                 },
//               ),
//             ),
//             const SizedBox(width: 12),

//             // Product Details
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     widget.title,
//                     style: const TextStyle(
//                       fontWeight: FontWeight.w600,
//                       fontSize: 16,
//                     ),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     '\₹${widget.price.toStringAsFixed(2)}',
//                     style: TextStyle(
//                       color: Colors.orange[700],
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                     ),
//                   ),
//                   const SizedBox(height: 8),

//                   // Quantity Controls
//                   Row(
//                     children: [
//                       _QuantityButton(
//                         icon: Icons.remove,
//                         onPressed:
//                             widget.onDecrease ??
//                             () {
//                               // Default decrease functionality
//                               if (widget.quantity > 1) {
//                                 // Implement quantity decrease logic
//                                 // You might want to call an update cart API here
//                               }
//                             },
//                       ),
//                       const SizedBox(width: 12),
//                       Text(
//                         '${widget.quantity}',
//                         style: const TextStyle(
//                           fontWeight: FontWeight.w600,
//                           fontSize: 16,
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Obx(() {
//                         if (cartController.isAddCartLoading.value) {
//                           return const SizedBox(
//                             width: 20,
//                             height: 20,
//                             child: CircularProgressIndicator(strokeWidth: 2),
//                           );
//                         } else {
//                           return _QuantityButton(
//                             icon: Icons.add,
//                             onPressed: widget.onIncrease ?? () {},
//                           );
//                         }
//                       }),
//                     ],
//                   ),
//                 ],
//               ),
//             ),

//             // Delete Button
//             Column(
//               children: [
//                 Obx(() {
//                   return cartController.isRemoveFromCartLoading.value
//                       ? const SizedBox(
//                           width: 20,
//                           height: 20,
//                           child: CircularProgressIndicator(strokeWidth: 2),
//                         )
//                       : IconButton(
//                           onPressed: widget.onDelete,

//                           icon: Icon(
//                             Icons.delete_outline,
//                             color: Colors.red[400],
//                           ),
//                         );
//                 }),
//                 const SizedBox(height: 8),
//                 Text(
//                   'Total: \₹${(widget.price * widget.quantity).toStringAsFixed(2)}',
//                   style: const TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.grey,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<bool> _showDeleteConfirmation(BuildContext context) async {
//     return await showDialog<bool>(
//           context: context,
//           builder: (context) => AlertDialog(
//             title: const Text('Remove Item'),
//             content: const Text(
//               'Are you sure you want to remove this item from your cart?',
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.of(context).pop(false),
//                 child: const Text('Cancel'),
//               ),
//               TextButton(
//                 onPressed: () => Navigator.of(context).pop(true),
//                 style: TextButton.styleFrom(foregroundColor: Colors.red),
//                 child: const Text('Remove'),
//               ),
//             ],
//           ),
//         ) ??
//         false;
//   }
// }

// class _QuantityButton extends StatelessWidget {
//   final IconData icon;
//   final VoidCallback onPressed;

//   const _QuantityButton({required this.icon, required this.onPressed});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 32,
//       height: 32,
//       decoration: BoxDecoration(
//         color: Colors.blue.shade50,
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: Colors.blue.shade200),
//       ),
//       child: IconButton(
//         padding: EdgeInsets.zero,
//         icon: Icon(icon, size: 16, color: Colors.blue[700]),
//         onPressed: onPressed,
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:Xkart/view/add_to_cart_screen/controller/cart_controller.dart';

class CartItemCard extends StatefulWidget {
  final String imageUrl;
  final String title;
  final double price;
  final int initialQuantity; // API quantity
  final String productId;
  final String cartItemId; // Cart item ID for local quantity management
  final VoidCallback? onDelete;

  const CartItemCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.initialQuantity,
    required this.productId,
    required this.cartItemId,
    this.onDelete,
  });

  @override
  State<CartItemCard> createState() => _CartItemCardState();
}

class _CartItemCardState extends State<CartItemCard> {
  final CartController cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                widget.imageUrl.isNotEmpty
                    ? widget.imageUrl
                    : 'https://via.placeholder.com/80',
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.image_not_supported,
                      color: Colors.grey,
                      size: 32,
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),

            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\₹${widget.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Colors.orange[700],
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Quantity Controls with Reactive UI
                  Obx(() {
                    final localQuantity = cartController.getLocalQuantity(
                      widget.cartItemId,
                    );

                    return Row(
                      children: [
                        _QuantityButton(
                          icon: FontAwesomeIcons.minus,
                          onPressed: () {
                            cartController.decreaseLocalQuantity(
                              widget.cartItemId,
                            );
                          },
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.blue.shade200),
                          ),
                          child: Text(
                            '$localQuantity',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        _QuantityButton(
                          icon: Icons.add,
                          onPressed: () {
                            cartController.increaseLocalQuantity(
                              widget.cartItemId,
                            );
                          },
                        ),
                        const SizedBox(width: 8),
                        // Show if quantity changed from API
                        if (localQuantity != widget.initialQuantity)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade100,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Modified',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.orange.shade800,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    );
                  }),
                ],
              ),
            ),

            // Delete Button and Total
            Column(
              children: [
                Obx(() {
                  return cartController.isRemoveFromCartLoading.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : IconButton(
                          onPressed: () async {
                            final shouldDelete = await _showDeleteConfirmation(
                              context,
                            );
                            if (shouldDelete) {
                              widget.onDelete?.call();
                            }
                          },
                          icon: FaIcon(
                            FontAwesomeIcons.trash,
                            color: Colors.red[400],
                          ),
                        );
                }),
                const SizedBox(height: 8),
                // Dynamic total calculation
                Obx(() {
                  final localQuantity = cartController.getLocalQuantity(
                    widget.cartItemId,
                  );
                  final total = widget.price * localQuantity;

                  return Text(
                    ' \₹${total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _showDeleteConfirmation(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Remove Item'),
            content: const Text(
              'Are you sure you want to remove this item from your cart?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Remove'),
              ),
            ],
          ),
        ) ??
        false;
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _QuantityButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(icon, size: 16, color: Colors.blue[700]),
        onPressed: onPressed,
      ),
    );
  }
}
