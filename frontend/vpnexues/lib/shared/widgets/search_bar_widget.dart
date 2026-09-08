import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../../features/search/search_screen.dart';
import 'package:vpnexues_pvt/core/constants/app_colors.dart';
import 'package:vpnexues_pvt/shared/utils/responsive.dart';
import 'package:vpnexues_pvt/shared/localization/language_provider.dart';

class SearchBarWidget extends StatefulWidget {
  final VoidCallback? onFilterTap;
  const SearchBarWidget({super.key, this.onFilterTap});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final SpeechToText _speechToText = SpeechToText();
  bool _isListening = false;

  Future<void> _startListening() async {
    bool available = await _speechToText.initialize(
      onError: (_) => setState(() => _isListening = false),
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          setState(() => _isListening = false);
        }
      },
    );
    if (available) {
      setState(() => _isListening = true);
      await _speechToText.listen(
        onResult: (result) {
          if (result.finalResult && result.recognizedWords.isNotEmpty) {
            setState(() => _isListening = false);
            if (!mounted) return;
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => SearchScreen(initialQuery: result.recognizedWords),
              ),
            );
          }
        },
        listenOptions: SpeechListenOptions(
          listenFor: const Duration(seconds: 10),
          localeId: 'en_IN',
        ),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Microphone permission denied')),
      );
    }
  }

  Future<void> _stopListening() async {
    await _speechToText.stop();
    setState(() => _isListening = false);
  }

  @override
  void dispose() {
    _speechToText.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filterPadding = Responsive.isSmallPhone(context) ? 14.0 : 20.0;
    final lang = context.watch<LanguageProvider>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SearchScreen()),
                );
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.cardShadow,
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 14),
                    const Icon(Icons.search, color: AppColors.textLightGray, size: 22),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        lang.t('search_vegetables'),
                        style: const TextStyle(
                          color: AppColors.textLightGray,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (_isListening) {
                          await _stopListening();
                        } else {
                          await _startListening();
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: _isListening ? AppColors.primary.withValues(alpha: 0.15) : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _isListening ? Icons.mic : Icons.mic_none,
                          color: _isListening ? AppColors.primary : AppColors.textLightGray,
                          size: 22,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: widget.onFilterTap,
            child: Container(
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: filterPadding),
              decoration: BoxDecoration(
                color: AppColors.filterGreen,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(
                  lang.t('search_filter'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
