import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/auth.dart';
import 'package:flutter_complete_guide/providers/cart.dart';
import 'package:flutter_complete_guide/screens/product_details_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_complete_guide/providers/product.dart';

class ProductItem extends StatelessWidget {
  // final String id, title, imgUrl;

  // ProductItem(this.id, this.title, this.imgUrl);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);

    print('product rebuilds');
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailsScreen.routeName,
                arguments: product.id);
          },
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              placeholder: AssetImage('assets/images/product-placeholder.png'),
              image: NetworkImage(
                product.imageUrl,
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        footer: Column(
          children: [
            GridTileBar(
              backgroundColor: Colors.black54,
              leading: Consumer<Product>(
                builder: (ctx, product, _) => IconButton(
                  icon: Icon(product.isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border),
                  onPressed: () {
                    product.toggleFavoriteStatus(
                        authData.token, authData.userId);
                  },
                  color: Theme.of(context).accentColor,
                ),
              ),
              title: Text(
                product.title,
                textAlign: TextAlign.center,
              ),
              trailing: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  cart.addItem(product.id, product.price, product.title);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('item has been added to the cart'),
                      duration: Duration(seconds: 2),
                      action: SnackBarAction(
                        label: 'UNDO',
                        onPressed: () {
                          cart.removeSingleItem(product.id);
                        },
                      ),
                    ),
                  );
                },
                color: Theme.of(context).accentColor,
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 5),
              width: double.infinity,
              child: Center(
                child: Text(
                  '\$${product.price}',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              color: Colors.black,
            )
          ],
        ),
      ),
    );
  }
}
