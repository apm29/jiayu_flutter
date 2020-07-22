import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:jiayu_flutter/components/scroll/ImagePlaceholder.dart';
import 'package:jiayu_flutter/model/GoodsDetail.dart';
import 'package:jiayu_flutter/pages/style/styles.dart';
import 'package:jiayu_flutter/store/stores/GoodsStore.dart';
import 'package:redux/redux.dart';

///
/// author : apm29
/// date : 2020/7/21 3:09 PM
/// description :
///
class GoodsDetailPage extends StatelessWidget {
  final String goodsId;

  const GoodsDetailPage({Key key, this.goodsId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StoreProvider<GoodsStore>(
        store: goodsStore,
        child: Builder(
          builder: (context) => StoreConnector<GoodsStore, GoodsDetail>(
            converter: (store) {
              var detail = store.state.goodsDetail;
              return detail;
            },
            onInit: (store) =>
                store.dispatch(GoodsDetailLoadAction(context, goodsId)),
            builder: (context, goodsDetail) => Scaffold(
              body: goodsDetail == null
                  ? Center(
                      child: CupertinoActivityIndicator(),
                    )
                  : CustomScrollView(
                      slivers: <Widget>[
                        CupertinoSliverRefreshControl(
                          onRefresh: () async {
                            await StoreProvider.of<GoodsStore>(context,
                                    listen: false)
                                .dispatch(
                                    GoodsDetailLoadAction(context, goodsId));
                          },
                        ),
                        SliverToBoxAdapter(
                          child: Stack(
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.width * 0.618,
                                child:
                                    StoreConnector<GoodsStore, PageController>(
                                  converter: (store) =>
                                      store.state.pageController,
                                  builder: (context, controller) =>
                                      PageView.builder(
                                    controller: controller,
                                    itemBuilder: (context, index) =>
                                        ImageWithPlaceholder(
                                      src: goodsDetail.goods.gallery[index],
                                    ),
                                    itemCount: goodsDetail.goods.gallery.length,
                                  ),
                                ),
                              ),
                              StoreConnector<GoodsStore, PageController>(
                                converter: (store) =>
                                    store.state.pageController,
                                builder: (context, controller) => Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: PageViewIndicator(
                                    pageController: controller,
                                    count: goodsDetail.goods.gallery.length,
                                  ),
                                ),
                              ),
                              SafeArea(child: BackButton())
                            ],
                          ),
                        ),
                        SliverList(
                          delegate: SliverChildListDelegate.fixed(
                            [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 6,
                                ),
                                child: Text(
                                  goodsDetail.goods.name,
                                  style: goodsDetailTitleStyle,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 6,
                                ),
                                child: Text(
                                  goodsDetail.goods.brief,
                                  style: goodsDetailBriefStyle,
                                ),
                              ),
                              SubTitle('商品信息'),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 6,
                                ),
                                child: Wrap(
                                  children: [
                                    PriceTag(
                                        goodsDetail.goods.originPrice, '市场价'),
                                    PriceTag(
                                        goodsDetail.goods.retailPrice, '底价'),
                                    ...goodsDetail.attributes
                                        .map((e) => AttributeTag(e))
                                        .toList()
                                  ],
                                ),
                              ),
                              SubTitle('商品规格'),
                              SpecificationGrid(),
                              SubTitle('商品详情'),
                              Html(data: goodsDetail.goods.detail),
                            ],
                          ),
                        )
                      ],
                    ),
            ),
          ),
        ),
      ),
      extendBody: true,
      bottomNavigationBar: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: MaterialButton(
              onPressed: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.star,color: Colors.white,),
                  Text(
                    '收藏',
                    style: goodsDetailFooterStyle,
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(vertical: 10),
              color: mainColor,
            ),
          ),
          Expanded(
            flex: 3,
            child: MaterialButton(
                onPressed: () {},
                child: Text(
                  '咨询客服',
                  style: goodsDetailFooterStyle,
                ),
                padding: EdgeInsets.symmetric(vertical: 10),
                color: mainSecondaryColor),
          ),
        ],
      ),
    );
  }
}

class PageViewIndicator extends StatefulWidget {
  final PageController pageController;
  final int count;

  const PageViewIndicator({Key key, this.pageController, this.count})
      : super(key: key);

  @override
  _PageViewIndicatorState createState() => _PageViewIndicatorState();
}

class _PageViewIndicatorState extends State<PageViewIndicator> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    widget.pageController.addListener(changeIndex);
  }

  void changeIndex() {
    setState(() {
      var index = widget.pageController.page.round();
      currentIndex = index;
    });
  }

  @override
  void dispose() {
    widget.pageController.removeListener(changeIndex);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.count <= 1
        ? Container()
        : Container(
            margin: EdgeInsets.only(bottom: 12),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.count, (index) => index)
                  .map((e) => Container(
                        width: currentIndex == e ? 30 : 20,
                        height: 4,
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        color: currentIndex == e ? mainColor : Colors.grey,
                      ))
                  .toList(),
            ),
          );
  }
}

class SubTitle extends StatelessWidget {
  final String text;

  const SubTitle(
    this.text, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 6),
          padding: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          color: mainSecondaryColor,
          child: Text(
            text,
            style: goodsDetailBriefStyle.copyWith(color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class AttributeTag extends StatelessWidget {
  final Attributes attributes;

  const AttributeTag(
    this.attributes, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12, right: 32),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            attributes.attribute,
            style: goodsDetailBriefStyle,
          ),
          SizedBox(
            width: 18,
          ),
          Text(
            attributes.value,
            style: goodsDetailTagStyle,
          ),
        ],
      ),
    );
  }
}

class PriceTag extends StatelessWidget {
  final dynamic price;
  final String tag;

  const PriceTag(
    this.price,
    this.tag, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12, right: 32),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            tag,
            style: goodsDetailBriefStyle,
          ),
          SizedBox(
            width: 18,
          ),
          Text(
            '¥' + price.toString(),
            style: goodsDetailTagStyle,
          ),
        ],
      ),
    );
  }
}

class SpecificationGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: StoreBuilder<GoodsStore>(
        builder: (context, store) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...store.state.specificationsMap.keys
                .map((specificationKeys) =>
                    buildSpecificationRow(specificationKeys, store))
                .toList(),
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 8,
              ),
              child: PriceTag(store.state.currentProducts?.price, '价格'),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 8,
              ),
              child: AttributeTag(Attributes(
                  attribute: '库存',
                  value: '${store.state.currentProducts?.number}')),
            ),
            ImageWithPlaceholder(
              src: store.state.currentProducts?.url,
            ),
          ],
        ),
      ),
    );
  }

  Container buildSpecificationRow(
      String specificationKeys, Store<GoodsStore> store) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Row(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(8.0),
            constraints: BoxConstraints(minWidth: 50),
            child: Text(
              specificationKeys,
              style: goodsDetailBriefStyle,
            ),
          ),
          Expanded(
            child: Wrap(
              children: store.state.specificationsMap[specificationKeys]
                  .map(
                    (e) => buildSpecificationValue(e, store),
                  )
                  .toList(),
            ),
          )
        ],
      ),
    );
  }

  GestureDetector buildSpecificationValue(
      Specifications e, Store<GoodsStore> store) {
    return GestureDetector(
      onTap: () {
        store.dispatch(ChangeSpecificationAction(e));
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        margin: EdgeInsets.only(right: 12),
        constraints: BoxConstraints(minWidth: 80),
        color: store.state.specificationMatch(e)
            ? mainColor
            : Colors.grey[400],
        child: Text(
          e.value,
          textAlign: TextAlign.center,
          style: goodsDetailBriefStyle.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
