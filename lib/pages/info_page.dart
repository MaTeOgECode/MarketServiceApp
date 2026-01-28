import 'package:flutter/material.dart';

class AboutCreatorsPage extends StatelessWidget {
  const AboutCreatorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Usamos los colores de tu tema definido en main.dart
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      // AppBar estándar sin necesidad de dart:ui
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: primaryColor, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text("Sobre Nosotros"),
        // El color de fondo y texto lo toma automáticamente de tu appBarTheme en main.dart
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Sección Hero (Misión)
            _buildHeroSection(primaryColor),

            // Headline & Story
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                children: [
                  Text(
                    "Redefinimos la forma en que encuentras ayuda confiable.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                      color: isDark ? Colors.white : const Color(0xFF111418),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Nos dimos cuenta de que encontrar un plomero o electricista confiable no debería sentirse como una apuesta. Construimos esta plataforma para conectar a los trabajadores calificados con los propietarios.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: isDark ? Colors.white70 : Colors.black54,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            // Título de sección con barrita lateral
            _buildSectionTitle("El Equipo", primaryColor),

            // Grid de Miembros
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: MediaQuery.of(context).size.width > 600 ? 2 : 1,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 2.8,
                children: [
                  _buildTeamMember(
                    context,
                    "Mateo Gonzales",
                    "CEO & Visionario",
                    Icons.link,
                    "1",
                  ),
                  _buildTeamMember(
                    context,
                    "Alejandro Laura",
                    "Jefe de Desarrollo",
                    Icons.code,
                    "2",
                  ),
                ],
              ),
            ),

            // Footer de contacto
            _buildFooter(context, isDark, primaryColor),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection(Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: 220,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          // 1. AQUÍ VA LA IMAGEN DE FONDO
          image: const DecorationImage(
            image: NetworkImage(
              "https://images.unsplash.com/photo-1522202176988-66273c2fd55f?auto=format&fit=crop&w=800&q=80",
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          // 2. EL GRADIENTE PARA QUE EL TEXTO SEA LEGIBLE
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.1),
                primaryColor.withOpacity(0.9),
              ],
            ),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Nuestro objetivo",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Empoderando talento local para construir comunidades mejores.",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color accent) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 4,
            decoration: BoxDecoration(
              color: accent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamMember(
    BuildContext context,
    String name,
    String role,
    IconData actionIcon,
    String imgId,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          ClipRRect(borderRadius: BorderRadius.circular(12)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Text(
                  role,
                  style: const TextStyle(
                    color: Color(0xFF136DEC),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(actionIcon, size: 16, color: Colors.grey),
                    const SizedBox(width: 12),
                    const Icon(
                      Icons.share_outlined,
                      size: 16,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context, bool isDark, Color primaryColor) {
    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      width: double.infinity,
      color: isDark ? Colors.black26 : Colors.grey.shade100,
      child: Column(
        children: [
          const Text(
            "Contactanos",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _socialBtn(context, Icons.language, primaryColor),
              const SizedBox(width: 20),
              _socialBtn(context, Icons.people_alt_outlined, primaryColor),
              const SizedBox(width: 20),
              _socialBtn(context, Icons.email_outlined, primaryColor),
            ],
          ),
          const SizedBox(height: 32),
          const Text(
            "© 2024 Marketplace Inc. Made with passion.",
            style: TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _socialBtn(BuildContext context, IconData icon, Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A222C) : Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Icon(icon, color: color, size: 22),
    );
  }
}
