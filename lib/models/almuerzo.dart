class Almuerzo {
  final int id;
  final String cliente;
  final String plato;
  final int cantidad;
  final double precio;
  final DateTime fechaPedido;
  final bool entregado;
  final int usuarioId;
  final double total;

  const Almuerzo({
    required this.id,
    required this.cliente,
    required this.plato,
    required this.cantidad,
    required this.precio,
    required this.fechaPedido,
    required this.entregado,
    required this.usuarioId,
    required this.total,
  });

  factory Almuerzo.fromJson(Map<String, dynamic> json) {
    double toDouble(dynamic v) {
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString()) ?? 0;
    }

    return Almuerzo(
      id: (json['id'] as num).toInt(),
      cliente: (json['cliente'] ?? '') as String,
      plato: (json['plato'] ?? '') as String,
      cantidad: (json['cantidad'] as num).toInt(),
      precio: toDouble(json['precio']),
      fechaPedido: DateTime.parse(json['fecha_pedido'] as String),
      entregado: (json['entregado'] ?? false) as bool,
      usuarioId: (json['usuario_id'] as num).toInt(),
      total: toDouble(json['total']),
    );
  }
}
