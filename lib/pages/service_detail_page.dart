import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/servicios_model.dart';
import '../services/servicios_service.dart';
import '../services/reservas_service.dart';
import '../services/auth_service.dart';

class ServiceDetailPage extends StatefulWidget {
  final ServiciosModel servicio;
  final String estadoReserva;
  final String? contratacionId;

  const ServiceDetailPage({
    super.key,
    required this.servicio,
    this.estadoReserva = "pendiente",
    this.contratacionId,
  });

  @override
  State<ServiceDetailPage> createState() => _ServiceDetailPageState();
}

class _ServiceDetailPageState extends State<ServiceDetailPage> {
  static const Color primaryBlue = Color(0xFF137FEC);
  static const Color lightBackground = Color(0xFFF6F7F8);
  static const Color darkBackground = Color(0xFF101922);
  static const Color darkInput = Color(0xFF1E293B);

  double _ratingSeleccionado = 0;
  final TextEditingController _commentController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isBooking = false;

  void _enviarCalificacion() async {
    if (_ratingSeleccionado == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Selecciona una puntuación")),
      );
      return;
    }

    // Mostrar un indicador de carga para evitar múltiples clics
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final serviceRef = FirebaseFirestore.instance
          .collection('servicios')
          .doc(widget.servicio.id);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(serviceRef);

        if (!snapshot.exists) {
          throw Exception("El servicio con ID ${widget.servicio.id} no existe en la base de datos.");
        }

        // VALIDACIÓN DE NULOS: Si el campo no existe, usamos 0.0 o 0
        final data = snapshot.data() as Map<String, dynamic>;
        
        double promedioActual = 0.0;
        if (data.containsKey('promedioEstrellas') && data['promedioEstrellas'] != null) {
          promedioActual = (data['promedioEstrellas'] as num).toDouble();
        }

        int votosTotales = 0;
        if (data.containsKey('totalVotos') && data['totalVotos'] != null) {
          votosTotales = (data['totalVotos'] as num).toInt();
        }

        // Cálculo
        int nuevosVotos = votosTotales + 1;
        double nuevoPromedio = ((promedioActual * votosTotales) + _ratingSeleccionado) / nuevosVotos;

        // 1. Actualizar el servicio original
        transaction.update(serviceRef, {
          'promedioEstrellas': nuevoPromedio,
          'totalVotos': nuevosVotos,
        });

