import 'dart:io';
import 'dart:wasm';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:proypersical/app/helpers/alert_dialog.dart';

import 'package:proypersical/app/service/product_service.dart';
import 'package:proypersical/app/widgets/text_field_simple.dart';

class ProductCreate extends StatefulWidget {
  @override
  _ProductCreateState createState() => _ProductCreateState();
}

class _ProductCreateState extends State<ProductCreate> {
  File imagen;
  final picker = ImagePicker();
  final productService = new ProductService();
  final _formKey = GlobalKey<FormState>();
  String formNombre;
  String formDescripcion;
  num formPrecio;

  FocusNode nombreFocusNode;
  FocusNode descripcionFocusNode;
  FocusNode precioFocusNode;

  @override
  void initState() {
    nombreFocusNode = new FocusNode();
    descripcionFocusNode = new FocusNode();
    precioFocusNode = new FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Crear Producto"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Form(
              key: _formKey,
              child: Container(
                padding:
                    EdgeInsets.only(top: 30, left: 30, right: 30, bottom: 30),
                child: Column(
                  children: <Widget>[
                    AppTextFieldSimple(
                      //initialValue: formEmail,
                      isRequired: true,
                      titulo: "Nombre",
                      tituloColor: Color(0xff51585F),
                      onValueChanged: (valor) {
                        formNombre = valor;
                      },
                      capitalization: TextCapitalization.none,
                      fillColor: Colors.white,
                      thisFocusNode: nombreFocusNode,
                      nextFocusNode: descripcionFocusNode,
                    ),
                    Container(
                      height: 20,
                    ),
                    AppTextFieldSimple(
                      titulo: "Descripción",
                      isRequired: true,
                      maxCharacters: 100,
                      tituloColor: Color(0xff51585F),
                      onValueChanged: (valor) {
                        formDescripcion = valor;
                      },
                      capitalization: TextCapitalization.words,
                      fillColor: Colors.white,
                      thisFocusNode: descripcionFocusNode,
                      nextFocusNode: precioFocusNode,
                    ),
                    Container(
                      height: 20,
                    ),
                    AppTextFieldSimple(
                      titulo: "Precio",
                      isRequired: true,
                      tituloColor: Color(0xff51585F),
                      onValueChanged: (valor) {
                        try {
                          formPrecio = double.parse(valor);
                        } on FormatException {
                          print('Format error!');
                        }
                      },
                      capitalization: TextCapitalization.none,
                      fillColor: Colors.white,
                      isDecimal: true,
                      maxCharacters: 8,
                      thisFocusNode: precioFocusNode,
                    ),
                    Container(
                      height: 20,
                    ),
                    Text(
                      "Seleccione una imagen para el producto",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Container(
                      margin: EdgeInsets.all(20),
                      height: MediaQuery.of(context).size.height / 8,
                      width: MediaQuery.of(context).size.height / 8,
                      child: GestureDetector(
                        onTap: () async {
                          var pickerFile = await picker.getImage(
                              source: ImageSource.gallery);
                          setState(
                            () {
                              if (pickerFile != null) {
                                imagen = File(pickerFile.path);
                              }
                            },
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(150),
                          child: Container(
                            color: Colors.grey[200],
                            height: 150,
                            width: 150,
                            child: Stack(
                              fit: StackFit.expand,
                              children: <Widget>[
                                (imagen != null)
                                    ? Image.file(imagen)
                                    : Image(
                                        fit: BoxFit.cover,
                                        image: AssetImage(
                                          'assets/no_image.png',
                                        ),
                                      ),
                                Center(
                                  child: Text("Cambiar"),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: GestureDetector(
        onTap: () async {
          dynamic result = await productService.postProduct(
              descripcion: formDescripcion,
              nombre: formNombre,
              precio: formPrecio,
              imagen: imagen);

          if (result == "ok") {
            return mostrarDialogoWithRoute(
              context,
              "¡Éxito!",
              "El producto se cargó exitosamente",
              "home",
            );
          } else {
            return mostrarDialogo(
              context,
              "Error",
              result,
            );
          }
          //print(result);
          /*if (formDni.trim() != "0") {
                          _onActualizar();
                        } else {
                          AlertManager.mostrarError(
                              context, "EL CI es inválido");
                        }*/
        },
        child: Container(
          alignment: Alignment.center,
          child: Text(
            "Guardar",
            style: TextStyle(fontFamily: "Gotham", color: Colors.white),
            textAlign: TextAlign.center,
          ),
          color: Theme.of(context).primaryColor,
          height: 45,
          width: double.infinity,
        ),
      ),
    );
  }
}

Future<File> comprimirImagen(File file) async {
  final directory = await getApplicationDocumentsDirectory();

  var resultBytes = await FlutterImageCompress.compressWithFile(
    file.path,
    quality: 75,
  );

  var resultFile = await File(directory.path + "/tmp_image_compress.jpeg")
      .writeAsBytes(resultBytes);

  return resultFile;
}
