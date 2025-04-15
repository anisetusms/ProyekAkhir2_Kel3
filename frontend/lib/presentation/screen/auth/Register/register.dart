part of 'register_import.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  late RegisterController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(RegisterController());
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegisterController>(
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
                              child: SvgPicture.asset(
                                MyImages.backArrow,
                                colorFilter: ColorFilter.mode(
                                  controller.themeController.isDarkMode.value
                                      ? MyColors.white
                                      : MyColors.primaryColor,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height * 0.25,
                        child: const Text(
                          MyString.registerTitle,
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 45),
                        ),
                      ),

                      // NAME
                      CustomTextFormField(
                        controller: controller.nameController,
                        obscureText: false,
                        maxLength: 30,
                        validator: Validations().nameValidation,
                        textInputAction: TextInputAction.next,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(15),
                          child: SvgPicture.asset(MyImages.user),
                        ),
                        hintText: "Name",
                        fillColor: controller.themeController.isDarkMode.value
                            ? MyColors.darkTextFieldColor
                            : MyColors.disabledTextFieldColor,
                      ),
                      const SizedBox(height: 20),

                      // USERNAME
                      CustomTextFormField(
                        controller: controller.usernameController,
                        obscureText: false,
                        maxLength: 30,
                        validator: Validations().nameValidation,
                        textInputAction: TextInputAction.next,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(15),
                          child: SvgPicture.asset(MyImages.user),
                        ),
                        hintText: "Username",
                        fillColor: controller.themeController.isDarkMode.value
                            ? MyColors.darkTextFieldColor
                            : MyColors.disabledTextFieldColor,
                      ),
                      const SizedBox(height: 20),

                      // EMAIL
                      CustomTextFormField(
                        controller: controller.emailController,
                        obscureText: false,
                        keyboardType: TextInputType.emailAddress,
                        validator: Validations().emailValidation,
                        textInputAction: TextInputAction.next,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(15),
                          child: SvgPicture.asset(MyImages.emailBox),
                        ),
                        hintText: MyString.emailHintText,
                        fillColor: controller.themeController.isDarkMode.value
                            ? MyColors.darkTextFieldColor
                            : MyColors.disabledTextFieldColor,
                      ),
                      const SizedBox(height: 20),

                      // PHONE
                      CustomTextFormField(
                        controller: controller.phoneController,
                        obscureText: false,
                        keyboardType: TextInputType.phone,
                        validator: Validations().mobileNumberValidation,
                        textInputAction: TextInputAction.next,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Icon(Icons.phone, color: Colors.grey),
                        ),
                        hintText: "Phone Number",
                        fillColor: controller.themeController.isDarkMode.value
                            ? MyColors.darkTextFieldColor
                            : MyColors.disabledTextFieldColor,
                      ),
                      const SizedBox(height: 20),

                      // ADDRESS
                      CustomTextFormField(
                        controller: controller.addressController,
                        obscureText: false,
                        validator: Validations().addressValidation,
                        textInputAction: TextInputAction.next,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Icon(Icons.location_on, color: Colors.grey),
                        ),
                        hintText: "Address",
                        fillColor: controller.themeController.isDarkMode.value
                            ? MyColors.darkTextFieldColor
                            : MyColors.disabledTextFieldColor,
                      ),
                      const SizedBox(height: 20),

                      // GENDER DROPDOWN
                      Obx(() => DropdownButtonFormField<String>(
                        value: controller.selectedGender.value.isNotEmpty ? controller.selectedGender.value : null,
                        items: ['Pria', 'Wanita']
                            .map((gender) => DropdownMenuItem(value: gender, child: Text(gender)))
                            .toList(),
                        onChanged: (value) => controller.selectedGender.value = value ?? '',
                        decoration: InputDecoration(
                          hintText: "Select Gender",
                          filled: true,
                          fillColor: controller.themeController.isDarkMode.value
                              ? MyColors.darkTextFieldColor
                              : MyColors.disabledTextFieldColor,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                        ),
                      )),
                      const SizedBox(height: 20),

                      // PASSWORD
                      Obx(() => CustomTextFormField(
                            controller: controller.passwordController,
                            obscureText: controller.showPassword.value,
                            validator: Validations().passwordValidation,
                            textInputAction: TextInputAction.done,
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(15),
                              child: SvgPicture.asset(MyImages.passwordLock),
                            ),
                            hintText: MyString.passwordHintText,
                            fillColor: controller.themeController.isDarkMode.value
                                ? MyColors.darkTextFieldColor
                                : MyColors.disabledTextFieldColor,
                            suffixIcon: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: InkWell(
                                onTap: () {
                                  controller.showPassword.value = !controller.showPassword.value;
                                },
                                child: SvgPicture.asset(
                                  controller.showPassword.value ? MyImages.hidePassword : MyImages.showPassword,
                                  colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                                ),
                              ),
                            ),
                          )),
                      const SizedBox(height: 20),

                      // IMAGE PICKER
                      Obx(() => GestureDetector(
                            onTap: () => controller.pickImage(),
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                                color: controller.themeController.isDarkMode.value
                                    ? MyColors.darkTextFieldColor
                                    : MyColors.disabledTextFieldColor,
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.image, color: Colors.grey),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      controller.selectedImage.value != null
                                          ? controller.selectedImage.value!.path.split('/').last
                                          : "Pick a profile image",
                                      style: const TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),
                      const SizedBox(height: 40),

                      // BUTTON
                      SizedBox(
                        height: 55,
                        width: MediaQuery.of(context).size.width,
                        child: Button(
                          onpressed: () => controller.register(),
                          text: MyString.signUp,
                          shadowColor: controller.themeController.isDarkMode.value
                              ? Colors.transparent
                              : MyColors.buttonShadowColor,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // TERMS
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(children: [
                          TextSpan(
                            text: 'By signing up you agree to BookNest’s ',
                            style: TextStyle(
                              color: controller.themeController.isDarkMode.value
                                  ? MyColors.white
                                  : MyColors.textBlackColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                          const TextSpan(
                            text: 'Terms of Services and Privacy Policy.',
                            style: TextStyle(
                              color: MyColors.successColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              height: 1.5,
                            ),
                          )
                        ]),
                      ),
                      const SizedBox(height: 30),

                      // LOGIN
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            MyString.alreadyAccount,
                            style: TextStyle(
                              color: controller.themeController.isDarkMode.value
                                  ? MyColors.white
                                  : Colors.grey.shade400,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                          InkWell(
                            onTap: () => Get.off(const LoginScreen()),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                MyString.signIn,
                                style: TextStyle(
                                  color: controller.themeController.isDarkMode.value
                                      ? MyColors.textYellowColor
                                      : MyColors.primaryColor,
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
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
