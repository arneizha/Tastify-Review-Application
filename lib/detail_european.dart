import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/firestore_service.dart';
import 'package:flutter_application/main_screen.dart';
import 'package:flutter_application/review_european.dart';

class detail_european extends StatefulWidget {
  final DocumentSnapshot kategori; // Ganti dengan tipe data yang sesuai

  const detail_european({Key? key, required this.kategori}) : super(key: key);

  @override
  State<detail_european> createState() => Detail_european();
}

class Detail_european extends State<detail_european> {
  late TextEditingController _searchController;
  List<DocumentSnapshot> userList = []; // Tambahkan deklarasi userList

  List<DocumentSnapshot> searchResults = [];
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();

    // Inisialisasi data userList menggunakan stream Firestore
    FirestoreService().geteuropean().listen((QuerySnapshot snapshot) {
      setState(() {
        userList = snapshot.docs;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFCEDEBD),
      appBar: AppBar(
        backgroundColor: Color(0xFF435334),
        title: const Text(
          'European Restaurant',
          style: TextStyle(
            color: Color(0xFFFAF1E4),
            fontSize: 25.0,
          ),
        ),
        toolbarHeight: 70.0,
        elevation: 15,
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  isSearching = true;
                  searchResults = userList.where((document) {
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;
                    return data['name']
                        .toLowerCase()
                        .contains(value.toLowerCase());
                  }).toList();
                });
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, size: 30.0),
                hintText: 'Search',
                hintStyle: TextStyle(fontSize: 20.0),
                contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: FirestoreService().geteuropean(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    } else {
                      List userList = snapshot.data!.docs;
                      return SizedBox(
                        width: double.infinity,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: isSearching
                              ? searchResults.length
                              : userList.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot documentSnapshot = isSearching
                                ? searchResults[index]
                                : userList[index];
                            Map<String, dynamic> data =
                                documentSnapshot.data() as Map<String, dynamic>;
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => review_european(
                                      european: documentSnapshot,
                                    ),
                                  ),
                                );
                              },
                              child: Card(
                                elevation: 15,
                                margin: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                color: Color(0xFF9EB384),
                                child: Row(
                                  children: [
                                    Image.network(
                                      data['image'],
                                      width: 150,
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            data['name'],
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF435334),
                                            ),
                                          ),
                                          Text(
                                            data['address'],
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Color(0xFFFAF1E4),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }
                  }
                }),
          ),
        ],
      ),
    );
  }
}

