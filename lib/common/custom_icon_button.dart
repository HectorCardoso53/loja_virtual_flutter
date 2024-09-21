import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    super.key,
    required this.iconData,
    required this.color,
    this.onTap,
    this.size, // Parâmetro opcional
  });

  final IconData iconData;
  final Color color;
  final VoidCallback? onTap;
  final double? size; // Definindo como opcional usando o `?`

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Container(
            color: onTap == null ? Colors.grey[200] : Colors.transparent, // Cor de fundo do botão desativado
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Icon(
                iconData,
                color: onTap == null ? Colors.grey[400] : color,
                size: size ?? 24, // Valor padrão de 24 se `size` for nulo
              ),
            ),
          ),
        ),
      ),
    );
  }
}
