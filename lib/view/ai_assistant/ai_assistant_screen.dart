// AI Assistant Bottom Sheet Widget
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:Xkart/util/constants/app_colors.dart';

class AIAssistantBottomSheet extends StatefulWidget {
  @override
  _AIAssistantBottomSheetState createState() => _AIAssistantBottomSheetState();
}

class _AIAssistantBottomSheetState extends State<AIAssistantBottomSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  TextEditingController _messageController = TextEditingController();
  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _slideAnimation = Tween<Offset>(begin: Offset(0, 1), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );

    _animationController.forward();

    // Initial welcome message
    messages.add({
      'text': 'Hello! I\'m your AI Assistant. How can I help you today?',
      'isUser': false,
      'time': DateTime.now(),
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      messages.add({
        'text': _messageController.text.trim(),
        'isUser': true,
        'time': DateTime.now(),
      });
    });

    String userMessage = _messageController.text.trim();
    _messageController.clear();

    // Simulate AI response
    Future.delayed(Duration(milliseconds: 1000), () {
      setState(() {
        messages.add({
          'text': _getAIResponse(userMessage),
          'isUser': false,
          'time': DateTime.now(),
        });
      });
    });
  }

  String _getAIResponse(String message) {
    // Simple AI responses - you can integrate with actual AI API
    List<String> responses = [
      "That's an interesting question! Let me help you with that.",
      "I understand your query. Here's what I can suggest...",
      "Based on your message, I recommend...",
      "Great question! Here's my analysis...",
      "I'm here to assist you. Let me provide some insights...",
    ];

    return responses[DateTime.now().millisecond % responses.length];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return SlideTransition(
            position: _slideAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.8,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, -5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Header with handle and close button
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                        ),
                      ),
                      child: Column(
                        children: [
                          // Handle
                          Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: AppColors.accentColor.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          SizedBox(height: 12),
                          // Header title and close button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.assistant,
                                    color: AppColors.accentColor,
                                    size: 24,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'AI Assistant',
                                    style: TextStyle(
                                      color: AppColors.accentColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () => Get.back(),
                                child: Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: AppColors.accentColor.withOpacity(
                                      0.2,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    color: AppColors.accentColor,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Messages area
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.all(16),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          return _buildMessageBubble(message);
                        },
                      ),
                    ),

                    // Input area
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        border: Border(
                          top: BorderSide(color: Colors.grey[200]!),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(color: Colors.grey[300]!),
                              ),
                              child: TextField(
                                controller: _messageController,
                                decoration: InputDecoration(
                                  hintText: 'Ask me anything...',
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: _sendMessage,
                                    icon: Icon(
                                      Icons.send,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                ),
                                onSubmitted: (_) => _sendMessage(),
                                textInputAction: TextInputAction.send,
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          // Voice input button (optional)
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: IconButton(
                              onPressed: () {
                                // Voice input functionality
                                Get.snackbar(
                                  'Voice Input',
                                  'Voice feature coming soon!',
                                  snackPosition: SnackPosition.BOTTOM,
                                );
                              },
                              icon: Icon(
                                Icons.mic,
                                color: AppColors.accentColor,
                              ),
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
        },
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    bool isUser = message['isUser'];

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primaryColor,
              child: Icon(
                Icons.assistant,
                color: AppColors.accentColor,
                size: 16,
              ),
            ),
            SizedBox(width: 8),
          ],

          Flexible(
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isUser ? AppColors.primaryColor : Colors.grey[200],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomLeft: isUser ? Radius.circular(16) : Radius.circular(4),
                  bottomRight: isUser
                      ? Radius.circular(4)
                      : Radius.circular(16),
                ),
              ),
              child: Text(
                message['text'],
                style: TextStyle(
                  color: isUser ? AppColors.accentColor : Colors.black87,
                  fontSize: 14,
                ),
              ),
            ),
          ),

          if (isUser) ...[
            SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey[300],
              child: Icon(Icons.person, color: Colors.grey[700], size: 16),
            ),
          ],
        ],
      ),
    );
  }
}

// Alternative: AI Assistant Screen (if you want full screen instead)
class AIAssistantScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI Assistant'),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.accentColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // AI Assistant settings
            },
          ),
        ],
      ),
      body: AIAssistantBottomSheet(), // Reuse the same widget
    );
  }
}

  // // FloatingActionButton with AI Assistant Bottom Sheet
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => _showAIAssistantBottomSheet(),
      //   backgroundColor: AppColors.primaryColor,
      //   child: Icon(
      //     Icons.assistant, // AI Assistant icon
      //     color: AppColors.accentColor,
      //   ),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

// // Usage in your routes (if you want full screen option)
// // Add this to your AppRoutes
// class AppRoutes {
//   static const String aiAssistant = '/ai-assistant';
//   // ... other routes
// }

// Add this to your GetPages
