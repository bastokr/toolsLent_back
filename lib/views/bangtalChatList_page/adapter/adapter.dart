import 'package:fish_redux/fish_redux.dart';
import '../itemDetail_component/component.dart';

import '../state.dart';
import 'reducer.dart';

class BangtalChatListAdapter extends SourceFlowAdapter<BangtalChatListState> {
  BangtalChatListAdapter()
      : super(
          pool: <String, Component<Object>>{'detail': ItemDetailComponent()},
          reducer: buildReducer(),
        );
}
