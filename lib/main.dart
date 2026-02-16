import 'package:flutter/material.dart';
import 'dart:math';

void main() =>
    runApp(const AhorcadoApp()); 

class AhorcadoApp extends StatelessWidget {
  const AhorcadoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:
          false, 
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(
          0xFF05061C,
        ), // Define el color de fondo oscuro
      ),
      home: const JuegoAhorcado(),
    );
  }
}

class JuegoAhorcado extends StatefulWidget {
  const JuegoAhorcado({super.key});

  @override
  State<JuegoAhorcado> createState() => _JuegoAhorcadoState();
}

// -------------------- MI "BASE DE DATOS" DEL JUEGO ----------------------
class _JuegoAhorcadoState extends State<JuegoAhorcado> {
  // Contiene: Palabra (solución) y Pista (ayuda)
  final List<Map<String, String>> _datos = [
    {"palabra": "FLUTTER", "pista": "Framework de Google para apps móviles."},
    {"palabra": "VARIABLE", "pista": "Espacio en memoria para guardar datos."},
    {
      "palabra": "ALGORITMO",
      "pista": "Pasos ordenados para resolver un problema.",
    },
    {"palabra": "BINARIO", "pista": "Sistema numérico de ceros y unos."},
    {"palabra": "DATABASE", "pista": "Lugar donde se guardan muchos datos."},
    {
      "palabra": "PYTHON",
      "pista": "Lenguaje muy usado en Inteligencia Artificial.",
    },
    {"palabra": "CODIGO", "pista": "Conjunto de instrucciones para la PC."},
    {
      "palabra": "BUCLE",
      "pista": "Estructura que repite instrucciones (for, while).",
    },
    {
      "palabra": "FUNCION",
      "pista": "Bloque de código para una tarea específica.",
    },
    {
      "palabra": "CLASE",
      "pista": "Plantilla para crear objetos en programación.",
    },
    {
      "palabra": "ANDROID",
      "pista": "Sistema operativo móvil más usado del mundo.",
    },
    {
      "palabra": "COMPUTADORA",
      "pista": "Máquina electrónica que procesa datos.",
    },


    {"palabra": "MATRIZ", "pista": "Arreglo de datos en varias dimensiones."},
    {"palabra": "INTERNET", "pista": "La gran red mundial de computadoras."},
    {"palabra": "TECLADO", "pista": "Periférico de entrada para escribir."},
    {
      "palabra": "MOUSE",
      "pista": "Dispositivo para mover el puntero en pantalla.",
    },
    {
      "palabra": "SOFTWARE",
      "pista": "La parte lógica e intangible de una computadora.",
    },
    {
      "palabra": "HARDWARE",
      "pista": "La parte física que puedes tocar de la PC.",
    },
  ];

  late String _palabraSecreta; // Palabra elegida para la partida
  late String _pistaActual; // Pista de la palabra actual
  //(Late es una variable que no se usa inmediato)
  List<String> _letrasAdivinadas =
      []; // Lista de letras que el usuario ya presionó
  int _intentosFallidos = 0; // Contador de errores
  int _racha = 0; // Contador de victorias consecutivas
  final int _maxIntentos = 6; // Límite de fallos permitidos
  //(final es una variable que solo se asigna una vez)

  @override
  void initState() {
    super.initState();
    _iniciarJuego();
  }

  //----- Selecciona la palabra al azar y resetea los contadores para limpiar y redibujar------

  void _iniciarJuego() {
    setState(() {
      final seleccionado = _datos[Random().nextInt(_datos.length)];
      _palabraSecreta = seleccionado["palabra"]!
          .toUpperCase(); //Extrae la palabra seleccionada
      _pistaActual = seleccionado["pista"]!;
      _letrasAdivinadas = []; //Limpia teclado
      _intentosFallidos = 0; //Limpia errores para reiniciar las 6 vidas
    });
  }

  //--------- Verifica si la letra presionada es correcta o incorrecta------
  void _comprobarLetra(String letra) {
    if (_letrasAdivinadas.contains(letra) ||
        _intentosFallidos >=
            _maxIntentos) //Aqui checa si ya se presionó la letra antes o si ya perdió
      return; //Evita que se siga jugando después de perder

    setState(() {
      _letrasAdivinadas.add(letra); // Guarda la letra usada
      if (!_palabraSecreta.contains(letra)) {
        //Checa si la letra no esta en la palbra
        _intentosFallidos++; // Si falló, aumenta el contador de errores
      }
    });
  }

