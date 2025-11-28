import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../common/colo_extension.dart';
import '../../widgets/meal_category_cell.dart';
import '../../widgets/meal_recommed_cell.dart';
import '../../widgets/popular_meal_row.dart';
import 'food_detail_screen.dart';

class MealDetailScreen extends StatefulWidget {
  final Map mealCategory;

  const MealDetailScreen({super.key, required this.mealCategory});

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  final TextEditingController searchController = TextEditingController();

  final List<Map<String, String>> foodCategories = [
    {"name": tr("category_salad"), "image": "assets/images/c_1.png"},
    {"name": tr("category_cake"), "image": "assets/images/c_2.png"},
    {"name": tr("category_pie"), "image": "assets/images/c_3.png"},
    {"name": tr("category_smoothies"), "image": "assets/images/c_4.png"},
    {"name": tr("category_salad"), "image": "assets/images/c_1.png"},
    {"name": tr("category_cake"), "image": "assets/images/c_2.png"},
    {"name": tr("category_pie"), "image": "assets/images/c_3.png"},
    {"name": tr("category_smoothies"), "image": "assets/images/c_4.png"},
  ];

  final List<Map<String, String>> trendingMeals = [
    {
      "name": tr("blueberry_pancake"),
      "image": "assets/images/f_1.png",
      "b_image": "assets/images/pancake_1.png",
      "size": tr("size_medium"),
      "time": tr("time_30mins"),
      "kcal": tr("kcal_230"),
    },
    {
      "name": tr("salmon_nigiri"),
      "image": "assets/images/f_2.png",
      "b_image": "assets/images/nigiri.png",
      "size": tr("size_medium"),
      "time": tr("time_20mins"),
      "kcal": tr("kcal_120"),
    },
  ];

  final List<Map<String, String>> suggestedMeals = [
    {
      "name": tr("honey_pancake"),
      "image": "assets/images/rd_1.png",
      "size": tr("size_easy"),
      "time": tr("time_30mins"),
      "kcal": tr("kcal_180"),
    },
    {
      "name": tr("canai_bread"),
      "image": "assets/images/m_4.png",
      "size": tr("size_easy"),
      "time": tr("time_20mins"),
      "kcal": tr("kcal_230"),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchSection(),
            SizedBox(height: screenSize.width * 0.05),
            _buildCategoriesSection(),
            SizedBox(height: screenSize.width * 0.05),
            _buildRecommendationsSection(screenSize),
            SizedBox(height: screenSize.width * 0.05),
            _buildPopularSection(),
            SizedBox(height: screenSize.width * 0.05),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: TColor.white,
      centerTitle: true,
      elevation: 0,
      leading: _buildAppBarButton(
        "assets/images/black_btn.png",
        () => Navigator.pop(context),
      ),
      title: Text(
        widget.mealCategory["name"].toString(),
        style: TextStyle(
          color: TColor.black,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: [_buildAppBarButton("assets/images/more_btn.png", () {})],
    );
  }

  Widget _buildAppBarButton(String iconPath, VoidCallback onTap) {
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

  Widget _buildSearchSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: TColor.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                prefixIcon: Image.asset(
                  "assets/images/search.png",
                  width: 25,
                  height: 25,
                ),
                hintText: tr("search_food"),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            width: 1,
            height: 25,
            color: TColor.gray.withOpacity(0.3),
          ),
          InkWell(
            onTap: () {},
            child: Image.asset(
              "assets/images/Filter.png",
              width: 25,
              height: 25,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            tr("category_label"),
            style: TextStyle(
              color: TColor.black,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(
          height: 120,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            scrollDirection: Axis.horizontal,
            itemCount: foodCategories.length,
            itemBuilder: (context, index) {
              final categoryData = foodCategories[index];
              return MealCategoryCell(cObj: categoryData, index: index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendationsSection(Size screenSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            tr("recommendation_for_diet"),
            style: TextStyle(
              color: TColor.black,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(
          height: screenSize.width * 0.6,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            scrollDirection: Axis.horizontal,
            itemCount: suggestedMeals.length,
            itemBuilder: (context, index) {
              final mealData = suggestedMeals[index];
              return MealRecommendCell(fObj: mealData, index: index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPopularSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            tr("popular_label"),
            style: TextStyle(
              color: TColor.black,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: trendingMeals.length,
          itemBuilder: (context, index) {
            final mealData = trendingMeals[index];
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FoodDetailScreen(
                      foodData: mealData,
                      mealData: widget.mealCategory,
                    ),
                  ),
                );
              },
              child: PopularMealRow(mObj: mealData),
            );
          },
        ),
      ],
    );
  }
}
