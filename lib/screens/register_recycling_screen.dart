import 'package:flutter/material.dart';
import 'package:eco_hogar/widgets/custom_app_bar.dart';
import 'package:eco_hogar/widgets/waste_type_card.dart';
import 'package:eco_hogar/widgets/custom_button.dart';
import 'package:eco_hogar/models/recycling_model.dart';
import 'package:eco_hogar/services/recycling_service.dart';
import 'package:eco_hogar/services/auth_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

/// Pantalla para registrar reciclaje
class RegisterRecyclingScreen extends StatefulWidget {
  const RegisterRecyclingScreen({Key? key}) : super(key: key);

  @override
  State<RegisterRecyclingScreen> createState() =>
      _RegisterRecyclingScreenState();
}

class _RegisterRecyclingScreenState extends State<RegisterRecyclingScreen> {
  final RecyclingService _recyclingService = RecyclingService();
  final AuthService _authService = AuthService();
  final ImagePicker _imagePicker = ImagePicker();

  WasteType? _selectedWasteType;
  late TextEditingController _quantityController;
  late TextEditingController _notesController;
  DateTime _selectedDate = DateTime.now();
  XFile? _selectedImage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController();
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final image = await _imagePicker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() => _selectedImage = image);
    }
  }

  Future<void> _registerRecycling() async {
    if (_selectedWasteType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona un tipo de residuo')),
      );
      return;
    }

    if (_quantityController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa la cantidad')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      String? userId = _authService.currentUserId;
      if (userId == null) throw Exception('Usuario no autenticado');

      double quantity = double.parse(_quantityController.text);

      await _recyclingService.registerRecycling(
        userId: userId,
        wasteType: _selectedWasteType!,
        quantity: quantity,
        unit: 'kg',
        date: _selectedDate,
        notes: _notesController.text,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '¡Registrado! +${RecyclingModel.calculatePoints(quantity, _selectedWasteType!)} puntos',
            ),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Registrar Reciclaje',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tipo de residuo
            Text(
              'Selecciona el tipo de residuo',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: WasteType.values.map((type) {
                return WasteTypeCard(
                  wasteType: type,
                  isSelected: _selectedWasteType == type,
                  onTap: () {
                    setState(() => _selectedWasteType = type);
                  },
                  size: 90,
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            // Cantidad
            Text(
              'Cantidad',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _quantityController,
              decoration: const InputDecoration(
                hintText: 'Ingresa la cantidad en kg',
                prefixIcon: Icon(Icons.scale),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            // Fecha
            Text(
              'Fecha',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2024),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  setState(() => _selectedDate = date);
                }
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFECF0F1)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today),
                    const SizedBox(width: 12),
                    Text(
                      '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Notas
            Text(
              'Notas (opcional)',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                hintText: 'Añade notas sobre este registro',
                prefixIcon: Icon(Icons.note),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            // Botón de registro
            CustomButton(
              label: 'Registrar Reciclaje',
              onPressed: _registerRecycling,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }
}
