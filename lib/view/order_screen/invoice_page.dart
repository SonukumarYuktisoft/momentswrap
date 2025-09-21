import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:Xkart/models/order_model/order_model.dart';
import 'package:Xkart/util/constants/app_colors.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'dart:io';
import 'dart:typed_data';

class InvoicePage extends StatefulWidget {
  final OrderModel order;

  const InvoicePage({super.key, required this.order});

  @override
  State<InvoicePage> createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  bool isGeneratingPDF = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Invoice #${_getFormattedOrderId(widget.order.id)}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.accentColor,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.accentColor,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: isGeneratingPDF ? null : _downloadPDF,
            icon: isGeneratingPDF
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.accentColor,
                    ),
                  )
                : Icon(Icons.download_outlined),
          ),
          IconButton(
            onPressed: isGeneratingPDF ? null : _sharePDF,
            icon: Icon(Icons.share_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.accentColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryColor.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInvoiceHeader(),
                SizedBox(height: 20),
                _buildCompanyInfo(),
                SizedBox(height: 20),
                _buildCustomerInfo(),
                SizedBox(height: 20),
                _buildOrderDetails(),
                SizedBox(height: 20),
                _buildProductsTable(),
                SizedBox(height: 20),
                _buildTotalSection(),
                SizedBox(height: 20),
                _buildPaymentInfo(),
                if (widget.order.notes != null &&
                    widget.order.notes!.isNotEmpty) ...[
                  SizedBox(height: 20),
                  _buildNotesSection(),
                ],
                SizedBox(height: 30),
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInvoiceHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'INVOICE',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
                Text(
                  '#${_getFormattedOrderId(widget.order.id)}',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.successColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.successColor.withOpacity(0.3),
                ),
              ),
              child: Text(
                'DELIVERED',
                style: TextStyle(
                  color: AppColors.successColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Container(
          height: 3,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }

  Widget _buildCompanyInfo() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'From:',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Xkart',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Premium Gift & Craft Solutions',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
          SizedBox(height: 8),
          Text(
            'Email: support@Xkart.com\nPhone: +91 9876543210\nWebsite: www.Xkart.com',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerInfo() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceTint,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bill To:',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          if (widget.order.shippingAddress != null) ...[
            Text(
              widget.order.shippingAddress!.fullName,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textColor,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Phone: ${widget.order.shippingAddress!.phoneNumber}',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            SizedBox(height: 4),
            Text(
              widget.order.shippingAddress!.formattedAddress,
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ] else ...[
            Text(
              'Customer ID: ${widget.order.customer}',
              style: TextStyle(fontSize: 14, color: AppColors.textColor),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOrderDetails() {
    return Row(
      children: [
        Expanded(
          child: _buildDetailCard(
            'Order Date',
            _getFormattedDate(widget.order.createdAt),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildDetailCard(
            'Delivery Date',
            _getFormattedDate(widget.order.updatedAt),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildDetailCard(
            'Payment Method',
            widget.order.paymentMethod.toUpperCase(),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailCard(String title, String value) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsTable() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // Table Header
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Item',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                      fontSize: 12,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Qty',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                      fontSize: 12,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Rate',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                      fontSize: 12,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Amount',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Table Rows
          ...widget.order.products.asMap().entries.map((entry) {
            final index = entry.key;
            final product = entry.value;
            final isLast = index == widget.order.products.length - 1;

            return Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: isLast
                    ? null
                    : Border(
                        bottom: BorderSide(
                          color: AppColors.primaryColor.withOpacity(0.1),
                        ),
                      ),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.product.name,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textColor,
                          ),
                        ),
                        if (product.product.shortDescription.isNotEmpty) ...[
                          SizedBox(height: 2),
                          Text(
                            product.product.shortDescription,
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.textSecondary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '${product.quantity}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textColor,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '₹${product.price.toStringAsFixed(0)}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textColor,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '₹${(product.price * product.quantity).toStringAsFixed(0)}',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textColor,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTotalSection() {
    final subtotal = widget.order.totalAmount;
    final tax = 0.0; // Add tax calculation if needed
    final total = subtotal + tax;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Subtotal:',
                style: TextStyle(fontSize: 14, color: AppColors.textColor),
              ),
              Text(
                '₹${subtotal.toStringAsFixed(0)}',
                style: TextStyle(fontSize: 14, color: AppColors.textColor),
              ),
            ],
          ),
          if (tax > 0) ...[
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tax:',
                  style: TextStyle(fontSize: 14, color: AppColors.textColor),
                ),
                Text(
                  '₹${tax.toStringAsFixed(0)}',
                  style: TextStyle(fontSize: 14, color: AppColors.textColor),
                ),
              ],
            ),
          ],
          SizedBox(height: 12),
          Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  AppColors.primaryColor.withOpacity(0.3),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Amount:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              Text(
                '₹${total.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.successColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentInfo() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceTint,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.payment, color: AppColors.successColor, size: 20),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Payment Status',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              Text(
                widget.order.paymentStatus.toUpperCase(),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.successColor,
                ),
              ),
            ],
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.successColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'PAID',
              style: TextStyle(
                color: AppColors.successColor,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.warningColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.warningColor.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Notes:',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.warningColor,
            ),
          ),
          SizedBox(height: 8),
          Text(
            widget.order.notes!,
            style: TextStyle(fontSize: 12, color: AppColors.warningColor),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Container(
          height: 1,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                AppColors.primaryColor.withOpacity(0.3),
                Colors.transparent,
              ],
            ),
          ),
        ),
        SizedBox(height: 16),
        Text(
          'Thank you for your business!',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'This is a computer generated invoice and does not require a signature.',
          style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  String _getFormattedOrderId(String orderId) {
    return orderId.length >= 8
        ? orderId.substring(orderId.length - 8)
        : orderId;
  }

  String _getFormattedDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _downloadPDF() async {
    setState(() {
      isGeneratingPDF = true;
    });

    try {
      final pdf = await _generateEnhancedPDF();
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf,
        name: 'Invoice_${_getFormattedOrderId(widget.order.id)}.pdf',
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to generate PDF: ${e.toString()}',
        backgroundColor: AppColors.errorColor,
        colorText: AppColors.accentColor,
      );
    } finally {
      setState(() {
        isGeneratingPDF = false;
      });
    }
  }

  Future<void> _sharePDF() async {
    setState(() {
      isGeneratingPDF = true;
    });

    try {
      final pdf = await _generateEnhancedPDF();
      final directory = await getTemporaryDirectory();
      final file = File(
        '${directory.path}/Invoice_${_getFormattedOrderId(widget.order.id)}.pdf',
      );
      await file.writeAsBytes(pdf);

      await Share.shareXFiles([
        XFile(file.path),
      ], text: 'Invoice for Order #${_getFormattedOrderId(widget.order.id)}');
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to share PDF: ${e.toString()}',
        backgroundColor: AppColors.errorColor,
        colorText: AppColors.accentColor,
      );
    } finally {
      setState(() {
        isGeneratingPDF = false;
      });
    }
  }

  Future<Uint8List> _generateEnhancedPDF() async {
    final pdf = pw.Document();

    // Define colors for PDF - using PdfColor with opacity values between 0.0 and 1.0
    final primaryColor = PdfColor.fromHex('#6366F1');
    final greyColor = PdfColor.fromHex('#6B7280');
    final lightGreyColor = PdfColor.fromHex('#F8FAFC');
    final darkColor = PdfColor.fromHex('#1E293B');
    final successColor = PdfColor.fromHex('#10B981');
    final borderColor = PdfColor.fromHex('#E2E8F0');

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(20),
        build: (pw.Context context) {
          return pw.Column(
            children: [
              // Header Section with Company Info and Invoice Details
              pw.Container(
                padding: pw.EdgeInsets.all(16),
                decoration: pw.BoxDecoration(
                  color: lightGreyColor,
                  borderRadius: pw.BorderRadius.circular(8),
                  border: pw.Border.all(color: borderColor),
                ),
                child: pw.Column(
                  children: [
                    // Top Row: Company Name and Invoice Title
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              'Moment Wrap',
                              style: pw.TextStyle(
                                fontSize: 22,
                                fontWeight: pw.FontWeight.bold,
                                color: darkColor,
                              ),
                            ),
                            pw.SizedBox(height: 2),
                            pw.Text(
                              'Your Premium Shopping Destination',
                              style: pw.TextStyle(
                                fontSize: 10,
                                color: greyColor,
                              ),
                            ),
                          ],
                        ),
                        pw.Container(
                          padding: pw.EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: pw.BoxDecoration(
                            color: primaryColor,
                            borderRadius: pw.BorderRadius.circular(6),
                          ),
                          child: pw.Text(
                            'INVOICE',
                            style: pw.TextStyle(
                              fontSize: 20,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.white,
                            ),
                          ),
                        ),
                      ],
                    ),

                    pw.SizedBox(height: 12),

                    // Company Contact Info and Invoice Details
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              'Email: support@momentwrap.com',
                              style: pw.TextStyle(
                                fontSize: 9,
                                color: greyColor,
                              ),
                            ),
                            pw.Text(
                              'Phone: +91-XXXXXXXXXX',
                              style: pw.TextStyle(
                                fontSize: 9,
                                color: greyColor,
                              ),
                            ),
                            pw.Text(
                              'Website: www.momentwrap.com',
                              style: pw.TextStyle(
                                fontSize: 9,
                                color: greyColor,
                              ),
                            ),
                          ],
                        ),
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.end,
                          children: [
                            pw.Text(
                              'Invoice #: INV-${_getFormattedOrderId(widget.order.id)}',
                              style: pw.TextStyle(
                                fontSize: 10,
                                fontWeight: pw.FontWeight.bold,
                                color: darkColor,
                              ),
                            ),
                            pw.Text(
                              'Order ID: ${widget.order.id}',
                              style: pw.TextStyle(
                                fontSize: 9,
                                color: greyColor,
                              ),
                            ),
                            pw.Text(
                              'Order Date: ${_getFormattedDate(widget.order.createdAt)}',
                              style: pw.TextStyle(
                                fontSize: 9,
                                color: greyColor,
                              ),
                            ),
                            pw.SizedBox(height: 4),
                            pw.Container(
                              padding: pw.EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: pw.BoxDecoration(
                                color: PdfColor.fromHex('#DCFCE7'),
                                borderRadius: pw.BorderRadius.circular(3),
                                border: pw.Border.all(color: successColor),
                              ),
                              child: pw.Text(
                                'Status: DELIVERED',
                                style: pw.TextStyle(
                                  fontSize: 8,
                                  fontWeight: pw.FontWeight.bold,
                                  color: successColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 16),

              // Bill To and Ship To Section
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Bill To
                  pw.Expanded(
                    child: pw.Container(
                      padding: pw.EdgeInsets.all(12),
                      decoration: pw.BoxDecoration(
                        color: PdfColors.white,
                        borderRadius: pw.BorderRadius.circular(6),
                        border: pw.Border.all(color: borderColor),
                      ),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'BILL TO:',
                            style: pw.TextStyle(
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                          pw.SizedBox(height: 6),
                          if (widget.order.shippingAddress != null) ...[
                            pw.Text(
                              widget.order.shippingAddress!.fullName,
                              style: pw.TextStyle(
                                fontSize: 11,
                                fontWeight: pw.FontWeight.bold,
                                color: darkColor,
                              ),
                            ),
                            pw.SizedBox(height: 2),
                            pw.Text(
                              widget.order.shippingAddress!.phoneNumber,
                              style: pw.TextStyle(
                                fontSize: 9,
                                color: greyColor,
                              ),
                            ),
                            pw.Text(
                              'Customer ID: ${widget.order.customer}',
                              style: pw.TextStyle(
                                fontSize: 8,
                                color: greyColor,
                              ),
                            ),
                          ] else ...[
                            pw.Text(
                              'Customer ID: ${widget.order.customer}',
                              style: pw.TextStyle(
                                fontSize: 10,
                                color: darkColor,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  pw.SizedBox(width: 10),
                  // Ship To
                  pw.Expanded(
                    child: pw.Container(
                      padding: pw.EdgeInsets.all(12),
                      decoration: pw.BoxDecoration(
                        color: PdfColors.white,
                        borderRadius: pw.BorderRadius.circular(6),
                        border: pw.Border.all(color: borderColor),
                      ),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'SHIP TO:',
                            style: pw.TextStyle(
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                          pw.SizedBox(height: 6),
                          if (widget.order.shippingAddress != null) ...[
                            pw.Text(
                              widget.order.shippingAddress!.fullName,
                              style: pw.TextStyle(
                                fontSize: 11,
                                fontWeight: pw.FontWeight.bold,
                                color: darkColor,
                              ),
                            ),
                            pw.SizedBox(height: 2),
                            pw.Text(
                              widget.order.shippingAddress!.formattedAddress,
                              style: pw.TextStyle(
                                fontSize: 9,
                                color: greyColor,
                              ),
                            ),
                          ] else ...[
                            pw.Text(
                              'Same as billing address',
                              style: pw.TextStyle(
                                fontSize: 9,
                                color: greyColor,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  pw.SizedBox(width: 10),
                  // Order Summary (moved to right side)
                  pw.Container(
                    width: 140,
                    padding: pw.EdgeInsets.all(12),
                    decoration: pw.BoxDecoration(
                      color: lightGreyColor,
                      borderRadius: pw.BorderRadius.circular(6),
                      border: pw.Border.all(color: primaryColor, width: 1.5),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'ORDER SUMMARY',
                          style: pw.TextStyle(
                            fontSize: 10,
                            fontWeight: pw.FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        pw.SizedBox(height: 8),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(
                              'Subtotal:',
                              style: pw.TextStyle(
                                fontSize: 9,
                                color: darkColor,
                              ),
                            ),
                            pw.Text(
                              'Rs. ${widget.order.totalAmount.toStringAsFixed(2)}',
                              style: pw.TextStyle(
                                fontSize: 9,
                                color: darkColor,
                              ),
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 4),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(
                              'Tax (0%):',
                              style: pw.TextStyle(
                                fontSize: 9,
                                color: greyColor,
                              ),
                            ),
                            pw.Text(
                              'Rs. 0.00',
                              style: pw.TextStyle(
                                fontSize: 9,
                                color: greyColor,
                              ),
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 4),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(
                              'Shipping:',
                              style: pw.TextStyle(
                                fontSize: 9,
                                color: greyColor,
                              ),
                            ),
                            pw.Text(
                              'Free',
                              style: pw.TextStyle(
                                fontSize: 9,
                                color: successColor,
                              ),
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 8),
                        pw.Container(
                          width: double.infinity,
                          height: 0.5,
                          color: borderColor,
                        ),
                        pw.SizedBox(height: 8),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(
                              'TOTAL:',
                              style: pw.TextStyle(
                                fontSize: 11,
                                fontWeight: pw.FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                            pw.Text(
                              'Rs. ${widget.order.totalAmount.toStringAsFixed(2)}',
                              style: pw.TextStyle(
                                fontSize: 11,
                                fontWeight: pw.FontWeight.bold,
                                color: successColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              pw.SizedBox(height: 16),

              // Order Information Section (compact)
              pw.Container(
                width: double.infinity,
                padding: pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  color: lightGreyColor,
                  borderRadius: pw.BorderRadius.circular(6),
                  border: pw.Border.all(color: borderColor),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Purchased From: Moment Wrap Online Store',
                      style: pw.TextStyle(fontSize: 9, color: darkColor),
                    ),
                    pw.Text(
                      'Payment Method: ${widget.order.paymentMethod}',
                      style: pw.TextStyle(fontSize: 9, color: darkColor),
                    ),
                    pw.Text(
                      'Payment Status: ${widget.order.paymentStatus}',
                      style: pw.TextStyle(fontSize: 9, color: darkColor),
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 16),

              // Order Items Table (compact)
              pw.Text(
                'ORDER ITEMS',
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              pw.SizedBox(height: 8),

              pw.Container(
                decoration: pw.BoxDecoration(
                  borderRadius: pw.BorderRadius.circular(6),
                  border: pw.Border.all(color: borderColor, width: 1),
                ),
                child: pw.Table(
                  border: pw.TableBorder(
                    horizontalInside: pw.BorderSide(
                      color: borderColor,
                      width: 0.5,
                    ),
                    verticalInside: pw.BorderSide(
                      color: borderColor,
                      width: 0.5,
                    ),
                  ),
                  columnWidths: {
                    0: pw.FixedColumnWidth(25),
                    1: pw.FlexColumnWidth(3),
                    2: pw.FixedColumnWidth(35),
                    3: pw.FixedColumnWidth(70),
                    4: pw.FixedColumnWidth(70),
                  },
                  children: [
                    // Table Header
                    pw.TableRow(
                      decoration: pw.BoxDecoration(
                        color: PdfColor.fromHex('#F1F5F9'),
                      ),
                      children: [
                        pw.Container(
                          padding: pw.EdgeInsets.all(8),
                          child: pw.Text(
                            '#',
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 10,
                              color: primaryColor,
                            ),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                        pw.Container(
                          padding: pw.EdgeInsets.all(8),
                          child: pw.Text(
                            'Product Details',
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 10,
                              color: primaryColor,
                            ),
                          ),
                        ),
                        pw.Container(
                          padding: pw.EdgeInsets.all(8),
                          child: pw.Text(
                            'Qty',
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 10,
                              color: primaryColor,
                            ),
                          ),
                        ),
                        pw.Container(
                          padding: pw.EdgeInsets.all(8),
                          child: pw.Text(
                            'Unit Price',
                            textAlign: pw.TextAlign.right,
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 10,
                              color: primaryColor,
                            ),
                          ),
                        ),
                        pw.Container(
                          padding: pw.EdgeInsets.all(8),
                          child: pw.Text(
                            'Total',
                            textAlign: pw.TextAlign.right,
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 10,
                              color: primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Product Rows
                    ...widget.order.products.asMap().entries.map(
                      (entry) => pw.TableRow(
                        decoration: pw.BoxDecoration(
                          color: entry.key % 2 == 0
                              ? PdfColors.white
                              : PdfColor.fromHex('#FAFAFA'),
                        ),
                        children: [
                          pw.Container(
                            padding: pw.EdgeInsets.all(8),
                            child: pw.Text(
                              '${entry.key + 1}',
                              style: pw.TextStyle(
                                fontSize: 9,
                                color: darkColor,
                              ),
                              textAlign: pw.TextAlign.center,
                            ),
                          ),
                          pw.Container(
                            padding: pw.EdgeInsets.all(8),
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  entry.value.product.name,
                                  style: pw.TextStyle(
                                    fontSize: 9,
                                    fontWeight: pw.FontWeight.bold,
                                    color: darkColor,
                                  ),
                                ),
                                if (entry
                                    .value
                                    .product
                                    .shortDescription
                                    .isNotEmpty) ...[
                                  pw.SizedBox(height: 1),
                                  pw.Text(
                                    entry
                                                .value
                                                .product
                                                .shortDescription
                                                .length >
                                            40
                                        ? '${entry.value.product.shortDescription.substring(0, 40)}...'
                                        : entry.value.product.shortDescription,
                                    style: pw.TextStyle(
                                      fontSize: 8,
                                      color: greyColor,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          pw.Container(
                            padding: pw.EdgeInsets.all(8),
                            child: pw.Text(
                              '${entry.value.quantity}',
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                fontSize: 9,
                                color: darkColor,
                              ),
                            ),
                          ),
                          pw.Container(
                            padding: pw.EdgeInsets.all(8),
                            child: pw.Text(
                              'Rs. ${entry.value.price.toStringAsFixed(2)}',
                              textAlign: pw.TextAlign.right,
                              style: pw.TextStyle(
                                fontSize: 9,
                                color: darkColor,
                              ),
                            ),
                          ),
                          pw.Container(
                            padding: pw.EdgeInsets.all(8),
                            child: pw.Text(
                              'Rs. ${(entry.value.price * entry.value.quantity).toStringAsFixed(2)}',
                              textAlign: pw.TextAlign.right,
                              style: pw.TextStyle(
                                fontSize: 9,
                                fontWeight: pw.FontWeight.bold,
                                color: darkColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 16),

              // Bottom Section with Terms
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Terms & Conditions
                  pw.Expanded(
                    child: pw.Container(
                      padding: pw.EdgeInsets.all(12),
                      decoration: pw.BoxDecoration(
                        color: PdfColors.white,
                        borderRadius: pw.BorderRadius.circular(6),
                        border: pw.Border.all(color: borderColor),
                      ),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'Terms & Conditions:',
                            style: pw.TextStyle(
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                          pw.SizedBox(height: 6),
                          pw.Text(
                            '• All sales are final. Returns accepted within 30 days of delivery.\n• Please retain this invoice for warranty claims and returns.\n• For support, contact us at support@momentwrap.com\n• Quality assurance and customer satisfaction guaranteed.',
                            style: pw.TextStyle(fontSize: 8, color: darkColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Notes section if available
              if (widget.order.notes != null &&
                  widget.order.notes!.isNotEmpty) ...[
                pw.SizedBox(height: 12),
                pw.Container(
                  width: double.infinity,
                  padding: pw.EdgeInsets.all(12),
                  decoration: pw.BoxDecoration(
                    color: PdfColor.fromHex('#FEF3CD'),
                    borderRadius: pw.BorderRadius.circular(6),
                    border: pw.Border.all(color: PdfColor.fromHex('#F59E0B')),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Special Notes:',
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColor.fromHex('#D97706'),
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        widget.order.notes!,
                        style: pw.TextStyle(
                          fontSize: 8,
                          color: PdfColor.fromHex('#92400E'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              pw.SizedBox(height: 12),

              // State ads section
              pw.Container(
                width: double.infinity,
                padding: pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  color: PdfColor.fromHex('#F0F9FF'),
                  borderRadius: pw.BorderRadius.circular(6),
                  border: pw.Border.all(color: PdfColor.fromHex('#0EA5E9')),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      children: [
                        pw.Container(
                          width: 16,
                          height: 16,
                          decoration: pw.BoxDecoration(
                            color: PdfColor.fromHex('#10B981'),
                            borderRadius: pw.BorderRadius.circular(8),
                          ),
                          child: pw.Center(
                            child: pw.Text(
                              '✓',
                              style: pw.TextStyle(
                                fontSize: 10,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColors.white,
                              ),
                            ),
                          ),
                        ),
                        pw.SizedBox(width: 8),
                        pw.Text(
                          'Thank you for supporting a paperless world.',
                          style: pw.TextStyle(
                            fontSize: 10,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColor.fromHex('#0F766E'),
                          ),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 2),
                    pw.Padding(
                      padding: pw.EdgeInsets.only(left: 24),
                      child: pw.Text(
                        'Together, let\'s save trees!',
                        style: pw.TextStyle(
                          fontSize: 8,
                          color: PdfColor.fromHex('#0F766E'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 10),

              // Promotional offers section
              pw.Row(
                children: [
                  // Insurance offer
                  pw.Expanded(
                    child: pw.Container(
                      padding: pw.EdgeInsets.all(10),
                      decoration: pw.BoxDecoration(
                        color: PdfColor.fromHex('#FEF9C3'),
                        borderRadius: pw.BorderRadius.circular(6),
                        border: pw.Border.all(
                          color: PdfColor.fromHex('#EAB308'),
                        ),
                      ),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Row(
                            children: [
                              pw.Container(
                                width: 18,
                                height: 18,
                                decoration: pw.BoxDecoration(
                                  color: PdfColor.fromHex('#1F2937'),
                                  borderRadius: pw.BorderRadius.circular(3),
                                ),
                                child: pw.Center(
                                  child: pw.Text(
                                    '🛡',
                                    style: pw.TextStyle(
                                      fontSize: 10,
                                      color: PdfColors.white,
                                    ),
                                  ),
                                ),
                              ),
                              pw.SizedBox(width: 6),
                              pw.Text(
                                'Up to 15% off',
                                style: pw.TextStyle(
                                  fontSize: 10,
                                  fontWeight: pw.FontWeight.bold,
                                  color: PdfColor.fromHex('#92400E'),
                                ),
                              ),
                              pw.SizedBox(width: 3),
                              pw.Text('🔍', style: pw.TextStyle(fontSize: 8)),
                            ],
                          ),
                          pw.SizedBox(height: 3),
                          pw.Text(
                            'on Insurance',
                            style: pw.TextStyle(
                              fontSize: 8,
                              color: PdfColor.fromHex('#92400E'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  pw.SizedBox(width: 8),
                  // Personal loan offer
                  pw.Expanded(
                    child: pw.Container(
                      padding: pw.EdgeInsets.all(10),
                      decoration: pw.BoxDecoration(
                        color: PdfColor.fromHex('#FED7AA'),
                        borderRadius: pw.BorderRadius.circular(6),
                        border: pw.Border.all(
                          color: PdfColor.fromHex('#F97316'),
                        ),
                      ),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Row(
                            children: [
                              pw.Container(
                                width: 18,
                                height: 18,
                                decoration: pw.BoxDecoration(
                                  color: PdfColor.fromHex('#F97316'),
                                  borderRadius: pw.BorderRadius.circular(3),
                                ),
                                child: pw.Center(
                                  child: pw.Text(
                                    '₹',
                                    style: pw.TextStyle(
                                      fontSize: 12,
                                      fontWeight: pw.FontWeight.bold,
                                      color: PdfColors.white,
                                    ),
                                  ),
                                ),
                              ),
                              pw.SizedBox(width: 6),
                              pw.Text(
                                'Instant Personal Loan',
                                style: pw.TextStyle(
                                  fontSize: 10,
                                  fontWeight: pw.FontWeight.bold,
                                  color: PdfColor.fromHex('#9A3412'),
                                ),
                              ),
                            ],
                          ),
                          pw.SizedBox(height: 3),
                          pw.Text(
                            'Up to ₹5 Lakh Loan',
                            style: pw.TextStyle(
                              fontSize: 8,
                              color: PdfColor.fromHex('#9A3412'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              pw.Spacer(),

              // Footer Section (compact)
              pw.Container(
                width: double.infinity,
                padding: pw.EdgeInsets.all(16),
                decoration: pw.BoxDecoration(
                  color: PdfColor.fromHex('#F8FAFC'),
                  borderRadius: pw.BorderRadius.circular(8),
                  border: pw.Border.all(color: borderColor),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Row(
                      children: [
                        pw.Container(
                          width: 40,
                          height: 40,
                          decoration: pw.BoxDecoration(
                            color: primaryColor,
                            borderRadius: pw.BorderRadius.circular(20),
                          ),
                          child: pw.Center(
                            child: pw.Text(
                              'MW',
                              style: pw.TextStyle(
                                fontSize: 16,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColors.white,
                              ),
                            ),
                          ),
                        ),
                        pw.SizedBox(width: 12),
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              'Thank you for shopping with Moment Wrap!',
                              style: pw.TextStyle(
                                fontSize: 12,
                                fontWeight: pw.FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                            pw.SizedBox(height: 2),
                            pw.Text(
                              'We appreciate your business and hope you love your purchase!',
                              style: pw.TextStyle(
                                fontSize: 8,
                                color: greyColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    pw.Text(
                      'Follow us: @momentwrap',
                      style: pw.TextStyle(
                        fontSize: 9,
                        color: primaryColor,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }
}
