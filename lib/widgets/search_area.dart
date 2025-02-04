import 'package:flutter/material.dart';

class SearchArea extends StatefulWidget {
  final ValueChanged<String> onSearch;
  final VoidCallback onClose;

  const SearchArea({super.key, required this.onSearch, required this.onClose});
  @override
  State<SearchArea> createState() => _SearchAreaState();
}

class _SearchAreaState extends State<SearchArea> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      height: 80,
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _searchController,
              focusNode: _focusNode,
              onChanged: widget.onSearch,
              onFieldSubmitted: widget.onSearch,
              decoration: const InputDecoration(
                hintText: 'search...',
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                isDense: true,
                filled: true,
                fillColor: Colors.transparent, 
                border: InputBorder.none,
                focusedBorder: UnderlineInputBorder(  
                  borderSide: BorderSide(
                  color: Color.fromARGB(255, 151, 13, 225),
                  width: 2),
                ),
                enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.transparent,
                  width: 2,
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
              FocusManager.instance.primaryFocus?.unfocus();
              widget.onSearch('');
            }
          ),
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: widget.onClose
          )
        ],
      ),
    );
  }
}