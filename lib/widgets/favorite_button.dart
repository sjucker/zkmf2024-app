import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class FavoriteButton extends StatefulWidget {
  final String identifier;
  final Function valueChanged;
  final Color offColor;
  final Color onColor;

  const FavoriteButton({
    super.key,
    required this.identifier,
    required this.valueChanged,
    required this.offColor,
    required this.onColor,
  });

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool _favorite = false;
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    _favorite = _isFavorite(widget.identifier);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          setState(() {
            _favorite = !_favorite;
            _setFavorite(widget.identifier, _favorite);
            widget.valueChanged(_favorite);
          });
        },
        icon: Icon(
          (_favorite ? Icons.star : Icons.star_border_outlined),
          color: _favorite ? widget.onColor : widget.offColor,
        ));
  }

  bool _isFavorite(String identifier) {
    return box.read('favorite-$identifier}') ?? false;
  }

  void _setFavorite(String identifier, bool favorite) {
    box.write(('favorite-$identifier}'), favorite);
  }
}
