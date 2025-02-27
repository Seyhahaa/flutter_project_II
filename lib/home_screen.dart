import 'package:flutter/material.dart';
import 'package:flutter_project_ii/all_event_module/all_event_screen.dart';
import 'package:flutter_project_ii/api_module/event_logic.dart';
import 'package:flutter_project_ii/api_module/event_model.dart';
import 'package:flutter_project_ii/profile_module/language_data.dart';
import 'package:flutter_project_ii/profile_module/language_logic.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_project_ii/detail_screen.dart';
import 'package:flutter_project_ii/search/search_screen.dart';
import 'package:flutter_project_ii/widgets/event_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  //const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Language _lang = Language();
  bool language = true;

  @override
  Widget build(BuildContext context) {
    _lang = context.watch<LanguageLogic>().language;
    List<Event> record = context.watch<EventLogic>().records;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Color(0xFF1A202C),
        title: Container(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
          child: Row(
            children: [
              Image(
                image: Image.asset('assets/Wegocolor.png').image,
                height: 45,
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchScreen(),
                  ));
            },
            icon: Icon(
              Icons.search,
              color: Colors.white,
              size: 35,
            ),
          ),
          Stack(
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.notifications_none,
                  color: Colors.white,
                  size: 35,
                ),
              ),
              Positioned(
                right: 10,
                top: 0,
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '1',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        color: Color(0xFF1A202C),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Text(
                  _lang.feature,
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SizedBox(height: 10),
                SizedBox(
                  height: 235,
                  child: _buildSlider(record),
                ),
                SizedBox(height: 30),
                Row(
                  children: [
                    Text(
                      _lang.popular,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              // builder: (context) => AllEventScreen(),
                              builder: (context) => SearchScreen(),
                            ));
                      },
                      child: Text(
                        _lang.more,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF455AF7)),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 20),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: record.length,
                  itemBuilder: (context, index) {
                    return _buildEventCard(record[index]);
                  },
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEventCard(Event event) {
    return EventCard(
      date: event.attributes.startDate.toString(),
      title: event.attributes.title,
      imageUrl: event.attributes.featureImage,
      eventId: event.id,
      isFavorited: event.attributes.isFavorited,
      favoritesCount: event.attributes.favoritesCount ?? 0,
      toggleFavoriteUrl: event.links.toggleFavorite,
      onFavoriteToggled: () {
        // Refresh the events list
        context.read<EventLogic>().read(context);
      },
    );
  }

  Widget _buildSlider(List<Event> events) {
    return Container(
      height: 235,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(40),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: PageView.builder(
        physics: BouncingScrollPhysics(),
        pageSnapping: true,
        itemCount: events.length,
        itemBuilder: (context, index) {
          return _buildSlideItem(events[index]);
        },
      ),
    );
  }

  Widget _buildSlideItem(Event item) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(30),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailScreen(item),
              ));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: Image.network(
                    item.attributes.featureImage,
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width,
                    height: 150,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        height: 150,
                        color: Colors.grey[800],
                        child: Icon(Icons.image_not_supported,
                            color: Colors.white54),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    height: 50,
                    width: 45,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(40),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                            (DateFormat('MMM dd, yyyy')
                                .format(DateTime.parse(
                                    item.attributes.startDate.toString()))
                                .substring(0, 3)),
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                        Text(
                            (DateFormat('MMM dd, yyyy')
                                .format(DateTime.parse(
                                    item.attributes.startDate.toString()))
                                .substring(4, 6)),
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: item.attributes.isFavorited
                      ? Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.red.withAlpha(200),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                          child: Icon(
                            Icons.favorite,
                            color: Colors.white,
                            size: 20,
                          ),
                        )
                      : SizedBox(),
                ),
              ],
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                item.attributes.title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
