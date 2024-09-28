import 'package:permission_handler/permission_handler.dart';

Future<void> requestStoragePermission() async {
  final status = await Permission.storage.request();

  if (status.isGranted) {
    print('Permissão de armazenamento concedida.');
  } else if (status.isDenied) {
    print('Permissão de armazenamento negada.');
  } else if (status.isPermanentlyDenied) {
    print('Permissão de armazenamento permanentemente negada.');
    openAppSettings(); // Abre as configurações do aplicativo para o usuário habilitar manualmente
  }
}
