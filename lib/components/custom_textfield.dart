import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:videohub/core/services/algorithms.dart';

class CustomTextField extends StatelessWidget {
  final String? label, hintText, suffixText;
  final IconData? icon, suffixIcon;
  final bool? enable, readOnly;
  final int? minLines, maxLines;
  final TextInputType? keyboardType;
  final TextAlign? textAlign;
  final EdgeInsets? padding;
  final TextEditingController? controller;
  final Function()? suffixAction;
  final Function(String)? onChanged;
  final Function()? action;
  const CustomTextField({Key? key, this.label, this.hintText, this.keyboardType, this.padding, this.minLines, this.textAlign, this.readOnly, this.maxLines, this.icon, this.suffixIcon, this.suffixText, required this.enable, this.onChanged, this.action, required this.controller, this.suffixAction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          label != null ? Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Text(label!),
          ) : Container(),
          TextFormField(
            enabled: enable,
            controller: controller,
            onChanged: onChanged,
            onTap: enable == true ? action : null,
            readOnly: readOnly ?? false,
            maxLines: maxLines,
            minLines: minLines,
            keyboardType: keyboardType,
            textAlign: textAlign ?? TextAlign.start,
            decoration: InputDecoration(
              prefixIcon: Icon(icon ?? Iconsax.user),
              suffixIcon: suffixAction != null ? null : (suffixIcon != null ? Icon(suffixIcon) : null),
              suffixText: suffixText,
              hintText: hintText,
              enabled: enable ?? true
            ),
          ),
        ],
      ),
    );
  }
}

class CustomNumberTextField extends StatelessWidget {
  final String? title, label, hintText;
  final bool? enable;
  final TextEditingController? controller;
  final Function()? onSubstractAction, onAddAction;
  final Function(String)? onChanged;
  const CustomNumberTextField({Key? key, this.label, this.hintText, this.title, this.onChanged, required this.enable, required this.controller, this.onSubstractAction, this.onAddAction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        (title != null || hintText != null) && enable != false ? Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: Text((title ?? hintText!)),
        ) : Container(),
        Row(
          children: [
            enable == false ? Expanded(child: Text((title ?? hintText!)), flex: 12,) : Container(),
            Expanded(
              child: TextFormField(
                enabled: enable,
                controller: controller,
                onChanged: onChanged,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  prefixIcon: enable == true ? IconButton(icon: const Icon(Iconsax.minus_cirlce), onPressed: () {Algorithms.digitInputOperation(controller: controller!, isAddition: false); onChanged != null ? onChanged!("d") : debugPrint("no");} ) : null,
                  suffixIcon: enable == true ? IconButton(onPressed: () {Algorithms.digitInputOperation(controller: controller!, isAddition: true); onChanged != null ? onChanged!("") : debugPrint("no");} , icon: const Icon(Iconsax.add_circle) ) : null,
                  hintText: hintText,
                  enabled: enable ?? true
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
