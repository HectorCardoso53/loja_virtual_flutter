import 'package:flutter/material.dart';
import 'package:loja_virtual/common/custom_icon_button.dart';
import 'package:loja_virtual/models/item_size.dart';
import 'package:loja_virtual/models/product.dart';

import 'edit_item_size.dart';

class SizesForm extends StatelessWidget {
  SizesForm(this.product);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return FormField<List<ItemSize>>(
      initialValue: product.sizes,
      validator: (sizes) {
        if (sizes!.isEmpty) return 'Insira um tamanho';
        return null;
      },
      builder: (state) {
        final sizes = state.value ?? [];
        final canAddSize =
            sizes.length < 10; // Ajuste a condição conforme necessário

        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Tamanhos',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                CustomIconButton(
                  iconData: Icons.add,
                  color: canAddSize ? Colors.black : Colors.grey[400]!,
                  // Cor muda com base na condição
                  onTap: canAddSize
                      ? () {
                          sizes.add(ItemSize());
                          state.didChange(sizes);
                        }
                      : null, // Desativa o botão se canAddSize for falso
                ),
              ],
            ),
            Column(
              children: sizes.map((size) {
                return EditItemSize(
                  key: ObjectKey(size),
                  size: size,
                  onRemove: () {
                    sizes.remove(size);
                    state.didChange(sizes);
                  },
                  onMoveUp: (sizes.isNotEmpty && size != sizes.first)
                      ? () {
                          final index = sizes.indexOf(size);
                          if (index > 0) {
                            sizes.remove(size);
                            sizes.insert(index - 1, size);
                            state.didChange(sizes);
                          }
                        }
                      : () {},
                  // Sempre passa uma função não-nula
                  onMoveDown: (sizes.isNotEmpty && size != sizes.last)
                      ? () {
                          final index = sizes.indexOf(size);
                          if (index < sizes.length - 1) {
                            sizes.remove(size);
                            sizes.insert(index + 1, size);
                            state.didChange(sizes);
                          }
                        }
                      : () {}, // Sempre passa uma função não-nula
                );
              }).toList(),
            ),
            if (state.hasError)
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  state.errorText!,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              )
          ],
        );
      },
    );
  }
}
