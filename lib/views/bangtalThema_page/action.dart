import 'package:fish_redux/fish_redux.dart';
import 'package:escroomtok/models/image_model.dart';
import 'package:escroomtok/models/media_account_state_model.dart';
import 'package:escroomtok/models/movie_detail.dart';
import 'package:escroomtok/models/review.dart';
import 'package:escroomtok/models/video_model.dart';
import 'package:palette_generator/palette_generator.dart';

enum BangtalThemaPageAction {
  action,
  init,
  setbgcolor,
  setVideos,
  setImages,
  setReviews,
  setAccountState,
  recommendationTapped,
  castCellTapped,
  openMenu,
  showSnackBar
}

class BangtalThemaPageActionCreator {
  static Action onAction() {
    return const Action(BangtalThemaPageAction.action);
  }

  static Action onInit(MovieDetailModel model) {
    return Action(BangtalThemaPageAction.init, payload: model);
  }

  static Action onsetColor(PaletteGenerator c) {
    return Action(BangtalThemaPageAction.setbgcolor, payload: c);
  }

  static Action onSetImages(ImageModel c) {
    return Action(BangtalThemaPageAction.setImages, payload: c);
  }

  static Action onSetReviews(ReviewModel c) {
    return Action(BangtalThemaPageAction.setReviews, payload: c);
  }

  static Action onSetVideos(VideoModel c) {
    return Action(BangtalThemaPageAction.setVideos, payload: c);
  }

  static Action onRecommendationTapped(int movieid, String backpic) {
    return Action(BangtalThemaPageAction.recommendationTapped,
        payload: [movieid, backpic]);
  }

  static Action onCastCellTapped(
      int peopleid, String profilePath, String profileName) {
    return Action(BangtalThemaPageAction.castCellTapped,
        payload: [peopleid, profilePath, profileName]);
  }

  static Action onSetAccountState(MediaAccountStateModel model) {
    return Action(BangtalThemaPageAction.setAccountState, payload: model);
  }

  static Action openMenu() {
    return Action(BangtalThemaPageAction.openMenu);
  }

  static Action showSnackBar(String message) {
    return Action(BangtalThemaPageAction.showSnackBar, payload: message);
  }
}
