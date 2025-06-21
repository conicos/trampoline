import 'dart:async';
import 'ad_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMob {
  BannerAd? _bannerAd;
  AdMob() {
    _bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: AdHelper.bannerAdUnitId,
        listener: BannerAdListener(
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            ad.dispose();
          },
        ),
        request: const AdRequest());
  }

  void load() async {
    await _bannerAd!.load();
  }

  void dispose() {
    _bannerAd!.dispose();
  }

  Widget getAdBanner() {
    return Container(
      alignment: Alignment.center,
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }

  double getAdBannerHeight() {
    return _bannerAd!.size.height.toDouble();
  }
}

class AdInterstitial {
  InterstitialAd? _interstitialAd;
  int num_of_attempt_load = 0;
  bool? ready;
  AdInterstitial() {}

  // create interstitial ads
  void createAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        // 広告が正常にロードされたときに呼ばれます。
        onAdLoaded: (InterstitialAd ad) {
          print('interstitialad add loaded');
          _interstitialAd = ad;
          num_of_attempt_load = 0;
          ready = true;
          // junkenModel.changeInvalid();
          print(_interstitialAd?.responseInfo);
        },
        // 広告のロードが失敗した際に呼ばれます。
        onAdFailedToLoad: (LoadAdError error) {
          num_of_attempt_load++;
          _interstitialAd = null;
          if (num_of_attempt_load <= 2) {
            createAd();
          }
        },
      ),
    );
  }

  // show interstitial ads to user
  Future<void> showAd() async {
    ready = false;
    if (_interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) {
        print("ad onAdshowedFullscreen");
      },
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print("ad Disposed");
        ad.dispose();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError aderror) {
        print('$ad OnAdFailed $aderror');
        ad.dispose();
        createAd();
      },
    );

    // 広告の表示には.show()を使う
    await _interstitialAd!.show();
    _interstitialAd = null;
  }
}

// class RewardedAdManager
//     implements RewardedAdLoadCallback, FullScreenContentCallback {
//   RewardedAdManager({required this.getReward});

//   RewardedAd? _rewardedAd; // 広告オブジェクト
//   var getReward;

//   // 広告のロード処理
//   void loadRewardedAd() {
//     RewardedAd.load(
//       adUnitId: AdHelper.rewardedAdUnitId,
//       request: const AdRequest(),
//       rewardedAdLoadCallback: RewardedAdLoadCallback(
//         onAdLoaded: (ad) {
//           print('広告を読み込みました。');
//           _rewardedAd = ad; // 広告オブジェクトを保存
//         },
//         onAdFailedToLoad: (error) {
//           print('Ad failed to load: $error');
//         },
//       ),
//     );
//   }

//   // 広告の表示処理
//   void show() async {
//     // 広告が表示されたときの処理
//     _rewardedAd?.fullScreenContentCallback = FullScreenContentCallback(
//       onAdShowedFullScreenContent: (ad) {
//         print('Ad showed fullscreen content.');
//       },
//       // 広告が閉じられたときの処理
//       onAdDismissedFullScreenContent: (ad) {
//         print('Ad dismissed fullscreen content.');
//         ad.dispose();
//         loadRewardedAd();
//       },
//       onAdFailedToShowFullScreenContent: (ad, error) {
//         print('Ad failed to show fullscreen content: $error');
//         ad.dispose();
//         loadRewardedAd();
//       },
//     );

//     // _rewardedAd?.setImmersiveMode(true);
//     await _rewardedAd?.show(
//       // リワード広告再生時の処理
//       onUserEarnedReward: (ad, reward) {
//         print('User earned reward: ${reward.amount} ${reward.type}');
//         // TODO: 報酬を与える処理を追加
//         print('報酬を獲得しました。');
//         getReward();
//       },
//     );
//   }

//   // リワード広告のロードが成功した場合のコールバック
//   @override
//   void onRewardedAdLoaded(RewardedAd ad) {
//     _rewardedAd = ad;
//   }

//   // リワード広告のロードが失敗した場合のコールバック
//   @override
//   void onRewardedAdFailedToLoad(LoadAdError error) {
//     print('Rewarded ad failed to load: $error');
//   }

