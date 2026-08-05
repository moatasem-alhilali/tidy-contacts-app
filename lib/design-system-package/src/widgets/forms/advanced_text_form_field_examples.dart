// import 'package:flutter/material.dart';
// import 'package:hive_manager/design-system-package/src/widgets/forms/text_form_field_widget.dart';

// /// Comprehensive examples for using [TextFormFieldWidget].
// ///
// /// This file contains real-world examples showing how to use various features
// /// of the AdvancedTextFormField widget.
// class AdvancedTextFormFieldExamples extends StatefulWidget {
//   const AdvancedTextFormFieldExamples({super.key});

//   @override
//   State<AdvancedTextFormFieldExamples> createState() =>
//       _AdvancedTextFormFieldExamplesState();
// }

// class _AdvancedTextFormFieldExamplesState
//     extends State<AdvancedTextFormFieldExamples> {
//   final _formKey = GlobalKey<FormState>();
//   final _emailController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _creditCardController = TextEditingController();
//   final _usernameController = TextEditingController();
//   final _bioController = TextEditingController();

//   bool _isLoading = false;
//   bool _emailValid = false;
//   bool _passwordValid = false;

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _phoneController.dispose();
//     _passwordController.dispose();
//     _creditCardController.dispose();
//     _usernameController.dispose();
//     _bioController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('AdvancedTextFormField Examples'),
//         backgroundColor: Theme.of(context).primaryColor,
//         foregroundColor: Colors.white,
//       ),
//       body: Form(
//         key: _formKey,
//         child: ListView(
//           padding: const EdgeInsets.all(16),
//           children: [
//             _buildSectionTitle('Basic Email Field'),
//             _buildBasicEmailExample(),
//             const SizedBox(height: 32),
//             _buildSectionTitle('Phone Number with Formatting'),
//             _buildPhoneExample(),
//             const SizedBox(height: 32),
//             _buildSectionTitle('Password with Validation'),
//             _buildPasswordExample(),
//             const SizedBox(height: 32),
//             _buildSectionTitle('Credit Card with Animation'),
//             _buildCreditCardExample(),
//             const SizedBox(height: 32),
//             _buildSectionTitle('Username with Custom Rules'),
//             _buildUsernameExample(),
//             const SizedBox(height: 32),
//             _buildSectionTitle('Multi-line Bio with Word Count'),
//             _buildBioExample(),
//             const SizedBox(height: 32),
//             _buildSectionTitle('Date Input with Formatting'),
//             _buildDateExample(),
//             const SizedBox(height: 32),
//             _buildSectionTitle('Search Field with Debouncing'),
//             _buildSearchExample(),
//             const SizedBox(height: 32),
//             _buildSectionTitle('Currency Field'),
//             _buildCurrencyExample(),
//             const SizedBox(height: 32),
//             _buildSectionTitle('Custom Styled Field'),
//             _buildCustomStyledExample(),
//             const SizedBox(height: 48),
//             _buildSubmitButton(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSectionTitle(String title) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16),
//       child: Text(
//         title,
//         style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//               fontWeight: FontWeight.bold,
//               color: Theme.of(context).primaryColor,
//             ),
//       ),
//     );
//   }

//   Widget _buildBasicEmailExample() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Simple email field with validation icons and live validation:',
//           style: TextStyle(fontSize: 14, color: Colors.grey),
//         ),
//         const SizedBox(height: 8),
//         TextFormFieldWidget(
//           controller: _emailController,
//           labelText: 'Email Address',
//           hintText: 'Enter your email address',
//           emailFormatter: true,
//           isRequired: true,
//           liveValidation: true,
//           customValidationRules: [ValidationRules.email],
//           onValidationChanged: (isValid) =>
//               setState(() => _emailValid = isValid),
//           keyboardType: TextInputType.emailAddress,
//           textInputAction: TextInputAction.next,
//         ),
//         if (_emailValid && _emailController.text.isNotEmpty)
//           const Padding(
//             padding: EdgeInsets.only(top: 8),
//             child: Text(
//               '✅ Email looks good!',
//               style: TextStyle(color: Colors.green, fontSize: 12),
//             ),
//           ),
//       ],
//     );
//   }

