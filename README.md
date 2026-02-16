# Juego del Ahorcado

Este proyecto es una aplicación móvil que representa el juego del "Ahorcado" desarrollada íntegramente en Flutter, diseñada con una estética de modo oscuro y enfocada en conceptos técnicos de programación. La aplicación funciona mediante un ciclo de juego donde se selecciona aleatoriamente una palabra de una base de datos interna que incluye términos como "Algoritmo", "Flutter", "Bucle" y "Software", cada una acompañada de una pista descriptiva para ayudar al usuario.

## ¿Cómo funciona el código?

La lógica principal se gestiona a través de un StatefulWidget que controla el estado de la partida. Al iniciar el sistema elige una palabra al azar y limpia los registros de intentos. El jugador interactúa con un teclado virtual de la A a la Z generado dinámicamente; y cuando se presiona una letra el código verifica si existe dentro de la palabra secreta. Si la letra es correcta se revela en su posición correspondiente mediante una fila de espacios subrayados; y si es incorrecta se incrementa un contador de fallos y el botón del teclado se marca en rojo para evitar repetir el error.

La parte visual del ahorcado es uno de los puntos clave del desarrollo: utiliza un widget de tipo Stack para superponer las piezas del personaje (cabeza, cuerpo, extremidades). Estas piezas solo se renderizan cuando el contador de errores alcanza niveles específicos, utilizando transformaciones de rotación para dar un aspecto más natural a los brazos y piernas.

El juego también incluye un sistema de "Rachas" que premia las victorias consecutivas, reiniciándose a cero si el jugador pierde. Al finalizar cada ronda ya sea por victoria (adivinar todas las letras) o derrota (agotar los 6 intentos) la aplicación muestra un mensaje dinámico con la opción de cargar una nueva palabra, permitiendo un flujo de juego continuo y adictivo.
