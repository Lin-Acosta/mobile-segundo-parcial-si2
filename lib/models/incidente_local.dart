class IncidenteLocal {
  final int? id;
  final String coordenadagps;
  final String? descripcion;
  final String fecha;
  final String estado;
  final bool isSynced;

  IncidenteLocal({
    this.id,
    required this.coordenadagps,
    this.descripcion,
    required this.fecha,
    required this.estado,
    required this.isSynced,
  });

  IncidenteLocal copyWith({
    int? id,
    String? coordenadagps,
    String? descripcion,
    String? fecha,
    String? estado,
    bool? isSynced,
  }) {
    return IncidenteLocal(
      id: id ?? this.id,
      coordenadagps: coordenadagps ?? this.coordenadagps,
      descripcion: descripcion ?? this.descripcion,
      fecha: fecha ?? this.fecha,
      estado: estado ?? this.estado,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'coordenadagps': coordenadagps,
      'descripcion': descripcion,
      'fecha': fecha,
      'estado': estado,
      'is_synced': isSynced ? 1 : 0,
    };
  }

  static IncidenteLocal fromMap(Map<String, Object?> map) {
    return IncidenteLocal(
      id: map['id'] as int?,
      coordenadagps: map['coordenadagps'] as String,
      descripcion: map['descripcion'] as String?,
      fecha: map['fecha'] as String,
      estado: map['estado'] as String,
      isSynced: (map['is_synced'] as int) == 1,
    );
  }
}
