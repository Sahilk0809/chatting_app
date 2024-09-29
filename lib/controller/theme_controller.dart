import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController{
  // to check whether the it is dark mode or light mode
  RxBool isDark = false.obs;

  SharedPreferences? sharedPreferences; // to store theme after restarting the app

  ThemeController(bool value){
    isDark.value = value;
  }

  // toggle the light dark mode
  void toggleLightDarkMode(){
    isDark.value = !isDark.value;
    toggleLightDarkSharedPreferences(isDark.value);
  }

  Future<void> toggleLightDarkSharedPreferences(bool value) async {
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences!.setBool("theme", value);
  }
}

var themeController = Get.put(ThemeController(themeIsDark));

bool themeIsDark = false;