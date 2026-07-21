# EcoHogar 🌱

## Aplicación Móvil de Reciclaje e Incentivos Ambientales

EcoHogar es una aplicación móvil diseñada para incentivar el reciclaje en hogares de bajos recursos mediante un sistema de registro y recompensas. La app permite registrar, rastrear y premiar las acciones de reciclaje con una interfaz intuitiva y colorida.

### 🎯 Objetivo

Promover la sostenibilidad ambiental a través de gamificación, educación ambiental y reconocimiento comunitario.

### 📱 Características Principales

- **Autenticación de usuarios** con Firebase Authentication
- **Registro de reciclaje** con múltiples categorías
- **Sistema de puntos y insignias** para motivar la participación
- **Escaneo de códigos QR** para registros rápidos
- **Dashboard con estadísticas** de impacto ambiental
- **Certificados PDF mensuales** descargables
- **Educación ambiental** integrada
- **Soporte para temas claro/oscuro**
- **Múltiples idiomas** (Español, Inglés)

### 🛠️ Stack Tecnológico

- **Framework**: Flutter 3.x
- **Backend**: Firebase (Authentication, Firestore, Storage)
- **Generación de PDF**: pdf package
- **Escaneo QR**: qr_code_scanner
- **Gráficas**: fl_chart
- **Almacenamiento local**: shared_preferences, sqflite

### 📂 Estructura del Proyecto

```
EcoHogar/
├── android/                 # Configuración Android
├── ios/                     # Configuración iOS
├── lib/
│   ├── main.dart
│   ├── config/
│   │   ├── theme/
│   │   ├── routes/
│   │   └── firebase_config.dart
│   ├── models/
│   ├── services/
│   ├── screens/
│   ├── widgets/
│   └── utils/
├── pubspec.yaml
└── README.md
```

### 🚀 Instalación y Uso

1. **Clonar el repositorio**
   ```bash
   git clone https://github.com/edithmallqui2025-star/EcoHogar.git
   cd EcoHogar
   ```

2. **Instalar dependencias**
   ```bash
   flutter pub get
   ```

3. **Configurar Firebase**
   - Crear proyecto en Firebase Console
   - Descargar `google-services.json` (Android) y `GoogleService-Info.plist` (iOS)
   - Colocar en sus respectivas carpetas

4. **Ejecutar la aplicación**
   ```bash
   flutter run
   ```

### 📋 Requisitos Previos

- Flutter SDK 3.x
- Dart 3.x
- Android SDK (para desarrollo Android)
- Firebase account
- XCode (opcional, para iOS)

### 🎨 Diseño Visual

**Colores principales:**
- Verde Principal: `#2ECC71`
- Azul Secundario: `#3498DB`
- Blanco: `#FFFFFF`
- Gris Claro: `#ECF0F1`
- Gris Oscuro: `#2C3E50`

### 📄 Licencia

MIT License - Libre para uso comunitario

### 👥 Contribuciones

Las contribuciones son bienvenidas. Por favor, abre un issue o pull request.

### 📞 Contacto

Para más información, contactar a: edithmallqui2025-star@github.com
