import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vpnexues_pvt/core/constants/app_colors.dart';
import 'providers/chat_provider.dart';
import 'widgets/chat_bubble.dart';
import 'widgets/chat_input_bar.dart';
import 'widgets/faq_quick_replies.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatProvider>().initChat();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 2),
            FaqQuickReplies(
              replies: context.watch<ChatProvider>().quickReplies,
              onReply: (text) {
                context.read<ChatProvider>().sendMessage(text);
                _scrollToBottom();
              },
            ),
            const SizedBox(height: 4),
            Expanded(
              child: Consumer<ChatProvider>(
                builder: (context, provider, _) {
                  _scrollToBottom();
                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.only(bottom: 8),
                    itemCount: provider.messages.length,
                    itemBuilder: (context, index) {
                      return ChatBubble(message: provider.messages[index]);
                    },
                  );
                },
              ),
            ),
            ChatInputBar(
              onSend: (text) {
                context.read<ChatProvider>().sendMessage(text);
                _scrollToBottom();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.arrow_back_ios_new,
                  size: 18, color: AppColors.textColor(context)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Support Chat',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textColor(context),
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFF4CAF50),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Active now',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondaryColor(context),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Consumer<ChatProvider>(
            builder: (context, provider, _) {
              final langLabel = provider.language == 'en'
                  ? 'සිංහල'
                  : provider.language == 'si'
                      ? 'தமிழ்'
                      : 'EN';
              return GestureDetector(
                onTap: () => provider.toggleLanguage(),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: AppColors.lightGreen,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.language,
                          size: 14, color: AppColors.primary),
                      const SizedBox(width: 4),
                      Text(
                        langLabel,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
