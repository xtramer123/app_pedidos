import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../models/almuerzo.dart';
import '../models/usuario.dart';
import '../services/api_service.dart';
import '../widgets/almuerzo_card.dart';
import '../widgets/app_backdrop.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  final ApiService api;
  final Usuario user;
  final VoidCallback onLogout;
  const HomeScreen({super.key, required this.api, required this.user, required this.onLogout});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;
  bool _loading = true;
  String? _error;
  List<Almuerzo> _items = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final items = await widget.api.getAlmuerzos();
      if (!mounted) return;
      setState(() => _items = items);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
      if (e is ApiException && e.statusCode == 401) widget.onLogout();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _create() async {
    final created = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CreateAlmuerzoSheet(api: widget.api),
    );
    if (created == true) _load();
  }

  Future<void> _toggle(Almuerzo a) async {
    try {
      await widget.api.updateAlmuerzo(a.id, {'entregado': !a.entregado});
      _load();
    } catch (e) {
      _snack(e.toString());
    }
  }

  Future<void> _delete(Almuerzo a) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Anular pedido'),
        content: Text('¿Deseas anular el pedido de ${a.cliente}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Anular')),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await widget.api.deleteAlmuerzo(a.id);
      _load();
    } catch (e) {
      _snack(e.toString());
    }
  }

  void _snack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final entregados = _items.where((e) => e.entregado).length;
    final totalVendido = _items.fold<double>(0, (s, e) => s + e.total);
    final pages = [
      _OrdersPage(
        items: _items,
        loading: _loading,
        error: _error,
        onRefresh: _load,
        onToggle: _toggle,
        onDelete: _delete,
      ),
      ProfileScreen(
        user: widget.user,
        totalPedidos: _items.length,
        entregados: entregados,
        totalVendido: totalVendido,
        onLogout: () async {
          await widget.api.logout();
          widget.onLogout();
        },
      ),
    ];

    return Scaffold(
      body: AppBackdrop(child: pages[_index]),
      floatingActionButton: _index == 0
          ? FloatingActionButton.extended(onPressed: _create, icon: const Icon(Icons.add_rounded), label: const Text('Nuevo pedido'))
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        backgroundColor: Colors.white,
        indicatorColor: AppColors.primary.withValues(alpha: 0.25),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.receipt_long_outlined), selectedIcon: Icon(Icons.receipt_long_rounded), label: 'Pedidos'),
          NavigationDestination(icon: Icon(Icons.person_outline_rounded), selectedIcon: Icon(Icons.person_rounded), label: 'Perfil'),
        ],
      ),
    );
  }
}

class _OrdersPage extends StatelessWidget {
  final List<Almuerzo> items;
  final bool loading;
  final String? error;
  final Future<void> Function() onRefresh;
  final void Function(Almuerzo) onToggle;
  final void Function(Almuerzo) onDelete;

  const _OrdersPage({
    required this.items,
    required this.loading,
    required this.error,
    required this.onRefresh,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
        children: [
          Text('Mis pedidos', style: t.headlineMedium),
          const SizedBox(height: 4),
          Text('Pedidos de almuerzo asociados a tu cuenta.', style: t.bodyMedium),
          const SizedBox(height: 16),
          if (loading)
            const Padding(padding: EdgeInsets.only(top: 60), child: Center(child: CircularProgressIndicator()))
          else if (error != null)
            _StateCard(icon: Icons.error_outline_rounded, title: 'No se pudo cargar', message: error!, color: AppColors.danger)
          else if (items.isEmpty)
            const _StateCard(
              icon: Icons.lunch_dining_outlined,
              title: 'Sin pedidos aún',
              message: 'Crea tu primer pedido con el botón "Nuevo pedido".',
              color: AppColors.secondary,
            )
          else
            ...items.map((a) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: AlmuerzoCard(almuerzo: a, onToggleEntregado: () => onToggle(a), onDelete: () => onDelete(a)),
                )),
        ],
      ),
    );
  }
}

class _StateCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final Color color;
  const _StateCard({required this.icon, required this.title, required this.message, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(children: [
          Icon(icon, size: 42, color: color),
          const SizedBox(height: 10),
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(message, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium),
        ]),
      ),
    );
  }
}

class _CreateAlmuerzoSheet extends StatefulWidget {
  final ApiService api;
  const _CreateAlmuerzoSheet({required this.api});

  @override
  State<_CreateAlmuerzoSheet> createState() => _CreateAlmuerzoSheetState();
}

class _CreateAlmuerzoSheetState extends State<_CreateAlmuerzoSheet> {
  final _formKey = GlobalKey<FormState>();
  final _cliente = TextEditingController();
  final _plato = TextEditingController();
  final _cantidad = TextEditingController(text: '1');
  final _precio = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _cliente.dispose();
    _plato.dispose();
    _cantidad.dispose();
    _precio.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await widget.api.createAlmuerzo(
        cliente: _cliente.text.trim(),
        plato: _plato.text.trim(),
        cantidad: int.parse(_cantidad.text),
        precio: double.parse(_precio.text.replaceAll(',', '.')),
      );
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(child: Container(width: 44, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(99)))),
                const SizedBox(height: 16),
                Text('Nuevo pedido', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                TextFormField(controller: _cliente, decoration: const InputDecoration(labelText: 'Cliente'), validator: (v) => v == null || v.trim().isEmpty ? 'Requerido' : null),
                const SizedBox(height: 12),
                TextFormField(controller: _plato, decoration: const InputDecoration(labelText: 'Plato'), validator: (v) => v == null || v.trim().isEmpty ? 'Requerido' : null),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _cantidad,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Cantidad'),
                        validator: (v) => (int.tryParse(v ?? '') ?? 0) > 0 ? null : 'Mayor a 0',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _precio,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(labelText: 'Precio (S/)'),
                        validator: (v) => (double.tryParse((v ?? '').replaceAll(',', '.')) ?? 0) > 0 ? null : 'Mayor a 0',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                ElevatedButton(
                  onPressed: _loading ? null : _submit,
                  child: _loading ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text('Guardar pedido'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
