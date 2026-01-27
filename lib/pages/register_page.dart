import 'package:flutter/material.dart';
import 'package:miproyecto/services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthService _authService = AuthService();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _ciController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  String _errorMessage = '';
  bool _obscurePassword = true;

  // Colores constantes (coherentes con el login)
  final Color primaryColor = const Color(0xFF137FEC);
  final Color textGray = const Color(0xFF4C739A);
  final Color inputBorder = const Color(0xFFCFDBE7);

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF101922) : const Color(0xFFF6F7F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: isDark ? Colors.white : Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Crear Cuenta',
          style: TextStyle(color: isDark ? Colors.white : Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Ícono decorativo
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.person_add_rounded, color: primaryColor, size: 30),
            ),
            const SizedBox(height: 16),
            Text(
              'Únete a Service Pro',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF0D141B),
              ),
            ),
            const SizedBox(height: 32),

            // Campos del formulario
            _buildFieldGroup('Nombre Completo', _nombreController, 'Tu nombre', isDark, Icons.person_outline),
            _buildFieldGroup('Cédula de Identidad', _ciController, 'Nº de documento', isDark, Icons.badge_outlined),
            _buildFieldGroup('Dirección', _direccionController, 'Calle, Nro, Ciudad', isDark, Icons.location_on_outlined),
            _buildFieldGroup('Correo Electrónico', _emailController, 'ejemplo@correo.com', isDark, Icons.email_outlined),
            
            // Campo de contraseña con visibilidad
            _buildFieldGroup(
              'Contraseña', 
              _passwordController, 
              'Mínimo 6 caracteres', 
              isDark, 
              Icons.lock_outline,
              isPassword: true,
            ),

            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(_errorMessage, style: const TextStyle(color: Colors.red, fontSize: 13)),
              ),

            const SizedBox(height: 32),

            // Botón de Registrar
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _handleRegister,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: const Text(
                  'Registrarse',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // Widget funcional para agrupar Etiqueta + Input
  Widget _buildFieldGroup(String label, TextEditingController controller, String hint, bool isDark, IconData icon, {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: isDark ? Colors.white : const Color(0xFF0D141B),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isDark ? Colors.transparent : inputBorder),
            ),
            child: TextField(
              controller: controller,
              obscureText: isPassword ? _obscurePassword : false,
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
              decoration: InputDecoration(
                prefixIcon: Icon(icon, color: textGray, size: 20),
                hintText: hint,
                hintStyle: TextStyle(color: textGray.withOpacity(0.6), fontSize: 15),
                contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                border: InputBorder.none,
                suffixIcon: isPassword 
                  ? IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off, color: textGray),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    )
                  : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleRegister() async {
    try {
      await _authService.register(
        nombre: _nombreController.text,
        ci: _ciController.text,
        direccion: _direccionController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (!mounted) return;
      Navigator.popAndPushNamed(context, '/home');
    } catch (e) {
      setState(() {
        _errorMessage = 'Hubo un error al crear la cuenta. Inténtalo de nuevo.';
      });
    }
  }
}