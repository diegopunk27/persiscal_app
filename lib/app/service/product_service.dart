import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:proypersical/app/global/environment.dart';
import 'package:proypersical/app/models/product.dart';
import 'package:http_parser/http_parser.dart';

class ProductService with ChangeNotifier {
  Product product;
  //bool _autenticando = false;

  /* Permite controlar que el proceso de post todavía no terminó, así se puede evitar el doble post */
  /*bool get autenticando => _autenticando;
  set autenticando(bool valor) {
    _autenticando = valor;
    notifyListeners();
  }*/

  /* Métodos de auth */
  Future<List<Product>> getProducts() async {
    List<Product> salida;

    final response = await http.get(
      "${Environment.apiUrl}/productos",
    );
    print(response.body);

    if (response.statusCode == 200) {
      final listProduct = productFromJson(response.body);
      //print(listProduct);
      salida = listProduct;
    } else {
      salida = [];
    }

    return salida;
  }

  Future<Product> getProductDetail({@required int id}) async {
    Product salida;

    final response = await http.get(
      "${Environment.apiUrl}/productos/$id",
    );
    //print("response" + response.body);

    if (response.statusCode == 200) {
      final product = Product.fromJson(json.decode(response.body));
      salida = product;
    } else {
      salida = new Product();
    }

    return salida;
  }

  Future<dynamic> postProduct({
    @required String nombre,
    @required String descripcion,
    @required num precio,
    File imagen,
  }) async {
    dynamic salida = "";
    Map<String, dynamic> error;
    dynamic response;

    final data = {
      "nombre": nombre,
      "descripcion": descripcion,
      "precio": precio,
    };

    if (imagen != null) {
      var postUri = Uri.parse("${Environment.apiUrl}/productos");
      var request = new http.MultipartRequest("POST", postUri);
      request.fields['nombre'] = nombre;
      request.fields['descripcion'] = descripcion;
      request.fields['precio'] = precio.toString();

      var imagenaux = await http.MultipartFile.fromPath(
        "imagen",
        imagen.path,
        contentType: MediaType('image', '*'),
      );

      request.files.add(imagenaux);
      response = await request.send();
    } else {
      response = await http.post(
        "${Environment.apiUrl}/productos",
        body: jsonEncode(data),
        headers: {"Content-Type": "application/json"},
      );
    }

    if (response.statusCode == 200) {
      salida = 'ok';
    } else {
      error = jsonDecode(response.body)["result"];
      if (error.containsKey('nombre')) {
        salida += "* ${error['nombre'][0]} \n";
      }
      if (error.containsKey('descripcion')) {
        salida += "* ${error['descripcion'][0]} \n";
      }
      if (error.containsKey('precio')) {
        salida += "* ${error['precio'][0]} \n";
      }
      if (error.containsKey('imagen')) {
        salida += "* ${error['imagen'][0]} \n";
      }
    }

    return salida;
  }
}
