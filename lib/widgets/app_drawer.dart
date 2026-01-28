import 'package:flutter/material.dart';
import 'package:MarketServiceApp/services/auth_service.dart';
import 'package:MarketServiceApp/models/user_model.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();
    final firebaseUser = authService.currentUser;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    const Color primaryColor = Color(0xFF137FEC);

    return Drawer(
      backgroundColor: isDark ? const Color(0xFF101922) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // HEADER: Obtiene datos de Firestore
          FutureBuilder<UserModel?>(
            future: authService.getUserData(firebaseUser?.uid ?? ''),
            builder: (context, snapshot) {
              // Si aún no carga el nombre, mostramos el email o "Cargando..."
              String nombre = snapshot.data?.nombre ?? "Cargando...";
              String email = firebaseUser?.email ?? "";

              return Container(
                padding: const EdgeInsets.only(
                  top: 60,
                  bottom: 24,
                  left: 24,
                  right: 24,
                ),
                color: isDark
                    ? Colors.white.withOpacity(0.05)
                    : const Color(0xFFF8F9FA),
                child: Row(
                  children: [
                    Container(
                      width: 64, // Corregido de 'size'
                      height: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: primaryColor, width: 2),
                        image: DecorationImage(
                          image: NetworkImage(snapshot.data?.fotoUrl ?? ''),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nombre,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            email, // EMAIL DEBAJO DEL NOMBRE
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark ? Colors.white70 : Colors.black54,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // LISTA DE OPCIONES
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
              children: [
                _item(Icons.monetization_on, 'Contratos', isDark, () {}),
                ListTile(
                  leading: const Icon(Icons.history, color: Color(0xFF136DEC)),
                  title: const Text("Historial"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/historial');
                  },
                ),
                const Divider(height: 32),
                _item(Icons.help_outline, 'Ayuda y Soporte', isDark, () {}),
                ListTile(
                  leading: const Icon(
                    Icons.people_outline,
                    color: Color(0xFF136DEC),
                  ),
                  title: const Text("Sobre nosotros"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                  onTap: () {
                    Navigator.pop(context);

                    Navigator.pushNamed(context, '/info');
                  },
                ),
              ],
            ),
          ),

          // BOTÓN CERRAR SESIÓN
          _logoutSection(context, authService),
        ],
      ),
    );
  }

  // Widgets de apoyo para limpiar el código principal
  Widget _item(IconData icon, String label, bool isDark, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: isDark ? Colors.white60 : Colors.black54),
      title: Text(
        label,
        style: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
      ),
      onTap: onTap,
    );
  }

  Widget _logoutSection(BuildContext context, AuthService authService) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: InkWell(
        onTap: () async {
          await authService.signOut();
          Navigator.pushReplacementNamed(context, '/login');
        },
        child: const Row(
          children: [
            Icon(Icons.logout, color: Colors.redAccent),
            SizedBox(width: 16),
            Text(
              'Cerrar Sesión',
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
