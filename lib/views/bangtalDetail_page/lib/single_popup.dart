import 'package:flutter/material.dart';
import 'package:smart_select/smart_select.dart';
import 'choices.dart' as choices;

class FeaturesSinglePopup extends StatefulWidget {
  @override
  _FeaturesSinglePopupState createState() => _FeaturesSinglePopupState();
}

class _FeaturesSinglePopupState extends State<FeaturesSinglePopup> {
  String _fruit = 'mel';
  String _framework = 'flu';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SmartSelect<String>.single(
          title: '방탕출카페',
          value: _framework,
          choiceItems: choices.frameworks,
          modalType: S2ModalType.popupDialog,
          onChange: (state) => setState(() => _framework = state.value),
          tileBuilder: (context, state) {
            return ListTile(
              subtitle: Text(state.title),
              title: Text(
                state.valueDisplay,
                style: TextStyle(color: Colors.grey),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              leading: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Text('${state.valueDisplay[0]}',
                    style: TextStyle(color: Colors.white)),
              ),
              trailing:
                  const Icon(Icons.keyboard_arrow_right, color: Colors.grey),
              onTap: state.showModal,
            );
          },
        ),
        const SizedBox(height: 7),
      ],
    );
  }
}
