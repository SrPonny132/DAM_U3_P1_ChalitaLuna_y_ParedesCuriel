class Tarea {
  int idTarea;
  String idMateria;
  String fechaEntrega;
  String descripcion;

  Tarea({
    required this.idTarea,
    required this.idMateria,
    required this.fechaEntrega,
    required this.descripcion,
  });

  // Método para convertir un mapa a una instancia de Tarea
  factory Tarea.fromMap(Map<String, dynamic> map) {
    return Tarea(
      idTarea: map['IDTAREA'],
      idMateria: map['IDMATERIA'],
      fechaEntrega: map['F_ENTREGA'],
      descripcion: map['DESCRIPCION'],
    );
  }

  // Método para convertir una instancia de Tarea a un mapa
  Map<String, dynamic> toMap() {
    return {
      'IDTAREA': idTarea,
      'IDMATERIA': idMateria,
      'F_ENTREGA': fechaEntrega,
      'DESCRIPCION': descripcion,
    };
  }
}
