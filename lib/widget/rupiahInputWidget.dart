import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class RupiahInputWidget extends StatefulWidget {
  final TextEditingController controller;
  final Function(String)? onSubmitted;

  const RupiahInputWidget({Key? key, required this.controller, this.onSubmitted}) : super(key: key);

  @override
  _RupiahInputWidgetState createState() => _RupiahInputWidgetState();
}

class _RupiahInputWidgetState extends State<RupiahInputWidget> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_formatRupiah);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_formatRupiah);
    super.dispose();
  }

  void _formatRupiah() {
    final text = widget.controller.text;
    final number = int.tryParse(text.replaceAll(RegExp('[^0-9]'), '')) ?? 0;
    final formattedNumber = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(number);
    if (formattedNumber != widget.controller.text) {
      widget.controller.value = widget.controller.value.copyWith(
        text: formattedNumber,
        selection: TextSelection.collapsed(offset: formattedNumber.length),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        labelText: 'Harga (IDR)',
        border: OutlineInputBorder(),
      ),
      onSubmitted: widget.onSubmitted,
    );
  }
}

