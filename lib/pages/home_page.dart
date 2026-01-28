import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../widgets/app_home.dart';
import '../services/categorias_services.dart';
import '../services/servicios_service.dart';
import '../pages/reservas_page.dart'; 

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // LISTA DE PÁGINAS PARA EL BOTTOM NAVBAR
  final List<Widget> _pages = [
    const _MainHomeContent(),
    const MyBookingsPage(), 
    const Center(child: Text("Mensajes")),
    const Center(child: Text("Perfil")),
  ];

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF101922) : const Color(0xFFF6F7F8),
      drawer: const AppDrawer(),
      body: _pages[_selectedIndex], 
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: isDark
            ? const Color.fromARGB(255, 43, 53, 68) // Ajustado para que se vea bien en oscuro
            : Colors.white,
        selectedItemColor: const Color(0xFF137FEC),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Reservas'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Mensajes'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Perfil'),
        ],
      ),
    );
  }
}

class _MainHomeContent extends StatefulWidget {
  const _MainHomeContent();
  @override
  State<_MainHomeContent> createState() => _MainHomeContentState();
}

class _MainHomeContentState extends State<_MainHomeContent> {
  final CategoriasService _categoriasService = CategoriasService();
  final ServiciosService _serviciosService = ServiciosService();
  String? _selectedCategoryId;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 0, 
        backgroundColor: Colors.transparent,
        title: Text('Inicio', style: TextStyle(color: isDark ? Colors.white : Colors.black)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu), 
          onPressed: () => Scaffold.of(context).openDrawer()
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Aquí puedes re-insertar el buscador si lo tenías
            AppWidgetHome.buildCategoriesList(
              service: _categoriasService,
              selectedId: _selectedCategoryId,
              onCategorySelected: (nombre) => setState(() => _selectedCategoryId = (_selectedCategoryId == nombre) ? null : nombre),
            ),
            AppWidgetHome.buildServicesList(
              service: _serviciosService,
              filterId: _selectedCategoryId,
              isDark: isDark,
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}