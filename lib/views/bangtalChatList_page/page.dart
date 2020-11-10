import 'package:fish_redux/fish_redux.dart';
import 'adapter/adapter.dart';
import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class BangtalChatListPage
    extends Page<BangtalChatListState, Map<String, dynamic>>
    with TickerProviderMixin {
  BangtalChatListPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<BangtalChatListState>(
              adapter:
                  NoneConn<BangtalChatListState>() + BangtalChatListAdapter(),
              slots: <String, Dependent<BangtalChatListState>>{}),
          // middleware: <Middleware<BangtalChatListState>>[],
        );
}
