// // ai_assistant_controller.dart
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'dart:convert';
// import 'dart:developer';
// // Import your existing services
// import 'package:Xkart/services/api_services.dart';

// class AIAssistantController extends GetxController with SingleGetTickerProviderMixin {
//   // Animation Controllers
//   late AnimationController animationController;
//   late Animation<double> scaleAnimation;
//   late Animation<Offset> slideAnimation;

//   // Services
//   final ApiServices _apiServices = ApiServices();

//   // Message handling
//   final TextEditingController messageController = TextEditingController();
//   final RxList<MessageModel> messages = <MessageModel>[].obs;
//   final RxBool isLoading = false.obs;
//   final RxBool isTyping = false.obs;

//   // API Configuration - Update these with your actual endpoints
//   static const String baseUrl = 'https://your-api-endpoint.com/api/v1';
//   static const String aiChatEndpoint = '/ai/chat';
//   static const String aiHistoryEndpoint = '/ai/history';
  
//   @override
//   void onInit() {
//     super.onInit();
//     _initializeAnimations();
//     _addWelcomeMessage();
//     _loadConversationHistory(); // Load previous conversation if needed
//   }

//   void _initializeAnimations() {
//     animationController = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );

//     scaleAnimation = Tween<double>(
//       begin: 0.8,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: animationController,
//       curve: Curves.easeOutBack,
//     ));

//     slideAnimation = Tween<Offset>(
//       begin: const Offset(0, 1),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(
//       parent: animationController,
//       curve: Curves.easeOut,
//     ));

//     animationController.forward();
//   }

//   void _addWelcomeMessage() {
//     messages.add(MessageModel(
//       text: 'Hello! I\'m your AI Assistant. How can I help you today?',
//       isUser: false,
//       time: DateTime.now(),
//     ));
//   }

//   // Load previous conversation history
//   Future<void> _loadConversationHistory() async {
//     try {
//       final response = await _apiServices.getRequest(
//         url: '$baseUrl$aiHistoryEndpoint',
//         authToken: true, // Set to false if no auth required
//       );

//       if (response.statusCode == 200) {
//         final data = response.data;
//         if (data['history'] != null) {
//           final List<dynamic> historyList = data['history'];
//           for (var item in historyList) {
//             messages.add(MessageModel.fromJson(item));
//           }
//         }
//       }
//     } catch (e) {
//       log('Error loading conversation history: $e');
//     }
//   }

//   // Send message method using your existing API service
//   Future<void> sendMessage() async {
//     if (messageController.text.trim().isEmpty) return;

//     final userMessage = messageController.text.trim();
    
//     // Add user message
//     messages.add(MessageModel(
//       text: userMessage,
//       isUser: true,
//       time: DateTime.now(),
//     ));

//     messageController.clear();
//     isLoading.value = true;
//     isTyping.value = true;

//     try {
//       // Use your existing API service for AI response
//       await _getAIResponseFromAPI(userMessage);
//     } catch (e) {
//       _handleError(e.toString());
//     } finally {
//       isLoading.value = false;
//       isTyping.value = false;
//     }
//   }

//   // Get AI Response using your existing API service
//   Future<void> _getAIResponseFromAPI(String userMessage) async {
//     try {
//       log('Sending message to AI: $userMessage');
      
//       // Prepare request data
//       Map<String, dynamic> requestData = {
//         'message': userMessage,
//         'conversation_id': _getConversationId(),
//         'timestamp': DateTime.now().toIso8601String(),
//         'user_context': await _getUserContext(), // Add user context if needed
//       };

//       // Use your existing POST API service
//       final response = await _apiServices.requestPostForApi(
//         url: '$baseUrl$aiChatEndpoint',
//         dictParameter: requestData,
//         authToken: true, // Set to false if no auth required
//       );

//       log('AI API Response: ${response?.data}');

//       if (response != null && response.statusCode == 200) {
//         final responseData = response.data;
        
//         // Handle different response formats
//         String aiResponse;
//         if (responseData is Map<String, dynamic>) {
//           aiResponse = responseData['response'] ?? 
//                       responseData['message'] ?? 
//                       responseData['reply'] ??
//                       'Sorry, I couldn\'t process that.';
//         } else {
//           aiResponse = responseData.toString();
//         }
        
//         messages.add(MessageModel(
//           text: aiResponse,
//           isUser: false,
//           time: DateTime.now(),
//         ));

//         // Save conversation to history (optional)
//         _saveConversationToHistory(userMessage, aiResponse);
        
