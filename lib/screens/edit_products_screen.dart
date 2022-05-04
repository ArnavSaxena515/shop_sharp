// This screen allows users to update product details or fill in the details of a new product to be added

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

import '../providers/auth.dart';
import '../providers/product.dart';
import '../providers/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({Key? key}) : super(key: key);
  static const String routeName = '/edit-products-screen';

  // route name for the routes table

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  //focus nodes to facilitate user navigation across the different form fields
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();

  // all form variables initialised with empty values
  String title = "", description = "", imageUrl = "", id = "";
  double price = 0.0;
  bool isFavorite = false;

  final TextEditingController _imageUrlController = TextEditingController();

  // Global Key to be hooked with the form to manage its state
  final _addProductFormKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    // adding a listener to imageFocusNode to listen for updates in the url provided for the image to load the image preview once URL entered by user
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  // bool to check if the widget has been initalised once before, to be used in didChangeDependencies
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      //execute only if isInit is true, ie if the state of this widget is just initialising for the first time

      //product ID passed by the screen it was called from
      final arg = (ModalRoute.of(context)!.settings.arguments ?? "").toString();
      String productID = arg;
      if (productID.isNotEmpty) {}
      // try to find the product by id, if product not found, a dummy product with empty values is returned
      final product = Provider.of<Products>(context).findByID(productID);
      //print("details returned by function");
      //product.printDetails();
      // initialise all form values, in case the user wants to edit the product, the previous details are shown by loading them in corresponding variables
      title = product.title;
      description = product.description;
      price = product.price;
      imageUrl = product.imageUrl;
      _imageUrlController.text = product.imageUrl;
      id = productID;
      isFavorite = product.isFavorite;
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    //dispose all listeners and focus nodes to prevent memory leaks
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    //function to call for an update to state once image url is updated
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    //method to save the form details and update the items list as needed
    //todo generate a random ID for product
    if (_addProductFormKey.currentState!.validate()) {
      _addProductFormKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      // to save variables by executing the onsaved method of the form fields, be sure to call .save() after successful validation

      // product is initialised with all the details filled by user and a random ID is generated
      final Product newProduct = Product(
        title: title,
        imageUrl: imageUrl,
        price: price,
        description: description,
        id: id.isEmpty ? '$title/${DateTime.now()}' : id,
        isFavorite: isFavorite,
      );
      //  newProduct.printDetails();

      if (id.isEmpty) {
        final userId = Provider.of<Auth>(context, listen: false).userId;
        await Provider.of<Products>(context, listen: false).addNewProduct(newProduct, userId).catchError((error) {
          // ignore: prefer_void_to_null
          return showDialog<Null>(
              context: context,
              builder: (ctx) => AlertDialog(
                    title: const Text("An error Occurred"),
                    content: const Text("Something went wrong, please try again"),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(ctx).pop();
                          },
                          child: const Text("Okay"))
                    ],
                  ));
        }).then((_) {
          setState(() {
            _isLoading = false;
          });
          Navigator.of(context).pop();
        });
      } else {
        await Provider.of<Products>(context, listen: false).updateProduct(id, newProduct).catchError((error) {
          // ignore: prefer_void_to_null
          return showDialog<Null>(
              context: context,
              builder: (ctx) => AlertDialog(
                    title: const Text("An error Occurred"),
                    content: const Text("Something went wrong, please try again"),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(ctx).pop();
                          },
                          child: const Text("Okay"))
                    ],
                  ));
        }).then((_) {
          setState(() {
            _isLoading = false;
          });
          Navigator.of(context).pop();
        });
      }
    }
    return;
  }

  void _clearForm() {
    // function to clear all details
    setState(() {
      _addProductFormKey.currentState!.reset();
      imageUrl = '';
      title = '';
      description = '';
      price = 0;
    });
  }

  // bool _isImageURlValid(String url) {
  //   //todo implement regex to validate image url
  //   return true;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Product"),
        actions: [IconButton(onPressed: () => _saveForm(), icon: const Icon(Icons.save))],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _addProductFormKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: title,
                        decoration: const InputDecoration(label: Text("Title"), hintText: "Product Name"),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        onSaved: (productTitle) {
                          title = productTitle!;
                        },
                        validator: (value) => value!.isEmpty ? "Please enter a Title" : null,
                      ),
                      TextFormField(
                        initialValue: price.toStringAsFixed(2),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter a price";
                          }
                          if (double.tryParse(value) == null) {
                            return "Please enter a valid number";
                          }
                          if (double.parse(value) <= 0.0) {
                            return "The price must be greater than 0";
                          }

                          return null;
                        },
                        decoration: const InputDecoration(label: Text("Price"), hintText: "Price per unit"),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        onSaved: (productPrice) {
                          price = double.parse(productPrice!);
                        },
                        onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_descriptionFocusNode),
                      ),
                      TextFormField(
                        initialValue: description,
                        validator: (value) => value!.length < 10 ? "Please enter at least 10 characters in the product description" : null,
                        decoration: const InputDecoration(label: Text("Description"), hintText: "Brief description of the product"),
                        textInputAction: TextInputAction.next,
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        focusNode: _descriptionFocusNode,
                        onSaved: (productDescription) {
                          description = productDescription!;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            margin: const EdgeInsets.only(top: 8, right: 10),
                            decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
                            child: _imageUrlController.text.isEmpty
                                //show empty box with text if image url not loaded or entered yet
                                ? const Center(child: Text("Enter a valid URL"))
                                : FittedBox(
                                    child: Stack(
                                    children: [
                                      //shows circular progress indicator while image loads,
                                      const Center(child: CircularProgressIndicator()),
                                      FadeInImage.memoryNetwork(
                                        image: _imageUrlController.text,
                                        placeholder: kTransparentImage,
                                      ),
                                    ],
                                  )

                                    //     Image.network(
                                    //   _imageUrlController.text,
                                    //   fit: BoxFit.cover,
                                    // ),
                                    ),
                          ),
                          Expanded(
                            child: TextFormField(
                              onFieldSubmitted: (value) {
                                // setState(() {
                                //   _imageUrlController.text = value;
                                // });
                                imageUrl = value;
                                _saveForm();
                              },
                              controller: _imageUrlController,
                              decoration: const InputDecoration(
                                label: Text("Image URL"),
                                hintText: "Enter the image URL here",
                              ),
                              textInputAction: TextInputAction.done,
                              focusNode: _imageUrlFocusNode,
                              onSaved: (productImageUrl) {
                                setState(() {
                                  imageUrl = productImageUrl!;
                                });
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter an image URL.";
                                }
                                return null;
                                // if (value.startsWith('http') && !value.startsWith('https')) {
                                //   return "Please enter a valid URL.";
                                // }
                                // if (!value.endsWith(".jpg") && !value.endsWith(".png") && !value.endsWith(".jpeg")) {
                                //   return "Please enter a valid URL.";
                                // }
                              },
                            ),
                          ) // show image preview to user
                        ],
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(width: 150, child: ElevatedButton(onPressed: _saveForm, child: const Text("Submit Details"))),
                          SizedBox(width: 150, child: ElevatedButton(onPressed: _clearForm, child: const Text("Reset"))),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
