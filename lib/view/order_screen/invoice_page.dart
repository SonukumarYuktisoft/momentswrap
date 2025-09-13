import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:momentswrap/models/order_model/order_model.dart';
import 'package:momentswrap/util/constants/app_colors.dart';
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
            'MomentsWrap',
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
            'Email: support@momentswrap.com\nPhone: +91 9876543210\nWebsite: www.momentswrap.com',
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
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(30),
        build: (pw.Context context) {
          return [
            // Header Section with Company Info and Invoice Details
            pw.Container(
              padding: pw.EdgeInsets.all(20),
              decoration: pw.BoxDecoration(
                color: lightGreyColor,
                borderRadius: pw.BorderRadius.circular(10),
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
                              fontSize: 26,
                              fontWeight: pw.FontWeight.bold,
                              color: darkColor,
                            ),
                          ),
                          pw.SizedBox(height: 4),
                          pw.Text(
                            'Your Premium Shopping Destination',
                            style: pw.TextStyle(
                              fontSize: 12,
                              color: greyColor,
                            ),
                          ),
                        ],
                      ),
                      pw.Container(
                        padding: pw.EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: pw.BoxDecoration(
                          color: primaryColor,
                          borderRadius: pw.BorderRadius.circular(8),
                        ),
                        child: pw.Text(
                          'INVOICE',
                          style: pw.TextStyle(
                            fontSize: 24,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  pw.SizedBox(height: 20),
                  
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
                            style: pw.TextStyle(fontSize: 10, color: greyColor),
                          ),
                          pw.Text(
                            'Phone: +91-XXXXXXXXXX',
                            style: pw.TextStyle(fontSize: 10, color: greyColor),
                          ),
                          pw.Text(
                            'Website: www.momentwrap.com',
                            style: pw.TextStyle(fontSize: 10, color: greyColor),
                          ),
                        ],
                      ),
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Text(
                            'Invoice #: INV-${_getFormattedOrderId(widget.order.id)}',
                            style: pw.TextStyle(
                              fontSize: 12,
                              fontWeight: pw.FontWeight.bold,
                              color: darkColor,
                            ),
                          ),
                          pw.Text(
                            'Order ID: ${widget.order.id}',
                            style: pw.TextStyle(fontSize: 10, color: greyColor),
                          ),
                          pw.Text(
                            'Order Date: ${_getFormattedDate(widget.order.createdAt)}',
                            style: pw.TextStyle(fontSize: 10, color: greyColor),
                          ),
                          pw.SizedBox(height: 8),
                          pw.Container(
                            padding: pw.EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: pw.BoxDecoration(
                              color: PdfColor.fromHex('#DCFCE7'),
                              borderRadius: pw.BorderRadius.circular(4),
                              border: pw.Border.all(color: successColor),
                            ),
                            child: pw.Text(
                              'Status: DELIVERED',
                              style: pw.TextStyle(
                                fontSize: 10,
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

            pw.SizedBox(height: 25),

            // Bill To and Ship To Section
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Bill To
                pw.Expanded(
                  child: pw.Container(
                    padding: pw.EdgeInsets.all(16),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.white,
                      borderRadius: pw.BorderRadius.circular(8),
                      border: pw.Border.all(color: borderColor),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'BILL TO:',
                          style: pw.TextStyle(
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        pw.SizedBox(height: 10),
                        if (widget.order.shippingAddress != null) ...[
                          pw.Text(
                            widget.order.shippingAddress!.fullName,
                            style: pw.TextStyle(
                              fontSize: 14,
                              fontWeight: pw.FontWeight.bold,
                              color: darkColor,
                            ),
                          ),
                          pw.SizedBox(height: 4),
                          pw.Text(
                            widget.order.shippingAddress!.phoneNumber,
                            style: pw.TextStyle(fontSize: 12, color: greyColor),
                          ),
                          pw.Text(
                            'Customer ID: ${widget.order.customer}',
                            style: pw.TextStyle(fontSize: 10, color: greyColor),
                          ),
                        ] else ...[
                          pw.Text(
                            'Customer ID: ${widget.order.customer}',
                            style: pw.TextStyle(fontSize: 12, color: darkColor),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                pw.SizedBox(width: 15),
                // Ship To
                pw.Expanded(
                  child: pw.Container(
                    padding: pw.EdgeInsets.all(16),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.white,
                      borderRadius: pw.BorderRadius.circular(8),
                      border: pw.Border.all(color: borderColor),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'SHIP TO:',
                          style: pw.TextStyle(
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        pw.SizedBox(height: 10),
                        if (widget.order.shippingAddress != null) ...[
                          pw.Text(
                            widget.order.shippingAddress!.fullName,
                            style: pw.TextStyle(
                              fontSize: 14,
                              fontWeight: pw.FontWeight.bold,
                              color: darkColor,
                            ),
                          ),
                          pw.SizedBox(height: 4),
                          pw.Text(
                            widget.order.shippingAddress!.formattedAddress,
                            style: pw.TextStyle(fontSize: 12, color: greyColor),
                          ),
                        ] else ...[
                          pw.Text(
                            'Same as billing address',
                            style: pw.TextStyle(fontSize: 12, color: greyColor),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),

            pw.SizedBox(height: 25),

            // Order Information Section
            pw.Container(
              width: double.infinity,
              padding: pw.EdgeInsets.all(16),
              decoration: pw.BoxDecoration(
                color: lightGreyColor,
                borderRadius: pw.BorderRadius.circular(8),
                border: pw.Border.all(color: borderColor),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'ORDER INFORMATION',
                    style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  pw.SizedBox(height: 12),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        'Purchased From: Moment Wrap Online Store',
                        style: pw.TextStyle(fontSize: 11, color: darkColor),
                      ),
                      pw.Text(
                        'Payment Method: ${widget.order.paymentMethod}',
                        style: pw.TextStyle(fontSize: 11, color: darkColor),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 4),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        'Payment Status: ${widget.order.paymentStatus}',
                        style: pw.TextStyle(fontSize: 11, color: darkColor),
                      ),
                      pw.Text(
                        'Estimated Delivery: ${_getFormattedDate(widget.order.updatedAt)}',
                        style: pw.TextStyle(fontSize: 11, color: darkColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            pw.SizedBox(height: 25),

            // Order Items Table
            pw.Text(
              'ORDER ITEMS',
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
                color: primaryColor,
              ),
            ),
            pw.SizedBox(height: 12),

            pw.Container(
              decoration: pw.BoxDecoration(
                borderRadius: pw.BorderRadius.circular(8),
                border: pw.Border.all(color: borderColor, width: 1),
              ),
              child: pw.Table(
                border: pw.TableBorder(
                  horizontalInside: pw.BorderSide(color: borderColor, width: 0.5),
                  verticalInside: pw.BorderSide(color: borderColor, width: 0.5),
                ),
                columnWidths: {
                  0: pw.FixedColumnWidth(30),
                  1: pw.FlexColumnWidth(3),
                  2: pw.FixedColumnWidth(40),
                  3: pw.FixedColumnWidth(80),
                  4: pw.FixedColumnWidth(80),
                },
                children: [
                  // Table Header
                  pw.TableRow(
                    decoration: pw.BoxDecoration(
                      color: PdfColor.fromHex('#F1F5F9'),
                    ),
                    children: [
                      pw.Container(
                        padding: pw.EdgeInsets.all(12),
                        child: pw.Text(
                          '#',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 12,
                            color: primaryColor,
                          ),
                          textAlign: pw.TextAlign.center,
                        ),
                      ),
                      pw.Container(
                        padding: pw.EdgeInsets.all(12),
                        child: pw.Text(
                          'Product Details',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 12,
                            color: primaryColor,
                          ),
                        ),
                      ),
                      pw.Container(
                        padding: pw.EdgeInsets.all(12),
                        child: pw.Text(
                          'Qty',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 12,
                            color: primaryColor,
                          ),
                        ),
                      ),
                      pw.Container(
                        padding: pw.EdgeInsets.all(12),
                        child: pw.Text(
                          'Unit Price',
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 12,
                            color: primaryColor,
                          ),
                        ),
                      ),
                      pw.Container(
                        padding: pw.EdgeInsets.all(12),
                        child: pw.Text(
                          'Total',
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 12,
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
                        color: entry.key % 2 == 0 ? PdfColors.white : PdfColor.fromHex('#FAFAFA'),
                      ),
                      children: [
                        pw.Container(
                          padding: pw.EdgeInsets.all(12),
                          child: pw.Text(
                            '${entry.key + 1}',
                            style: pw.TextStyle(fontSize: 11, color: darkColor),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                        pw.Container(
                          padding: pw.EdgeInsets.all(12),
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                entry.value.product.name,
                                style: pw.TextStyle(
                                  fontSize: 11,
                                  fontWeight: pw.FontWeight.bold,
                                  color: darkColor,
                                ),
                              ),
                              if (entry.value.product.shortDescription.isNotEmpty) ...[
                                pw.SizedBox(height: 2),
                                pw.Text(
                                  entry.value.product.shortDescription,
                                  style: pw.TextStyle(
                                    fontSize: 9,
                                    color: greyColor,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        pw.Container(
                          padding: pw.EdgeInsets.all(12),
                          child: pw.Text(
                            '${entry.value.quantity}',
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(fontSize: 11, color: darkColor),
                          ),
                        ),
                        pw.Container(
                          padding: pw.EdgeInsets.all(12),
                          child: pw.Text(
                            'Rs. ${entry.value.price.toStringAsFixed(2)}',
                            textAlign: pw.TextAlign.right,
                            style: pw.TextStyle(fontSize: 11, color: darkColor),
                          ),
                        ),
                        pw.Container(
                          padding: pw.EdgeInsets.all(12),
                          child: pw.Text(
                            'Rs. ${(entry.value.price * entry.value.quantity).toStringAsFixed(2)}',
                            textAlign: pw.TextAlign.right,
                            style: pw.TextStyle(
                              fontSize: 11,
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

            pw.SizedBox(height: 25),

            // Bottom Section with Terms and Order Summary
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Terms & Conditions
                pw.Expanded(
                  flex: 2,
                  child: pw.Container(
                    padding: pw.EdgeInsets.all(16),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.white,
                      borderRadius: pw.BorderRadius.circular(8),
                      border: pw.Border.all(color: borderColor),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Terms & Conditions:',
                          style: pw.TextStyle(
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        pw.SizedBox(height: 10),
                        pw.Text(
                          '• All sales are final. Returns accepted within 30 days of delivery.',
                          style: pw.TextStyle(fontSize: 9, color: darkColor),
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text(
                          '• Please retain this invoice for warranty claims and returns.',
                          style: pw.TextStyle(fontSize: 9, color: darkColor),
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text(
                          '• For support, contact us at support@momentwrap.com',
                          style: pw.TextStyle(fontSize: 9, color: darkColor),
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text(
                          '• Quality assurance and customer satisfaction guaranteed.',
                          style: pw.TextStyle(fontSize: 9, color: darkColor),
                        ),
                      ],
                    ),
                  ),
                ),
                pw.SizedBox(width: 20),
                // Order Summary
                pw.Container(
                  width: 180,
                  padding: pw.EdgeInsets.all(20),
                  decoration: pw.BoxDecoration(
                    color: lightGreyColor,
                    borderRadius: pw.BorderRadius.circular(8),
                    border: pw.Border.all(color: primaryColor, width: 2),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'ORDER SUMMARY',
                        style: pw.TextStyle(
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      pw.SizedBox(height: 15),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            'Subtotal:',
                            style: pw.TextStyle(fontSize: 11, color: darkColor),
                          ),
                          pw.Text(
                            'Rs. ${widget.order.totalAmount.toStringAsFixed(2)}',
                            style: pw.TextStyle(fontSize: 11, color: darkColor),
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 8),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            'Tax (0%):',
                            style: pw.TextStyle(fontSize: 11, color: greyColor),
                          ),
                          pw.Text(
                            'Rs. 0.00',
                            style: pw.TextStyle(fontSize: 11, color: greyColor),
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 8),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            'Shipping:',
                            style: pw.TextStyle(fontSize: 11, color: greyColor),
                          ),
                          pw.Text(
                            'Free',
                            style: pw.TextStyle(fontSize: 11, color: successColor),
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 12),
                      pw.Container(
                        width: double.infinity,
                        height: 1,
                        color: borderColor,
                      ),
                      pw.SizedBox(height: 12),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            'TOTAL:',
                            style: pw.TextStyle(
                              fontSize: 14,
                              fontWeight: pw.FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                          pw.Text(
                            'Rs. ${widget.order.totalAmount.toStringAsFixed(2)}',
                            style: pw.TextStyle(
                              fontSize: 14,
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

            pw.SizedBox(height: 30),

            // Footer Section
            pw.Container(
              width: double.infinity,
              padding: pw.EdgeInsets.all(25),
              decoration: pw.BoxDecoration(
                color: PdfColor.fromHex('#F8FAFC'),
                borderRadius: pw.BorderRadius.circular(10),
                border: pw.Border.all(color: borderColor),
              ),
              child: pw.Column(
                children: [
                  // Logo placeholder - you can replace this with actual logo
                  pw.Container(
                    width: 60,
                    height: 60,
                    decoration: pw.BoxDecoration(
                      color: primaryColor,
                      borderRadius: pw.BorderRadius.circular(30),
                    ),
                    child: pw.Center(
                      child: pw.Text(
                        'MW',
                        style: pw.TextStyle(
                          fontSize: 20,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.white,
                        ),
                      ),
                    ),
                  ),
                  pw.SizedBox(height: 15),
                  pw.Text(
                    'Thank you for shopping with Moment Wrap!',
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  pw.SizedBox(height: 8),
                  pw.Text(
                    'We appreciate your business and hope you love your purchase!',
                    style: pw.TextStyle(fontSize: 11, color: greyColor),
                    textAlign: pw.TextAlign.center,
                  ),
                  pw.SizedBox(height: 15),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Text(
                        'Follow us: ',
                        style: pw.TextStyle(fontSize: 10, color: greyColor),
                      ),
                      pw.Text(
                        '@momentwrap',
                        style: pw.TextStyle(
                          fontSize: 10,
                          color: primaryColor,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Notes section if available
            if (widget.order.notes != null && widget.order.notes!.isNotEmpty) ...[
              pw.SizedBox(height: 20),
              pw.Container(
                width: double.infinity,
                padding: pw.EdgeInsets.all(16),
                decoration: pw.BoxDecoration(
                  color: PdfColor.fromHex('#FEF3CD'),
                  borderRadius: pw.BorderRadius.circular(8),
                  border: pw.Border.all(color: PdfColor.fromHex('#F59E0B')),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Special Notes:',
                      style: pw.TextStyle(
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColor.fromHex('#D97706'),
                      ),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text(
                      widget.order.notes!,
                      style: pw.TextStyle(
                        fontSize: 11,
                        color: PdfColor.fromHex('#92400E'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ];
        },
        footer: (pw.Context context) {
          return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: pw.EdgeInsets.only(top: 15),
            child: pw.Text(
              'Page ${context.pageNumber} of ${context.pagesCount}',
              style: pw.TextStyle(fontSize: 10, color: greyColor),
            ),
          );
        },
      ),
    );

    return pdf.save();
  }
}