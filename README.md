![logo](https://i.imgur.com/xOniTxy.png)
# moodify app 🎵
## proyecto flutter
### participantes: Aldana Aranda, Jessica Escobar y Federico Pérez Martinetti

### Index

1. Descripción
2. Documentación
    * [Requerimientos previos](#requerimientos-previos)
    * [Instalación](#instalación)
    * [Ejecución](#ejecución)
    * [Estructura del proyecto](#estructura)
    * [Widgets destacados](#widgets)
    * [State Management](#state-management)
    * [Funcionalidades](#funcionalidades)
    * [Roadmap](#roadmap)
3. Ramas
    + [Aldi_branch](https://github.com/FMartine7i/moodify_api/tree/aldi_branch)
    + [Jessi_branch](https://github.com/FMartine7i/moodify_api/tree/jessii_branch)
    + [Fede_branch](https://github.com/FMartine7i/moodify_api/tree/fede_branch)

## Descripción
**moodify** es una app que permite a los usuarios encontrar playlists, canciones y álbums basados en su **estado de ánimo** actual.

## Documentación
### Requerimientos previos
> [!NOTE]
> Tener instalado Flutter SDK y Dart. Editor de código recomendado: Visual Studio Code.
### Instalación
> - Clonar repositorio del Frontend: ``https://github.com/FMartine7i/flutter_app_2024.git``
> - ``cd flutter_app_2024``
> - Instalar dependencias con: ``flutter pub get``
### Ejecución
> [!NOTE]
> Emulador: 
> * API 35
> * dispositivo: Pixel 4 XL
> * SO: Android 15
> * 1440 x 3040

> Correr el comando: ``flutter run``
### Estructura
> - ``pubspec.yaml``: contiene las dependencias de la app
> - ``lib``: contiene la lógica de la app
> - ``screens``: contiene los archivos de cada pantalla
> - ``widgets``: contiene los widgets de la app
> - ``main.dart``: contiene el punto de entrada de la app

> ### flutter_app_2024
> - ├── lib/
> - │   ├── helpers/
> - │   │   ├── preferences.dart
> - │   │   ├── theme_provider.dart
> - │   ├── main.dart
> - │   ├── mocks/
> - │   │   ├── albumes_mock.dart
> - │   │   ├── songs_mock.dart
> - │   │   ├── usuario_mock.dart
> - │   ├── screens/
> - │   │   ├── album_individual.dart
> - │   │   ├── albu_list_screen.dart
> - │   │   ├── home_screen.dart
> - │   │   ├── login_screen.dart
> - │   │   ├── profile_screen
> - │   │   ├── songs.dart
> - │   │   ├── songs_list_screen.dart
> - │   │   ├── songs_list_item.dart
> - │   ├─ themes/
> - │   │   ├── default_theme.dart
> - │   ├── widgets/
> - │   │   ├── drawer_menu.dart
> - │   ├ pubspec.yaml


### Widgets
* destacados

    | widget | descripción |
    |---|---|
    | **drawer menu** | Menú lateral desplegable con opciones dinámicas.



### State Management
* providers implementados

    | provider | descripción |
    |---|---|
    | **theme provider** | Permite alternar entre tema claro y oscuro.   


### Funcionalidades
* funcionalidades implementadas
    | funcionalidad | descripción |
    |---|---|
    | **cambiar tema** | permite cambiar entre tema claro y oscuro.
    | **login** | permite iniciar sesión con usuario y contraseña.
    | **mostrar canciones** | permite mostrar canciones de un álbum.
    | **mostrar canción** | permite mostrar canción individual.
    | **mostrar álbumes** | permite mostrar álbumes almacenados.
    | **mostrar álbum** | permite mostrar álbum individual.
    | **mostrar playlists** | permite mostrar las playlists de spotify.
    | **mostrar perfil** | muestra el perfil del usuario. Permite agregar una foto personalizada, cambiar el nombre y ver sus canciones y álbumes favoritos.

>[!Tip]
> Las funcionalidades de la app se encuentran en desarrollo, por lo tanto se podrá ingresar a la app solo presionando el botón de ``login`` en la pantalla de inicio. No es necesario registrarse en la sección de ``sign up``.

>[!Important]
> Lo mismo sucede en el ``drawer menu``. Al seleccionar "songs" se desplegarán las opciones de ver todas las canciones y de elegir canciones por "mood". Esta segunda opción no está implementada, dado que esos datos se obtienen de la API de Spotify.
> El botón "get started" en la ``home screen`` también accederá a buscar canciones por "mood", por lo tanto en esta versión no tiene una funcionalidad.

### Roadmap
Constituir el backend con ``Node.Js`` para integrar la API de Spotify para obtener información de canciones, álbumes y artistas.