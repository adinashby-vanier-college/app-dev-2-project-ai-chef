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
  String availableCookingTime = "";
  List<String> chosenCookingTools = [];

  String getRecipe(){
    return "using the following ingredients: " + chosenIngredients.toString() +
    " the following dietary restrictions, avoid recipes that are " + chosenDietRestrictions.toString() +
    ", I only have the following amount of time " + availableCookingTime +
    " I only have the following available cooking tools " + chosenCookingTools.toString() +
    "You can add common ingredients that are found in the kitchen but do not add anything that I did not is besides. "
        " Also do not refer to the recipe at all when you answer, I want the recipe and nothing more."
    + chosenIngredients.toString();
  }
}