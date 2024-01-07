import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pure_match/repository.dart';
import 'package:pure_match/userModel.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;

class search extends StatefulWidget {
  const search({super.key});

  @override
  State<search> createState() => _searchState();
}

class _searchState extends State<search> {

  final userRepository = UserRepository();
  List<User> allUsers = []; // Store all users fetched from API
  List<User> displayedUsers = []; // Users displayed based on search
  List<int> userIsSelected = [];  // Selected users to add for admin
  Map<int, String> userPhoto = {};  // Users images

  // Fetch users when the page loads
  @override
  void initState() {
    super.initState();
    _getUsers().then((value) {
      setState(() {
        allUsers = value;
      });
    });
  }

  // Get users data from repository
  Future<List<User>> _getUsers() async {
    List<User> users = await userRepository.fetchUsers();
    return users;
  }

  // Filter users based on the search query
  void filterUsers(String query) {
    setState(() {
      displayedUsers = allUsers
          .where((user) => user.name.toLowerCase().startsWith(query.toLowerCase()))
          .toList();
    });
    // Get filtered users photo URLs
    for (var user in displayedUsers) {
      final userPhotoUrl = user.photo;
      getImage(userPhotoUrl, user.id);
    }
  }

  // Get Image from URL
  Future<void> getImage(String userPhotoUrl, int userId) async {
    final response = await http.get(Uri.parse(userPhotoUrl));

    if (response.statusCode == 200) {
      final document = html.parse(response.body);
      final anchorElements = document.getElementsByTagName('a');

      // Most of the provided links are either broken or outdated, and there is a redirect link
      // Check if there's a redirect link
      if (anchorElements.isNotEmpty) {
        final redirectUrl = anchorElements[0].attributes['href'];

        // Visit the redirect URL
        final redirectResponse = await http.get(Uri.parse(redirectUrl!));
        if (redirectResponse.statusCode == 200) {
          final redirectDocument = html.parse(redirectResponse.body);
          final imgElement = redirectDocument.querySelector('img');

          // Update the image URL state
          if (imgElement != null) {
            final extractedUrl = imgElement.attributes['src'];
            // Store the image URL of each user if found, otherwise get a placeholder image
            String imageUrl = extractedUrl ?? 'https://via.placeholder.com/150';
            setState(() {
              userPhoto[userId] = imageUrl;
            });
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text(
          displayedUsers.isEmpty ? 'Add an Admin' : 'Add Admin',
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Color(0xffFCFCFC),
          ),
        ),
        leading: IconButton(
          icon: const Icon(CupertinoIcons.left_chevron),
          onPressed: () {
        //    Navigator.of(context).pop();
          },
        ),
        actions: <Widget>[
          // Display Pure Match app logo if not returning any users in the search result
          // If there is any unselected users in the search result switch the logo to 'Add' button (grey color/inactive)
          // If any user is selected, 'Add' button becomes active/white color
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: displayedUsers.isEmpty
                ? Image.asset('assets/icon/pureMatch.png')
                : userIsSelected.isEmpty
                  ? const Text('Add', style: TextStyle(color: Color(0xffBBBBBB), fontSize: 16))
                  : const Text('Add', style: TextStyle(color: Color(0xffFCFCFC), fontSize: 16)),
          ),
        ],
      ),

      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(bottom: 9.03),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                color: const Color(0xff171717),
                // Search bar
                child: TextField(
                  keyboardType: TextInputType.text,
                  keyboardAppearance: Brightness.light,
                  autocorrect: false,
                  maxLines: 1,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xff2C2D30),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.52),
                      borderSide: BorderSide.none,
                    ),
                    hintText: "Search for a user",
                    hintStyle: const TextStyle(color: Color(0xffBBBBBB)),
                    prefixIcon: Container(
                      padding: const EdgeInsets.only(right: 8),
                      height: 18.0,
                      width: 18.0,
                      child: const Icon(CupertinoIcons.search),
                    ),
                    prefixIconColor: const Color(0xffBBBBBB),
                  ),
                  // Get search result
                  onChanged: (String searchQuery) {
                    setState(() {
                      if (searchQuery.isEmpty){
                        displayedUsers = [];
                      } else {
                        filterUsers(searchQuery);
                      }
                    });
                  }
                ),
              ),

              // Display the search result if any exists
              Expanded(
                child: displayedUsers.isEmpty
                    ? const SizedBox.shrink()
                    : ListView.builder(
                    itemCount: displayedUsers.length,
                    itemBuilder: (context, index) {
                      final user = displayedUsers[index];
                      final formattedDate = DateFormat('MM/dd/yyyy').format(DateTime.parse(user.joinedAt!));
                      return Container(
                        padding: const EdgeInsets.only(left: 16, right: 24, top: 8, bottom: 8),
                        child: ListTile(
                          leading: SizedBox(
                            width: 56,
                            height: 56,
                            child: (userPhoto[user.id] != null)
                                ? CircleAvatar(
                                    backgroundImage: NetworkImage(userPhoto[user.id]!),
                                    // Handle the error by setting a placeholder image URL
                                    onBackgroundImageError: (exception, stackTrace) {
                                      setState(() {
                                        userPhoto[user.id] = 'https://via.placeholder.com/150'; // Placeholder image URL
                                      });
                                    },
                                  )
                                : const CircleAvatar(
                                    backgroundImage: NetworkImage('https://via.placeholder.com/150'),
                                  ),
                          ),
                          title: Text(user.name),
                          subtitle: Text(
                              '${user.role ?? 'Member'} since $formattedDate'),
                          trailing: GestureDetector(
                            onTap: () {
                              setState(() {
                                if (userIsSelected.contains(user.id)) {
                                  userIsSelected.remove(user.id);
                                } else {
                                  userIsSelected.add(user.id);
                                }
                              });
                             },
                            // Users selection option
                            child: SizedBox(
                              height: 24,
                              width: 24,
                              child: userIsSelected.contains(user.id)
                                  ? const Icon(Icons.check_circle, color: Colors.white)
                                  : const Icon(Icons.radio_button_unchecked, color: Color(0xffBBBBBB)),
                            ),
                          ),
                          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 18),
                          subtitleTextStyle: const TextStyle(color: Color(0xffBBBBBB), fontSize: 14),
                          horizontalTitleGap: 12,
                        ),
                      );
                    },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
