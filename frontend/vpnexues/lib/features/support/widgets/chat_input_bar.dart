import 'package:flutter/material.dart';
import 'package:vpnexues_pvt/core/constants/app_colors.dart';

class ChatInputBar extends StatefulWidget {
  final Function(String) onSend;
  final bool enabled;

  const ChatInputBar({super.key, required this.onSend, this.enabled = true});

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onSend(text);
    _controller.clear();
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 14,
        right: 10,
        top: 10,
        bottom: MediaQuery.of(context).padding.bottom + 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              constraints: const BoxConstraints(maxHeight: 100),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(22),
              ),
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                enabled: widget.enabled,
                textInputAction: TextInputAction.newline,
                maxLines: null,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF333333),
                ),
                decoration: const InputDecoration(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(
                    color: Color(0xFF999999),
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0E5A35), Color(0xFF1B7A4A)],
              ),
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              onPressed: widget.enabled ? _handleSend : null,
              icon: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}
