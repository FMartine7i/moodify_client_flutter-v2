<img src="https://i.imgur.com/xOniTxy.png" alt="moodify" width="60%">

# moodify flutter app v2.0 🎵
## proyecto flutter

<table>
  <tr>
    <td><img src="https://i.imgur.com/1aLP7MN.png"></td>
    <td><img src="https://i.imgur.com/j9WsSwT.png"></td>
    <td><img src="https://i.imgur.com/asmaNWy.png"></td>
    <td><img src="https://i.imgur.com/rSbcm4j.png"></td>
  </tr>
</table>

<hr>

## Index
* [Descripción](#descripción)
* [Requerimientos previos](#requerimientos-previos)
* [Instalación](#instalación)
* [Ejecución](#ejecución)
* [Funcionalidades](#funcionalidades)
* [Estructura del proyecto](#estructura)
* [Widgets destacados](#widgets)
* [State Management](#state-management)
* [Estado](#estado)
* [Roadmap](#roadmap)

## Descripción
Segunda versión del proyecto frontend para la app **moodify**. Esta versión, además de contar con mejoras visuales, se conecta con la API desarrollada específicamente para esta app para obtener canciones, álbumes y playlists de acuerdo a un "mood" ingresado por el usuario.
> [!NOTE]
> La API de Spotify no está devolviendo las playlists, por lo tanto, en la app se mostrarán ``mocks`` de playlists.

## Requerimientos previos
* Tener instalado Flutter SDK y Dart.
* Tener acceso a la [API moodify](https://github.com/FMartine7i/Moodify_v2)

## Instalación
* Clonar [este repositorio](https://github.com/FMartine7i/Moodify_v2)
* Acceder a la carpeta principal: ``cd flutter_application_base``
* Instalar dependencias con: ``flutter pub get``
## Ejecución
> [!NOTE]
> Emulador: 
> * API 35
> * dispositivo: Pixel 4 XL
> * SO: Android 15
> * 1440 x 3040

* Correr el comando: ``flutter run``

## Funcionalidades
### Funcionalidades implementadas

| <img src="https://i.imgur.com/1aLP7MN.png" width="200"> | <img src="https://i.imgur.com/j9WsSwT.png" width="200"> | <img src="https://i.imgur.com/asmaNWy.png" width="200"> |
| - | - | - |
| Sistema de ``login/sign up``. Primero, el usuario deberá registrarse, luego podrá ingresar con el nombre y contraseña que haya elegido. | En el menú principal se muestran canciones aleatorias y se puede acceder al ``drawer menu``. | A través del ``drawer menu`` se puede acceder a las listas de canciones, álbumes  y playlists y elegir por ``mood``. Además, cuenta con un toggle para alternar el tema. |

| <img src="https://i.imgur.com/ivU1tJU.png" width="200"> | <img src="https://i.imgur.com/aDe6ypX.png" width="200"> | <img src="https://i.imgur.com/rSbcm4j.png" width="200"> |
| - | - | - |
| Screen para el perfil. El usuario puede cambiar su ``username`` y su foto de perfil. También se mostrarán sus canciones y álbumes gustados. | Lista de todas las canciones de la API. Se puede dar agregar a favoritos y seleccionar cualquiera de ellas para reproducir. | Vista de los detalles de la canción seleccionada en la lista. |
> [!WARNING]
> La API de Spotify no está devolviendo las urls de las previews de las canciones, por ello, no reproducirá ningún sonido.

> [!IMPORTANT]
> El sistema para agregar canciones a favoritos aún no está terminado, debido a la complejidad de su implementación.

## Estructura
> - ``pubspec.yaml``: contiene las dependencias de la app
> - ``lib``: contiene la lógica de la app
> - ``controllers``: contiene la lógica de los controladores de la app. ``AuthController`` se encarga de la autenticación para el ``login``y el ``sign up``.
> - ``screens``: contiene los archivos de cada pantalla
> - ``widgets``: contiene los widgets de la app
> - ``main.dart``: contiene el punto de entrada de la app
> - ``services``: contiene la lógica para la conexión con la API

> ### flutter_app_2024
> - ├── lib/
> - │   ├── controllers/
> - │   │   ├── auth_controller.dart
> - │   ├── helpers/
> - │   │   ├── preferences.dart
> - │   │   ├── theme_provider.dart
> - │   ├── main.dart
> - │   ├── mocks/
> - │   │   ├── albums_mock.dart
> - │   │   ├── playlists_mock.dart
> - │   │   ├── songs_mock.dart
> - │   ├── screens/
> - │   │   ├── album_item_screen.dart
> - │   │   ├── albums_list_screen.dart
> - │   │   ├── home_screen.dart
> - │   │   ├── login_screen.dart
> - │   │   ├── playlist_list_item.dart
> - │   │   ├── playlists_list_screen.dart
> - │   │   ├── profile_screen.dart
> - │   │   ├── screens.dart
> - │   │   ├── songs.dart
> - │   │   ├── songs_list_screen.dart
> - │   │   ├── songs_list_item.dart
> - │   ├─ services/
> - │   │   ├── api_service.dart
> - │   ├─ themes/
> - │   │   ├── default_theme.dart
> - │   ├── widgets/
> - │   │   ├── animated_play_button.dart
> - │   │   ├── drawer_menu.dart
> - │   │   ├── glassmorphism.dart
> - │   │   ├── search_area.dart
> - │   │   ├── song_slide.dart
> - │   ├ pubspec.yaml


## Widgets

  | widget | descripción |
  |---|---|
  | **animated_play_button** | Botón de reproducción animado. |
  | **drawer menu** | Menú lateral desplegable con opciones dinámicas. |
  | **glassmorphism** | Permite crear un efecto de vidrio con un gradiente. |
  | **search_area** | Botón de búsqueda para cada entidad. |
  | **song_slide** | Permite mostrar una mini lista de canciones con su imagen y nombre. |

## State Management

  | provider | descripción |
  |---|---|
  | **theme provider** | Permite alternar entre tema claro y oscuro.   

## Estado
  | Nombre del proyecto | moodify client v2 |
  | - | - |
  | Estado |  <img src="https://img.shields.io/badge/incomplete-90%25-8A2BE2"> |
  | Tech Stack | Flutter, Dart, Provider, HTTP |

## Roadmap
* [x] Desarrollar un mini reproductor de canciones.
* [x] Agregar una sección para playlists personalizadas.
* [x] Arreglar el sistema de likes de canciones.
* [x] Hacer funcionales los sistemas de ``loops`` y ``shuffle``.