//   Widget _buildPhoneExample() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Phone field with country prefix and formatting:',
//           style: TextStyle(fontSize: 14, color: Colors.grey),
//         ),
//         const SizedBox(height: 8),
//         TextFormFieldWidget(
//           controller: _phoneController,
//           labelText: 'Phone Number',
//           hintText: '(555) 123-4567',
//           phoneFormatter: true,
//           prefixText: '+1 ',
//           maxLength: 14,
//           keyboardType: TextInputType.phone,
//           customValidationRules: [ValidationRules.phone],
//           pulseOnFocus: true,
//           prefixIcon: const Icon(Icons.phone),
//         ),
//       ],
//     );
//   }

//   Widget _buildPasswordExample() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Password field with strength validation and toggle visibility:',
//           style: TextStyle(fontSize: 14, color: Colors.grey),
//         ),
//         const SizedBox(height: 8),
//         StatefulBuilder(
//           builder: (context, setState) {
//             var obscureText = true;
//             return TextFormFieldWidget(
//               controller: _passwordController,
//               labelText: 'Password',
//               hintText: 'Enter a strong password',
//               obscureText: obscureText,
//               isRequired: true,
//               liveValidation: true,
//               customValidationRules: [
//                 ValidationRules.minLength(8),
//                 ValidationRules.pattern(
//                   RegExp(
//                       r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$'),
//                   'Password must contain uppercase, lowercase, number, and special character',
//                 ),
//               ],
//               onValidationChanged: (isValid) =>
//                   this.setState(() => _passwordValid = isValid),
//               suffixIcon: IconButton(
//                 icon:
//                     Icon(obscureText ? Icons.visibility : Icons.visibility_off),
//                 onPressed: () => setState(() => obscureText = !obscureText),
//               ),
//               prefixIcon: const Icon(Icons.lock),
//             );
//           },
//         ),
//         const SizedBox(height: 8),
//         const Text(
//           'Requirements: 8+ characters, uppercase, lowercase, number, special character',
//           style: TextStyle(fontSize: 12, color: Colors.grey),
//         ),
//       ],
//     );
//   }

//   Widget _buildCreditCardExample() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Credit card field with formatting and loading state:',
//           style: TextStyle(fontSize: 14, color: Colors.grey),
//         ),
//         const SizedBox(height: 8),
//         StatefulBuilder(
//           builder: (context, setState) {
//             var isValidating = false;
//             return TextFormFieldWidget(
//               controller: _creditCardController,
//               labelText: 'Credit Card Number',
//               hintText: '1234 5678 9012 3456',
//               creditCardFormatter: true,
//               maxLength: 19,
//               keyboardType: TextInputType.number,
//               isLoading: isValidating,
//               loadingText: 'Validating card...',
//               glowEffect: true,
//               onChanged: (value) {
//                 if (value.replaceAll(' ', '').length == 16) {
//                   setState(() => isValidating = true);
//                   // Simulate API call
//                   Future.delayed(const Duration(seconds: 2), () {
//                     if (mounted) setState(() => isValidating = false);
//                   });
//                 }
//               },
//               prefixIcon: const Icon(Icons.credit_card),
//             );
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildUsernameExample() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Username field with custom validation rules:',
//           style: TextStyle(fontSize: 14, color: Colors.grey),
//         ),
//         const SizedBox(height: 8),
//         TextFormFieldWidget(
//           controller: _usernameController,
//           labelText: 'Username',
//           hintText: 'Enter a unique username',
//           lowercaseFormatter: true,
//           isRequired: true,
//           liveValidation: true,
//           customValidationRules: [
//             ValidationRules.minLength(3),
//             ValidationRules.maxLength(20),
//             ValidationRules.pattern(
//               RegExp(r'^[a-z0-9_]+$'),
//               'Only lowercase letters, numbers, and underscores allowed',
//             ),
//           ],
//           prefixIcon: const Icon(Icons.person),
//           helperText: 'Only lowercase letters, numbers, and underscores',
//         ),
//       ],
//     );
//   }

