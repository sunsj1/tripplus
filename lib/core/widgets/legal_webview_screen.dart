import 'package:flutter/material.dart';
import 'package:journeyplus/core/constants/app_links.dart';
import 'package:journeyplus/core/theme/app_colors.dart';
import 'package:journeyplus/core/theme/app_text_styles.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Loads a legal page from [journeyplus.in](https://www.journeyplus.in) so
/// policy updates on the website reflect in the app without a new release.
class LegalWebViewScreen extends StatefulWidget {
  const LegalWebViewScreen({
    super.key,
    required this.title,
    required this.url,
  });

  factory LegalWebViewScreen.privacy() => const LegalWebViewScreen(
        title: 'Privacy & location',
        url: AppLinks.privacyPolicyUrl,
      );

  factory LegalWebViewScreen.terms() => const LegalWebViewScreen(
        title: 'Terms & conditions',
        url: AppLinks.termsAndConditionsUrl,
      );

  final String title;
  final String url;

  @override
  State<LegalWebViewScreen> createState() => _LegalWebViewScreenState();
}

class _LegalWebViewScreenState extends State<LegalWebViewScreen> {
  late final WebViewController _controller;
  var _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() {
            _loading = true;
            _error = null;
          }),
          onPageFinished: (_) => setState(() => _loading = false),
          onWebResourceError: (details) => setState(() {
            _loading = false;
            _error = details.description;
          }),
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        title: Text(widget.title, style: AppTextStyles.titleMedium),
        actions: [
          IconButton(
            tooltip: 'Reload',
            onPressed: () => _controller.reload(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_loading)
              const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            if (_error != null && !_loading)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Could not load this page.',
                        style: AppTextStyles.titleSmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _error!,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textTertiary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: () => _controller.reload(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
