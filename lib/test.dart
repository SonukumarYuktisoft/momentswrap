
  // Widget _buildImageCarousel() {
  //   final images = widget.product.images.isNotEmpty ? widget.product.images : [''];
  //   final hasValidImages = widget.product.images.isNotEmpty;
    
  //   return SliverToBoxAdapter(
  //     child: Container(
  //       height: MediaQuery.of(context).size.height * 0.5,
  //       color: Colors.grey[100],
  //       child: Stack(
  //         children: [
  //           PageView.builder(
  //             controller: pageController,
  //             onPageChanged: (index) => setState(() => currentImageIndex = index),
  //             itemCount: images.length,
  //             itemBuilder: (context, index) {
  //               return Container(
  //                 padding: EdgeInsets.all(20),
  //                 child: hasValidImages
  //                     ? Image.network(
  //                         images[index],
  //                         fit: BoxFit.contain,
  //                         errorBuilder: (_, __, ___) => _buildPlaceholderImage(),
  //                       )
  //                     : _buildPlaceholderImage(),
  //               );
  //             },
  //           ),

  //           // Actions
  //           Positioned(
  //             top: 20,
  //             right: 20,
  //             child: Column(
  //               children: [
  //                 _buildActionButton(Icons.favorite_border, () {}),
  //                 SizedBox(height: 12),
  //                 _buildActionButton(Icons.share_outlined, () {
  //                   ShareHelper.shareProduct(
  //                     name: widget.product.name,
  //                     price: widget.product.price.toString(),
  //                     imageUrl: hasValidImages ? widget.product.images.first : "",
  //                     shareUrl: 'https://moment-wrap-frontend.vercel.app/product/${widget.product.id}',
  //                   );
  //                 }),
  //               ],
  //             ),
  //           ),

  //           // Page Indicators
  //           if (images.length > 1)
  //             Positioned(
  //               bottom: 20,
  //               left: 0,
  //               right: 0,
  //               child: Center(
  //                 child: SmoothPageIndicator(
  //                   controller: pageController,
  //                   count: images.length,
  //                   effect: WormEffect(
  //                     dotColor: Colors.grey[300]!,
  //                     activeDotColor: AppColors.primaryColor,
  //                     dotHeight: 8,
  //                     dotWidth: 8,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //         ],
  //       ),
  //     ),
  //   );
  // }


