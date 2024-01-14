import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MaginotDialog extends StatefulWidget {
  final TextEditingController controller;
  const MaginotDialog({super.key, required this.controller});

  @override
  State<MaginotDialog> createState() => _MaginotDialogState();
}

class _MaginotDialogState extends State<MaginotDialog> {
  List textAndDate = [];
  final _formKey = GlobalKey<FormState>();

  var selectedDate = DateTime.now();

  void onSavePressed() {
    if (widget.controller.text == "") {
      _formKey.currentState!.validate();
      return;
    }
    textAndDate.add(widget.controller.text);
    final finalDate =
        DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    textAndDate.add(finalDate);
    widget.controller.clear();
    Navigator.pop(context, textAndDate);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: AlertDialog(
        title: const Text("Add new maginot"),
        content: SizedBox(
          height: 250,
          width: 250,
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: TextFormField(
                  onChanged: (value) {
                    if (value != '' && value.isNotEmpty) {
                      _formKey.currentState!.validate();
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "This is required";
                    }
                    return null;
                  },
                  controller: widget.controller,
                  cursorColor: Theme.of(context).primaryColor,
                  decoration: const InputDecoration(
                    hintText: "Task",
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 140,
                child: CupertinoDatePicker(
                  minimumDate: DateTime.now(),
                  mode: CupertinoDatePickerMode.date,
                  onDateTimeChanged: (date) {
                    setState(() {
                      selectedDate = date;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  widget.controller.clear();
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                  foregroundColor: const MaterialStatePropertyAll(Colors.grey),
                  overlayColor: MaterialStatePropertyAll(Colors.grey.shade500),
                ),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: onSavePressed,
                style: ButtonStyle(
                  foregroundColor:
                      MaterialStatePropertyAll(Theme.of(context).primaryColor),
                  overlayColor: MaterialStatePropertyAll(
                      Theme.of(context).primaryColor.withOpacity(0.2)),
                ),
                child: const Text("Add"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