//   // リワード広告が閉じられた場合のコールバック
//   @override
//   void onRewardedAdDismissed(RewardedAd ad) {
//     ad.dispose();
//     loadRewardedAd();
//   }

//   // リワード広告が表示できなかった場合のコールバック
//   @override
//   void onRewardedAdFailedToShow(RewardedAd ad, AdError error) {
//     ad.dispose();
//     loadRewardedAd();
//   }

//   // 報酬広告が開いたときに実行されるコールバック
//   @override
//   void onRewardedAdOpened(RewardedAd ad) {
//     print('Rewarded ad opened.');
//   }

//   // ユーザーが報酬を獲得したときに実行されるコールバック
//   @override
//   void onUserEarnedReward(RewardedAd ad, RewardItem reward) {
//     print('User earned reward: ${reward.amount} ${reward.type}');
//   }

//   // 広告がクリックされたときに実行されるコールバック
//   @override
//   // TODO: implement onAdClicked
//   GenericAdEventCallback? get onAdClicked => throw UnimplementedError();

//   // フルスクリーン広告が閉じられたときに実行されるコールバック
//   @override
//   // TODO: implement onAdDismissedFullScreenContent
//   GenericAdEventCallback? get onAdDismissedFullScreenContent =>
//       throw UnimplementedError();

//   // 広告の読み込みに失敗したときに実行されるコールバック
//   @override
//   // TODO: implement onAdFailedToLoad
//   FullScreenAdLoadErrorCallback get onAdFailedToLoad =>
//       throw UnimplementedError();

//   // フルスクリーン広告の表示に失敗したときに実行されるコールバック
//   @override
//   // TODO: implement onAdFailedToShowFullScreenContent
//   void Function(dynamic ad, AdError error)?
//       get onAdFailedToShowFullScreenContent => throw UnimplementedError();

//   // 広告が表示されたときに実行されるコールバック
//   @override
//   // TODO: implement onAdImpression
//   GenericAdEventCallback? get onAdImpression => throw UnimplementedError();

//   // 広告が読み込まれたときに実行されるコールバック
//   @override
//   // TODO: implement onAdLoaded
//   GenericAdEventCallback<RewardedAd> get onAdLoaded =>
//       throw UnimplementedError();

//   // フルスクリーン広告が表示されたときに実行されるコールバック
//   @override
//   // TODO: implement onAdShowedFullScreenContent
//   GenericAdEventCallback? get onAdShowedFullScreenContent =>
//       throw UnimplementedError();

//   // フルスクリーン広告が閉じられる直前に実行されるコールバック
//   @override
//   // TODO: implement onAdWillDismissFullScreenContent
//   GenericAdEventCallback? get onAdWillDismissFullScreenContent =>
//       throw UnimplementedError();
// }

class RewardedAdManager {
  RewardedAdManager({required this.getReward});

  RewardedAd? _rewardedAd; // 広告オブジェクト
  var getReward;

  // 広告のロード処理
  Future<void> loadRewardedAd() async {
    final completer = Completer<void>();

    RewardedAd.load(
      adUnitId: AdHelper.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          print('広告を読み込みました。');
          _rewardedAd = ad; // 広告オブジェクトを保存
          _rewardedAd?.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (ad) {
              print('Ad showed fullscreen content.');
            },
            onAdDismissedFullScreenContent: (ad) {
              print('Ad dismissed fullscreen content.');
              ad.dispose();
              loadRewardedAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              print('Ad failed to show fullscreen content: $error');
              ad.dispose();
              loadRewardedAd();
            },
          );
          completer.complete(); // ロード完了
        },
        onAdFailedToLoad: (error) {
          print('Ad failed to load: $error');
          completer.completeError(error); // エラー
        },
      ),
    );

    return completer.future;
  }

  // 広告の表示処理
  Future<void> show() async {
    await _rewardedAd?.show(
      onUserEarnedReward: (ad, reward) {
        print('User earned reward: ${reward.amount} ${reward.type}');
        getReward();
      },
    );
    _rewardedAd = null; // Showした後は広告オブジェクトをクリア
  }

  // 広告のロードと表示を連続して行うメソッド
  Future<void> loadAndShowAd() async {
    await loadRewardedAd();
    await show();
  }
}
