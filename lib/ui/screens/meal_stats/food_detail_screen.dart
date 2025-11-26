import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import '../../../common/colo_extension.dart';
import '../../widgets/round_button.dart';
import '../../widgets/round_textfield.dart';
import '../../widgets/food_step_detail_row.dart';
import 'meal_schedule_screen.dart';

class FoodDetailScreen extends StatefulWidget {
  final Map foodData;
  final Map mealData;

  const FoodDetailScreen({
    super.key,
    required this.foodData,
    required this.mealData,
  });

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  final List<Map<String, String>> nutritionalInfo = [
    {"icon": "assets/img/burn.png", "label": "180kCal"},
    {"icon": "assets/img/egg.png", "label": "30g fats"},
    {"icon": "assets/img/proteins.png", "label": "20g proteins"},
    {"icon": "assets/img/carbo.png", "label": "50g carbo"},
  ];

  final List<Map<String, String>> requiredIngredients = [
    {
      "icon": "assets/img/flour.png",
      "name": "Wheat Flour",
      "quantity": "100grm",
    },
    {"icon": "assets/img/sugar.png", "name": "Sugar", "quantity": "3 tbsp"},
    {
      "icon": "assets/img/baking_soda.png",
      "name": "Baking Soda",
      "quantity": "2tsp",
    },
    {"icon": "assets/img/eggs.png", "name": "Eggs", "quantity": "2 items"},
  ];

  final List<Map<String, String>> preparationSteps = [
    {"step": "1", "instruction": "Prepare all of the ingredients that needed"},
    {"step": "2", "instruction": "Mix flour, sugar, salt, and baking powder"},
    {
      "step": "3",
      "instruction":
          "In a seperate place, mix the eggs and liquid milk until blended",
    },
    {
      "step": "4",
      "instruction":
          "Put the egg and milk mixture into the dry ingredients, Stir untul smooth and smooth",
    },
    {"step": "5", "instruction": "Prepare all of the ingredients that needed"},
  ];

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: TColor.primaryG),
      ),
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [_buildNavigationBar(), _buildFoodImageHeader(screenSize)];
        },
        body: Container(
          decoration: BoxDecoration(
            color: TColor.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                _buildScrollableContent(screenSize),
                _buildBottomActionButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SliverAppBar _buildNavigationBar() {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      centerTitle: true,
      elevation: 0,
      leading: _buildNavigationButton(
        "assets/img/black_btn.png",
        () => Navigator.pop(context),
      ),
      actions: [_buildNavigationButton("assets/img/more_btn.png", () {})],
    );
  }

  Widget _buildNavigationButton(String iconPath, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(8),
        height: 40,
        width: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: TColor.lightGray,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Image.asset(
          iconPath,
          width: 15,
          height: 15,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  SliverAppBar _buildFoodImageHeader(Size screenSize) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      centerTitle: true,
      elevation: 0,
      leadingWidth: 0,
      leading: Container(),
      expandedHeight: screenSize.width * 0.5,
      flexibleSpace: ClipRect(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Transform.scale(
              scale: 1.25,
              child: Container(
                width: screenSize.width * 0.55,
                height: screenSize.width * 0.55,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(screenSize.width * 0.275),
                ),
              ),
            ),
            Transform.scale(
              scale: 1.25,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Image.asset(
                  widget.foodData["b_image"].toString(),
                  width: screenSize.width * 0.50,
                  height: screenSize.width * 0.50,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScrollableContent(Size screenSize) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          _buildDragHandle(),
          SizedBox(height: screenSize.width * 0.05),
          _buildFoodHeader(),
          SizedBox(height: screenSize.width * 0.05),
          _buildNutritionSection(),
          SizedBox(height: screenSize.width * 0.05),
          _buildDescriptionSection(),
          const SizedBox(height: 15),
          _buildIngredientsSection(screenSize),
          _buildPreparationStepsSection(),
          SizedBox(height: screenSize.width * 0.25),
        ],
      ),
    );
  }

  Widget _buildDragHandle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 50,
          height: 4,
          decoration: BoxDecoration(
            color: TColor.gray.withOpacity(0.3),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ],
    );
  }

  Widget _buildFoodHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.foodData["name"].toString(),
                  style: TextStyle(
                    color: TColor.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  "by James Ruth",
                  style: TextStyle(color: TColor.gray, fontSize: 12),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Image.asset(
              "assets/img/fav.png",
              width: 15,
              height: 15,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            "Nutrition",
            style: TextStyle(
              color: TColor.black,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(
          height: 50,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: nutritionalInfo.length,
            itemBuilder: (context, index) {
              final nutritionItem = nutritionalInfo[index];
              return _buildNutritionChip(nutritionItem);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNutritionChip(Map<String, String> nutritionItem) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            TColor.primaryColor2.withOpacity(0.4),
            TColor.primaryColor1.withOpacity(0.4),
          ],
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            nutritionItem["icon"]!,
            width: 15,
            height: 15,
            fit: BoxFit.contain,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              nutritionItem["label"]!,
              style: TextStyle(color: TColor.black, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            "Descriptions",
            style: TextStyle(
              color: TColor.black,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: ReadMoreText(
            'Pancakes are some people\'s favorite breakfast, who doesn\'t like pancakes? Especially with the real honey splash on top of the pancakes, of course everyone loves that! besides being Pancakes are some people\'s favorite breakfast, who doesn\'t like pancakes? Especially with the real honey splash on top of the pancakes, of course everyone loves that! besides being',
            trimLines: 4,
            colorClickableText: TColor.black,
            trimMode: TrimMode.Line,
            trimCollapsedText: ' Read More ...',
            trimExpandedText: ' Read Less',
            style: TextStyle(color: TColor.gray, fontSize: 12),
            moreStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIngredientsSection(Size screenSize) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Ingredients That You\nWill Need",
                style: TextStyle(
                  color: TColor.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  "${requiredIngredients.length} Items",
                  style: TextStyle(color: TColor.gray, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: (screenSize.width * 0.25) + 40,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: requiredIngredients.length,
            itemBuilder: (context, index) {
              final ingredient = requiredIngredients[index];
              return _buildIngredientCard(ingredient, screenSize);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildIngredientCard(Map<String, String> ingredient, Size screenSize) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: screenSize.width * 0.23,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: screenSize.width * 0.23,
            height: screenSize.width * 0.23,
            decoration: BoxDecoration(
              color: TColor.lightGray,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Image.asset(
              ingredient["icon"]!,
              width: 45,
              height: 45,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            ingredient["name"]!,
            style: TextStyle(color: TColor.black, fontSize: 12),
          ),
          Text(
            ingredient["quantity"]!,
            style: TextStyle(color: TColor.gray, fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _buildPreparationStepsSection() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Step by Step",
                style: TextStyle(
                  color: TColor.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  "${preparationSteps.length} Steps",
                  style: TextStyle(color: TColor.gray, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 15),
          shrinkWrap: true,
          itemCount: preparationSteps.length,
          itemBuilder: (context, index) {
            final stepData = preparationSteps[index];
            return FoodStepDetailRow(
              sObj: {
                "no": stepData["step"]!,
                "detail": stepData["instruction"]!,
              },
              isLast: preparationSteps.last == stepData,
            );
          },
        ),
      ],
    );
  }

  Widget _buildBottomActionButton() {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: RoundButton(
              title: "Add to ${widget.mealData["name"]} Meal",
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
