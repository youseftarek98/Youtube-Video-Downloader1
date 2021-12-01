import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../add_manager.dart';
import '../downloader.dart';

class BrowserPage extends StatefulWidget {
  const BrowserPage({Key? key}) : super(key: key);

  @override
  _BrowserPageState createState() => _BrowserPageState();
}

class _BrowserPageState extends State<BrowserPage> {
  final link = "https://www.youtube.com";

   WebViewController? _controller;

  bool _showDownloadButton = false;

  void checkUrl() async {
    if (await _controller!.currentUrl() == "https://www.youtube.com") {
      setState(() {
        _showDownloadButton = false;
      });
    } else {
      setState(() {
        _showDownloadButton = true;
      });
    }
  }

  ///------- AdMobAds ----------- ///
  BannerAd? _bottomBannerAd;
  bool isLoaded = false;
  late AdsManager adManager;

  void getBottomBannerAd(AdsManager adManager) {
    _bottomBannerAd = BannerAd(
      adUnitId: adManager.bannerAdUnitId,
      size: AdSize.largeBanner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            isLoaded = true;
            print('Ad loaded to load==============: $isLoaded !!!!!!');
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          //ad.dispose();
          print('Ad failed to load=====================: $error');
        },
      ),
    )..load();
  }

  Widget showAd() {
    return isLoaded
        ? Container(
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xffffda11), ),
        //color: Color(0xffffda11),
      ),
      alignment: Alignment.center,
      height: _bottomBannerAd!.size.height.toDouble() ,
      width: _bottomBannerAd!.size.width.toDouble(),
      child: AdWidget(ad: _bottomBannerAd!),
    )
        : Container(
      color: Colors.black87,
      alignment: Alignment.center,
      width: double.infinity,
      height: 50,
    );
  }
//------- AdMobAds -----------

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
//------- AdMobAds -----------
    adManager = Provider.of<AdsManager>(context);
    adManager.initialization.then((value) {
      getBottomBannerAd(adManager);
    });
    //------- AdMobAds -----------
  }

  @override
  void dispose() {
    super.dispose();
    _bottomBannerAd!.dispose(); //------- AdMobAds -----------
  }
  ///------- AdMobAds ----------- ///

  @override
  Widget build(BuildContext context) {
    checkUrl();
    return WillPopScope(
      onWillPop: () async {
        if (await _controller!.canGoBack()) {
          _controller!.goBack();
        }
        return false;
      },
      child: Scaffold(
        body: WebView(
          initialUrl: link,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (controller) {
            setState(() {
              _controller = controller;
            });
          },
        ),
        bottomNavigationBar: showAd(),
        floatingActionButton: _showDownloadButton == false
            ? Container()
            : FloatingActionButton(
                backgroundColor: Colors.pinkAccent,
                onPressed: () async {
               final url =  await _controller!.currentUrl();
               final title = await _controller!.getTitle() ;
               print(title);

               ///Download().downloadVideo( url! , 'Youtube Download ') ;

               Download().downloadVideo(url!, "$title");

                },
                child: const Icon(Icons.download),

              ),
      ),
    );
  }
}
