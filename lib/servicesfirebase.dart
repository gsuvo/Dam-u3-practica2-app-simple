import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dam_u3_simpleapp/residencias.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
var bd = FirebaseFirestore.instance;
class DB{
  static Future<List<Residencias>> mostrarTodos() async{
    List<Residencias> temp = [];
    var query = await bd.collection("residencias").get();
    query.docs.forEach((element) {
      Map<String,dynamic> mapa = element.data();
      var residencia=Residencias(
          id: element.id,
          noctrl: mapa['noctrl'],
          alumno: mapa['alumno'],
          semestre: mapa['semestre'],
          lugar: mapa['lugar'],
          direccion: mapa['direccion'],
      );
      temp.add(residencia);
    });return temp;
  }
  static Future<bool> insertar(Residencias residencia) async{
    try{
      await bd.collection("residencias").add({
        'noctrl': residencia.noctrl,
        'alumno': residencia.alumno,
        'semestre': residencia.semestre,
        'lugar': residencia.lugar,
        'direccion': residencia.direccion,
      });
      return true;
    }catch(e){
      return false;
    }
  }
  static Future<bool> actualizar(Residencias residencia) async{
    try{
      print("Actualizando residencia con ID: ${residencia.id}");
      print("Actualizando residencia con semestre: ${residencia.semestre}");
      await bd.collection("residencias").doc(residencia.id).update({
        'noctrl': residencia.noctrl,
        'alumno': residencia.alumno,
        'semestre': residencia.semestre,
        'lugar': residencia.lugar,
        'direccion': residencia.direccion,
      });
      return true;
    }catch(e){
      return false;
    }
  }
  static Future<bool> eliminar(String? id) async{
    try{
      await bd.collection("residencias").doc(id).delete();
      return true;
    }catch(e){
      return false;
    }
  }
}