//       } else {
//         throw Exception('API Error: ${response?.statusCode ?? 'Unknown error'}');
//       }
//     } catch (e) {
//       log('AI API Error: $e');
//       // Fallback to dummy response if API fails
//       await _getDummyResponse(userMessage);
//     }
//   }

//   // Save conversation to history using PUT request
//   Future<void> _saveConversationToHistory(String userMessage, String aiResponse) async {
//     try {
//       Map<String, dynamic> historyData = {
//         'conversation_id': _getConversationId(),
//         'user_message': userMessage,
//         'ai_response': aiResponse,
//         'timestamp': DateTime.now().toIso8601String(),
//       };

//       await _apiServices.requestPutForApi(
//         url: '$baseUrl$aiHistoryEndpoint',
//         dictParameter: historyData,
//         authToken: true,
//       );
//     } catch (e) {
//       log('Error saving conversation history: $e');
//     }
//   }

//   // Dummy response method - fallback when API fails
//   Future<void> _getDummyResponse(String userMessage) async {
//     await Future.delayed(const Duration(milliseconds: 1500));
    
//     final responses = [
//       "That's an interesting question! Let me help you with that.",
//       "I understand your query. Here's what I can suggest...",
//       "Based on your message, I recommend...",
//       "Great question! Here's my analysis...",
//       "I'm here to assist you. Let me provide some insights...",
//       "Thanks for asking! Here's what I think about that...",
//       "Let me process that for you. Here's my response...",
//     ];
    
//     final response = responses[DateTime.now().millisecond % responses.length];
    
//     messages.add(MessageModel(
//       text: response,
//       isUser: false,
//       time: DateTime.now(),
//     ));
//   }

//   // Voice input method - future implementation
//   Future<void> startVoiceInput() async {
//     try {
//       // Future: Implement speech-to-text
//       Get.snackbar(
//         'Voice Input',
//         'Voice feature coming soon!',
//         snackPosition: SnackPosition.BOTTOM,
//         duration: const Duration(seconds: 2),
//       );
      
//       // Future implementation with your API:
//       // final speechResult = await _speechToText();
//       // if (speechResult.isNotEmpty) {
//       //   messageController.text = speechResult;
//       //   sendMessage();
//       // }
//     } catch (e) {
//       _handleError('Voice input failed: $e');
//     }
//   }

//   // Clear conversation
//   void clearConversation() {
//     messages.clear();
//     _addWelcomeMessage();
//     Get.snackbar(
//       'Conversation Cleared',
//       'Starting fresh conversation',
//       snackPosition: SnackPosition.BOTTOM,
//     );
//   }

//   // Export conversation using your API
//   Future<void> exportConversation() async {
//     try {
//       isLoading.value = true;
      
//       Map<String, dynamic> exportData = {
//         'conversation_id': _getConversationId(),
//         'messages': messages.map((msg) => msg.toJson()).toList(),
//         'export_format': 'json',
//         'timestamp': DateTime.now().toIso8601String(),
//       };

//       final response = await _apiServices.requestPostForApi(
//         url: '$baseUrl/ai/export',
//         dictParameter: exportData,
//         authToken: true,
//       );

//       if (response?.statusCode == 200) {
//         Get.snackbar(
//           'Export Successful',
//           'Conversation exported successfully!',
//           snackPosition: SnackPosition.BOTTOM,
//         );
//       } else {
//         throw Exception('Export failed');
//       }
//     } catch (e) {
//       Get.snackbar(
//         'Export Failed',
//         'Failed to export conversation: $e',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   // Settings - can integrate with your API for user preferences
//   Future<void> openSettings() async {
//     try {
//       // Load AI Assistant settings from your API
//       final response = await _apiServices.getRequest(
//         url: '$baseUrl/ai/settings',
//         authToken: true,
//       );

//       if (response.statusCode == 200) {
//         // Navigate to settings screen with loaded data
//         // Get.toNamed('/ai-settings', arguments: response.data);
//         Get.snackbar(
//           'Settings',
//           'AI Assistant settings loaded!',
//           snackPosition: SnackPosition.BOTTOM,
//         );
//       }
//     } catch (e) {
//       Get.snackbar(
//         'Settings',
//         'Settings feature coming soon!',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     }
//   }

//   // Error handling
//   void _handleError(String error) {
//     messages.add(MessageModel(
//       text: 'Sorry, I encountered an error. Please try again.',
//       isUser: false,
//       time: DateTime.now(),
//       isError: true,
//     ));
//   }

