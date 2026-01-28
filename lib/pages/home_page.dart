import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../widgets/app_home.dart';
import '../services/categorias_services.dart';
import '../services/servicios_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CategoriasService _categoriasService = CategoriasService();
  final ServiciosService _serviciosService = ServiciosService();

  String? _selectedCategoryId;
  int _selectedIndex = 0; // Para manejar la navegación inferior

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF101922)
          : const Color(0xFFF6F7F8),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: isDark ? Colors.white : Colors.black),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text(
          'Inicio',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_none,
              color: isDark ? Colors.white : Colors.black,
            ),
            onPressed: () {},
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // BARRA DE BÚSQUEDA
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Buscar servicios...",
                    hintStyle: const TextStyle(color: Color(0xFF4C739A)),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Color(0xFF4C739A),
                    ),
                    suffixIcon: const Icon(
                      Icons.tune,
                      color: Color(0xFF4C739A),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),

            AppWidgetHome.buildSectionHeader("Categorías", () {}),
            AppWidgetHome.buildCategoriesList(
              service: _categoriasService,
              selectedId: _selectedCategoryId,
              onCategorySelected: (nombre) => setState(
                () => _selectedCategoryId = (_selectedCategoryId == nombre)
                    ? null
                    : nombre,
              ),
            ),

            const Padding(
              padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Text(
                "Recomendado para ti",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
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

      // BARRA DE NAVEGACIÓN INFERIOR (BottomNavigationBar)
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == 3) {
            Navigator.pushNamed(context, '/profile');
          } else {
            setState(() {
              _selectedIndex = index;
            });
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: isDark
            ? const Color.fromARGB(255, 195, 207, 224)
            : Colors.white,
        selectedItemColor: const Color(0xFF137FEC),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Reservas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Mensajes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
