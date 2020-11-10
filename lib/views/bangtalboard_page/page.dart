import 'package:fish_redux/fish_redux.dart';
import 'adapter/adapter.dart';
import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class BangtalboardPage extends Page<BangtalboardState, Map<String, dynamic>>
    with TickerProviderMixin {
  BangtalboardPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<BangtalboardState>(
              adapter: NoneConn<BangtalboardState>() + BantalboardAdapter(),
              slots: <String, Dependent<BangtalboardState>>{}),
          // middleware: <Middleware<BangtalboardState>>[],
        );
}
