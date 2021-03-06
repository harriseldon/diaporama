import 'package:diaporama/states/subreddits_state.dart';
import 'package:diaporama/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';

class AddSourceScreen extends StatefulWidget {
  @override
  _AddSourceScreenState createState() => _AddSourceScreenState();
}

class _AddSourceScreenState extends State<AddSourceScreen> {
  List<String> _subreddits = [];
  TextEditingController _searchController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<List<String>> _searchListener(String query) async {
    List<String> subs =
        await Provider.of<SubredditsState>(context, listen: false)
            .searchSubreddit(query);
    return subs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add new source"),
        centerTitle: true,
        leading: IconButton(
            icon: Icon(
              Icons.cancel,
              color: Colors.red,
            ),
            onPressed: () => Navigator.pop(context)),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Container(
          height: double.maxFinite,
          width: double.maxFinite,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 25,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    style: TextStyle(
                      color: lightGreyColor,
                    ),
                    decoration: InputDecoration(
                      labelText: "Source name",
                      labelStyle: TextStyle(
                        color: lightGreyColor,
                      ),
                      hintStyle: TextStyle(
                        color: redditOrange,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: blueColor,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: redditOrange,
                          width: 2.0,
                        ),
                      ),
                    ),
                    controller: _nameController,
                    validator: (value) {
                      if (value.isEmpty) return "Required";
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  TypeAheadField(
                    textFieldConfiguration: TextFieldConfiguration(
                      style: TextStyle(
                        color: lightGreyColor,
                      ),
                      decoration: InputDecoration(
                          labelText: "Subreddits",
                          labelStyle: TextStyle(
                            color: lightGreyColor,
                          ),
                          hintStyle: TextStyle(
                            color: redditOrange,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: blueColor,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: redditOrange,
                              width: 2.0,
                            ),
                          ),
                          suffixIcon: Icon(
                            Icons.search,
                            color: blueColor,
                          ),
                          prefixIcon: GestureDetector(
                            child: Icon(
                              Icons.cancel,
                              color: blueColor,
                            ),
                            onTap: () => _searchController.clear(),
                          )),
                      controller: _searchController,
                    ),
                    suggestionsCallback: (value) async =>
                        await _searchListener(value),
                    itemBuilder: (context, value) {
                      return Container(
                        child: Text(
                          value,
                          style: TextStyle(color: lightGreyColor),
                        ),
                        height: 25,
                        margin: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                      );
                    },
                    onSuggestionSelected: (value) {
                      setState(() {
                        _subreddits.add(value);
                      });
                    },
                    suggestionsBoxDecoration: SuggestionsBoxDecoration(
                      color: darkGreyColor,
                    ),
                    noItemsFoundBuilder: (context) {
                      return Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 15.0,
                          vertical: 10.0,
                        ),
                        child: Text(
                          "No subreddits found !",
                          style: TextStyle(color: lightGreyColor),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  Text(
                    "Selected subreddits",
                    style: TextStyle(
                      fontSize: 20,
                      color: lightGreyColor,
                      fontWeight: FontWeight.bold,
                      decorationStyle: TextDecorationStyle.solid,
                      decoration: TextDecoration.underline,
                      decorationColor: redditOrange,
                      decorationThickness: 3,
                    ),
                  ),
                  if (_subreddits.isEmpty)
                    Text(
                      "Please select at least one subreddit",
                      style: TextStyle(
                        color: Colors.red,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ListView(
                    shrinkWrap: true,
                    children: [
                      for (String sub in _subreddits)
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: redditOrange,
                                width: 2.0,
                              )),
                          margin: EdgeInsets.fromLTRB(15, 8, 15, 0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: IconButton(
                                    icon: Icon(
                                      Icons.remove_circle,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _subreddits.remove(sub);
                                      });
                                    }),
                              ),
                              Expanded(
                                flex: 4,
                                child: Text(
                                  sub,
                                  style: TextStyle(
                                    color: lightGreyColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _formKey.currentState.save();
          if (!_formKey.currentState.validate() || _subreddits.isEmpty) return;
          String subredditsString = _subreddits.join("+");
          String label = _nameController.text;
          Provider.of<SubredditsState>(context, listen: false)
              .addSource(label: label, subredditsString: subredditsString);
          Navigator.pop(context);
        },
        backgroundColor: blueColor,
        label: Text("Add"),
        icon: Icon(Icons.check),
      ),
    );
  }
}
