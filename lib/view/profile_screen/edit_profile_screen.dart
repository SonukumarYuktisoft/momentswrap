import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Xkart/controllers/profile_controller/profile_controller.dart';
import 'package:Xkart/util/constants/app_colors.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final ProfileController controller = Get.find<ProfileController>();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _streetController;
  late TextEditingController _postalCodeController;

  String? selectedGender;
  String? selectedState;
  String? selectedCity;
  DateTime? selectedDateOfBirth;

  // Indian states and their cities
  final Map<String, List<String>> indianStatesAndCities = {
    'Andhra Pradesh': [
      'Visakhapatnam',
      'Vijayawada',
      'Guntur',
      'Nellore',
      'Kurnool',
      'Tirupati',
    ],
    'Arunachal Pradesh': [
      'Itanagar',
      'Naharlagun',
      'Pasighat',
      'Tezpur',
      'Bomdila',
    ],
    'Assam': [
      'Guwahati',
      'Dibrugarh',
      'Jorhat',
      'Nagaon',
      'Tinsukia',
      'Silchar',
    ],
    'Bihar': [
      'Patna',
      'Gaya',
      'Bhagalpur',
      'Muzaffarpur',
      'Bihar Sharif',
      'Darbhanga',
    ],
    'Chhattisgarh': [
      'Raipur',
      'Bhilai',
      'Korba',
      'Durg',
      'Rajnandgaon',
      'Jagdalpur',
    ],
    'Delhi': [
      'New Delhi',
      'Central Delhi',
      'North Delhi',
      'South Delhi',
      'East Delhi',
      'West Delhi',
    ],
    'Goa': ['Panaji', 'Margao', 'Vasco da Gama', 'Mapusa', 'Ponda'],
    'Gujarat': [
      'Ahmedabad',
      'Surat',
      'Vadodara',
      'Rajkot',
      'Bhavnagar',
      'Jamnagar',
    ],
    'Haryana': [
      'Gurugram',
      'Faridabad',
      'Panipat',
      'Ambala',
      'Yamunanagar',
      'Rohtak',
    ],
    'Himachal Pradesh': [
      'Shimla',
      'Dharamshala',
      'Solan',
      'Mandi',
      'Kullu',
      'Kasauli',
    ],
    'Jharkhand': [
      'Ranchi',
      'Jamshedpur',
      'Dhanbad',
      'Bokaro',
      'Deoghar',
      'Hazaribagh',
    ],
    'Karnataka': [
      'Bangalore',
      'Mysore',
      'Hubli',
      'Mangalore',
      'Belgaum',
      'Davangere',
    ],
    'Kerala': [
      'Thiruvananthapuram',
      'Kochi',
      'Kozhikode',
      'Thrissur',
      'Kollam',
      'Palakkad',
    ],
    'Madhya Pradesh': [
      'Bhopal',
      'Indore',
      'Gwalior',
      'Jabalpur',
      'Ujjain',
      'Sagar',
    ],
    'Maharashtra': [
      'Mumbai',
      'Pune',
      'Nagpur',
      'Nashik',
      'Aurangabad',
      'Solapur',
    ],
    'Manipur': ['Imphal', 'Thoubal', 'Bishnupur', 'Churachandpur', 'Kakching'],
    'Meghalaya': ['Shillong', 'Tura', 'Jowai', 'Nongpoh', 'Baghmara'],
    'Mizoram': ['Aizawl', 'Lunglei', 'Serchhip', 'Champhai', 'Kolasib'],
    'Nagaland': ['Kohima', 'Dimapur', 'Mokokchung', 'Tuensang', 'Wokha'],
    'Odisha': [
      'Bhubaneswar',
      'Cuttack',
      'Rourkela',
      'Brahmapur',
      'Sambalpur',
      'Puri',
    ],
    'Punjab': [
      'Chandigarh',
      'Ludhiana',
      'Amritsar',
      'Jalandhar',
      'Patiala',
      'Bathinda',
    ],
    'Rajasthan': ['Jaipur', 'Jodhpur', 'Kota', 'Bikaner', 'Ajmer', 'Udaipur'],
    'Sikkim': ['Gangtok', 'Namchi', 'Gyalshing', 'Mangan', 'Jorethang'],
    'Tamil Nadu': [
      'Chennai',
      'Coimbatore',
      'Madurai',
      'Tiruchirappalli',
      'Salem',
      'Tirunelveli',
    ],
    'Telangana': [
      'Hyderabad',
      'Warangal',
      'Nizamabad',
      'Khammam',
      'Karimnagar',
      'Ramagundam',
    ],
    'Tripura': ['Agartala', 'Udaipur', 'Dharmanagar', 'Kailashahar', 'Belonia'],
    'Uttar Pradesh': [
      'Lucknow',
      'Kanpur',
      'Ghaziabad',
      'Agra',
      'Varanasi',
      'Meerut',
      'Allahabad',
    ],
    'Uttarakhand': [
      'Dehradun',
      'Haridwar',
      'Roorkee',
      'Haldwani',
      'Kashipur',
      'Rishikesh',
    ],
    'West Bengal': [
      'Kolkata',
      'Howrah',
      'Durgapur',
      'Asansol',
      'Siliguri',
      'Malda',
    ],
  };

  final List<String> genderOptions = ['Male', 'Female', 'Other'];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _initializeFormData();
  }

  void _initializeControllers() {
    _firstNameController = TextEditingController(text: controller.firstName);
    _lastNameController = TextEditingController(text: controller.lastName);
    _phoneController = TextEditingController(text: controller.phoneNumber);
    _emailController = TextEditingController(text: controller.email);
    _streetController = TextEditingController();
    _postalCodeController = TextEditingController();
  }

  void _initializeFormData() {
    // Initialize existing data if available
    selectedGender = controller.gender?.isNotEmpty == true
        ? controller.gender!.toLowerCase() == 'male'
              ? 'Male'
              : controller.gender!.toLowerCase() == 'female'
              ? 'Female'
              : controller.gender!.toLowerCase() == 'other'
              ? 'Other'
              : null
        : null;

    if (controller.addresses.isNotEmpty) {
      final address = controller.addresses.first;
      _streetController.text = address.street ?? '';
      selectedState = address.state;
      selectedCity = address.city;
      _postalCodeController.text = address.zipCode ?? '';
    }

    if (controller.dateOfBirth != null && controller.dateOfBirth!.isNotEmpty) {
      try {
        // Handle ISO date format from API (e.g., "1995-10-25T00:00:00.000Z")
        selectedDateOfBirth = DateTime.parse(controller.dateOfBirth!);
      } catch (e) {
        print('Error parsing date of birth: $e');
        // Try parsing just the date part if full ISO string fails
        try {
          final dateOnly = controller.dateOfBirth!.split('T')[0];
          selectedDateOfBirth = DateTime.parse(dateOnly);
        } catch (e2) {
          print('Error parsing date part: $e2');
        }
      }
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _streetController.dispose();
    _postalCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryColor.withOpacity(0.1),
              AppColors.backgroundColor,
            ],
          ),
        ),
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primaryColor,
                    ),
                    strokeWidth: 3,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Loading...',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          }

          return CustomScrollView(
            slivers: [
              // Modern App Bar
              SliverAppBar(
                expandedHeight: 120,
                floating: false,
                pinned: true,
                elevation: 0,
                backgroundColor: AppColors.primaryColor,
                leading: Container(
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.accentColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      color: AppColors.accentColor,
                      size: 18,
                    ),
                    onPressed: () => Get.back(),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.accentColor,
                      fontSize: 18,
                    ),
                  ),
                  centerTitle: true,
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                    ),
                  ),
                ),
              ),

              // Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Profile Image Section
                        _buildProfileImageSection(),
                        const SizedBox(height: 24),

                        // Personal Information Section
                        _buildPersonalInfoSection(),
                        const SizedBox(height: 24),

                        // Address Information Section
                        _buildAddressSection(),
                        const SizedBox(height: 32),

                        // Action Buttons
                        _buildActionButtons(),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildProfileImageSection() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.1),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.accentColor,
                  backgroundImage: controller.profileImage.value != null
                      ? FileImage(controller.profileImage.value!)
                      : controller.profileImageUrl.isNotEmpty
                      ? NetworkImage(controller.profileImageUrl)
                      : null,
                  child:
                      (controller.profileImage.value == null &&
                          controller.profileImageUrl.isEmpty)
                      ? Icon(
                          Icons.person_outline,
                          size: 50,
                          color: AppColors.primaryColor,
                        )
                      : null,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _showModernImagePickerDialog,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: AppColors.secondaryGradient,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.accentColor,
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.secondaryColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.camera_alt_outlined,
                      color: AppColors.accentColor,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            'Tap to change profile picture',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildModernSectionTitle('Personal Information'),
          const SizedBox(height: 20),

          // First Name Field
          _buildModernTextFormField(
            controller: _firstNameController,
            label: 'First Name',
            icon: Icons.person_outline,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'First name is required';
              }
              if (value.trim().length < 2) {
                return 'First name must be at least 2 characters';
              }
              return null;
            },
          ),

          const SizedBox(height: 20),

          // Last Name Field
          _buildModernTextFormField(
            controller: _lastNameController,
            label: 'Last Name',
            icon: Icons.person_outline,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Last name is required';
              }
              if (value.trim().length < 2) {
                return 'Last name must be at least 2 characters';
              }
              return null;
            },
          ),

          const SizedBox(height: 20),

          // Phone Field
          _buildModernTextFormField(
            controller: _phoneController,
            label: 'Phone Number',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9+\-\s\(\)]')),
              LengthLimitingTextInputFormatter(15),
            ],
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Phone number is required';
              }
              final cleanPhone = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');
              if (!RegExp(r'^[\+]?[0-9]{10,15}$').hasMatch(cleanPhone)) {
                return 'Please enter a valid phone number';
              }
              return null;
            },
          ),

          const SizedBox(height: 20),

          // Email Field (Read-only)
          _buildModernTextFormField(
            controller: _emailController,
            label: 'Email Address',
            icon: Icons.email_outlined,
            enabled: false,
            helperText: 'Email cannot be changed',
          ),

          const SizedBox(height: 20),

          // Gender Dropdown
          _buildModernDropdownField(
            label: 'Gender',
            icon: Icons.person_outline,
            value: selectedGender,
            items: genderOptions,
            onChanged: (value) {
              setState(() {
                selectedGender = value;
              });
            },
          ),

          const SizedBox(height: 20),

          // Date of Birth Picker
          _buildDateOfBirthField(),
        ],
      ),
    );
  }

  Widget _buildAddressSection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildModernSectionTitle('Address Information'),
          const SizedBox(height: 20),

          // Street Address
          _buildModernTextFormField(
            controller: _streetController,
            label: 'Street Address',
            icon: Icons.home_outlined,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Street address is required';
              }
              return null;
            },
          ),

          const SizedBox(height: 20),

          // State Dropdown
          _buildModernDropdownField(
            label: 'State',
            icon: Icons.location_on_outlined,
            value: selectedState,
            items: indianStatesAndCities.keys.toList(),
            onChanged: (value) {
              setState(() {
                selectedState = value;
                selectedCity = null; // Reset city when state changes
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a state';
              }
              return null;
            },
          ),

          const SizedBox(height: 20),

          // City Dropdown
          _buildModernDropdownField(
            label: 'City',
            icon: Icons.location_city_outlined,
            value: selectedCity,
            items: selectedState != null
                ? indianStatesAndCities[selectedState] ?? []
                : [],
            onChanged: selectedState != null
                ? (value) {
                    setState(() {
                      selectedCity = value;
                    });
                  }
                : null,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a city';
              }
              return null;
            },
          ),

          const SizedBox(height: 20),

          // Postal Code
          _buildModernTextFormField(
            controller: _postalCodeController,
            label: 'Postal Code',
            icon: Icons.mail_outline,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(6),
            ],
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Postal code is required';
              }
              if (value.length != 6) {
                return 'Please enter a valid 6-digit postal code';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildModernSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textColor,
          ),
        ),
      ],
    );
  }

  Widget _buildModernTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? helperText,
    bool enabled = true,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        validator: validator,
        style: TextStyle(
          fontSize: 16,
          color: enabled ? AppColors.textColor : AppColors.textSecondary,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          labelText: label,
          helperText: helperText,
          helperStyle: TextStyle(color: AppColors.textSecondary, fontSize: 12),
          prefixIcon: Container(
            margin: EdgeInsets.all(12),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: enabled
                  ? AppColors.primaryColor.withOpacity(0.1)
                  : AppColors.textSecondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: enabled ? AppColors.primaryColor : AppColors.textSecondary,
              size: 20,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: AppColors.primaryColor.withOpacity(0.2),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.errorColor, width: 1),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: AppColors.textSecondary.withOpacity(0.2),
            ),
          ),
          filled: true,
          fillColor: enabled
              ? AppColors.accentColor
              : AppColors.backgroundColor,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          labelStyle: TextStyle(
            color: enabled ? AppColors.primaryColor : AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
          errorStyle: TextStyle(color: AppColors.errorColor, fontSize: 12),
        ),
      ),
    );
  }

  Widget _buildModernDropdownField({
    required String label,
    required IconData icon,
    required String? value,
    required List<String> items,
    required void Function(String?)? onChanged,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        onChanged: onChanged,
        validator: validator,
        style: TextStyle(
          fontSize: 16,
          color: AppColors.textColor,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Container(
            margin: EdgeInsets.all(12),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.primaryColor, size: 20),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: AppColors.primaryColor.withOpacity(0.2),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.errorColor, width: 1),
          ),
          filled: true,
          fillColor: AppColors.accentColor,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          labelStyle: TextStyle(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.w500,
          ),
          errorStyle: TextStyle(color: AppColors.errorColor, fontSize: 12),
        ),
        dropdownColor: AppColors.accentColor,
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: TextStyle(color: AppColors.textColor, fontSize: 14),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDateOfBirthField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: _selectDateOfBirth,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.accentColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primaryColor.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.only(right: 12),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.calendar_today_outlined,
                  color: AppColors.primaryColor,
                  size: 20,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Date of Birth',
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      selectedDateOfBirth != null
                          ? '${selectedDateOfBirth!.day}/${selectedDateOfBirth!.month}/${selectedDateOfBirth!.year}'
                          : 'Select your date of birth',
                      style: TextStyle(
                        color: selectedDateOfBirth != null
                            ? AppColors.textColor
                            : AppColors.textSecondary,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_drop_down, color: AppColors.primaryColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // Update Button
        SizedBox(
          width: double.infinity,
          child: Obx(
            () => Container(
              decoration: BoxDecoration(
                gradient: controller.isUpdating.value
                    ? LinearGradient(
                        colors: [
                          AppColors.primaryColor.withOpacity(0.6),
                          AppColors.primaryColor.withOpacity(0.4),
                        ],
                      )
                    : AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: controller.isUpdating.value ? null : _updateProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  foregroundColor: AppColors.accentColor,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: controller.isUpdating.value
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.accentColor,
                          ),
                        ),
                      )
                    : Icon(Icons.save_outlined),
                label: Text(
                  controller.isUpdating.value
                      ? 'Updating...'
                      : 'Update Profile',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Cancel Button
        SizedBox(
          width: double.infinity,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.accentColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.primaryColor.withOpacity(0.3),
              ),
            ),
            child: TextButton.icon(
              onPressed: controller.isUpdating.value ? null : () => Get.back(),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.textSecondary,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: Icon(Icons.close_outlined),
              label: Text(
                'Cancel',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showModernImagePickerDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.accentColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.photo_camera_outlined,
                color: AppColors.primaryColor,
                size: 20,
              ),
            ),
            SizedBox(width: 12),
            Text(
              'Update Photo',
              style: TextStyle(
                color: AppColors.textColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildModernImageOption(
              icon: Icons.camera_alt_outlined,
              title: 'Take Photo',
              subtitle: 'Use camera to take a new photo',
              onTap: () {
                Get.back();
                controller.pickImage(ImageSource.camera);
              },
            ),
            SizedBox(height: 12),
            _buildModernImageOption(
              icon: Icons.photo_library_outlined,
              title: 'Choose from Gallery',
              subtitle: 'Select from your photos',
              onTap: () {
                Get.back();
                controller.pickImage(ImageSource.gallery);
              },
            ),
            if (controller.profileImage.value != null ||
                controller.profileImageUrl.isNotEmpty) ...[
              SizedBox(height: 12),
              _buildModernImageOption(
                icon: Icons.delete_outline,
                title: 'Remove Photo',
                subtitle: 'Use default avatar',
                color: AppColors.errorColor,
                onTap: () {
                  Get.back();
                  controller.removeImage();
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildModernImageOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? color,
  }) {
    final optionColor = color ?? AppColors.primaryColor;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: optionColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: optionColor.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: optionColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: optionColor, size: 20),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textColor,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDateOfBirth() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDateOfBirth ?? DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now().subtract(
        Duration(days: 365 * 13),
      ), // Minimum 13 years old
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryColor,
              onPrimary: AppColors.accentColor,
              surface: AppColors.accentColor,
              onSurface: AppColors.textColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDateOfBirth) {
      setState(() {
        selectedDateOfBirth = picked;
      });
    }
  }

  void _updateProfile() {
    if (_formKey.currentState!.validate()) {
      final firstName = _firstNameController.text.trim();
      final lastName = _lastNameController.text.trim();
      final phone = _phoneController.text.trim();

      if (controller.validateUpdateData(
        firstName: firstName,
        lastName: lastName,
        phone: phone,
      )) {
        // Prepare address data
        List<Map<String, dynamic>>? addressData;
        if (_streetController.text.trim().isNotEmpty &&
            selectedState != null &&
            selectedCity != null &&
            _postalCodeController.text.trim().isNotEmpty) {
          addressData = [
            {
              'street': _streetController.text.trim(),
              'city': selectedCity!,
              'state': selectedState!,
              'postalCode': _postalCodeController.text.trim(),
              'country': 'India',
            },
          ];
        }

        // Format date of birth
        String? formattedDateOfBirth;
        if (selectedDateOfBirth != null) {
          formattedDateOfBirth =
              '${selectedDateOfBirth!.year}-${selectedDateOfBirth!.month.toString().padLeft(2, '0')}-${selectedDateOfBirth!.day.toString().padLeft(2, '0')}';
        }

        controller.updateCustomerProfile(
          newFirstName: firstName,
          newLastName: lastName,
          newPhone: phone,
          gender: selectedGender?.toLowerCase(),
          dateOfBirth: formattedDateOfBirth,
          addresses: addressData,
        );
      }
    }
  }
}
