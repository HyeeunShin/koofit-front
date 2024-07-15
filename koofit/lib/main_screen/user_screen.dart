import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:koofit/login/kakao_login.dart';
import 'package:koofit/login/loginview.dart';
import 'package:koofit/login/splash_screen.dart';
import 'package:koofit/model/config/palette.dart';
import 'package:get/get.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  String? _nickname;
  String? _profileImageUrl = '';
  String? _emailAddress;

  final viewmodel = Loginview(KakaoLogin());

  @override
  void initState() {
    super.initState();
    _getKakaoUserProfile(); // 카카오 사용자 정보 가져오기
  }

  // 카카오 사용자 정보 가져오기
  void _getKakaoUserProfile() async {
    try {
      User user = await UserApi.instance.me(); // 현재 사용자 정보 가져오기
      setState(() {
        _nickname = user.kakaoAccount!.profile!.nickname ?? 'No nickname';
        _profileImageUrl = user.kakaoAccount!.profile!.thumbnailImageUrl;
        _emailAddress = user.kakaoAccount!.email!;
      });
    } catch (e) {
      print('카카오 사용자 정보 가져오기 에러: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("내 정보"),
        titleTextStyle: TextStyle(
          color: Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context); // 뒤로가기
          },
          color: Colors.black87,
          icon: Icon(Icons.arrow_back, size: 25),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            kakaoInfoSection(
              profileImageUrl: _profileImageUrl,
            //   nickname: _nickname,
            //   emailAddress: _emailAddress,
            ),
            SizedBox(height: 20),
            InfoSection(),
            SizedBox(height: 20),
            ElevatedButton(
  onPressed: () async {
    //로그아웃
    await viewmodel.logout();
    //로그아웃 확인 후 splash로 이동 => 여기서 자동로그인 확인해야함.
    Get.offAll(() => SplashScreen());
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.red, // 버튼 배경색 변경
    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15), // 버튼 내 padding 조절
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10), // 버튼 모서리를 둥글게
    ),
  ),
  child: const Text(
    '로그아웃',
    style: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.white, // 버튼 텍스트 색상 변경
    ),
  ),
),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class kakaoInfoSection extends StatelessWidget {
  final String? profileImageUrl;
  

  const kakaoInfoSection({
    Key? key,
    required this.profileImageUrl,
    
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 70,
          backgroundImage: profileImageUrl != null
              ? NetworkImage(profileImageUrl!) // 카카오 프로필 이미지
              : null, // 기본 이미지 없음
        ),
        SizedBox(height: 20),
        // Text(
        //   nickname ?? 'No nickname', // 카카오 닉네임
        //   style: TextStyle(
        //     fontSize: 24,
        //     fontWeight: FontWeight.bold,
        //   ),
        // ),
        // Text(
        //   emailAddress ?? '유저 이메일',
        //   style: TextStyle(
        //     fontSize: 18,
        //     color: Colors.black,
        //   ),
        // ),
      ],
    );
  }
}

class InfoSection extends StatefulWidget {
  @override
  _InfoSectionState createState() => _InfoSectionState();
}

class _InfoSectionState extends State<InfoSection> {
  Map<String, bool> isSelected = {
    '이름': false,
    '학번': false,
    '나이': false,
    '이메일': false,
    '전화번호': false,
    '키': false,
    '몸무게': false,
    '목표 몸무게': false,
  };

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Column(
        children: isSelected.entries
            .map((entry) => buildListTile(context, entry.key, 'Sample', () {
                  setState(() {
                    isSelected.updateAll((key, value) => isSelected[key] = false);
                    isSelected[entry.key] = true;
                  });

                  // 클릭된 정보에 맞게 수정 코드 작성
                  switch (entry.key) {
                    case '이름':
                      // Get.to(() => EditName());
                      break;
                    case '학번':
                      // Get.to(() => EditStudentId());
                      break;
                    case '나이':
                      // Get.to(() => EditAge());
                  }
                }))
            .toList(),
      ),
    );
  }

  Widget buildListTile(BuildContext context, String title, String subtitle, VoidCallback onTap) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      color: isSelected[title] ?? false ? Colors.grey.shade300 : Colors.transparent,
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        onTap: onTap,
      ),
    );
  }
}



