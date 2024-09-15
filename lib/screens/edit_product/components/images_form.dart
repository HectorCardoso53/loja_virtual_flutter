import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/product.dart';
import 'package:loja_virtual/screens/edit_product/components/image_source_sheet.dart';

class ImagesForm extends StatelessWidget {
  const ImagesForm(this.product);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return FormField<List<dynamic>>(
      initialValue: List.from(product.images), // Isso deve ser uma lista de Strings
      builder: (state) {
        void onImageSelected(File file) {
          final imagePath = file.path; // Converta File para String (caminho do arquivo)
          state.value!.add(imagePath);
          state.didChange(state.value);
          Navigator.of(context).pop();
        }

        return Column(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: 400.0,
                autoPlay: false,
                enlargeCenterPage: true,
              ),
              items: state.value?.map<Widget>((image) {
                return Builder(
                  builder: (BuildContext context) {
                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        // Exibição de imagens
                        if (image.startsWith('http') || image.startsWith('https'))
                          Image.network(image,
                              fit: BoxFit.cover, width: double.infinity)
                        else
                          Image.file(File(image),
                              fit: BoxFit.cover, width: double.infinity),
                        // Botão de remover imagem
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            onPressed: () {
                              state.didChange(state.value!..remove(image));
                            },
                            icon: Icon(Icons.remove),
                            color: Colors.red,
                          ),
                        ),
                      ],
                    );
                  },
                );
              }).toList()
                ?..add(
                  Material(
                    color: Colors.grey[100],
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: IconButton(
                        onPressed: () {
                          // Ação do botão
                          if (Platform.isAndroid)
                            showModalBottomSheet(
                              context: context,
                              builder: (_) => ImageSourceSheet(
                                onImageSelected: onImageSelected,
                              ),
                            );
                          else
                            showCupertinoModalPopup(
                              context: context,
                              builder: (_) => ImageSourceSheet(
                                onImageSelected: onImageSelected,
                              ),
                            );
                        },
                        icon: Icon(Icons.add_a_photo),
                        color: Theme.of(context).primaryColor,
                        iconSize: 50,
                      ),
                    ),
                  ),
                ),
            ),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  state.errorText!,
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
        );
      },
      validator: (images) {
        if (images == null || images.isEmpty) {
          return 'Adicione ao menos uma imagem';
        }
        return null;
      },
      onSaved: (images)=> product.newImages = images!,
    );
  }
}
