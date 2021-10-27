import 'dart:async';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:proypersical/app/models/product.dart';
import 'package:proypersical/app/service/authentication_service.dart';
import 'package:proypersical/app/service/product_service.dart';
import 'package:proypersical/app/ui/pages/product_detail.dart';
import 'package:proypersical/app/ui/pages/product_create.dart';
import 'package:proypersical/app/widgets/card_producto.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final productService = new ProductService();
  StreamController _postsController;
  List<Product> products = [];

  @override
  void initState() {
    _postsController = new StreamController();
    getPost();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Productos"),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: Colors.white70,
            ),
            onPressed: () async {
              Navigator.of(context).pushReplacementNamed('home');
            },
          ),
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.white70,
            ),
            onPressed: () async {
              context.read<AuthenticationService>().signOut();
              Navigator.of(context).pushReplacementNamed('login');
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _postsController.stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Ocurrio el siguiente error ${snapshot.error}"),
            );
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          products = snapshot.data;

          return Scrollbar(
            child: RefreshIndicator(
              onRefresh: getPost,
              child: Container(
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    if (products == null) {
                      return CircularProgressIndicator();
                    }

                    return CardProducto(
                      imagen: products[index].imagen.length > 0
                          ? products[index].imagen
                          : null,
                      precio: products[index].precio,
                      titulo: products[index].nombre,
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ProductDetail(
                              id: products[index].id,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ProductCreate()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  /*Future getProducts() async {
    return products = await productService.getProducts();
  }*/

  Future getPost() async {
    await Future.delayed(Duration(seconds: 2));
    productService.getProducts().then((res) async {
      _postsController.add(res);
      return res;
    });
  }
}
