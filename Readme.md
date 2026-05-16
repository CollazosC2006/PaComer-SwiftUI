# 🍽️ Pa' comer

Una aplicación móvil nativa para iOS que conecta a los usuarios con la oferta gastronómica de su zona, funcionando como un directorio interactivo para explorar menús locales, realizar pedidos en tiempo real y coordinar la entrega directamente con el restaurante.

## 📖 Descripción del Proyecto

A diferencia de las plataformas de delivery tradicionales, **Pa' comer** adopta un modelo de "solo transmisión de órdenes". La aplicación se encarga exclusivamente de la experiencia de usuario (UI), la selección del menú, el cálculo del carrito y la captura de datos logísticos, transmitiendo la orden estructurada directamente al WhatsApp del restaurante. 

A partir de ese punto, el restaurante asume la logística de preparación, cobro y entrega.

### ✨ Propuesta de Valor
* **Precios reales y sin inflación:** Al eliminar las altas comisiones de los intermediarios logísticos, los restaurantes pueden ofrecer los mismos precios que en su local físico.
* **Conexión directa:** Fomenta un trato más directo entre el negocio local y el cliente mediante la integración nativa con herramientas de mensajería (WhatsApp).
* **Catálogo Digital:** Sirve como herramienta de consulta conectada a la nube para ver menús actualizados, fotografías y precios antes de visitar el establecimiento.

## 🛠️ Stack Tecnológico

El proyecto está desarrollado utilizando los estándares modernos de Apple para el ecosistema iOS:

* **Lenguaje:** Swift
* **UI Toolkit:** SwiftUI
* **Arquitectura:** MVVM (Model-View-ViewModel) aplicando principios de Clean Architecture (Uso de Protocolos/Contratos).
* **Backend as a Service (BaaS):** Firebase Firestore (Lectura de catálogos en tiempo real y mapeo directo a estructuras nativas).
* **Almacenamiento Local:** `UserDefaults` + Protocolo `Codable` nativo de Apple (Persistencia de perfil y carrito con cero dependencias externas).
* **Imágenes y Caché:** Kingfisher (Optimización de red y carga asíncrona en listas).
* **Integración (Deep Linking):** URL Schemes nativos (`UIApplication`) para redireccionamiento dinámico.

## 📱 Características Principales (UX/UI)

El diseño de la aplicación aplica los principios de las Human Interface Guidelines (HIG) orientadas a la usabilidad y conversión móvil:
* **Navegación Fluida:** Enrutamiento robusto mediante `NavigationStack` y `NavigationPath`, permitiendo un control profundo del historial de vistas y gestos nativos de retroceso.
* **Flujo sin Fricción:** Muestra el valor desde el inicio sin registros obligatorios. El usuario explora y añade al carrito libremente, solicitando sus datos únicamente en el paso final del checkout.
* **Formularios Amigables:** Entradas de texto nativas optimizadas (despliegue automático de teclado numérico para teléfonos) y validación de campos obligatorios.
* **Gestión de Estado Reactiva:** La interfaz responde instantáneamente a las acciones del usuario gracias a los *Property Wrappers* de SwiftUI (`@StateObject`, `@EnvironmentObject`, `@Published`).

## ⚙️ Instalación y Configuración

1. Clona este repositorio:
   ```bash
   git clone [https://github.com/tu-usuario/pa-comer.git](https://github.com/tu-usuario/pa-comer.git)
   ```

2. Abre el archivo del proyecto (PaComer.xcodeproj) en Xcode (Versión 15 o superior recomendada).
3. Asegúrate de tener el archivo GoogleService-Info.plist en la raíz del proyecto para habilitar la conexión con Firebase.
4. Espera a que Swift Package Manager (SPM) termine de resolver e instalar automáticamente las dependencias (Firebase iOS SDK y Kingfisher).
5. Selecciona un simulador de iPhone o tu dispositivo físico y ejecuta la aplicación (Cmd + R). Requiere iOS 16.0 o superior.

## 🎓 Contexto
Este proyecto fue desarrollado como micro proyecto de la asignatura Aplicaciones Móviles.
- **Autores:** Carlos Daniel Collazos Zambrano
- **Docente:** Cristhian Nicolas Figueroa Martinez.
- **Institución:** Facultad de Ingeniería Electrónica y Telecomunicaciones, Universidad del Cauca.