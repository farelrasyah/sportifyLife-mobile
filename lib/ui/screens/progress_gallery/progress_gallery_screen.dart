import 'package:flutter/material.dart';
import '../../../common/colo_extension.dart';
import '../../widgets/round_button.dart';
import 'result_comparison_screen.dart';

class ProgressGalleryScreen extends StatefulWidget {
  const ProgressGalleryScreen({super.key});

  @override
  State<ProgressGalleryScreen> createState() => _ProgressGalleryScreenState();
}

class _ProgressGalleryScreenState extends State<ProgressGalleryScreen> {
  final List<Map<String, dynamic>> _progressPhotos = [
    {
      "date": "2 June",
      "images": [
        "assets/img/pp_1.png",
        "assets/img/pp_2.png",
        "assets/img/pp_3.png",
        "assets/img/pp_4.png",
      ],
    },
    {
      "date": "5 May",
      "images": [
        "assets/img/pp_5.png",
        "assets/img/pp_6.png",
        "assets/img/pp_7.png",
        "assets/img/pp_8.png",
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildReminderCard(),
            _buildTrackingPromotionCard(screenSize),
            SizedBox(height: screenSize.width * 0.05),
            _buildComparisonSection(),
            _buildGalleryHeader(),
            _buildPhotoGallery(),
            SizedBox(height: screenSize.width * 0.05),
          ],
        ),
      ),
      floatingActionButton: _buildCameraFAB(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: TColor.white,
      centerTitle: true,
      elevation: 0,
      leadingWidth: 0,
      leading: const SizedBox(),
      title: Text(
        "Progress Photo",
        style: TextStyle(
          color: TColor.black,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: [
        InkWell(
          onTap: () {},
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
              "assets/img/more_btn.png",
              width: 15,
              height: 15,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReminderCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xffFFE5E5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: TColor.white,
                borderRadius: BorderRadius.circular(30),
              ),
              width: 50,
              height: 50,
              alignment: Alignment.center,
              child: Image.asset(
                "assets/img/date_notifi.png",
                width: 30,
                height: 30,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Reminder!",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "Next Photos Fall On July 08",
                    style: TextStyle(
                      color: TColor.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 60,
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () {},
                icon: Icon(Icons.close, color: TColor.gray, size: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrackingPromotionCard(Size screenSize) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.all(20),
        height: screenSize.width * 0.4,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              TColor.primaryColor2.withOpacity(0.4),
              TColor.primaryColor1.withOpacity(0.4),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                Text(
                  "Track Your Progress Each\nMonth With Photo",
                  style: TextStyle(color: TColor.black, fontSize: 12),
                ),
                const Spacer(),
                SizedBox(
                  width: 110,
                  height: 35,
                  child: RoundButton(
                    title: "Learn More",
                    fontSize: 12,
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            Image.asset(
              "assets/img/progress_each_photo.png",
              width: screenSize.width * 0.35,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      decoration: BoxDecoration(
        color: TColor.primaryColor2.withOpacity(0.3),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Compare my Photo",
            style: TextStyle(
              color: TColor.black,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            width: 100,
            height: 25,
            child: RoundButton(
              title: "Compare",
              type: RoundButtonType.bgGradient,
              fontSize: 12,
              fontWeight: FontWeight.w400,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ResultComparisonScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGalleryHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Gallery",
            style: TextStyle(
              color: TColor.black,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              "See more",
              style: TextStyle(color: TColor.gray, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoGallery() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _progressPhotos.length,
      itemBuilder: (context, index) {
        var photoData = _progressPhotos[index];
        var imageList = photoData["images"] as List<String>;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                photoData["date"].toString(),
                style: TextStyle(color: TColor.gray, fontSize: 12),
              ),
            ),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.zero,
                itemCount: imageList.length,
                itemBuilder: (context, imageIndex) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 100,
                    decoration: BoxDecoration(
                      color: TColor.lightGray,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        imageList[imageIndex],
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCameraFAB() {
    return InkWell(
      onTap: () {
        // TODO: Implement camera functionality
      },
      child: Container(
        width: 55,
        height: 55,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: TColor.secondaryG),
          borderRadius: BorderRadius.circular(27.5),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Icon(Icons.photo_camera, size: 20, color: TColor.white),
      ),
    );
  }
}
