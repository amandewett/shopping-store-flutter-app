import 'package:flutter/material.dart';
import 'package:shopping_store/constants/app_sizes.dart';

class shoppingTextFormField extends StatelessWidget {
  final TextEditingController textEditingController;
  final TextInputType textInputType;
  final int maxLines;
  final bool isObscure;
  final String hintText;
  final String labelText;
  final bool isSuffixIcon;
  final void Function() onTapSuffixIcon;
  final bool isFieldEmpty;
  final String? Function(BuildContext, String?) validator;
  final void Function(String value) onChanged;
  final bool isEnabled;
  final IconData suffixIcon;

  const shoppingTextFormField({
    Key? key,
    required this.textEditingController,
    this.textInputType = TextInputType.text,
    this.maxLines = 1,
    this.isObscure = false,
    required this.hintText,
    required this.labelText,
    this.isSuffixIcon = false,
    required this.onTapSuffixIcon,
    this.isFieldEmpty = false,
    required this.validator,
    required this.onChanged,
    this.isEnabled = true,
    this.suffixIcon = Icons.remove_red_eye,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      keyboardType: textInputType,
      maxLines: maxLines,
      enabled: isEnabled,
      onChanged: (value) => onChanged(value),
      obscureText: isObscure,
      style: Theme.of(context).textTheme.bodySmall?.apply(),
      decoration: InputDecoration(
        isDense: true,
        labelStyle: Theme.of(context).textTheme.bodySmall?.apply(
              color: Theme.of(context).primaryColor,
            ),
        hintStyle: Theme.of(context).textTheme.bodySmall?.apply(
              color: Theme.of(context).hintColor,
            ),
        hintText: hintText,
        labelText: labelText,
        border: OutlineInputBorder(
          gapPadding: 1.0,
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(
            AppSizes.cardBorderRadius + 10,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          gapPadding: 1.0,
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(
            AppSizes.cardBorderRadius + 10,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          gapPadding: 1.0,
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(
            AppSizes.cardBorderRadius + 10,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          gapPadding: 1.0,
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(
            AppSizes.cardBorderRadius + 10,
          ),
        ),
        errorBorder: OutlineInputBorder(
          gapPadding: 1.0,
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(
            AppSizes.cardBorderRadius + 10,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          gapPadding: 1.0,
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(
            AppSizes.cardBorderRadius + 10,
          ),
        ),
        errorStyle: Theme.of(context).textTheme.bodySmall!.apply(
              color: Theme.of(context).colorScheme.error,
            ),
        suffixIcon: Visibility(
          visible: isSuffixIcon,
          child: GestureDetector(
            onTap: onTapSuffixIcon,
            child: Icon(
              suffixIcon,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ),
      validator: (String? value) => validator(context, value),
    );
  }
}
