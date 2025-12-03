class IngredientsList {
  static final IngredientsList _instance = IngredientsList._internal();

  factory IngredientsList() {
    return _instance;
  }

  IngredientsList._internal();

  List<String> hardCodedIngredientList = [
    "Acorn",
    "Agave",
    "Almonds",
    "Anchovies",
    "Anise",
    "Apple Cider Vinegar",
    "Apples",
    "Apricots",
    "Arugula",
    "Asparagus",
    "Avocado",

    "Bacon",
    "Baking Powder",
    "Baking Soda",
    "Bananas",
    "Barley",
    "Basil",
    "Bay Leaf",
    "Beans (Black)",
    "Beans (Kidney)",
    "Beef Broth",
    "Beets",
    "Bell Pepper (Red)",
    "Bell Pepper (Yellow)",
    "Black Olives",
    "Black Pepper",
    "Blueberries",
    "Bok Choy",
    "Brandy",
    "Bread Crumbs",
    "Broccoli",

    "Cabbage",
    "Cane Sugar",
    "Cantaloupe",
    "Caraway Seeds",
    "Carrots",
  ];
  List<String> chosenIngredients = [];
  List<String> chosenDietRestrictions = [];
}