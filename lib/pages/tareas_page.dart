import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/tarea.dart';
import '../controllers/tareaDB.dart';
import 'package:dam_u3_practica1_asistenciaprofesores/widgets/drawer.dart';

class TareaPage extends StatefulWidget {
  const TareaPage({Key? key});

  @override
  State<TareaPage> createState() => _TareaPageState();
}

class _TareaPageState extends State<TareaPage> {
  List<Tarea> tareas = [];
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _fechaEntregaController = TextEditingController();

  Future<void> loadTareas() async {
    List<Tarea> result = await TareaDB.getTareas();
    setState(() {
      tareas = result;
    });
  }

  @override
  void initState() {
    super.initState();
    loadTareas();
  }

  Future<void> showEditTareaDialog(Tarea tarea) async {
    _descripcionController.text = tarea.descripcion;
    _fechaEntregaController.text = tarea.fechaEntrega;

    var result = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Editar datos de la tarea"),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _descripcionController,
                  decoration: const InputDecoration(
                    labelText: "Descripción",
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );

                    if (selectedDate != null) {
                      final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
                      setState(() {
                        _fechaEntregaController.text = formattedDate;
                      });
                      setState(() {
                        _fechaEntregaController.text = selectedDate.toString();
                      });
                    }
                  },
                  child: const Text("Seleccionar Fecha de Entrega"),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text("Guardar"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancelar"),
            ),
          ],
        );
      },
    );

    if (result == true) {
      try {
        tarea.descripcion = _descripcionController.text;
        tarea.fechaEntrega = _fechaEntregaController.text;
        await TareaDB.update(tarea);
        loadTareas();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Tarea actualizada correctamente"),
          backgroundColor: Color.fromARGB(255, 80, 188, 150),
        ));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Error al actualizar la tarea"),
          backgroundColor: Color.fromARGB(255, 58, 54, 67),
        ));
      }
    }
  }

  Future<void> showAddTareaDialog() async {
    _descripcionController.clear();
    _fechaEntregaController.clear();

    var result = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Agregar nueva tarea"),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _descripcionController,
                  decoration: const InputDecoration(
                    labelText: "Descripción",
                  ),
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        final DateTime currentDate = DateTime.now();
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: currentDate,
                          firstDate: DateTime(currentDate.year, currentDate.month, currentDate.day - 1),
                          lastDate: DateTime(currentDate.year + 1),
                        );

                        if (selectedDate != null) {
                          final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
                          setState(() {
                            _fechaEntregaController.text = formattedDate;
                          });
                        }
                      },
                      child: const Text("Seleccionar Fecha de Entrega"),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _fechaEntregaController,
                        decoration: const InputDecoration(
                          labelText: "Fecha de Entrega",
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (_descripcionController.text.isEmpty ||
                    _fechaEntregaController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Todos los campos son obligatorios"),
                    backgroundColor: Color.fromARGB(255, 208, 120, 140),
                  ));
                } else {
                  Navigator.pop(context, true);
                }
              },
              child: const Text("Guardar"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancelar"),
            ),
          ],
        );
      },
    );

    if (result == true) {
      try {
        Tarea newTarea = Tarea(
          idTarea: 0,
          idMateria: '',
          descripcion: _descripcionController.text,
          fechaEntrega: _fechaEntregaController.text,
        );
        await TareaDB.insert(newTarea);
        loadTareas();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Tarea agregada correctamente"),
          backgroundColor: Color.fromARGB(255, 80, 188, 150),
        ));
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Error al agregar la tarea"),
          backgroundColor: Color.fromARGB(255, 58, 54, 67),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tareas'),
        centerTitle: true,
      ),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          Expanded(
            child: Card(
              margin: const EdgeInsets.all(10),
              child: Column(
                children: [
                  const Text(
                    'Tareas',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: tareas.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(tareas[index].descripcion),
                          subtitle: Text('Fecha de Entrega: ${tareas[index].fechaEntrega}'),
                          onTap: () {
                            showEditTareaDialog(tareas[index]);
                          },
                        );
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Agregar Tarea'),
                    leading: const Icon(Icons.add),
                    onTap: () {
                      showAddTareaDialog();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}