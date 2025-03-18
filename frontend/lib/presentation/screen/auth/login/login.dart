part of 'login_import.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  late LoginController controller;
  bool showPassword = false;

  @override
  void initState() {
    super.initState();
    controller = Get.put(LoginController());
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      init: controller,
      builder: (controller) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              return Get.back();
                            },
                            child: Container(
                              padding: const EdgeInsets.only(right: 3, top: 3, bottom: 3),
                              child: SvgPicture.asset(MyImages.backArrow),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height * 0.25,
                        child: const Text(MyString.loginTitle, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 45)),
                      ),
                      // Focus(
                      //   child: Builder(
                      //     builder: (BuildContext context) {
                      //       final FocusNode emailFocusNode = Focus.of(context);
                      //       final bool hasFocus = emailFocusNode.hasFocus;
                      //       return
                      //     },
                      //   ),
                      // ),
                      CustomTextFormField(
                        controller: controller.emailController,
                        obscureText: false,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          return Validations().emailValidation(value);
                        },
                        hintText: MyString.emailHintText,
                        fillColor: controller.themeController.isDarkMode.value ? MyColors.darkTextFieldColor : MyColors.disabledTextFieldColor,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: SvgPicture.asset(MyImages.emailBox),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Focus(
                      //   child: Builder(
                      //     builder: (BuildContext context) {
                      //       final FocusNode passwordFocusNode = Focus.of(context);
                      //       final bool hasFocus = passwordFocusNode.hasFocus;
                      //       return
                      //     },
                      //   ),
                      // ),
                      CustomTextFormField(
                        controller: controller.passwordController,
                        obscureText: controller.password.value,
                        textInputAction: TextInputAction.done,
                        validator: (value) {
                          return Validations().passwordValidation(value);
                        },
                        hintText: MyString.passwordHintText,
                        fillColor: controller.themeController.isDarkMode.value ? MyColors.darkTextFieldColor :MyColors.disabledTextFieldColor,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: SvgPicture.asset(MyImages.passwordLock),
                        ),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                controller.password.value = !controller.password.value;
                              });
                            },
                            child: SvgPicture.asset(controller.password.value ? MyImages.hidePassword : MyImages.showPassword, colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        height: 55,
                        width: MediaQuery.of(context).size.width,
                        child: Button(
                          onpressed: () {
                            return controller.submit();
                          },
                          text: MyString.signIn,
                          shadowColor: controller.themeController.isDarkMode.value ? Colors.transparent : MyColors.buttonShadowColor,
                        ),
                      ),
                      const SizedBox(height: 30),
                      InkWell(
                          onTap: () {
                            Get.toNamed("/choicePassword");
                          },
                          child: Text(MyString.forgotPassword, style: TextStyle(fontSize: 16, color: controller.themeController.isDarkMode.value ? MyColors.textYellowColor : MyColors.successColor, fontWeight: FontWeight.w600),)
                      ),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const CustomDivider(size: 0.23),
                          Text(MyString.orContinue, style: TextStyle(color: controller.themeController.isDarkMode.value ? MyColors.white : Colors.black54, fontSize: 18),),
                          const CustomDivider(size: 0.23),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          customLoginOptionButton(MyImages.facebook, controller.themeController.isDarkMode.value),
                          const SizedBox(width: 20),
                          customLoginOptionButton(MyImages.google, controller.themeController.isDarkMode.value),
                          const SizedBox(width: 20),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: controller.themeController.isDarkMode.value ? MyColors.white : MyColors.dividerLightTheme),
                            ),
                            child: SvgPicture.asset(MyImages.apple, width: 30,
                              colorFilter: ColorFilter.mode(controller.themeController.isDarkMode.value ? MyColors.white : MyColors.black, BlendMode.srcIn),),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(MyString.donAccount, style: TextStyle(color: Colors.grey.shade400,fontWeight: FontWeight.w400, fontSize: 14)),
                          InkWell(
                            onTap: () {
                              Get.toNamed("/registerScreen");
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              child: Text(MyString.signUp, style: TextStyle(
                                  color: controller.themeController.isDarkMode.value ? MyColors.textYellowColor : MyColors.primaryColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ),
            ),
          ),
        );
      },
    );
  }
}

customLoginOptionButton(String image, bool isDarkMode) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color:isDarkMode ? MyColors.white : MyColors.dividerLightTheme),
    ),
    child: SvgPicture.asset(image, width: 30,),
  );
}
