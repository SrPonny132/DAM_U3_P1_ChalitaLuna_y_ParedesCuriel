import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/tarea.dart';
import '../controllers/tareaDB.dart';
import 'package:dam_u3_practica1_asistenciaprofesores/widgets/drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Tarea> tareas = [];
  DateTime _selectedDay = DateTime.now();

  Future<void> loadTareas() async {
    List<Tarea> resultTareas = await TareaDB.getTareas();
    setState(() {
      tareas = resultTareas;
    });
  }

  @override
  void initState() {
    super.initState();
    loadTareas();
  }

  List<Tarea> _getProximasTareas() {
    // Ordenar tareas por fecha de entrega ascendente
    tareas.sort((a, b) => DateTime.parse(a.fechaEntrega)
        .toLocal()
        .compareTo(DateTime.parse(b.fechaEntrega).toLocal()));
    // Obtener las primeras tres tareas
    return tareas.take(3).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio - Control de tareas'),
      ),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          Expanded(
            child: Card(
              margin: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Próximas Tareas',
                      style:
                      TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _getProximasTareas().length,
                      itemBuilder: (context, index) {
                        final tarea = _getProximasTareas()[index];
                        return ListTile(
                          title: Text(tarea.descripcion),
                          subtitle: Text('Fecha de Entrega: ${tarea.fechaEntrega}'),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Calendario',
                      style:
                      TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: TableCalendar(
                        focusedDay: _selectedDay,
                        firstDay: DateTime(2000),
                        lastDay: DateTime(2100),
                        headerStyle: const HeaderStyle(
                          formatButtonVisible: false,
                          titleCentered: true,
                        ),
                        onDaySelected: (selectedDay, focusedDay) {
                          setState(() {
                            _selectedDay = selectedDay;
                          });
                        },
                      ),
                    ),
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