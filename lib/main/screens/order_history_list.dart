import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import '../../extensions/extension_util/context_extensions.dart';
import '../../extensions/extension_util/int_extensions.dart';
import '../../extensions/extension_util/string_extensions.dart';
import '../../extensions/extension_util/widget_extensions.dart';
import '../../main/components/CommonScaffoldComponent.dart';
import '../../extensions/common.dart';
import '../../extensions/decorations.dart';
import '../../extensions/text_styles.dart';
import '../../main.dart';
import '../../user/components/OrderCardComponent.dart';
import '../models/OrderListModel.dart';
import '../network/RestApis.dart';
import '../utils/Common.dart';
import '../utils/Constants.dart';
import '../utils/Images.dart';
import '../utils/dynamic_theme.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  List<OrderData> orderList = [];
  int page = 1;
  int totalPage = 1;
  bool isLastPage = false;
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    getOrdersHistoryListApi();
  }

  getOrdersHistoryListApi() async {
    await getUserOrderHistoryList(page: page).then((value) {
      totalPage = value.pagination!.totalPages.validate(value: 1);
      page = value.pagination!.currentPage.validate(value: 1);
      isLastPage = false;
      if (page == 1) orderList.clear();
      orderList.addAll(value.data!);
      appStore.setLoading(false);
      setState(() {});
    }).catchError((e) {
      isLastPage = true;
      toast(e.toString(), print: true);
    }).whenComplete(() => appStore.setLoading(false));
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffoldComponent(
      appBarTitle: language.completedOrders,
      body: Observer(builder: (context) {
        return Stack(
          children: [
            appStore.isLoading
                ? loaderWidget()
                : orderList.length > 0
                    ? ListView.builder(
                        itemCount: orderList.length,
                        itemBuilder: (context, index) {
                          return OrderHistoryItem(orderData: orderList[index]).paddingAll(10);
                        })
                    : emptyWidget()
          ],
        );
      }),
    );
  }
}

class OrderHistoryItem extends StatelessWidget {
  final OrderData orderData;
  OrderHistoryItem({super.key, required this.orderData});

