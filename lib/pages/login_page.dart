import 'package:flutter/material.dart';
import 'package:miproyecto/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  
  bool _obscurePassword = true;
  String _errorMessage = '';

  // Definición de colores según el HTML
  final Color primaryColor = const Color(0xFF137FEC);
  final Color lightBg = const Color(0xFFF6F7F8);
  final Color darkBg = const Color(0xFF101922);
  final Color inputBorder = const Color(0xFFCFDBE7);
  final Color textGray = const Color(0xFF4C739A);

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? darkBg : lightBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: isDark ? Colors.white : Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Login',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 32),
            
            // Branding/Logo Placeholder (Icono de Herramienta)
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: const Icon(Icons.handyman, color: Colors.white, size: 36),
            ),
            
            const SizedBox(height: 24),
            
            // HeadlineText
            Text(
              'Bienvenido',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF0D141B),
              ),
            ),
            
            const SizedBox(height: 8),
            
            // BodyText
            Text(
              'Inicia sesión para reservar tu próximo servicio',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: textGray),
            ),
            
            const SizedBox(height: 32),

            // Formulario
            _buildLabel('Correo Electrónico', isDark),
            _buildTextField(
              controller: _emailController,
              hint: 'Ingresa tu correo',
              isDark: isDark,
              icon: null,
            ),
            
            const SizedBox(height: 16),
            
            _buildLabel('Contraseña', isDark),
            _buildTextField(
              controller: _passwordController,
              hint: 'Ingresa tu contraseña',
              isDark: isDark,
              obscure: _obscurePassword,
              icon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  color: textGray,
                ),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),

            // Olvidaste contraseña
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: Text('¿Olvidaste tu contraseña?', 
                  style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
              ),
            ),

            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(_errorMessage, style: const TextStyle(color: Colors.red)),
              ),

            // Botón de Login
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _handleLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: const Text('Ingresar', 
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),

            // Divisor
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Row(
                children: [
                  Expanded(child: Divider(color: inputBorder)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('O continúa con', style: TextStyle(color: textGray, fontSize: 14)),
                  ),
                  Expanded(child: Divider(color: inputBorder)),
                ],
              ),
            ),

            // Social Logins
            Row(
              children: [
                Expanded(child: _socialButton('Google', Icons.g_mobiledata, isDark, Colors.white, isDark ? Colors.white : Colors.black)),
                const SizedBox(width: 16),
                Expanded(child: _socialButton('Apple', Icons.apple, isDark, Colors.black, Colors.white)),
              ],
            ),

            // Footer
            const SizedBox(height: 48),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('¿No tienes cuenta?', style: TextStyle(color: textGray)),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/register'),
                  child: Text('Regístrate', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // Helper para etiquetas de campos
  Widget _buildLabel(String text, bool isDark) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 4, bottom: 8),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF0D141B),
          ),
        ),
      ),
    );
  }

  // Helper para los inputs estilizados
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required bool isDark,
    bool obscure = false,
    Widget? icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? Colors.transparent : inputBorder),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: TextStyle(color: isDark ? Colors.white : Colors.black),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: textGray),
          contentPadding: const EdgeInsets.all(16),
          border: InputBorder.none,
          suffixIcon: icon,
        ),
      ),
    );
  }

  // Helper para botones sociales
  Widget _socialButton(String label, IconData icon, bool isDark, Color bgColor, Color textColor) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: inputBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: textColor, size: 28),
          const SizedBox(width: 8),
          Text(label, style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // Lógica de autenticación
  Future<void> _handleLogin() async {
    final user = await _authService.signInWithEmailAndPassword(
      _emailController.text,
      _passwordController.text,
    );
    if (user != null) {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      setState(() {
        _errorMessage = 'Error de autenticación: Revisa tus datos';
      });
    }
  }
}