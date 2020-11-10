import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class BangtalCreatePage extends Page<BangtalCreateState, Map<String, dynamic>> {
  BangtalCreatePage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<BangtalCreateState>(
              adapter: null, slots: <String, Dependent<BangtalCreateState>>{}),
          middleware: <Middleware<BangtalCreateState>>[],
        );
}
