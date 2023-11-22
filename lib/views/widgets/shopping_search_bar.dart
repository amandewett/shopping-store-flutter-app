import 'package:flutter/material.dart';

class shoppingSearchBar extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isEnabled;
  final bool isObscure;
  final void Function(String value) onChanged;
  final String hintText;
  final String labelText;
  final void Function() onTapSuffixIcon;
  final String? Function(BuildContext, String?) validator;
  final bool autoFocus;

  const shoppingSearchBar({
    Key? key,
    required this.textEditingController,
    this.isEnabled = true,
    this.isObscure = false,
    required this.onChanged,
    required this.hintText,
    required this.labelText,
    required this.onTapSuffixIcon,
    required this.validator,
    this.autoFocus = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      child: TextFormField(
        controller: textEditingController,
        keyboardType: TextInputType.text,
        autofocus: autoFocus,
        maxLines: 1,
        enabled: isEnabled,
        onChanged: (textValue) => onChanged(textValue),
        obscureText: isObscure,
        style: Theme.of(context).textTheme.labelMedium,
        decoration: InputDecoration(
          isDense: true,
          labelStyle: Theme.of(context).textTheme.labelMedium?.apply(
                color: Theme.of(context).colorScheme.primary,
              ),
          hintStyle: Theme.of(context).textTheme.labelMedium?.apply(
                color: Theme.of(context).colorScheme.primary,
                fontWeightDelta: -1,
              ),
          hintText: hintText,
          filled: !isEnabled,
          fillColor: Theme.of(context).scaffoldBackgroundColor,
          border: OutlineInputBorder(
            gapPadding: 4.0,
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(25.0),
          ),
          enabledBorder: OutlineInputBorder(
            gapPadding: 4.0,
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(25.0),
          ),
          focusedBorder: OutlineInputBorder(
            gapPadding: 4.0,
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(25.0),
          ),
          disabledBorder: OutlineInputBorder(
            gapPadding: 4.0,
            borderSide: BorderSide(
              color: Theme.of(context).hintColor,
              width: isEnabled ? 1.0 : 1.0,
            ),
            borderRadius: BorderRadius.circular(25.0),
          ),
          errorBorder: OutlineInputBorder(
            gapPadding: 1.0,
            borderSide: BorderSide(
              color: Theme.of(context).hintColor,
              width: isEnabled ? 1.0 : 1.0,
            ),
            borderRadius: BorderRadius.circular(25.0),
          ),
          errorStyle: Theme.of(context).textTheme.titleLarge!.apply(
                color: Theme.of(context).colorScheme.error,
                fontSizeDelta: -7,
              ),
          suffixIcon: GestureDetector(
            onTap: onTapSuffixIcon,
            child: Icon(
              Icons.search,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        validator: (String? value) => validator(context, value),
      ),
    );
  }
}