//   // Helper methods
//   String _getConversationId() {
//     // Generate or retrieve conversation ID
//     return 'conv_${DateTime.now().millisecondsSinceEpoch}';
//   }

//   // Get user context for better AI responses
//   Future<Map<String, dynamic>> _getUserContext() async {
//     try {
//       // You can load user context from your API or SharedPreferences
//       return {
//         'user_id': 'current_user_id', // Get from SharedPreferences
//         'language': 'en',
//         'timezone': DateTime.now().timeZoneName,
//         'app_version': '1.0.0',
//       };
//     } catch (e) {
//       return {};
//     }
//   }

//   // Delete specific message (if needed)
//   Future<void> deleteMessage(int index) async {
//     try {
//       final message = messages[index];
      
//       // Call delete API if message is stored on server
//       await _apiServices.deleteRequest(
//         url: '$baseUrl/ai/message/${message.time.millisecondsSinceEpoch}',
//         authToken: true,
//       );

//       messages.removeAt(index);
//       Get.snackbar(
//         'Message Deleted',
//         'Message removed successfully',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     } catch (e) {
//       log('Error deleting message: $e');
//     }
//   }

//   @override
//   void onClose() {
//     animationController.dispose();
//     messageController.dispose();
//     super.onClose();
//   }
// }

// // Message Model - same as before but with additional fields
// class MessageModel {
//   final String text;
//   final bool isUser;
//   final DateTime time;
//   final bool isError;
//   final String? messageId; // For server-side message tracking

//   MessageModel({
//     required this.text,
//     required this.isUser,
//     required this.time,
//     this.isError = false,
//     this.messageId,
//   });

//   // Convert to JSON for API calls
//   Map<String, dynamic> toJson() {
//     return {
//       'text': text,
//       'isUser': isUser,
//       'time': time.toIso8601String(),
//       'isError': isError,
//       'messageId': messageId,
//     };
//   }

//   // Create from JSON (from API response)
//   factory MessageModel.fromJson(Map<String, dynamic> json) {
//     return MessageModel(
//       text: json['text'] ?? '',
//       isUser: json['isUser'] ?? false,
//       time: DateTime.parse(json['time'] ?? DateTime.now().toIso8601String()),
//       isError: json['isError'] ?? false,
//       messageId: json['messageId'],
//     );
//   }
// }

// // AI Assistant Service specifically for your API structure
// class AIAssistantService extends GetxService {
//   final ApiServices _apiServices = ApiServices();
//   static const String baseUrl = 'https://your-api-endpoint.com/api/v1';

//   // Different AI providers integration using your API service
  
//   // Custom AI Integration using your existing API structure
//   Future<String> getCustomAIResponse(String message) async {
//     try {
//       final response = await _apiServices.requestPostForApi(
//         url: '$baseUrl/ai/custom-chat',
//         dictParameter: {
//           'message': message,
//           'model': 'your-ai-model',
//           'max_tokens': 150,
//           'temperature': 0.7,
//         },
//         authToken: true,
//       );

//       if (response?.statusCode == 200) {
//         final data = response!.data;
//         return data['response'] ?? 'Sorry, I couldn\'t process that.';
//       }
//       throw Exception('Custom AI API Error');
//     } catch (e) {
//       throw Exception('Custom AI Error: $e');
//     }
//   }

//   // OpenAI Integration using your API as proxy
//   Future<String> getOpenAIResponse(String message) async {
//     try {
//       final response = await _apiServices.requestPostForApi(
//         url: '$baseUrl/ai/openai-chat',
//         dictParameter: {
//           'message': message,
//           'model': 'gpt-3.5-turbo',
//           'max_tokens': 150,
//         },
//         authToken: true,
//       );

//       if (response?.statusCode == 200) {
//         return response!.data['response'];
//       }
//       throw Exception('OpenAI API Error');
//     } catch (e) {
//       throw Exception('OpenAI Error: $e');
//     }
//   }

//   // Google AI Integration using your API as proxy
//   Future<String> getGoogleAIResponse(String message) async {
//     try {
//       final response = await _apiServices.requestPostForApi(
//         url: '$baseUrl/ai/google-chat',
//         dictParameter: {
//           'message': message,
//           'model': 'gemini-pro',
//         },
//         authToken: true,
//       );

//       if (response?.statusCode == 200) {
//         return response!.data['response'];
//       }
//       throw Exception('Google AI API Error');
//     } catch (e) {
//       throw Exception('Google AI Error: $e');
//     }
//   }
// }