        // 2. Actualizar la contratación
        if (widget.contratacionId != null) {
          final reservaRef = FirebaseFirestore.instance
              .collection('servicios_contratados')
              .doc(widget.contratacionId);
          
          transaction.update(reservaRef, {
            'calificacion': _ratingSeleccionado,
            'comentario': _commentController.text,
            'estado': 'calificado'
          });
        }
      });

      if (mounted) {
        Navigator.pop(context); // Cerrar el loading
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("¡Calificación publicada!"), backgroundColor: Colors.green),
        );
        Navigator.pop(context); // Volver a la lista
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Cerrar el loading
        // Aquí imprimimos el error exacto para que lo veas en consola
        print("ERROR DETECTADO: $e"); 
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
        );
      }
    }
  }

  // --- El resto de tus métodos permanecen igual ---
  void _marcarComoCompletado() async {
    if (widget.contratacionId == null) return;
    try {
      await ReservasService().finalizarServicio(widget.contratacionId!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Servicio completado"), backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? darkBackground : lightBackground,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildAppBar(),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.servicio.nombreTienda,
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black),
                      ),
                      const SizedBox(height: 10),
                      _buildRatingInfo(isDark),
                      const Divider(height: 40, color: Colors.grey),
                      const Text("Sobre este servicio", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Text(widget.servicio.descripcion,
                        style: TextStyle(fontSize: 16, color: isDark ? Colors.grey[400] : Colors.grey[700], height: 1.5),
                      ),
                      const SizedBox(height: 30),

                      if (widget.estadoReserva == "pendiente" && widget.contratacionId != null)
                        _buildConfirmButton()
                      else if (widget.estadoReserva == "completado") 
                        _buildCalificacionSection(isDark)
                      else if (widget.contratacionId == null)
                        const SizedBox.shrink()
                      else
                        _buildAvisoPendiente(isDark),
                      
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (widget.contratacionId == null) _buildBookingFooter(isDark),
        ],
      ),
    );
  }

  Widget _buildConfirmButton() {
    return SizedBox(
      width: double.infinity, height: 55,
      child: ElevatedButton.icon(
        onPressed: _marcarComoCompletado,
        icon: const Icon(Icons.check_circle, color: Colors.white),
        label: const Text("Confirmar Trabajo Terminado", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(backgroundColor: Colors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 300, pinned: true, backgroundColor: primaryBlue,
      leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: Colors.white), onPressed: () => Navigator.pop(context)),
      flexibleSpace: FlexibleSpaceBar(
        background: widget.servicio.imageUrl.isNotEmpty 
          ? Image.network(widget.servicio.imageUrl, fit: BoxFit.cover)
          : Container(color: Colors.grey),
      ),
    );
  }

  Widget _buildRatingInfo(bool isDark) {
    return Row(
      children: [
        const Icon(Icons.star, color: Colors.amber, size: 20),
        const SizedBox(width: 5),
        Text(widget.servicio.rating.toStringAsFixed(1), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Text(" (${widget.servicio.reviews} reseñas)", style: TextStyle(color: isDark ? Colors.grey[500] : Colors.grey[600])),
      ],
    );
  }

  Widget _buildCalificacionSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Danos tu opinión", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryBlue)),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) => IconButton(
            icon: Icon(index < _ratingSeleccionado ? Icons.star : Icons.star_border, color: Colors.amber, size: 40),
            onPressed: () => setState(() => _ratingSeleccionado = index + 1.0),
          )),
        ),
        const SizedBox(height: 15),
        TextField(
          controller: _commentController,
          maxLines: 3,
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
          decoration: InputDecoration(
            hintText: "Tu comentario...",
            filled: true, fillColor: isDark ? darkInput : Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          width: double.infinity, height: 50,
          child: ElevatedButton(
            onPressed: _enviarCalificacion,
            style: ElevatedButton.styleFrom(backgroundColor: primaryBlue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: const Text("Publicar Calificación", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  Widget _buildAvisoPendiente(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: isDark ? darkInput : Colors.grey[200], borderRadius: BorderRadius.circular(12)),
      child: const Row(
        children: [
          Icon(Icons.info_outline, color: primaryBlue),
          SizedBox(width: 10),
          Expanded(child: Text("Podrás calificar cuando el servicio se complete.", style: TextStyle(fontSize: 13, fontStyle: FontStyle.italic))),
        ],
      ),
    );
  }

  Widget _buildBookingFooter(bool isDark) {
    return Positioned(
      bottom: 0, left: 0, right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 35),
        decoration: BoxDecoration(
          color: isDark ? darkBackground : Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
          border: Border(top: BorderSide(color: isDark ? Colors.white10 : Colors.grey[200]!)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("PRECIO TOTAL", style: TextStyle(fontSize: 10, color: Colors.grey)),
                Text("Bs ${widget.servicio.precioValor.toStringAsFixed(0)}", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primaryBlue)),
              ],
            ),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _isBooking ? null : () async {
                  setState(() => _isBooking = true);
                  try {
                    final user = _authService.currentUser;
                    if (user == null) throw "Debes iniciar sesión";
                    await FirebaseFirestore.instance.collection('servicios_contratados').add({
                      'clienteId': user.uid,
                      'nombreCliente': user.email,
                      'servicioId': widget.servicio.id,
                      'nombreServicio': widget.servicio.nombreTienda,
                      'proveedorId': widget.servicio.proveedorId,
                      'precio': widget.servicio.precioValor,
                      'estado': 'pendiente',
                      'fechaContratacion': FieldValue.serverTimestamp(),
                      'descripcion': widget.servicio.descripcion,
                    });
                    if (mounted) Navigator.pop(context);
                  } catch (e) {
                    setState(() => _isBooking = false);
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: primaryBlue, padding: const EdgeInsets.symmetric(horizontal: 30), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: _isBooking ? const CircularProgressIndicator(color: Colors.white) : const Text("Reservar Ahora", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}