  @override
  Widget build(BuildContext context) {
    final bool isDelivered = orderData.status == ORDER_DELIVERED;
    final String statusLabel = orderData.status.validate().isNotEmpty
        ? orderStatus(orderData.status.validate())
        : language.delivered;
    final Color statusAccent = statusColor(orderData.status.validate());
    final Color headerTint = appStore.isDarkMode ? ColorUtils.scaffoldSecondaryDark : const Color(0xFFF3FBFB);

    return Container(
      width: context.width(),
      margin: .only(bottom: 16),
      decoration: boxDecorationWithRoundedCorners(
        borderRadius: BorderRadius.circular(defaultRadius),
        border: Border.all(color: ColorUtils.colorPrimary.withValues(alpha: 0.10)),
        backgroundColor: appStore.isDarkMode ? ColorUtils.cardDarkColor : context.cardColor,
        boxShadow: defaultBoxShadow(
          shadowColor: Colors.black.withValues(alpha: 0.06),
          blurRadius: 24,
          spreadRadius: 0,
          offset: const Offset(0, 10),
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
                color: headerTint,
                border: Border(bottom: BorderSide(color: ColorUtils.borderColor.withValues(alpha: 0.45))),
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: boxDecorationWithRoundedCorners(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: ColorUtils.borderColor, width: appStore.isDarkMode ? 0.2 : 1),
                          backgroundColor: appStore.isDarkMode ? ColorUtils.scaffoldSecondaryDark : const Color(0xFFE8FFFC),
                        ),
                        padding: .all(10),
                        child: Image.asset(
                          parcelTypeIcon(orderData.parcelType.validate()),
                          height: 26,
                          width: 26,
                          color: ColorUtils.colorPrimary,
                        ),
                      ),
                      12.width,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: .start,
                          children: [
                            Text(orderData.parcelType.validate(), style: boldTextStyle(size: 15), maxLines: 1, overflow: TextOverflow.ellipsis),
                            4.height,
                            Text('VELO-${orderData.id}', style: secondaryTextStyle(size: 13)),
                            8.height,
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                _miniBadge(
                                  context,
                                  text: statusLabel,
                                  color: statusAccent,
                                  background: statusAccent.withValues(alpha: appStore.isDarkMode ? 0.18 : 0.12),
                                ),
                                if (orderData.date != null)
                                  _miniBadge(
                                    context,
                                    text: DateFormat('dd MMM, hh:mm a').format(DateTime.parse("${orderData.date!}")),
                                    color: textSecondaryColorGlobal,
                                    background: appStore.isDarkMode ? ColorUtils.scaffoldSecondaryDark : Colors.white,
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (orderData.status != ORDER_CANCELLED)
                        Text(
                          printAmount(orderData.totalAmount ?? 0),
                          style: boldTextStyle(size: 16, color: ColorUtils.colorPrimary),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  _buildTimelineRow(
                    context,
                    icon: ic_from,
                    title: language.picked,
                    address: orderData.pickupPoint!.address.validate(),
                    dateTime: orderData.pickupDatetime,
                  ),
                  Container(
                    margin: .only(left: 11, top: 8, bottom: 8),
                    width: 2,
                    height: 26,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          ColorUtils.colorPrimary.withValues(alpha: 0.28),
                          ColorUtils.colorPrimary.withValues(alpha: 0.08),
                        ],
                      ),
                    ),
                  ),
                  _buildTimelineRow(
                    context,
                    icon: ic_to,
                    title: language.delivered,
                    address: orderData.deliveryPoint!.address.validate(),
                    dateTime: orderData.deliveryDatetime,
                  ),
                  if (isDelivered) ...[
                    16.height,
                    Container(
                      width: context.width(),
                      decoration: BoxDecoration(
                        gradient: ColorUtils.tealGradient,
                        borderRadius: BorderRadius.circular(defaultRadius),
                        boxShadow: [
                          BoxShadow(
                            color: ColorUtils.colorPrimary.withValues(alpha: 0.22),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(defaultRadius),
                          onTap: () {
                            print("invice ${orderData.invoice}");
                            PDFViewer(
                              invoice: "${orderData.invoice.validate()}",
                              filename: "${orderData.id.validate()}",
                            ).launch(context);
                          },
                          child: Padding(
                            padding: .symmetric(horizontal: 12, vertical: 14),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Ionicons.md_download_outline, color: Colors.white, size: 18),
                                8.width,
                                Text(language.invoice, style: boldTextStyle(color: Colors.white, size: 14)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _miniBadge(BuildContext context, {required String text, required Color color, required Color background}) {
    return Container(
      padding: .symmetric(horizontal: 10, vertical: 5),
      decoration: boxDecorationWithRoundedCorners(
        borderRadius: BorderRadius.circular(14),
        backgroundColor: background,
      ),
      child: Text(text, style: boldTextStyle(size: 11, color: color)),
    );
  }

  Widget _buildTimelineRow(
    BuildContext context, {
    required String icon,
    required String title,
    required String address,
    String? dateTime,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: boxDecorationWithRoundedCorners(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: ColorUtils.borderColor, width: appStore.isDarkMode ? 0.2 : 1),
            backgroundColor: appStore.isDarkMode ? ColorUtils.scaffoldSecondaryDark : const Color(0xFFF7FFFE),
          ),
          padding: .all(8),
          child: Image.asset(icon, height: 20, width: 20, color: ColorUtils.colorPrimary),
        ),
        12.width,
        Expanded(
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Text(title, style: secondaryTextStyle(size: 12, color: ColorUtils.colorPrimary)),
              4.height,
              Text(address, style: primaryTextStyle(size: 14), maxLines: 2, overflow: TextOverflow.ellipsis),
              if (dateTime != null) ...[
                6.height,
                Container(
                  padding: .symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: ColorUtils.colorPrimary.withValues(alpha: appStore.isDarkMode ? 0.16 : 0.08),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(printDateWithoutAt("${dateTime}Z"), style: secondaryTextStyle(size: 11)),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
