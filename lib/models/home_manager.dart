import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/section.dart';

class HomeManager extends ChangeNotifier {

  HomeManager() {
    _loadSections();
  }

  final List<Section> _sections = [];

  List<Section> _editingSections = [];

  bool editing = false;

  bool loading = false;  // Começa como false

  final FirebaseFirestore firestore = FirebaseFirestore.instance;


  Future<void> _loadSections() async {
    loading = true; // Definimos como true
    notifyListeners();  // Notifica o estado antes do carregamento

    try {
      // Obtendo os dados do Firestore
      final snapshot = await firestore.collection('home').orderBy('pos').get();
      _sections.clear();
      for (final DocumentSnapshot document in snapshot.docs) {
        _sections.add(Section.fromDocument(document));
      }
    } catch (e) {
      print("Erro ao carregar seções: $e");  // Captura e log de erro
    } finally {
      loading = false;  // Definimos como false após o carregamento
      notifyListeners();  // Notifica o estado após o carregamento
    }
  }

  void addSection(Section section){
    _editingSections.add(section);
    notifyListeners();
  }

  void removeSection(Section section){
    _editingSections.remove(section);
    notifyListeners();
  }

  List<Section> get sections {
    if(editing)
      return _editingSections;
    else
      return _sections;
  }

  void enterEditing(){
    editing = true;
    _editingSections = _sections.map((s)=> s.clone()).toList();
    notifyListeners();
  }

  Future<void> saveEditing() async {
    bool valid = true;

    for (final section in _editingSections) {
      if (!section.valid()) {
        valid = false;
      }
    }

    if (!valid) return;

    loading = true;
    notifyListeners(); // Notifica que o loading começou

    int pos = 0;

    try {
      for (final section in _editingSections) {
        await section.save(pos);
        pos++;
      }

      // Exclui seções que não estão na lista de seções em edição
      for (final section in List.from(_sections)) {
        if (!_editingSections.any((element) => element.id == section.id)) {
          await section.delete();
        }
      }

      // Recarregue as seções aqui para garantir que a UI tenha os dados mais recentes
      await _loadSections();

    } catch (e) {
      print('Erro durante o salvamento: $e');
      // Aqui você pode definir uma mensagem de erro para a interface
    } finally {
      loading = false;
      editing = false;
      notifyListeners(); // Notifica que o loading terminou
    }
  }

  void discartEditing(){
    editing = false;
    notifyListeners();
  }
}