/*class European {
  String name;
  String address;
  String imageAsset;
  String rating;
  String hari;
  String waktu;
  String description;

  European({
    required this.name,
    required this.address,
    required this.imageAsset,
    required this.rating,
    required this.hari,
    required this.waktu,
    required this.description,
  });
}

var ListEuropean = [
  European(
    name: 'La Regina Ristorante Italiano',
    address: 'Jl. Buring No.50, Oro-oro Dowo, Kec. Klojen, Kota Malang',
    imageAsset: 'assets/images/European/la_regina.jpg',
    rating: '4.4',
    hari: 'Everyday',
    waktu: '09.00 - 24.00',
    description:
        'La Regina Ristorante Italiano, yang terletak di Malang, adalah tempat yang memikat hati para penikmat kuliner Italia. Dengan suasana yang hangat dan ramah, restoran ini menawarkan pengalaman makan yang autentik dan menyenangkan. La Regina menggabungkan keahlian kuliner Italia dengan bahan-bahan segar dan berkualitas tinggi untuk menciptakan hidangan lezat yang memanjakan lidah.',
  ),
  European(
    name: 'Illy Café',
    address:
        'Lai Lai Market Buah, Jl. Arjuna No.36, Kauman, Kec. Klojen, Kota Malang',
    imageAsset: 'assets/images/European/illy.jpg',
    rating: '4,5',
    hari: 'Everyday',
    waktu: '09.00 - 24.00',
    description:
        'Illy Café merupakan european yang tempatnya gabung dengan Lai-Lai Market buahnya dalam stu gedung yang sama. Dieuropean ini mempunyai fasilitas seperti toilet, free WI-FI, smoking area, maupun non smoking area. european ini menyediakan aneka minuman dan makanan yang lebih ke western.',
  ),
  European(
    name: 'Pintbait',
    address: 'Jl. Kurinci No.24, Oro-oro Dowo, Kec. Klojen, Kota Malang',
    imageAsset: 'assets/images/European/pintbait.jpg',
    rating: '4.8',
    hari: 'Everyday',
    waktu: '09.00 - 24.00',
    description:
        'Pintbait, sebuah permata kuliner di Malang, menghadirkan nuansa cita rasa Eropa yang otentik dan menggugah selera. Terletak di jantung kota, restoran ini menawarkan pengalaman kuliner yang memadukan keanggunan Eropa dengan keramahan dan kenyamanan. Dekorasi interior Pintbait memberikan sentuhan elegan dan atmosfer yang menyambut. Suasana hangat menciptakan suasana yang sempurna untuk pertemuan romantis, acara keluarga, atau bahkan pertemuan bisnis yang santai.',
  ),
  European(
    name: 'The Arbanat',
    address: 'Jl. Terusan Dieng No.4-6, Pisang Candi, Kec. Sukun, Kota Malang',
    imageAsset: 'assets/images/European/arbanat.jpg',
    rating: '4.1',
    hari: 'Everyday',
    waktu: '09.00 - 24.00',
    description:
        'The Arbanat menyajikan menu campuran hidangan internasional dengan sentuhan kreatif, mencerminkan kualitas bahan-bahan segar dan pilihan menu yang beragam. Mulai dari hidangan pembuka yang inovatif hingga hidangan utama yang lezat, setiap sajian dirancang untuk memanjakan lidah para tamu.',
  ),
  European(
    name: 'Amsterdam Café & Resto',
    address: 'Jl. Pahlawan Trip No.25, Oro-oro Dowo, Kec. Klojen, Kota Malang',
    imageAsset: 'assets/images/European/amsterdam.jpg',
    rating: '4.6',
    hari: 'Everyday',
    waktu: '09.00 - 24.00',
    description:
        'Amsterdam Café & Resto, terletak di jantung Malang, adalah destinasi kuliner yang menghadirkan nuansa Eropa yang klasik dan modern secara bersamaan. Restoran ini menyatu dengan atmosfer yang hangat dan penuh gaya, menciptakan pengalaman bersantap yang istimewa bagi para pengunjungnya.',
  ),
  European(
    name: 'Malibu Steak & Pizza',
    address: 'Jl. Terusan Kawi No.6C, Gading Kasri, Klojen, Kota Malang',
    imageAsset: 'assets/images/European/malibu.jpg',
    rating: '4.4',
    hari: 'Everyday',
    waktu: '09.00 - 24.00',
    description:
        'Malibu Steak n Pizza merupakan salah satu Restoran di Kota Malang yang menghadirkan aneka menu hidangan Eropa seperti Steak, Pizza, Pasta, Salad, Soup dan aneka menu unik lainnya. Sebagai salah satu primadona steak di Kota Malang, Resto Malibu Steak n Pizza menghadirkan aneka macam Steak dengan berbagai pilihan saus seperti wine import dan coffee.',
  ),
  European(
    name: 'Oura',
    address: 'Jl. Pahlawan Trip No.A11, Oro-oro Dowo, Kec. Klojen, Kota Malang',
    imageAsset: 'assets/images/European/oura.jpg',
    rating: '4.2',
    hari: 'Everyday',
    waktu: '09.00 - 24.00',
    description: '',
  ),
  European(
    name: 'Brother’s Chicken and Shakes',
    address: 'Jl. Kawi No.37, Bareng, Kec. Klojen, Kota Malang',
    imageAsset: 'assets/images/European/brothers.jpg',
    rating: '4.0',
    hari: 'Everyday',
    waktu: '09.00 - 24.00',
    description:
        'Oura, sebuah destinasi kuliner di Malang, menawarkan pengalaman bersantap yang menggabungkan keunikan konsep dengan cita rasa yang luar biasa. Terletak di lokasi strategis, restoran ini menawarkan suasana yang modern dan menarik, menciptakan tempat yang sempurna untuk pertemuan santai atau perayaan khusus.',
  ),
  European(
    name: 'Black Castle Restaurant & Boulangerie',
    address:
        'Jl. Puncak Esberg No.5, Doro, Karangwidoro, Kec. Dau, Kabupaten Malang',
    imageAsset: 'assets/images/European/black_castle.jpg',
    rating: '4.2',
    hari: 'Everyday',
    waktu: '09.00 - 24.00',
    description:
        'Black Castle Restaurant & Boulangerie di Malang adalah destinasi kuliner yang memadukan pesona Eropa dengan kenyamanan yang modern. Terletak di jantung kota, restoran ini menghadirkan suasana yang elegan dan penuh gaya, memberikan pengalaman bersantap yang istimewa.',
  ),
];*/
