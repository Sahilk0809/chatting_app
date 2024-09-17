// import 'package:flutter/material.dart';
//
// class MyTextField extends StatelessWidget {
//   final TextEditingController controller;
//   final String label;
//   final Icon prefixIcon;
//   final bool obscureText;
//   final Widget? suffixIcon;
//
//   const MyTextField({
//     super.key,
//     required this.controller,
//     required this.label,
//     required this.prefixIcon,
//     this.obscureText = false,
//     this.suffixIcon,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       child: TextFormField(
//         cursorColor: Colors.grey,
//         controller: controller,
//         obscureText: obscureText,
//         decoration: InputDecoration(
//           prefixIcon: prefixIcon,
//           suffixIcon: suffixIcon,
//           label: Text(label),
//           labelStyle: TextStyle(color: Colors.grey[600]),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//             borderSide: const BorderSide(
//               color: Colors.grey,
//               width: 2,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final Widget? prefixIcon;
  final bool obscureText;
  final Widget? suffixIcon;
  final void Function(String)? onChanged;

  const MyTextField({
    super.key,
    required this.controller,
    required this.label,
    this.prefixIcon,
    this.obscureText = false,
    this.suffixIcon,
    this.onChanged,
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
            onChanged: widget.onChanged,
            controller: widget.controller,
            obscureText: widget.obscureText,
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
