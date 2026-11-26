import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../core/app_theme.dart';
import '../models/almuerzo.dart';

class AlmuerzoCard extends StatelessWidget {
  final Almuerzo almuerzo;
  final VoidCallback onToggleEntregado;
  final VoidCallback onDelete;

  const AlmuerzoCard({
    super.key,
    required this.almuerzo,
    required this.onToggleEntregado,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('dd MMM yyyy', 'es').format(almuerzo.fechaPedido);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.lunch_dining_rounded, color: AppColors.secondary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(almuerzo.plato, style: Theme.of(context).textTheme.titleMedium),
                      Text(almuerzo.cliente, style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                ),
                _StatusChip(entregado: almuerzo.entregado),
              ],
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                _Info(label: 'Cantidad', value: '${almuerzo.cantidad}'),
                _Info(label: 'Precio', value: 'S/ ${almuerzo.precio.toStringAsFixed(2)}'),
                _Info(label: 'Total', value: 'S/ ${almuerzo.total.toStringAsFixed(2)}', highlight: true),
                _Info(label: 'Fecha', value: date),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onToggleEntregado,
                    icon: Icon(almuerzo.entregado ? Icons.undo_rounded : Icons.check_circle_outline_rounded),
                    label: Text(almuerzo.entregado ? 'Marcar pendiente' : 'Marcar entregado'),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline_rounded, color: AppColors.danger),
                  tooltip: 'Anular pedido',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final bool entregado;
  const _StatusChip({required this.entregado});

  @override
  Widget build(BuildContext context) {
    final color = entregado ? AppColors.success : AppColors.secondary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        entregado ? 'Entregado' : 'Pendiente',
        style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 12),
      ),
    );
  }
}

class _Info extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;
  const _Info({required this.label, required this.value, this.highlight = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12)),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            color: highlight ? AppColors.secondary : AppColors.text,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
