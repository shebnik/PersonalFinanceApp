import 'package:flutter/material.dart';

// ignore: must_be_immutable
class RadioGroup extends StatefulWidget {
  final List<String> items;
  final int groupId;
  final Function onSelected;
  int selected = 0;
  final bool isDisabled;

  RadioGroup({
    Key? key,
    required this.items,
    required this.groupId,
    required this.onSelected,
    required this.selected,
    this.isDisabled = false,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RadioGroupState();
}

class _RadioGroupState extends State<RadioGroup> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
            padding: const EdgeInsets.only(top: 12),
            child: GestureDetector(
              onTap: () {
                if (!widget.isDisabled) {
                  onChangedState(index);
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: Radio(
                      value: index == widget.selected ? 1 : 0,
                      groupValue: widget.groupId,
                      onChanged: widget.isDisabled
                          ? null
                          : (value) => onChangedState(index),
                      activeColor: Theme.of(context).primaryColor,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text(
                      widget.items[index],
                      style: const TextStyle(fontSize: 14),
                    ),
                  )
                ],
              ),
            ));
      },
      itemCount: widget.items.length,
    );
  }

  void onChangedState(index) {
    setState(() {
      widget.selected = index;
    });
    widget.onSelected(index);
  }
}
