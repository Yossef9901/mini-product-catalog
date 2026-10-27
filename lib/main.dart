/*
HOMEWORK – SECTION 4: STATE LIFECYCLE & NAVIGATION
Project: Mini Product Catalog

PART 1 – SHORT ANSWERS
a) On first opening a page, initState(), didChangeDependencies(), then build() run.
b) Pressing a heart calls setState(), which schedules build() again.
c) When leaving a page, deactivate() runs. dispose() runs when its State is permanently removed.
   Returning may create a new page State, so initState(), didChangeDependencies(), and build() run again.
d) When browser width changes, didChangeDependencies() runs because MediaQuery is an inherited dependency.
   build() then runs to update the width text and switch between ListView and GridView.

PART 2 – NAVIGATOR VERSION (kept commented out as requested)
Navigator.pushNamed(context, '/products', arguments: 'Guest');
final username = ModalRoute.of(context)!.settings.arguments as String;

final result = await Navigator.push<String>(
  context,
  MaterialPageRoute(
    builder: (_) => DetailsPage(name: productName, price: productPrice),
  ),
);
if (result != null) setState(() => cartMessage = result);

// In DetailsPage:
// Navigator.pop(context, '$name added to cart');

PART 4 – SHORT ANSWERS
1) context.go replaces the current destination/stack; example: Login -> Products with context.goNamed.
   context.push adds a page above the current one; example: Products -> Details with context.push.
2) go is used for Login -> Products because the user should not return to Login using in-app back navigation.
   push is used for Details so the user can return to Products and receive the cart result.
3) Query parameter: /products?user=Guest (user follows ?).
   Path parameters: /details/Laptop/1200 (name and price are part of the path).

Note: dispose() is not guaranteed every time a page is visually left; it runs when the State is permanently removed.
*/

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mini_product_catalog/product_widgets.dart';

void main() {
  runApp(const MiniProductCatalogApp());
}

final List<Map<String, dynamic>> products = [
  {'name': 'Laptop', 'price': 1200},
  {'name': 'Phone', 'price': 800},
  {'name': 'Headphones', 'price': 150},
  {'name': 'Smart Watch', 'price': 250},
  {'name': 'Keyboard', 'price': 90},
  {'name': 'Tablet', 'price': 500},
];

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/products',
      name: 'products',
      builder: (context, state) {
        final username = state.uri.queryParameters['user'] ?? 'Guest';
        return ProductsPage(username: username);
      },
    ),
    GoRoute(
      path: '/details/:name/:price',
      name: 'details',
      builder: (context, state) {
        final name = state.pathParameters['name'] ?? 'Product';
        final price = double.tryParse(state.pathParameters['price'] ?? '') ?? 0;
        return DetailsPage(name: name, price: price);
      },
    ),
  ],
);

class MiniProductCatalogApp extends StatelessWidget {
  const MiniProductCatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Mini Product Catalog',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    debugPrint('LoginPage: initState');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    debugPrint('LoginPage: didChangeDependencies');
  }

  @override
  void deactivate() {
    debugPrint('LoginPage: deactivate');
    super.deactivate();
  }

  @override
  void dispose() {
    debugPrint('LoginPage: dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('LoginPage: build');
    return Scaffold(
      appBar: AppBar(title: const Text('Mini Product Catalog')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: Card(
            margin: const EdgeInsets.all(24),
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.storefront, size: 72, color: Colors.indigo),
                  const SizedBox(height: 16),
                  const Text(
                    'Welcome!',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text('Continue as Guest to browse products.'),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () {
                        context.goNamed(
                          'products',
                          queryParameters: {'user': 'Guest'},
                        );
                      },
                      icon: const Icon(Icons.login),
                      label: const Text('Login as Guest'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProductsPage extends StatefulWidget {
  final String username;

  const ProductsPage({super.key, required this.username});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  int favorites = 0;
  double _screenWidth = 0;
  String cartMessage = '';

  @override
  void initState() {
    super.initState();
    debugPrint('ProductsPage: initState');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final size = MediaQuery.sizeOf(context);
    _screenWidth = size.width;
    debugPrint(
      'ProductsPage: didChangeDependencies -> width: ${size.width}, height: ${size.height}',
    );
  }

  @override
  void deactivate() {
    debugPrint('ProductsPage: deactivate');
    super.deactivate();
  }

  @override
  void dispose() {
    debugPrint('ProductsPage: dispose');
    super.dispose();
  }

  Future<void> _openDetails(int index) async {
    final product = products[index];
    final encodedName = Uri.encodeComponent(product['name'].toString());
    final result = await context.push<String>(
      '/details/$encodedName/${product['price']}',
    );

    if (!mounted) return;
    if (result != null) {
      setState(() {
        cartMessage = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('ProductsPage: build');
    final width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Text(
                'Favorites: $favorites',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, ${widget.username}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 4),
            Text('Screen width: ${width.toStringAsFixed(1)} px'),
            const SizedBox(height: 12),
            if (cartMessage.isNotEmpty) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(cartMessage),
              ),
              const SizedBox(height: 8),
            ],
            Expanded(
              child: width < 600
                  ? ProductsListView(
                      products: products,
                      onFavoritePressed: (index) {
                        setState(() => favorites++);
                      },
                      onProductTap: _openDetails,
                    )
                  : ProductsGridView(
                      products: products,
                      onFavoritePressed: (index) {
                        setState(() => favorites++);
                      },
                      onProductTap: _openDetails,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailsPage extends StatefulWidget {
  final String name;
  final double price;

  const DetailsPage({
    super.key,
    required this.name,
    required this.price,
  });

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  void initState() {
    super.initState();
    debugPrint('DetailsPage: initState');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    debugPrint('DetailsPage: didChangeDependencies');
  }

  @override
  void deactivate() {
    debugPrint('DetailsPage: deactivate');
    super.deactivate();
  }

  @override
  void dispose() {
    debugPrint('DetailsPage: dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('DetailsPage: build');
    return Scaffold(
      appBar: AppBar(title: const Text('Product Details')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Card(
            margin: const EdgeInsets.all(24),
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.inventory_2_outlined, size: 76, color: Colors.indigo),
                  const SizedBox(height: 16),
                  Text(
                    widget.name,
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '\$${widget.price.toStringAsFixed(widget.price % 1 == 0 ? 0 : 2)}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () {
                        context.pop('${widget.name} added to cart');
                      },
                      icon: const Icon(Icons.shopping_cart),
                      label: const Text('Add to Cart'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
