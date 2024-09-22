import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final Widget? prefixIcon;
  final bool obscureText;
  final Widget? suffixIcon;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final void Function(PointerDownEvent)? onTapOutside;

  const MyTextField({
    super.key,
    required this.controller,
    required this.label,
    this.prefixIcon,
    this.obscureText = false,
    this.suffixIcon,
    this.onChanged,
    this.onTap,
    this.onTapOutside,
  });

  @override
  MyTextFieldState createState() => MyTextFieldState();
}

class MyTextFieldState extends State<MyTextField>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();

    _focusNode = FocusNode();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return ScaleTransition(
          scale: _scaleAnimation,
          child: TextField(
            onTapOutside: widget.onTapOutside,
            textInputAction: TextInputAction.newline,
            maxLines: 15,
            minLines: 1,
            enableSuggestions: true,
            onChanged: widget.onChanged,
            controller: widget.controller,
            obscureText: widget.obscureText,
            onTap: widget.onTap,
            focusNode: _focusNode,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              hintText: widget.label,
              labelStyle: TextStyle(
                fontSize: _focusNode.hasFocus ? 20 : 16,
                color: _focusNode.hasFocus ? Colors.black : Colors.grey[600],
              ),
              filled: true,
              fillColor: Colors.grey[100],
              prefixIcon: widget.prefixIcon,
              suffixIcon: widget.suffixIcon,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Colors.grey,
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Colors.blueGrey,
                  width: 2,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
