import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'state.dart';
import 'view.dart';

class SwiperComponent extends Component<SwiperState> {
  SwiperComponent()
      : super(
          shouldUpdate: (oldState, newState) {
            return oldState.banktalNewThema != newState.banktalNewThema ||
                oldState.banktaltok != newState.banktaltok;
          },
          effect: buildEffect(),
          view: buildView,
          dependencies: Dependencies<SwiperState>(
              adapter: null, slots: <String, Dependent<SwiperState>>{}),
        );
}