//   Widget _buildBioExample() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Multi-line bio field with word count limit:',
//           style: TextStyle(fontSize: 14, color: Colors.grey),
//         ),
//         const SizedBox(height: 8),
//         TextFormFieldWidget(
//           controller: _bioController,
//           labelText: 'Bio',
//           hintText: 'Tell us about yourself...',
//           maxLines: 4,
//           maxLength: 200,
//           limitedWordArabicFormatter: true,
//           countLimitedWordArabicFormatter: 50,
//           showCharacterCount: true,
//           liveValidation: true,
//           customValidationRules: [ValidationRules.maxLength(200)],
//           textInputAction: TextInputAction.newline,
//         ),
//       ],
//     );
//   }

//   Widget _buildDateExample() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Date field with automatic formatting:',
//           style: TextStyle(fontSize: 14, color: Colors.grey),
//         ),
//         const SizedBox(height: 8),
//         TextFormFieldWidget(
//           labelText: 'Date of Birth',
//           hintText: 'MM/DD/YYYY',
//           dateFormatter: true,
//           keyboardType: TextInputType.number,
//           prefixIcon: const Icon(Icons.calendar_today),
//           customValidationRules: [
//             ValidationRules.pattern(
//               RegExp(r'^\d{2}/\d{2}/\d{4}$'),
//               'Please enter date in MM/DD/YYYY format',
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildSearchExample() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Search field with debouncing to reduce API calls:',
//           style: TextStyle(fontSize: 14, color: Colors.grey),
//         ),
//         const SizedBox(height: 8),
//         TextFormFieldWidget(
//           labelText: 'Search',
//           hintText: 'Search for anything...',
//           validationDebounce: const Duration(milliseconds: 500),
//           onChanged: (value) {
//             // This will be debounced
//             print('Searching for: $value');
//           },
//           prefixIcon: const Icon(Icons.search),
//           suffixIcon: IconButton(
//             icon: const Icon(Icons.clear),
//             onPressed: () {
//               // Clear search
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildCurrencyExample() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Currency field with prefix and decimal formatting:',
//           style: TextStyle(fontSize: 14, color: Colors.grey),
//         ),
//         const SizedBox(height: 8),
//         TextFormFieldWidget(
//           labelText: 'Amount',
//           hintText: '0.00',
//           currencyFormatter: true,
//           prefixText: r'$ ',
//           keyboardType: TextInputType.number,
//           customValidationRules: [
//             ValidationRules.pattern(
//               RegExp(r'^\d+\.?\d{0,2}$'),
//               'Please enter a valid amount',
//             ),
//           ],
//           prefixIcon: const Icon(Icons.attach_money),
//         ),
//       ],
//     );
//   }

//   Widget _buildCustomStyledExample() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Custom styled field with gradient and glow effects:',
//           style: TextStyle(fontSize: 14, color: Colors.grey),
//         ),
//         const SizedBox(height: 8),
//         TextFormFieldWidget(
//           labelText: 'Special Field',
//           hintText: 'Enter something special...',
//           gradientBackground: true,
//           gradientColors: const [Colors.blue, Colors.purple],
//           borderRadius: BorderRadius.circular(16),
//           borderWidth: 2,
//           glowEffect: true,
//           pulseOnFocus: true,
//           style: const TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w500,
//           ),
//           prefixIcon: const Icon(Icons.star, color: Colors.amber),
//         ),
//       ],
//     );
//   }

//   Widget _buildSubmitButton() {
//     return ElevatedButton(
//       onPressed: _isLoading ? null : _handleSubmit,
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Theme.of(context).primaryColor,
//         foregroundColor: Colors.white,
//         padding: const EdgeInsets.symmetric(vertical: 16),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(8),
//         ),
//       ),
//       child: _isLoading
//           ? const SizedBox(
//               height: 20,
//               width: 20,
//               child: CircularProgressIndicator(
//                 strokeWidth: 2,
//                 valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//               ),
//             )
//           : const Text(
//               'Submit Form',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//     );
//   }

