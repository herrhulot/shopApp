import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: null,
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };

  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updatedImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      _imageUrlController.text =
          'https://pbs.twimg.com/profile_images/480860011980021763/NxtOwtUM_400x400.jpeg';
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imageUrl': '',
        };
        // _imageUrlController.text = _editedProduct.imageUrl;

      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updatedImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updatedImageUrl() {
    setState(() {});
  }

  Future<void> _saveForm() async {
    final _isValid = _formKey.currentState.validate();
    if (!_isValid) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != null) {
      print('id is not null');
      print(_editedProduct.id);
      Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
      setState(() {
        _isLoading = false;
      });
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        await showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text('Something went wrong.'),
            actions: [
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      // Här fanns tidigare en ListView men den  kan gå och suga en stor fet röv i en sjö nånstans!
      // Du ska använda SingleChildScrollView och Column istället!!!
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
              // child: Image.network(
              //     'https://d6ce0no7ktiq.cloudfront.net/images/stickers/663.png'),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Form(
                    autovalidate: true,
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          TextFormField(
                            initialValue: _initValues['title'],
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Skriv nåt då, gör det bara';
                              }
                              if (value == 'Hoo ha') {
                                return 'Men skriv inte Hoo ha';
                              }
                              if (value.startsWith('Ho') ||
                                  value.endsWith('a')) {
                                return 'Passa dig din jävel!';
                              }
                              if (value.length < 3) {
                                return 'Skriv längre än tre bokstäver ditt lilla...lu*er';
                              }

                              return null;
                            },
                            // initialValue: 'Hoo ha',
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(labelText: 'Title'),
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_priceFocusNode);
                            },
                            onSaved: (value) {
                              _editedProduct = Product(
                                title: value,
                                description: _editedProduct.description,
                                price: _editedProduct.price,
                                imageUrl: _editedProduct.imageUrl,
                                id: _editedProduct.id,
                                isFavorite: _editedProduct.isFavorite,
                              );
                            },
                          ),
                          TextFormField(
                            initialValue: _initValues['price'],
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Skriv nåt då, gör det bara';
                              }

                              if (double.parse(value) <= 0) {
                                return 'Nåt kostar den väl ditt luder?';
                              }
                              if (double.parse(value) >= 100000) {
                                return 'Den är inte så dyr din pissluffare!';
                              }
                              return null;
                            },
                            // initialValue: '5',
                            decoration: InputDecoration(labelText: 'Price'),
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            focusNode: _priceFocusNode,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_descriptionFocusNode);
                            },
                            onSaved: (value) {
                              _editedProduct = Product(
                                title: _editedProduct.title,
                                description: _editedProduct.description,
                                price: double.parse(value),
                                imageUrl: _editedProduct.imageUrl,
                                id: _editedProduct.id,
                                isFavorite: _editedProduct.isFavorite,
                              );
                            },
                          ),
                          TextFormField(
                            initialValue: _initValues['description'],
                            // initialValue: 'Booo yaaah!',
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Skriv nåt då, gör det bara';
                              }
                              if (value == 'Hoo ha') {
                                return 'Men skriv inte Hoo ha';
                              }
                              if (value.length <= 3) {
                                return 'Skriv längre än tre bokstäver ditt lilla...lu*er';
                              }
                              if (value.length > 200) {
                                return 'Skriv max 200 bokstäver!';
                              }
                              return null;
                            },
                            textCapitalization: TextCapitalization.sentences,
                            decoration:
                                InputDecoration(labelText: 'Description'),
                            maxLines: 3,
                            keyboardType: TextInputType.multiline,
                            focusNode: _descriptionFocusNode,
                            onSaved: (value) {
                              _editedProduct = Product(
                                title: _editedProduct.title,
                                description: value,
                                price: _editedProduct.price,
                                imageUrl: _editedProduct.imageUrl,
                                id: _editedProduct.id,
                                isFavorite: _editedProduct.isFavorite,
                              );
                            },
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                margin: EdgeInsets.only(
                                  top: 8,
                                  right: 10,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                ),
                                child: _imageUrlController.text.isEmpty
                                    ? Text('')
                                    : FittedBox(
                                        child: Image.network(
                                          _imageUrlController.text,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                              ),
                              Expanded(
                                child: TextFormField(
                                    //initialValue: _initValues['imageUrl'], När du har controller, kan inte sätta 'initialValue:'

                                    decoration: InputDecoration(
                                        labelText: 'Enter image URL'),
                                    keyboardType: TextInputType.url,
                                    textInputAction: TextInputAction.done,
                                    controller: _imageUrlController,
                                    focusNode: _imageUrlFocusNode,
                                    onSaved: (value) {
                                      _editedProduct = Product(
                                        title: _editedProduct.title,
                                        description: _editedProduct.description,
                                        price: _editedProduct.price,
                                        imageUrl: value,
                                        id: _editedProduct.id,
                                        isFavorite: _editedProduct.isFavorite,
                                      );
                                    },
                                    onFieldSubmitted: (_) {
                                      _saveForm();
                                    }),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
