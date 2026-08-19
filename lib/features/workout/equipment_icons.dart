/// Emoji representativo de cada tipo de equipo, para que se distinga de
/// un vistazo si un ejercicio es con barra, mancuerna, kettlebell, etc.
const Map<String, String> _equipmentEmoji = {
  "None": "🤸",
  "Barbell": "🏋️",
  "Dumbbell": "💪",
  "Kettlebell": "🔔",
  "Pull-up Bar": "🧗",
  "Rings": "⭕",
  "Rope": "🪢",
  "Box": "📦",
  "Wall Ball": "🥎",
  "Concept2 Rower": "🚣",
  "SkiErg": "🎿",
  "Assault Bike": "🚴",
  "Sandbag": "🎒",
  "Sled": "🛷",
  "Medicine Ball": "⚽",
};

/// Devuelve el emoji del equipo, o un ícono genérico si no lo reconoce.
String equipmentEmoji(String? equipment) {
  if (equipment == null) return "🏋️";
  return _equipmentEmoji[equipment] ?? "🏋️";
}
