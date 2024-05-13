import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/tarea.dart';
import '../controllers/tareaDB.dart';
import 'package:dam_u3_practica1_asistenciaprofesores/widgets/drawer.dart';

class ConsultasPage extends StatefulWidget {
  const ConsultasPage({Key? key});

  @override
  createState() => _ConsultasPageState();
}

class _ConsultasPageState extends State<ConsultasPage> {
  List<Tarea> tareas = [];
  DateTime _selectedDay = DateTime.now();

  Future<void> loadData() async {
    List<Tarea> resultTareas = await TareaDB.getTareas();
    setState(() {
      tareas = resultTareas;
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  List<Tarea> _getTareasPorDia(DateTime day) {
    return tareas
        .where((tarea) =>
    DateTime.parse(tarea.fechaEntrega).toLocal().isAtSameMomentAs(day) ||
        DateTime.parse(tarea.fechaEntrega).toLocal().isAfter(day))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tareas por Día'),
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Column(
                        children: [
                          const Text(
                            'Selecciona una fecha para ver las tareas que vencen',
                            style: TextStyle(fontSize: 18),
                          ),
                          Expanded(
                            child: TableCalendar(
                              focusedDay: _selectedDay,
                              firstDay: DateTime(2000),
                              lastDay: DateTime(2100),
                              eventLoader: (day) {
                                final normalizedDay =
                                DateTime(day.year, day.month, day.day);
                                return _getTareasPorDia(normalizedDay);
                              },
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
                        ],
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
