# EasyFood

## Introducción
EasyFood es una aplicación móvil para iOS desarrollada en Swift. Permite a los usuario filtrar recetas y guardarlas basado en varios criterios como los ingredientes, restricciones dietarias, alergias, etc.

### Prerrequisitos
La aplicación ha sido desarrollada utilizando Swift y Xcode. Asegúrate de tener instalado lo siguiente en tu ordenador:
- Xcode
- Swift
- CocoaPods (opcional para instalar las dependencias)

### Instalación
1. Clonar el repositorio
```bash
git clone https://github.com/Ainhoa5/EasyFood.git
```
2. Abrir el proyecto en Xcode
3. abre EasyFood.xcworkspace
4. Instalar las dependencias necesarias utilizando CocoaPods. Navega al directorio del proyecto y ejecuta:
```bash
pod install
```
Este comando instalará las dependencias necesarias, incluyendo Firebase SDK y la librería de URLImage.
Otra opción es instalarlos individualmente desde el manager de paquetes interno de Xcode.

### Credenciales
La aplicación utiliza Firebase para el almacenamiento de datos y la autenticación, y la API de Edamam para la búsqueda de recetas.
**Firebase:** Registra la aplicación en la [consola de Firebase](https://console.firebase.google.com/), descarga el fichero GoogleService-Info.plist, y añádelo al proyecto en Xcode.
**Edamam:** Crea una cuenta en [la web de Edamam](https://www.edamam.com/), Obtén tus credenciales y añádelas al proyecto en un fichero llamado Edamam.plist para ser reconocidas por la app.

## Uso
La aplicación es intuitiva y fácil de usar. Al iniciarla, los usuarios se encuentran con una lista de recetas que pueden filtrar según sus preferencias. Los usuarios también pueden crear una cuenta para guardar sus recetas favoritas y acceder a ellas desde cualquier dispositivo.

