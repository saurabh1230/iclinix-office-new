import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:iclinix/app/widget/custom_snackbar.dart';
import 'package:iclinix/helper/route_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import '../data/repo/profile_repo.dart';
import '../data/api/api_client.dart';
import 'package:http_parser/http_parser.dart';

import '../helper/date_converter.dart';

class ProfileController extends GetxController implements GetxService {
  final ProfileRepo profileRepo;
  final ApiClient apiClient;

  ProfileController({required this.profileRepo, required this.apiClient});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  XFile? _pickedImage;
  XFile? get pickedImage => _pickedImage;

  void pickImage({required bool isRemove}) async {
    if (isRemove) {
      _pickedImage = null;
    } else {
      _pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    }
    update();
  }


  DateTime? selectedDate;
  String? formattedDate;

  void updateDate(DateTime newDate) {
    selectedDate = newDate;
    formattedDate = SimpleDateConverter.formatDateToCustomFormat(selectedDate!);
    update();
  }

  var selectedGender = 'Male';
  final List<String> genderOptions = ['Male', 'Female',];

  void updateGender(String gender) {
    selectedGender = gender;
    update();
  }

  var selectedDiabetes = 'No';
  final List<String> diabetesOptions = ['No','Yes'];

  void updateDiabetes(String val) {
    selectedDiabetes = val;
    update();
  }

  var selectedGlasses = 'No';
  final List<String> glassesOptions = ['No','Yes'];

  void updateGlasses(String val) {
    selectedGlasses = val;
    update();
  }

  var selectedBp= 'No';
  final List<String> bpOptions = ['No','Yes'];

  void updateHealth(String val) {
    selectedBp = val;
    update();
  }



  Future<void> updateProfileApi( String? firstname,
      String? lastname,
      String? dob,
      String? diabetesProblem,
      String? bpProblem,
      String? eyeProblem,
      String? gender,
      ) async {
    _isLoading = true;
    update();

    Response response = await profileRepo.updateProfileRepo(firstname, lastname, dob, diabetesProblem, bpProblem, eyeProblem,gender);

    if(response.statusCode == 200) {
      var responseData = response.body;
      if(responseData["Msg"]  == "Data Updated Successfully") {
        Get.toNamed(RouteHelper.getDashboardRoute());
        _isLoading = false;
        update();
        return showCustomSnackBar('Saved Successfully', isError: true);
      } else {
        _isLoading = false;
        update();
        print('update profile failed');

      }
      _isLoading = false;
      update();
    } else {
      _isLoading = false;
      update();
    }
    _isLoading = false;
    update();
  }





}
