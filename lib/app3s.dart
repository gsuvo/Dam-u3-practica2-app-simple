import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dam_u3_simpleapp/residencias.dart';
import 'package:dam_u3_simpleapp/servicesfirebase.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class App3s extends StatefulWidget {
  const App3s({Key? key}) : super(key: key);

  @override
  State<App3s> createState() => _App3sState();
}

class _App3sState extends State<App3s> {
  String titulo ="Residencias";
  TextEditingController ctrlNoctrl = TextEditingController();
  TextEditingController ctrlAlumno = TextEditingController();
  TextEditingController ctrlSemestre = TextEditingController();
  TextEditingController ctrlLugar = TextEditingController();
  TextEditingController ctrlDireccion = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text("${titulo}"),
            bottom: TabBar(
              tabs: [
                Icon(Icons.list),
                Icon(Icons.add),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              listaResidencias(),
              captura()
            ],
          ),
        )
    );
  }
  Widget listaResidencias() {
    return FutureBuilder(
      future: DB.mostrarTodos(),
      builder: (context, listaDatos) {
        if (listaDatos.hasData && listaDatos.data != null) {
          List<Residencias> residencias = listaDatos.data as List<Residencias>;

          return ListView.builder(
            itemCount: residencias.length,
            itemBuilder: (context, indice) {
              return Card(
                elevation: 3,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text("${residencias[indice].alumno}"),
                  subtitle: Text("${residencias[indice].noctrl}"),
                  trailing: IconButton(
                     icon: Icon(Icons.delete),
                    onPressed: (){
                      showDialog(
                          context: context,
                          builder: (context){
                            return AlertDialog(
                              title: Text("Eliminar"),
                              content: Text("¿Estás seguro de eliminar a ${residencias[indice].alumno}?"),
                              actions: [
                                TextButton(
                                    onPressed: (){
                                      Navigator.pop(context);
                                    },
                                    child: Text("No")
                                ),
                                TextButton(
                                    onPressed: (){
                                      DB.eliminar(residencias[indice].id);
                                      Navigator.pop(context);
                                      setState(() {});
                                    },
                                    child: Text("Si")
                                )
                              ],
                            );
                          }
                      );
                    }
                  ),
                  onTap: () {
                    ctrlNoctrl.text = residencias[indice].noctrl;
                    ctrlAlumno.text = residencias[indice].alumno;
                    ctrlSemestre.text = residencias[indice].semestre.toString();
                    ctrlLugar.text = residencias[indice].lugar;
                    ctrlDireccion.text = residencias[indice].direccion;
                    DefaultTabController.of(context).animateTo(1);
                  },
                ),
              );
            },
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget captura(){
    return Center(
        child: ListView(
          padding: EdgeInsets.all(20),
          children: [
            Text("Datos Residencias",
              style: TextStyle(fontSize: 20,color: Colors.pink),
            ),SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: ctrlNoctrl,
                decoration: InputDecoration(
                    suffixIcon: Icon(Icons.numbers_sharp),
                    labelText: "No. Control",
                    border: OutlineInputBorder()
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: ctrlAlumno,
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.person),
                    labelText: "Nombre del alumno",
                    border: OutlineInputBorder()
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: ctrlSemestre,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.number, // Para que el teclado sea numérico
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.format_list_numbered),
                    labelText: "Semestre",
                    border: OutlineInputBorder()
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: ctrlLugar,
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.account_balance),
                    labelText: "Lugar",
                    border: OutlineInputBorder()
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                  controller: ctrlDireccion,
                  decoration: InputDecoration(
                      suffixIcon: Icon(Icons.location_on),
                      labelText: "Dirección",
                      border: OutlineInputBorder()
                  ),
                ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                    padding: EdgeInsets.all(8),
                  child: OutlinedButton(
                      onPressed: (){
                        ctrlNoctrl.clear();
                        ctrlAlumno.clear();
                        ctrlSemestre.clear();
                        ctrlLugar.clear();
                        ctrlDireccion.clear();
                      },
                      child: Text("Limpiar")
                  )
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: () async{
                        if(ctrlSemestre.text.isEmpty || ctrlNoctrl.text.isEmpty || ctrlAlumno.text.isEmpty || ctrlLugar.text.isEmpty || ctrlDireccion.text.isEmpty){
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Hay campos vacíos."))
                          );
                        }
                        else{
                        var residencia = Residencias(
                            noctrl: ctrlNoctrl.text,
                            alumno: ctrlAlumno.text,
                            semestre: int.parse(ctrlSemestre.text),
                            lugar: ctrlLugar.text,
                            direccion: ctrlDireccion.text
                        );
                          var query = await bd.collection("residencias").where("noctrl",isEqualTo: residencia.noctrl).get();
                            if(query.docs.isEmpty){
                              await DB.insertar(residencia);
                              setState(() {});
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("${residencia.alumno} insertado (a) correctamente.")));
                            }else if(query.docs.isNotEmpty){
                              print("Residencia existente: ${query.docs[0].id}");
                              residencia = Residencias(
                                  id: query.docs[0].id,
                                  noctrl: ctrlNoctrl.text,
                                  alumno: ctrlAlumno.text,
                                  semestre: int.parse(ctrlSemestre.text),
                                  lugar: ctrlLugar.text,
                                  direccion: ctrlDireccion.text);
                              await DB.actualizar(residencia);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("${residencia.alumno} actualizado correctamente.")));
                              setState(() {});

                            }
                        }
                        ctrlNoctrl.clear();
                        ctrlAlumno.clear();
                        ctrlSemestre.clear();
                        ctrlLugar.clear();
                        ctrlDireccion.clear();
                      },
                      child: Text("Guardar")
                  ),
                ),
              ],
            )
          ],
        )
    );
  }
}