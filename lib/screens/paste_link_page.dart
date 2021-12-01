import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:untitled/downloader.dart';
import 'package:untitled/get_shared_data.dart';

import '../add_manager.dart';

class PasteLink extends StatefulWidget {
  const PasteLink({Key? key}) : super(key: key);

  @override
  _PasteLinkState createState() => _PasteLinkState();
}

class _PasteLinkState extends State<PasteLink> {
  final TextEditingController _textController = TextEditingController();
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
  void initState() {
    DataClass().sharedData().then((value) {
      setState(() {
        _textController.text = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
bottomNavigationBar: showAd(),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextFormField(
              controller: _textController,
              decoration: const InputDecoration(
                  labelText: 'Paste Youtube Video Link...'),
            ),
            GestureDetector(
              onTap: () {
                if (_textController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("No Link Pasted")));
                } else {
                  Download().downloadVideo(
                      _textController.text.trim(), 'Youtube Download ');
                }
              },
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(top: 20),
                color: Colors.pinkAccent,
                padding: const EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width,
                child: const Text(
                  'Download video ',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ) ,
          ],
        ),
      ),
    );
  }
}
