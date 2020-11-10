import 'package:fish_redux/fish_redux.dart';
import 'package:escroomtok/views/bangtalThema_page/components/info_component/component.dart';
import 'package:escroomtok/views/bangtalThema_page/components/keywords_component/component.dart';
import 'package:escroomtok/views/bangtalThema_page/components/keywords_component/state.dart';

import 'components/info_component/state.dart';
import 'components/menu_component/component.dart';
import 'components/menu_component/state.dart';
import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class BangtalThemaPage extends Page<BangtalThemaPageState, Map<String, dynamic>>
    with TickerProviderMixin {
  BangtalThemaPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<BangtalThemaPageState>(
              adapter: null,
              slots: <String, Dependent<BangtalThemaPageState>>{
                'keywords': KeyWordsConnector() + KeyWordsComponent(),
                'info': InfoConnector() + InfoComponent(),
                'menu': MenuConnector() + MenuComponent()
              }),
          middleware: <Middleware<BangtalThemaPageState>>[],
        );
}
