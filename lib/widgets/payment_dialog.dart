import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme.dart';

class PaymentDialog extends StatefulWidget {
  final String upiId;
  final String merchantName;
  final double amount;
  final String transactionNote;
  final String whatsappNumber;

  const PaymentDialog({
    super.key,
    this.upiId = "gy6161375-1@okhdfcbank",
    this.merchantName = "The Rangmanch",
    this.amount = 99.00,
    this.transactionNote = "Beginner Acting Workshop Registration",
    this.whatsappNumber = "917986971024",
  });

  @override
  State<PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<PaymentDialog> {
  bool _copied = false;

  String get _upiUrl {
    final noteEncoded = Uri.encodeComponent(widget.transactionNote);
    final nameEncoded = Uri.encodeComponent(widget.merchantName);
    return "upi://pay?pa=${widget.upiId}&pn=$nameEncoded&am=${widget.amount.toStringAsFixed(2)}&cu=INR&tn=$noteEncoded";
  }

  String get _qrCodeUrl {
    final encodedData = Uri.encodeComponent(_upiUrl);
    return "https://api.qrserver.com/v1/create-qr-code/?size=250x250&margin=10&data=$encodedData";
  }

  Future<void> _launchUpi() async {
    final uri = Uri.parse(_upiUrl);
    
    // Copy to clipboard immediately as fallback
    await Clipboard.setData(ClipboardData(text: widget.upiId));
    if (mounted) {
      setState(() => _copied = true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("UPI ID '${widget.upiId}' copied to clipboard! Opening UPI apps..."),
          backgroundColor: AppColors.primary,
          duration: const Duration(seconds: 5),
        ),
      );
    }

    try {
      // Attempt to launch the UPI app directly
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint("Could not launch UPI URL: $e");
    }
  }

  Future<void> _sendWhatsAppConfirmation() async {
    final message = "Hi Sonam,\n\nI have completed the payment of ₹${widget.amount.toStringAsFixed(0)} for '${widget.transactionNote}'.\n\nHere is my payment receipt screenshot:";
    final encodedMessage = Uri.encodeComponent(message);
    final url = "https://wa.me/${widget.whatsappNumber}?text=$encodedMessage";
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        width: 450,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.2),
              blurRadius: 40,
              spreadRadius: -10,
            ),
          ],
        ),
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Secure UPI Payment",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: AppColors.textMuted),
                  ),
                ],
              ),
              Divider(color: Colors.white12, height: 24),

              // Product Info
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: Column(
                  children: [
                    Text(
                      widget.transactionNote,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "₹${widget.amount.toStringAsFixed(0)}",
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Interactive steps
              Text(
                "STEP 1: MAKE PAYMENT",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(height: 12),

              // Desktop QR Code display vs Mobile launch button
              if (!isMobile) ...[
                // QR Code
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Image.network(
                    _qrCodeUrl,
                    width: 180,
                    height: 180,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return const SizedBox(
                        width: 180,
                        height: 180,
                        child: Center(
                          child: CircularProgressIndicator(color: AppColors.primary),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Scan this QR code using Google Pay, PhonePe, Paytm, or BHIM UPI app.",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ] else ...[
                // Mobile instant pay button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _launchUpi,
                    icon: const Icon(Icons.payment, size: 20),
                    label: const Text("Pay via UPI App"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Launches Google Pay, PhonePe, Paytm, etc.",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12, color: AppColors.textMuted),
                ),
              ],

              const SizedBox(height: 16),

              // Copyable UPI ID Box
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.04),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.08)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SelectableText(
                        widget.upiId,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: widget.upiId));
                        setState(() => _copied = true);
                        Future.delayed(const Duration(seconds: 2), () {
                          if (mounted) setState(() => _copied = false);
                        });
                      },
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: Text(
                          _copied ? "COPIED" : "COPY ID",
                          key: ValueKey(_copied),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: _copied ? Colors.green : AppColors.secondary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              const Divider(color: Colors.white10),
              const SizedBox(height: 16),

              Text(
                "STEP 2: CONFIRM REGISTRATION",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(height: 12),
              
              // WhatsApp receipt button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _sendWhatsAppConfirmation,
                  icon: const FaIcon(FontAwesomeIcons.whatsapp, size: 20),
                  label: const Text("Confirm on WhatsApp"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF25D366),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Send the payment screenshot to get your WhatsApp group link and confirm your seat.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
