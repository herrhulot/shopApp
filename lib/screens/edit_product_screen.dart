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

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updatedImageUrl);
    super.initState();
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

  void _saveForm() {
    final _isValidated = _formKey.currentState.validate();
    if (_isValidated) {
      _formKey.currentState.save();
      Provider.of<Products>(context, listen: false).addProduct(_editedProduct);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    var _siffrorIdiot = false;
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_siffrorIdiot)
              FittedBox(
                child: Image.network(
                    'https://d6ce0no7ktiq.cloudfront.net/images/stickers/663.png'),
              ),
            Form(
              autovalidate: true,
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Skriv nåt då, gör det bara';
                        }
                        if (value == 'Hoo ha') {
                          return 'Men skriv inte Hoo ha';
                        }
                        if (value.startsWith('Ho') || value.endsWith('a')) {
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
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                            id: null,
                            title: value,
                            description: _editedProduct.description,
                            price: _editedProduct.price,
                            imageUrl: _editedProduct.imageUrl);
                      },
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Skriv nåt då, gör det bara';
                        }
                        if (double.tryParse(value) == null) {
                          _siffrorIdiot = true;
                          print('siffror sa jag din idiot');
                          return 'Använd siffror idiot!';
                        }
                        if (double.parse(value) <= 1) {
                          return 'Nåt kostar den väl ditt luder?';
                        }
                        if (double.parse(value) >= 1000) {
                          return 'Du är inte så rik din pissluffare!';
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
                            id: null,
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            price: double.parse(value),
                            imageUrl: _editedProduct.imageUrl);
                      },
                    ),
                    TextFormField(
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
                        if (value.length > 11) {
                          return 'Skriv max 11 bokstäver!';
                        }
                        return null;
                      },
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      onSaved: (value) {
                        _editedProduct = Product(
                            id: null,
                            title: _editedProduct.title,
                            description: value,
                            price: _editedProduct.price,
                            imageUrl: _editedProduct.imageUrl);
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
                              decoration:
                                  InputDecoration(labelText: 'Enter image URL'),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlController,
                              focusNode: _imageUrlFocusNode,
                              onSaved: (value) {
                                _editedProduct = Product(
                                    id: null,
                                    title: _editedProduct.title,
                                    description: _editedProduct.description,
                                    price: _editedProduct.price,
                                    imageUrl: value);
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
