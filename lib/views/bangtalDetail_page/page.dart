import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class BangtalDetailPage extends Page<BangtalDetailState, Map<String, dynamic>> {
  BangtalDetailPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<BangtalDetailState>(
              adapter: null, slots: <String, Dependent<BangtalDetailState>>{}),
          middleware: <Middleware<BangtalDetailState>>[],
        );
}
