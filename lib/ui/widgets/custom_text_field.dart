part of 'widgets.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController textEditingController;
  final double height;
  final double? width;
  final bool? enabled, obscureText, autofocus;
  final int? maxLength;
  final EdgeInsetsGeometry? padding, margin, contentPadding;
  final Decoration? decoration;
  final String? hintText;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged, onSubmitted;
  final Widget? prefixIcon;
  final TextInputType? keyboardType;
  final TextStyle? style;
  final TextInputAction? textInputAction;
  final List<Widget> leadingChildren;

  const CustomTextField({
    Key? key,
    required this.textEditingController,
    this.height = 40,
    this.width,
    this.decoration,
    this.hintText,
    this.padding,
    this.contentPadding = EdgeInsets.zero,
    this.margin,
    this.prefixIcon,
    this.onChanged,
    this.inputFormatters,
    this.keyboardType,
    this.enabled = true,
    this.obscureText = false,
    this.maxLength,
    this.onSubmitted,
    this.style = const TextStyle(fontSize: 16),
    this.leadingChildren = const [],
    this.autofocus,
    this.textInputAction,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool obscurePassword = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.padding,
      margin: widget.margin,
      height: widget.height,
      width: widget.width,
      decoration: widget.decoration,
      child: Row(
        children: <Widget>[
              Flexible(
                child: TextField(
                  controller: widget.textEditingController,
                  maxLines: 1,
                  textInputAction: widget.textInputAction,
                  maxLength: widget.maxLength,
                  enabled: widget.enabled,
                  autofocus: widget.autofocus ?? false,
                  style: widget.style,
                  textAlignVertical: TextAlignVertical.center,
                  inputFormatters: widget.inputFormatters,
                  keyboardType: widget.keyboardType,
                  cursorColor: SharedValue.primaryColor,
                  onChanged: widget.onChanged,
                  onSubmitted: widget.onSubmitted,
                  obscureText: widget.obscureText! ? obscurePassword : false,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(16))),
                    contentPadding: widget.contentPadding,
                    hintText: widget.hintText,
                    prefixIcon: widget.prefixIcon,
                    suffixIcon: widget.obscureText!
                        ? GestureDetector(
                            onTap: () {
                              setState(() {
                                obscurePassword = !obscurePassword;
                              });
                            },
                            child: obscurePassword
                                ? Icon(CupertinoIcons.eye,
                                    color: Colors.grey.withOpacity(.4))
                                : Icon(CupertinoIcons.eye_slash,
                                    color: Colors.grey.withOpacity(.4)),
                          )
                        : null,
                  ),
                ),
              ),
            ] +
            widget.leadingChildren,
      ),
    );
  }
}