  // -------------------- DIBUJITO DEL AHORCADO ------------------------------
  // Esta es la parte visual del juego pq dibuja la horca y el personaje de forma progresiva.
  // Se usa Stack para colocar las piezas una encima de otra como si fuera calcomania.
  Widget _buildFiguraAhorcado() {
    return Container(
      height: 180,
      width: 150,
      child: Stack(
        children: [
          // ---------- ESTRUCTURA DE LA HORCA --------

          // Base de la horca en el suelo
          Positioned(
            bottom: 0,
            left: 10,
            child: Container(height: 5, width: 80, color: Colors.brown),
          ),

          // Poste principal
          Positioned(
            bottom: 0,
            left: 20,
            child: Container(height: 160, width: 5, color: Colors.brown),
          ),

          // Brazo de la horca
          Positioned(
            top: 10,
            left: 20,
            child: Container(height: 5, width: 70, color: Colors.brown),
          ),

          // Reata de la horca
          Positioned(
            top: 10,
            left: 85,
            child: Container(height: 20, width: 3, color: Colors.brown),
          ),

          // ----------- PARTES DEL CUERPO -------------
          // Cada parte solo aparece si el contador de errores es mayor a cierto número

          // 1er Error: Aparece la CABEZA
          if (_intentosFallidos > 0)
            const Positioned(
              top: 30,
              left: 70,
              child: Icon(
                Icons.face,
                size: 35,
              ), //Viene de la librería material.dart
            ),

          // 2do Error: Aparece el CUERPO
          if (_intentosFallidos > 1)
            Positioned(
              top: 60,
              left: 85,
              child: Container(height: 50, width: 4, color: Colors.white),
            ),

          // 3er Error: Aparece el BRAZO IZQUIERDO
          // Se usa Transform.rotate para darle la inclinación al brazo
          if (_intentosFallidos > 2)
            Positioned(
              top: 70,
              left: 65,
              child: Transform.rotate(
                angle: 0.5, // Rotación hacia la izquierda
                child: Container(height: 4, width: 25, color: Colors.white),
              ),
            ),

          // 4to Error: Aparece el BRAZO DERECHO
          if (_intentosFallidos > 3)
            Positioned(
              top: 70,
              left: 85,
              child: Transform.rotate(
                angle: -0.5, // Rotación hacia la derecha
                child: Container(height: 4, width: 25, color: Colors.white),
              ),
            ),

          // 5to Error: Aparece la PIERNA IZQUIERDA
          if (_intentosFallidos > 4)
            Positioned(
              top: 105,
              left: 65,
              child: Transform.rotate(
                angle: -0.5,
                child: Container(height: 4, width: 25, color: Colors.white),
              ),
            ),

          // 6to Error: Aparece la PIERNA DERECHA
          if (_intentosFallidos > 5)
            Positioned(
              top: 105,
              left: 85,
              child: Transform.rotate(
                angle: 0.5,
                child: Container(height: 4, width: 25, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // -----Revisa si las letras de la palabra secreta están en la lista de adivinadas
    bool gano = _palabraSecreta
        .split('') //Split separa la palabra en letras
        .every((l) => _letrasAdivinadas.contains(l)); //Devuelve todo

    // Revisa si se alcanzó el límite de errores
    bool perdio = _intentosFallidos >= _maxIntentos;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "AHORCADITO",
          style: TextStyle(
            fontWeight: FontWeight.bold, // Texto en negrita
            letterSpacing: 1.2, // Espaciado ligero entre letras para estilo
          ),
        ),
        centerTitle: false, // Alinea el título a la izquierda (false)
        backgroundColor:
            Colors.transparent, // Hace que la barra sea transparente
        elevation: 0, // Elimina la sombra debajo de la barra
        actions: [
          Container(
            margin: const EdgeInsets.only(
              right: 20,
              top: 15,
            ), // Margen para separar la racha del borde
            child: Text(
              "Racha: 🔥 $_racha", // Muestra el emoji y la variable de victorias consecutivas
              style: const TextStyle(
                fontSize: 18,
                color: Colors.orange, // Color naranja para resaltar el fuego
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),

      body: Column(
        children: [
          const SizedBox(height: 10),
          _buildFiguraAhorcado(), // Llamada a la función que dibuja el monito
          // Contenedor que encierra la pista del juego
          Container(
            margin: const EdgeInsets.all(
              15,
            ), // Espacio exterior alrededor del cuadro
            padding: const EdgeInsets.all(
              12,
            ), // Espacio interior entre el borde y el texto
            decoration: BoxDecoration(
              color: const Color(0xFF1E2147), // Color de fondo azul marino
              borderRadius: BorderRadius.circular(15), // Bordes redondeados
              // Borde sutil de color azul brillante con transparencia
              border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
            ),
            // Muestra el foquito y la pista actual obtenida del mapa de datos
            child: Text("💡 PISTA: $_pistaActual", textAlign: TextAlign.center),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: SingleChildScrollView(
              // Si la palabra es muy larga, el usuario pueda deslizar hacia los lados
              scrollDirection: Axis.horizontal, // Desplazamiento horizontal
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Centra los elementos en la fila
                children: _palabraSecreta.split('').map((letra) {
                  // Split divide la palabra en letras
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 5,
                    ), // Espacio entre cada letra
                    width: 25, // Ancho de cada espacio de letra
                    decoration: const BoxDecoration(
                      // Crea la línea blanca debajo de cada letra (el espacio en blanco)
                      border: Border(
                        bottom: BorderSide(color: Colors.white, width: 2),
                      ),
                    ),

                    // Muestra la letra solo si ya fue adivinada, si no muestra un texto vacío
                    child: Text(
                      _letrasAdivinadas.contains(letra)
                          ? letra
                          : "", //si esta la letra la muestra, si no un espacio vacio
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }).toList(), // Convierte el mapa de nuevo a una lista de widgets
              ),
            ),
          ),

          //--------------------------- PARTE DEL TECLADO --------------------------//
          // Expanded hace que el teclado ocupe todo el espacio disponible restante en la pantalla
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ), // Margen lateral para que los botones no toquen los bordes
              child: GridView.count(
                crossAxisCount:
                    7, // Organiza los botones en una cuadrícula de 7 columnas
                mainAxisSpacing: 5, // Espaciado vertical entre botones
                crossAxisSpacing: 5, // Espaciado horizontal entre botones
                // Con children generamos la lista de botones dinámicamente
                children: "ABCDEFGHIJKLMNÑOPQRSTUVWXYZ".split('').map((letra) {
                  // Lógica de estado para cada botón individual:
                  bool yaUsada = _letrasAdivinadas.contains(
                    letra,
                  ); //Verifica si esta letra específica ya está en la lista de intentada
                  bool correcta =
                      yaUsada &&
                      _palabraSecreta.contains(
                        letra,
                      ); //Verifica si ya se usó y además existe dentro de la palabra

                  return ElevatedButton(
                    onPressed:
                        yaUsada ||
                            gano ||
                            perdio //Define qué pasa al tocar el botón
                        ? null // Si la letra ya se usó, o el juego terminó, el botón se bloquea y se pone gris
                        : () => _comprobarLetra(
                            letra,
                          ), // Si está disponible, manda la letra a la función de comprobación

                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          yaUsada //Cambia el color del botón según el estado
                          ? (correcta
                                ? Colors
                                      .green // Verde si la letra es parte de la palabra
                                : Colors
                                      .red) // Rojo si la letra NO es parte de la palabra
                          : const Color(
                              0xFF1E2147,
                            ), // Azul oscuro original si aún no se ha presionado

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          8,
                        ), // Bordes ligeramente redondeados
                      ),
                      padding: EdgeInsets
                          .zero, // Elimina el espacio interno para que la letra quepa bien
                    ),

                    // Texto que muestra la letra dentro del botón
                    child: Text(letra, style: const TextStyle(fontSize: 16)),
                  );
                }).toList(), // Convierte el resultado del mapeo en una lista real de widgets
              ),
            ),
          ),

          //------------------TEXTO AL FINAL DEL NIVEL----------------------------------//
  
          // Este 'if' controla la visibilidad, el contenedor solo nace si el juego terminó (ganó o perdió)
          if (gano || perdio)
            Container(
              padding: const EdgeInsets.all(20), // Espacio interno del mensaje
              width: double
                  .infinity, // Hace que el mensaje ocupe todo el ancho de la pantalla
              // COLOR DINÁMICO: Si ganó se pone verde, si perdió se pone rojo (con 30% de opacidad)
              color: gano
                  ? Colors.green.withOpacity(0.3)
                  : Colors.red.withOpacity(0.3),

              child: Column(
                children: [
                  // TEXTO DINÁMICO: Cambia el mensaje y el emoji según el caso
                  Text(
                    gano ? "¡LOGRADO! 💻" : "PERDISTE 💀",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // REVELACIÓN: Si el usuario perdió, le mostramos cuál era la palabra correcta
                  if (perdio) Text("La respuesta era: $_palabraSecreta"),

                  const SizedBox(
                    height: 10,
                  ), // Separación entre el texto y el botón
                  // BOTÓN DE ACCIÓN: Para reiniciar el ciclo del juego
                  ElevatedButton(
                    onPressed: () {
                      //----------------- LÓGICA DE RACHA: ---------------------------//

                      if (gano)
                        _racha++; // Si ganó, aumentamos el contador de fuego
                      else
                        _racha =
                            0; // Si perdió, la racha se rompe y vuelve a cero

                      _iniciarJuego(); // Llama a la función que limpia todo y elige nueva palabra
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.white, // Botón blanco para que resalte
                      foregroundColor:
                          Colors.black, // Letras negras para buen contraste
                    ),
                    child: const Text("SIGUIENTE PALABRA"),
                  ),
                ],
              ),
            ),
        ], 
      ),
    );
  }
}