// ignore_for_file: prefer_collection_literals, must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app2/model/categorymodel.dart';
import '../data/categoryData.dart';
import '../data/categoryformat.dart';
import '../data/news.dart';
import '../model/newsmodel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<CategoryModel> categories = <CategoryModel>[];
  List<ArticleModel> articles = <ArticleModel>[];
  bool _loading = true;

  getNews() async {
    News newsdata = News();
    await newsdata.getNews();
    articles = newsdata.datatobesavedin;
    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    categories = getCategories();
    getNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment
              .center, // this is to bring the row text in center
          children: <Widget>[
            Text(
              "NewYork ",
              style: TextStyle(color: Colors.black),
            ),
            Text(
              "Times",
              style: TextStyle(color: Colors.blueAccent),
            ),
          ],
        ),
      ),

      // category widgets
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 70.0,
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: ListView.builder(
                        itemCount: categories.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return CategoryTile(
                            imageUrl: categories[index].imageUrl,
                            categoryName: categories[index].categoryName,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                    ListView.builder(
                      itemCount: articles.length,
                      physics: const ClampingScrollPhysics(),
                      shrinkWrap: true, // add this otherwise an error
                      itemBuilder: (context, index) {
                        return NewsTemplate(
                          urlToImage: articles[index].urlToImage!,
                          title: articles[index].title!,
                          description: articles[index].description!,
                          url: '',
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  final String? categoryName, imageUrl;
  const CategoryTile({super.key, this.categoryName, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CategoryFragment(
                category: categoryName!.toLowerCase(),
              ),
            ));
      },
      child: Container(
        margin: const EdgeInsets.only(right: 16),
        child: Stack(
          children: <Widget>[
            ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: CachedNetworkImage(
                  imageUrl: imageUrl!,
                  width: 170,
                  height: 90,
                  fit: BoxFit.cover,
                )),
            Container(
              alignment: Alignment.center,
              width: 170,
              height: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.black26,
              ),
              child: Text(
                categoryName!,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// creating template for news

class NewsTemplate extends StatelessWidget {
  String title, description, url, urlToImage;
  NewsTemplate(
      {super.key,
      required this.title,
      required this.description,
      required this.urlToImage,
      required this.url});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: CachedNetworkImage(
                imageUrl: urlToImage,
                width: 380,
                height: 200,
                fit: BoxFit.cover,
              )),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                color: Colors.black),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(fontSize: 15.0, color: Colors.grey[800]),
          ),
        ],
      ),
    );
  }
}
