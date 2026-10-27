import 'package:flutter/material.dart';

typedef FavoritePressed = void Function(int index);
typedef ProductTapped = Future<void> Function(int index);

class ProductsListView extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final FavoritePressed onFavoritePressed;
  final ProductTapped onProductTap;

  const ProductsListView({
    super.key,
    required this.products,
    required this.onFavoritePressed,
    required this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: products.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final product = products[index];
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              child: Text(product['name'].toString().substring(0, 1)),
            ),
            title: Text(product['name'].toString()),
            subtitle: Text('\$${product['price']}'),
            trailing: IconButton(
              tooltip: 'Add to favorites',
              onPressed: () => onFavoritePressed(index),
              icon: const Icon(Icons.favorite_border, color: Colors.red),
            ),
            onTap: () => onProductTap(index),
          ),
        );
      },
    );
  }
}

class ProductsGridView extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final FavoritePressed onFavoritePressed;
  final ProductTapped onProductTap;

  const ProductsGridView({
    super.key,
    required this.products,
    required this.onFavoritePressed,
    required this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.35,
      ),
      itemBuilder: (context, index) {
        final product = products[index];
        return Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => onProductTap(index),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          product['name'].toString(),
                          style: Theme.of(context).textTheme.titleMedium,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        tooltip: 'Add to favorites',
                        onPressed: () => onFavoritePressed(index),
                        icon: const Icon(Icons.favorite_border, color: Colors.red),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    '\$${product['price']}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  const Text('Tap to view details'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
