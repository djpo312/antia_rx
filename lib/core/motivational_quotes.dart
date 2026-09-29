/// Frase inspirada en el deporte, con autor.
class MotivationalQuote {
  final String text;
  final String author;

  const MotivationalQuote(this.text, this.author);
}

/// Banco de frases motivacionales de deporte para mostrar en el Dashboard.
/// Una por día: se elige de forma determinística según la fecha (misma
/// idea que la semilla del WOD), así todas las pantallas de ese día
/// muestran la misma frase y cambia sola al día siguiente.
const List<MotivationalQuote> motivationalQuotes = [
  MotivationalQuote(
    "El dolor que sientes hoy será la fuerza que sientas mañana.",
    "Anónimo",
  ),
  MotivationalQuote(
    "No cuentes los días, haz que los días cuenten.",
    "Muhammad Ali",
  ),
  MotivationalQuote(
    "El único entrenamiento malo es el que no hiciste.",
    "Anónimo",
  ),
  MotivationalQuote(
    "Los campeones se hacen cuando nadie los está mirando.",
    "Anónimo",
  ),
  MotivationalQuote(
    "No se trata de ser el mejor, se trata de ser mejor que ayer.",
    "Anónimo",
  ),
  MotivationalQuote(
    "El cuerpo logra lo que la mente cree.",
    "Anónimo",
  ),
  MotivationalQuote(
    "Sufre ahora y vive el resto de tu vida como un campeón.",
    "Muhammad Ali",
  ),
  MotivationalQuote(
    "La disciplina es elegir entre lo que quieres ahora y lo que quieres más.",
    "Anónimo",
  ),
  MotivationalQuote(
    "Fallé más de 9000 tiros en mi carrera y por eso tuve éxito.",
    "Michael Jordan",
  ),
  MotivationalQuote(
    "No dejes que nadie te diga que no puedes hacer algo.",
    "Rocky Balboa",
  ),
  MotivationalQuote(
    "La fuerza no viene de ganar. Tu lucha desarrolla tu fuerza.",
    "Arnold Schwarzenegger",
  ),
  MotivationalQuote(
    "Todo el mundo quiere ser un campeón hasta que toca entrenar como uno.",
    "Anónimo",
  ),
  MotivationalQuote(
    "No pares cuando estés cansado, para cuando hayas terminado.",
    "Anónimo",
  ),
  MotivationalQuote(
    "Nunca digas nunca, porque los límites, como los miedos, muchas veces son solo una ilusión.",
    "Michael Jordan",
  ),
  MotivationalQuote(
    "Ganar no lo es todo, pero querer ganar sí lo es.",
    "Vince Lombardi",
  ),
  MotivationalQuote(
    "El éxito no es definitivo, el fracaso no es fatal: lo que cuenta es el valor para continuar.",
    "Winston Churchill",
  ),
  MotivationalQuote(
    "Cree que puedes y ya estás a medio camino.",
    "Theodore Roosevelt",
  ),
  MotivationalQuote(
    "La motivación te hace empezar. El hábito te hace continuar.",
    "Jim Ryun",
  ),
  MotivationalQuote(
    "No cuentes los kilómetros, haz que los kilómetros cuenten.",
    "Anónimo",
  ),
  MotivationalQuote(
    "Corro porque cuando no lo hago me siento inquieto e insatisfecho.",
    "Haruki Murakami",
  ),
  MotivationalQuote(
    "El límite existe solo en tu mente.",
    "Arnold Schwarzenegger",
  ),
  MotivationalQuote(
    "Cuanto más sudas en el entrenamiento, menos sangras en la batalla.",
    "Anónimo",
  ),
  MotivationalQuote(
    "El talento gana partidos, pero el trabajo en equipo y la inteligencia ganan campeonatos.",
    "Michael Jordan",
  ),
  MotivationalQuote(
    "Un campeón se define no por sus victorias sino por cómo se recupera cuando cae.",
    "Serena Williams",
  ),
  MotivationalQuote(
    "Si quieres algo que nunca has tenido, debes hacer algo que nunca has hecho.",
    "Anónimo",
  ),
  MotivationalQuote(
    "El dolor es temporal, rendirse dura para siempre.",
    "Lance Armstrong",
  ),
  MotivationalQuote(
    "No hay atajos para ningún lugar que valga la pena ir.",
    "Beverly Sills",
  ),
  MotivationalQuote(
    "Hazlo con pasión o no lo hagas.",
    "Anónimo",
  ),
  MotivationalQuote(
    "Cada campeón fue alguna vez un competidor que se negó a rendirse.",
    "Anónimo",
  ),
  MotivationalQuote(
    "La suerte es lo que sucede cuando la preparación se encuentra con la oportunidad.",
    "Anónimo",
  ),
  MotivationalQuote(
    "Trabaja duro en silencio, deja que el éxito haga el ruido.",
    "Anónimo",
  ),
  MotivationalQuote(
    "El único mal entrenamiento es el que no sucedió.",
    "Anónimo",
  ),
  MotivationalQuote(
    "Los obstáculos no tienen que detenerte. Si te topas con una pared, no te des la vuelta.",
    "Michael Jordan",
  ),
  MotivationalQuote(
    "Entrena como si nunca hubieras ganado, compite como si nunca hubieras perdido.",
    "Anónimo",
  ),
  MotivationalQuote(
    "No se trata de cuántas veces te caes, sino de cuántas veces te levantas.",
    "Vince Lombardi",
  ),
  MotivationalQuote(
    "La constancia es lo que transforma lo ordinario en extraordinario.",
    "Anónimo",
  ),
  MotivationalQuote(
    "Levántate temprano, entrena duro, sé amable.",
    "Anónimo",
  ),
  MotivationalQuote(
    "Convierte tu no puedo en un observa cómo lo hago.",
    "Anónimo",
  ),
  MotivationalQuote(
    "Cada repetición te acerca a la persona que quieres ser.",
    "Anónimo",
  ),
  MotivationalQuote(
    "El progreso, no la perfección.",
    "Anónimo",
  ),
  MotivationalQuote(
    "Cuando sientas ganas de rendirte, recuerda por qué empezaste.",
    "Anónimo",
  ),
];

/// Frase del día para [date]: determinística, así el Dashboard y
/// cualquier otra pantalla muestran siempre la misma para esa fecha.
MotivationalQuote quoteForDate(DateTime date) {
  final seed = date.year * 10000 + date.month * 100 + date.day;
  final index = seed % motivationalQuotes.length;
  return motivationalQuotes[index];
}
