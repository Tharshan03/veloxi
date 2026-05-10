import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:internet_file/internet_file.dart';
import 'package:intl/intl.dart';
import '../../extensions/extension_util/context_extensions.dart';
import '../../extensions/extension_util/int_extensions.dart';
import '../../extensions/extension_util/string_extensions.dart';
import '../../extensions/extension_util/widget_extensions.dart';
import '../../main/components/CommonScaffoldComponent.dart';
import '../../main/models/OrderListModel.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';

import '../../extensions/common.dart';
import '../../extensions/decorations.dart';
import '../../extensions/text_styles.dart';
import '../../main.dart';
import '../../main/utils/Common.dart';
import '../../main/utils/Constants.dart';
import '../../main/utils/Images.dart';
import '../../main/utils/Widgets.dart';
import '../../main/utils/dynamic_theme.dart';
import '../screens/OrderDetailScreen.dart';
import '../screens/OrderTrackingScreen.dart';
import 'package:http/http.dart' as http;

class OrderCardComponent extends StatefulWidget {
  final OrderData item;

  OrderCardComponent({required this.item});

  @override
  _OrderCardComponentState createState() => _OrderCardComponentState();
}

class _OrderCardComponentState extends State<OrderCardComponent> {
  @override
  Widget build(BuildContext context) {
    final Color statusAccent = statusColor(widget.item.status.validate());

    return GestureDetector(
      onTap: () {
        OrderDetailScreen(orderId: widget.item.id.validate()).launch(context, pageRouteAnimation: PageRouteAnimation.SlideBottomTop, duration: 400.milliseconds);
      },
      child: Container(
        margin: .only(bottom: 16),
        decoration: boxDecorationWithRoundedCorners(
          borderRadius: BorderRadius.circular(defaultRadius),
          border: Border.all(color: ColorUtils.colorPrimary.withValues(alpha: 0.10)),
          backgroundColor: appStore.isDarkMode ? ColorUtils.cardDarkColor : context.cardColor,
          boxShadow: defaultBoxShadow(
            shadowColor: Colors.black.withValues(alpha: 0.05),
            blurRadius: 22,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(defaultRadius),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
                decoration: BoxDecoration(
                  color: appStore.isDarkMode ? ColorUtils.scaffoldSecondaryDark : const Color(0xFFF3FBFB),
                  border: Border(bottom: BorderSide(color: ColorUtils.borderColor.withValues(alpha: 0.45))),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: boxDecorationWithRoundedCorners(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: ColorUtils.borderColor, width: appStore.isDarkMode ? 0.2 : 1),
                        backgroundColor: appStore.isDarkMode ? ColorUtils.scaffoldSecondaryDark : const Color(0xFFE8FFFC),
                      ),
                      padding: .all(10),
                      child: Image.asset(parcelTypeIcon(widget.item.parcelType.validate()), height: 26, width: 26, color: ColorUtils.colorPrimary),
                    ),
                    12.width,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: .start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(widget.item.parcelType.validate(), style: boldTextStyle(size: 15), maxLines: 1, overflow: TextOverflow.ellipsis),
                              ),
                              Container(
                                padding: .symmetric(horizontal: 10, vertical: 5),
                                decoration: boxDecorationWithRoundedCorners(
                                  borderRadius: BorderRadius.circular(14),
                                  backgroundColor: statusAccent.withValues(alpha: appStore.isDarkMode ? 0.18 : 0.12),
                                ),
                                child: Text(orderStatus(widget.item.status.validate()), style: boldTextStyle(size: 11, color: statusAccent)),
                              ),
                            ],
                          ),
                          4.height,
                          Text('${widget.item.orderTrackingId}', style: secondaryTextStyle(size: 13)),
                          8.height,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (widget.item.date != null)
                                Text(DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.parse("${widget.item.date!}")), style: secondaryTextStyle(size: 12)),
                              if (widget.item.status != ORDER_CANCELLED)
                                Text(printAmount(widget.item.totalAmount ?? 0), style: boldTextStyle(size: 16, color: ColorUtils.colorPrimary)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding: .all(16),
                child: Column(
                  children: [
                    _buildLocationRow(
                      icon: ic_from,
                      label: widget.item.pickupDatetime != null ? language.picked : language.picked,
                      address: widget.item.pickupPoint!.address.validate(),
                      dateTime: widget.item.pickupDatetime,
                      startTime: widget.item.pickupPoint!.startTime,
                      endTime: widget.item.pickupPoint!.endTime,
                      contactNumber: widget.item.pickupPoint!.contactNumber,
                      isPicked: widget.item.pickupDatetime != null,
                      notePrefix: language.courierWillPickupAt,
                    ),
                    Container(
                      margin: .only(left: 11, top: 8, bottom: 8),
                      child: Row(
                        children: [
                          Container(
                            width: 2,
                            height: 32,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  ColorUtils.colorPrimary.withValues(alpha: 0.30),
                                  ColorUtils.colorPrimary.withValues(alpha: 0.08),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildLocationRow(
                      icon: ic_to,
                      label: widget.item.deliveryDatetime != null ? language.delivered : language.delivered,
                      address: widget.item.deliveryPoint!.address.validate(),
                      dateTime: widget.item.deliveryDatetime,
                      startTime: widget.item.deliveryPoint!.startTime,
                      endTime: widget.item.deliveryPoint!.endTime,
                      contactNumber: widget.item.deliveryPoint!.contactNumber,
                      isPicked: widget.item.deliveryDatetime != null,
                      notePrefix: language.courierWillDeliverAt,
                    ),
                    if (widget.item.reScheduleDateTime != null)
                      Container(
                        margin: .only(top: 12),
                        padding: .all(12),
                        decoration: BoxDecoration(
                          color: Colors.orange.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.schedule, size: 16, color: Colors.orange),
                            8.width,
                            Expanded(
                              child: Text(
                                '${language.rescheduleMsg} ${DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.item.reScheduleDateTime!))}',
                                style: secondaryTextStyle(size: 12, color: Colors.orange.shade700),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

              if (widget.item.status == ORDER_DELIVERED || (widget.item.status == ORDER_DEPARTED && appStore.userType != DELIVERY_MAN))
                Container(
                  padding: .only(left: 16, right: 16, bottom: 16),
                  child: Row(
                    children: [
                      if ((widget.item.status == ORDER_DEPARTED) && appStore.userType != DELIVERY_MAN)
                        Expanded(
                          child: Container(
                            height: 44,
                            decoration: BoxDecoration(
                              gradient: ColorUtils.tealGradient,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: .center,
                              children: [
                                Text(language.trackOrder, style: boldTextStyle(color: Colors.white, size: 14)),
                                6.width,
                                const Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                              ],
                            ),
                          ).onTap(() {
                            OrderTrackingScreen(orderData: widget.item).launch(context);
                          }),
                        ),
                      if (widget.item.status == ORDER_DELIVERED)
                        Expanded(
                          child: Container(
                            height: 44,
                            decoration: BoxDecoration(
                              gradient: ColorUtils.tealGradient,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(color: ColorUtils.colorPrimary.withValues(alpha: 0.18), blurRadius: 14, offset: const Offset(0, 6)),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: .center,
                              children: [
                                const Icon(Icons.description_outlined, color: Colors.white, size: 18),
                                8.width,
                                Text(language.invoice, style: boldTextStyle(color: Colors.white, size: 14)),
                              ],
                            ),
                          ).onTap(() {
                            PDFViewer(
                              invoice: "${widget.item.invoice.validate()}",
                              filename: "${widget.item.id.validate()}",
                            ).launch(context);
                          }),
                        ),
                      if (widget.item.status != ORDER_DELIVERED && widget.item.status != ORDER_CANCELLED && (widget.item.status == ORDER_DEPARTED && appStore.userType != DELIVERY_MAN))
                        12.width,
                      if (widget.item.status != ORDER_DELIVERED && widget.item.status != ORDER_CANCELLED)
                        Container(
                          height: 44,
                          width: 44,
                          decoration: BoxDecoration(
                            color: ColorUtils.colorPrimary.withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.navigation, color: ColorUtils.veloxiTeal, size: 20).center(),
                        ).onTap(() {
                          openMap(
                            double.parse(widget.item.pickupPoint!.latitude.validate()),
                            double.parse(widget.item.pickupPoint!.longitude.validate()),
                            double.parse(widget.item.deliveryPoint!.latitude.validate()),
                            double.parse(widget.item.deliveryPoint!.longitude.validate()),
                          );
                        }),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationRow({
    required String icon,
    required String label,
    required String address,
    required String? dateTime,
    required String? startTime,
    required String? endTime,
    required String? contactNumber,
    required bool isPicked,
    required String notePrefix,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ImageIcon(AssetImage(icon), size: 20, color: ColorUtils.colorPrimary),
        12.width,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: secondaryTextStyle(size: 12)),
              4.height,
              Text(address, style: primaryTextStyle()).expand(),
              if (dateTime != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    4.height,
                    Text('${language.at} ${printDateWithoutAt("$dateTime")}', style: secondaryTextStyle(size: 12)),
                  ],
                ),
              if (startTime != null && endTime != null && dateTime == null)
                Text(
                '${language.note} ${notePrefix} ${DateFormat('dd MMM yyyy').format(DateTime.parse(startTime).toLocal())} ${language.from} ${DateFormat('hh:mm').format(DateTime.parse(startTime).toLocal())} ${language.to} ${DateFormat('hh:mm').format(DateTime.parse(endTime).toLocal())}',
                style: secondaryTextStyle(size: 12, color: Colors.red),
              ).paddingOnly(top: 4),
            ],
          ),
        ),
        12.width,
        if (contactNumber != null && widget.item.status != COMPLETED)
          Icon(Ionicons.ios_call_outline, size: 20, color: ColorUtils.colorPrimary).onTap(() {
            commonLaunchUrl('tel:$contactNumber');
          }),
      ],
    );
  }
}

class PDFViewer extends StatefulWidget {
  final String invoice;
  final String? filename;

  PDFViewer({required this.invoice, this.filename = ""});

  @override
  State<PDFViewer> createState() => _PDFViewerState();
}

class _PDFViewerState extends State<PDFViewer> {
  PdfController? pdfController;

  @override
  void initState() {
    super.initState();
    viewPDF();
  }

  Future<void> viewPDF() async {
    try {
      setState(() {
        appStore.setLoading(true);
        print("invoice ==> ${widget.invoice}");
        pdfController = PdfController(document: PdfDocument.openData(InternetFile.get("${widget.invoice}")));
        appStore.setLoading(false);
      });
    } catch (e) {
      print('Error viewing PDF: $e');
    }
  }

  Future<void> downloadPDF() async {
    appStore.setLoading(true);
    final response = await http.get(Uri.parse(widget.invoice));
    if (response.statusCode == 200) {
      print("success ${response.bodyBytes}");
      final bytes = response.bodyBytes;
      // final directory = await getApplicationDocumentsDirectory();
      final directory = await getExternalStorageDirectory();
      final path = directory!.path;
      String fileName = widget.filename.validate().isEmpty ? "invoice" : widget.filename.validate();
      File file = File('${path}/${fileName}.pdf');
      print("file ${file.path}");
      await file.writeAsBytes(bytes, flush: true);
      appStore.setLoading(false);
      toast("invoice downloaded at ${file.path}");
      final filef = File(file.path);
      if (await filef.exists()) {
        OpenFile.open(file.path);
      } else {
        throw 'File does not exist';
      }
      /* if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        throw 'Could not launch $url';
      }*/
    } else {
      appStore.setLoading(false);
      toast("Failed to download pdf");
      throw Exception('Failed to download PDF');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffoldComponent(
        appBar: commonAppBarWidget(language.invoice, actions: [
          Icon(Icons.download, color: Colors.white).withWidth(60).onTap(() {
            downloadPDF();
          }, splashColor: Colors.transparent, hoverColor: Colors.transparent, highlightColor: Colors.transparent),
        ]),
        body: Stack(
          children: [
            PdfView(
              controller: pdfController!,
            ),
            PdfPageNumber(
              controller: pdfController!,
              builder: (_, loadingState, page, pagesCount) {
                if (page == 0) return loaderWidget();
                return SizedBox();
              },
            ),
            Observer(builder: (context) {
              return loaderWidget().visible(appStore.isLoading);
            }),
          ],
        ));
  }
}
