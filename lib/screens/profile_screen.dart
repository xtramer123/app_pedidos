import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../models/usuario.dart';

class ProfileScreen extends StatelessWidget {
  final Usuario user;
  final int totalPedidos;
  final int entregados;
  final double totalVendido;
  final VoidCallback onLogout;

  const ProfileScreen({
    super.key,
    required this.user,
    required this.totalPedidos,
    required this.entregados,
    required this.totalVendido,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Text('Perfil', style: t.headlineMedium),
          const SizedBox(height: 18),
          _FoodPlateProfile(name: user.nombre, email: user.email, rol: user.rol),
          const SizedBox(height: 22),
          Row(
            children: [
              Expanded(child: _StatCard(label: 'Pedidos', value: '$totalPedidos', icon: Icons.receipt_long_rounded)),
              const SizedBox(width: 12),
              Expanded(child: _StatCard(label: 'Entregados', value: '$entregados', icon: Icons.check_circle_rounded)),
            ],
          ),
          const SizedBox(height: 12),
          _StatCard(label: 'Total vendido', value: 'S/ ${totalVendido.toStringAsFixed(2)}', icon: Icons.payments_rounded),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _row(Icons.badge_outlined, 'Nombre', user.nombre),
                  const Divider(height: 24),
                  _row(Icons.alternate_email_rounded, 'Email', user.email),
                  const Divider(height: 24),
                  _row(Icons.verified_user_outlined, 'Rol', user.rol),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: onLogout,
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Cerrar sesión'),
            style: OutlinedButton.styleFrom(foregroundColor: AppColors.danger),
          ),
        ],
      ),
    );
  }

  Widget _row(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: AppColors.secondary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
            const SizedBox(height: 2),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.text)),
          ]),
        ),
      ],
    );
  }
}

class _FoodPlateProfile extends StatelessWidget {
  final String name;
  final String email;
  final String rol;
  const _FoodPlateProfile({required this.name, required this.email, required this.rol});

  @override
  Widget build(BuildContext context) {
    final initial = name.trim().isNotEmpty ? name.trim()[0].toUpperCase() : 'U';
    return SizedBox(
      width: 280,
      height: 280,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(colors: [Color(0xFFFFF7ED), Color(0xFFFFEDD5)]),
              boxShadow: [
                BoxShadow(color: AppColors.secondary.withValues(alpha: 0.18), blurRadius: 30, offset: const Offset(0, 18)),
              ],
              border: Border.all(color: const Color(0xFFF3E3C7), width: 10),
            ),
          ),
          Container(
            width: 238,
            height: 238,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFF6DDB8), width: 2),
              color: Colors.white.withValues(alpha: 0.45),
            ),
          ),
          // Food items around the plate
          _foodItem(top: 18, left: 120, icon: Icons.egg_alt_rounded, color: AppColors.primary, angle: -0.2),
          _foodItem(top: 58, right: 28, icon: Icons.eco_rounded, color: const Color(0xFF84CC16), angle: 0.4),
          _foodItem(bottom: 58, right: 30, icon: Icons.local_pizza_rounded, color: AppColors.secondary, angle: -0.3),
          _foodItem(bottom: 22, left: 118, icon: Icons.bakery_dining_rounded, color: const Color(0xFFFBBF24), angle: 0.2),
          _foodItem(bottom: 62, left: 28, icon: Icons.restaurant_rounded, color: const Color(0xFFFB923C), angle: 0.5),
          _foodItem(top: 62, left: 26, icon: Icons.spa_rounded, color: const Color(0xFF22C55E), angle: -0.4),
          // Inner plate / profile
          Container(
            width: 170,
            height: 170,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: AppColors.border, width: 6),
              boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 12, offset: Offset(0, 6))],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 34,
                  backgroundColor: AppColors.primary,
                  child: Text(initial, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w800, color: Colors.white)),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    name,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppColors.text),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Text(
                    email,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 11, color: AppColors.muted),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.secondary.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(999)),
                  child: Text(rol, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.secondary)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _foodItem({double? top, double? bottom, double? left, double? right, required IconData icon, required Color color, required double angle}) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Transform.rotate(
        angle: angle,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.16),
            shape: BoxShape.circle,
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const _StatCard({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.18), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: AppColors.secondary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(label, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: AppColors.text)),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
