import 'package:flutter/material.dart';
import 'package:koofit/main_screen/search_tab_menu/add_food_screen.dart';
import 'package:koofit/model/HiveUserHelper.dart';
import 'package:koofit/model/config/palette.dart';
import 'package:koofit/model/data/food.dart';
import 'package:koofit/model/data/user.dart';
class FavoriteListItem extends StatefulWidget {
  final Food food;
  final int index;
  final User userData;
  final String selectedDate;
  const FavoriteListItem({super.key, required this.food,
    required this.index,
    required this.userData,
    required this.selectedDate});

  @override
  State<FavoriteListItem> createState() => _FavoriteListItemState();
}

class _FavoriteListItemState extends State<FavoriteListItem> {
  late List<Food> _favorites;
  bool isFavorite = true;

  onHeartTap() async {
    setState(() {
      isFavorite = !isFavorite;
    });

    if (isFavorite == false) {
      widget.userData.favorieFoodList.remove(widget.food);
      print(widget.userData.favorieFoodList);
      await HiveUserHelper().updateUser(0, widget.userData);
    } else {
      if (!_favorites.contains(widget.food)) {
        widget.userData.favorieFoodList.add(widget.food);
      } else {
        // Display a snackbar message if the food item already exists in favorites
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('이미 즐겨찾기에 추가되어 있는 음식입니다.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isFavorite,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white60,
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(
                color: Colors.black26,
                width: 3,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.food.foodName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Text(
                  '${(widget.food.calories)}cal',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
                Row(
                  children: [
                    const Text('탄  ', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('${widget.food.carbo}g'),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text('단  ', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('${widget.food.protein}g'),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text('지  ', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('${widget.food.fat}g'),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 13,
            right: 30,
            child: IconButton(
              onPressed: onHeartTap,
              icon: Icon(
                isFavorite
                    ? Icons.favorite
                    : Icons.favorite_outline_rounded,
                color: const Color(0xffFFB3BA),
                size: 30,
              ),
            ),
          ),
          Positioned(
            top: 55,
            right: 30,
            child: AddFoodScreen(food: widget.food, selectedDate: widget.selectedDate ),
          ),
        ],
      ),
    );
  }
}


class TabFavoriteScreen extends StatefulWidget {
  final User UserData;
  final String selectedDate;

  const TabFavoriteScreen({
    super.key,
    required this.UserData,
    required this.selectedDate
  });

  @override
  State<TabFavoriteScreen> createState() => _TabFavoriteScreenState();
}

class _TabFavoriteScreenState extends State<TabFavoriteScreen> {
  late List<Food> _favorites;

  @override
  void initState() {
    super.initState();
    _favorites = widget.UserData.favorieFoodList;
  }

  @override
  Widget build(BuildContext context) {
    if (_favorites.isEmpty) {
      return Padding(
        padding: EdgeInsets.only(top: 25),
        child: Text(
          "즐겨찾는 음식을 \n 등록해보세요!",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.grey,
          ),
        ),
      );
    }

    return Column(
      children: [
        SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          itemCount: _favorites.length,
          itemBuilder: (context, index) {
            return FavoriteListItem(
              food: _favorites[index],
              index: index,
              userData: widget.UserData,
              selectedDate: widget.selectedDate,
            );
          },
        ),
      ],
    );
  }
}
