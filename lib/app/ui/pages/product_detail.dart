import 'package:flutter/material.dart';
import 'package:proypersical/app/models/product.dart';
import 'package:proypersical/app/service/product_service.dart';
import 'package:expandable/expandable.dart';

class ProductDetail extends StatefulWidget {
  final int id;

  ProductDetail({
    @required this.id,
  });
  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  final productService = new ProductService();
  Product product = new Product();
  ExpandableController _expandableController = new ExpandableController();

  @override
  void initState() {
    //getProduct();
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
        title: Text("Detalle de Producto"),
      ),
      body: FutureBuilder(
        future: getProduct(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          return Container(
            //padding: EdgeInsets.only(top: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(product.imagen), fit: BoxFit.cover),
                  ),
                ),
                Container(
                  height: 20,
                ),
                ExpandablePanel(
                  controller: _expandableController,
                  //headerAlignment: ExpandablePanelHeaderAlignment.center,
                  header: Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Text(
                      "DESCRIPCIÓN",
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  collapsed: Container(
                    padding: EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 20),
                    child: product.descripcion != null
                        ? Text(
                            product.descripcion,
                            maxLines: 4,
                            overflow: TextOverflow.fade,
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          )
                        : Text(
                            " ",
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                  ),
                  expanded: Container(
                    padding: EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 20),
                    child: product.descripcion != null
                        ? Text(
                            product.descripcion,
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          )
                        : Text(
                            " ",
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: Text(
                    "\$" + product.precio,
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<Product> getProduct() async {
    return product = await productService.getProductDetail(id: widget.id);
    //setState(() {});
  }
}
