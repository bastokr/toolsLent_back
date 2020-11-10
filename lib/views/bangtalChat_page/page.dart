import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class BangtalChatPage extends Page<BangtalChatState, Map<String, dynamic>> {
  BangtalChatPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<BangtalChatState>(
              adapter: null, slots: <String, Dependent<BangtalChatState>>{}),
          middleware: <Middleware<BangtalChatState>>[],
        );
}
