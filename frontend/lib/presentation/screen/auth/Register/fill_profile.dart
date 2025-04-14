part of 'register_import.dart';

class FillProfileScreen extends StatefulWidget {
  const FillProfileScreen({super.key});

  @override
  State<FillProfileScreen> createState() => _FillProfileScreenState();
}

class _FillProfileScreenState extends State<FillProfileScreen> {
  late RegisterController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<RegisterController>();
  }

  File? localSelectedImage;

  Future<void> selectImageFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        localSelectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: controller.selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
    );
    if (pickedDate != null) {
      setState(() {
        controller.selectedDate = pickedDate;
        controller.dateController.text = "${pickedDate.toLocal()}".split(" ")[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomFullAppBar(title: MyString.fillProfile),
      bottomNavigationBar: Container(
        height: 90,
        padding: const EdgeInsets.all(15),
        child: Obx(() => Button(
              onPressed: () {
                    if (!controller.isLoading.value) {
    controller.fillProfileSubmit(status: 'fill');
  }
},
              text: controller.isLoading.value ? 'Loading...' : MyString.continueButton,
              shadowColor: controller.themeController.isDarkMode.value ? Colors.transparent : MyColors.buttonShadowColor,
            )),
      ),
      body: GetBuilder<RegisterController>(
        builder: (controller) {
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(15, 50, 15, 20),
            child: Form(
              key: controller.fillFormKey,
              child: Column(
                children: [
                  InkWell(
                    onTap: selectImageFromGallery,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 70,
                          backgroundImage: localSelectedImage != null ? FileImage(localSelectedImage!) : null,
                          child: localSelectedImage == null ? Image.asset(MyImages.profilePerson) : null,
                        ),
                        const Positioned(
                          bottom: 2,
                          right: 2,
                          child: Icon(Icons.edit),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 29),
                  CustomTextFormField(
                    controller: controller.nameController,
                    hintText: MyString.fullName,
                    validator: Validations().nameValidation,
                    fillColor: controller.themeController.isDarkMode.value ? MyColors.darkTextFieldColor : MyColors.disabledTextFieldColor,
                  ),
                  const SizedBox(height: 20),
                  CustomTextFormField(
                    controller: controller.nickNameController,
                    hintText: MyString.nickName,
                    validator: Validations().nameValidation,
                    fillColor: controller.themeController.isDarkMode.value ? MyColors.darkTextFieldColor : MyColors.disabledTextFieldColor,
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: CustomTextFormField(
                        controller: controller.dateController,
                        hintText: MyString.dateBirth,
                        validator: Validations().dateValidation,
                        fillColor: controller.themeController.isDarkMode.value ? MyColors.darkTextFieldColor : MyColors.disabledTextFieldColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomTextFormField(
                    controller: controller.emailController,
                    hintText: MyString.email,
                    validator: Validations().emailValidation,
                    keyboardType: TextInputType.emailAddress,
                    fillColor: controller.themeController.isDarkMode.value ? MyColors.darkTextFieldColor : MyColors.disabledTextFieldColor,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: countryPickerDropdown(controller.countryCode.value, controller.countryCodes)
,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 5,
                        child: CustomTextFormField(
                          controller: controller.mobileNumberController,
                          hintText: MyString.phoneNumber,
                          validator: Validations().mobileNumberValidation,
                          keyboardType: TextInputType.phone,
                          fillColor: controller.themeController.isDarkMode.value ? MyColors.darkTextFieldColor : MyColors.disabledTextFieldColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  commonDropdownButton(controller.selectedGender.value), // sekarang ini String, bukan RxStringMyString.genderSelect,controller.themeController.isDarkMode.value)
              )
            ),
          );
        },
      ),
    );
  }
}