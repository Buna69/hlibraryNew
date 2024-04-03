import 'package:flutter/material.dart';

class SearchBarWithClearButton extends StatefulWidget
    implements PreferredSizeWidget {
  const SearchBarWithClearButton({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SearchBarWithClearButtonState createState() =>
      _SearchBarWithClearButtonState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _SearchBarWithClearButtonState extends State<SearchBarWithClearButton>
    with SingleTickerProviderStateMixin {
  final TextEditingController _textEditingController = TextEditingController();
  bool _showClearButton = false;
  bool _isSearching = false;
  late FocusNode _searchFocusNode;
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _searchFocusNode = FocusNode();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    )..addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      if (_isSearching) {
        _textEditingController.clear();
        _showClearButton = false;
        _animationController.reverse();
        _searchFocusNode.unfocus();
      } else {
        _animationController.forward();
        _searchFocusNode.requestFocus();
      }
      _isSearching = !_isSearching;
    });
  }

  void _handleClearButtonClick() {
    setState(() {
      _textEditingController.clear();
      _showClearButton = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: _isSearching
            ? const Icon(Icons.arrow_back)
            : const Icon(Icons.search),
        onPressed: _toggleSearch,
      ),
      title: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: _isSearching ? MediaQuery.of(context).size.width - 56 : 0,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(_slideAnimation),
          child: _isSearching
              ? TextField(
                  controller: _textEditingController,
                  focusNode: _searchFocusNode,
                  onChanged: (value) {
                    setState(() {
                      _showClearButton = value.isNotEmpty;
                    });
                  },
                  decoration: InputDecoration(
                    suffixIcon: _showClearButton
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: _handleClearButtonClick,
                          )
                        : null,
                    hintText: 'Search',
                    border: const OutlineInputBorder(),
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
