class Materia {
  String idMateria;
  String nombre;
  String semestre;
  String docente;

  Materia({
    required this.idMateria,
    required this.nombre,
    required this.semestre,
    required this.docente,
  });

  // Método para convertir un mapa a una instancia de Materia
  factory Materia.fromMap(Map<String, dynamic> map) {
    return Materia(
      idMateria: map['IDMATERIA'],
      nombre: map['NOMBRE'],
      semestre: map['SEMESTRE'],
      docente: map['DOCENTE'],
    );
  }

  // Método para convertir una instancia de Materia a un mapa
  Map<String, dynamic> toMap() {
    return {
      'IDMATERIA': idMateria,
      'NOMBRE': nombre,
      'SEMESTRE': semestre,
      'DOCENTE': docente,
    };
  }
}