//   Future<void> _handleSubmit() async {
//     if (_formKey.currentState?.validate() ?? false) {
//       setState(() => _isLoading = true);

//       // Simulate form submission
//       await Future.delayed(const Duration(seconds: 2));

//       if (mounted) {
//         setState(() => _isLoading = false);

//         // Show success message
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Form submitted successfully!'),
//             backgroundColor: Colors.green,
//           ),
//         );
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Please fix the errors in the form'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }
// }

// /// Example demonstrating specific use cases for AdvancedTextFormField
// class SpecificExamples {
//   /// Registration form example
//   static Widget buildRegistrationForm() {
//     return Form(
//       child: Column(
//         children: [
//           // Full name field
//           TextFormFieldWidget(
//             labelText: 'Full Name',
//             hintText: 'Enter your full name',
//             capitalizeFormatter: true,
//             isRequired: true,
//             customValidationRules: [
//               ValidationRules.minLength(2),
//               ValidationRules.pattern(
//                 RegExp(r'^[a-zA-Z\s]+$'),
//                 'Only letters and spaces allowed',
//               ),
//             ],
//             prefixIcon: const Icon(Icons.person),
//           ),

//           const SizedBox(height: 16),

//           // Email field
//           TextFormFieldWidget(
//             labelText: 'Email',
//             hintText: 'Enter your email',
//             emailFormatter: true,
//             isRequired: true,
//             liveValidation: true,
//             customValidationRules: [ValidationRules.email],
//             prefixIcon: const Icon(Icons.email),
//           ),

//           const SizedBox(height: 16),

//           // Password field
//           TextFormFieldWidget(
//             labelText: 'Password',
//             hintText: 'Create a strong password',
//             obscureText: true,
//             isRequired: true,
//             customValidationRules: [
//               ValidationRules.minLength(8),
//               ValidationRules.pattern(
//                 RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)'),
//                 'Must contain uppercase, lowercase, and number',
//               ),
//             ],
//             prefixIcon: const Icon(Icons.lock),
//           ),

//           const SizedBox(height: 16),

//           // Phone field
//           TextFormFieldWidget(
//             labelText: 'Phone',
//             hintText: 'Enter your phone number',
//             phoneFormatter: true,
//             customValidationRules: [ValidationRules.phone],
//             prefixIcon: const Icon(Icons.phone),
//           ),
//         ],
//       ),
//     );
//   }

//   /// Payment form example
//   static Widget buildPaymentForm() {
//     return Form(
//       child: Column(
//         children: [
//           // Credit card field
//           const TextFormFieldWidget(
//             labelText: 'Card Number',
//             hintText: '1234 5678 9012 3456',
//             creditCardFormatter: true,
//             maxLength: 19,
//             keyboardType: TextInputType.number,
//             isRequired: true,
//             prefixIcon: Icon(Icons.credit_card),
//           ),

//           const SizedBox(height: 16),

//           Row(
//             children: [
//               // Expiry date
//               Expanded(
//                 child: TextFormFieldWidget(
//                   labelText: 'Expiry',
//                   hintText: 'MM/YY',
//                   customValidationRules: [
//                     ValidationRules.pattern(
//                       RegExp(r'^(0[1-9]|1[0-2])\/\d{2}$'),
//                       'Invalid expiry format',
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(width: 16),

//               // CVV
//               Expanded(
//                 child: TextFormFieldWidget(
//                   labelText: 'CVV',
//                   hintText: '123',
//                   numberFormatter: true,
//                   maxLength: 4,
//                   obscureText: true,
//                   customValidationRules: [
//                     ValidationRules.pattern(
//                       RegExp(r'^\d{3,4}$'),
//                       'Invalid CVV',
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),

//           const SizedBox(height: 16),

//           // Amount field
//           const TextFormFieldWidget(
//             labelText: 'Amount',
//             hintText: '0.00',
//             currencyFormatter: true,
//             prefixText: r'$ ',
//             keyboardType: TextInputType.number,
//             isRequired: true,
//             prefixIcon: Icon(Icons.attach_money),
//           ),
//         ],
//       ),
//     );
//   }
// }
